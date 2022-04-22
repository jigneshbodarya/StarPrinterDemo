//
//  StarController.swift
//  StarPrinterPOC
//
//  Created by Cristian Miehs on 20/02/2018.
//  Copyright © 2018 Cristian Miehs. All rights reserved.
//

import UIKit

//Steps:
// 1. Select printer from listPrinters()
// 2. Select paper size: "2\" (384dots)", "3\" (576dots)", "4\" (832dots)" (enum PaperSizeIndex)

class StarController
{
    private static let PREFIX = "StarPrinter_"
    
    class func listPrinters(completion: @escaping ([StarPrinterInfo]) -> Void)
    {
        DispatchQueue.global(qos: .background).async
        {
            var result = [StarPrinterInfo]()
            
            do {
                if let searchPrinterResult = try SMPort.searchPrinter(target: "ALL:") as? [PortInfo]
                {
                    for portInfo in searchPrinterResult
                    {
                        let printer = StarPrinterInfo(portInfo: portInfo)
                        result.append(printer)
                    }
                }
            }
            catch {
                // do nothing
            }
            
            if  let macAddress = UserDefaults.standard.string(forKey: "\(PREFIX)macAddress"),
                let portName = UserDefaults.standard.string(forKey: "\(PREFIX)portName"),
                let printer = result.first(where: { $0.macAddress == macAddress && $0.portName == portName }) {
                printer.selected = true
            }
            
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    class func setDefaultPrinter(_ printer: StarPrinterInfo?, paperSize: PaperSizeIndex)
    {
        if let printer = printer,
            let modelIndex = ModelCapability.modelIndex(of: printer.modelName),
            let emulation = ModelCapability.emulation(at: modelIndex) {
            
            let portSettings = ModelCapability.portSettings(at: modelIndex)
            
            
            let defaults = UserDefaults.standard
            defaults.set(printer.portName, forKey: "\(PREFIX)portName")
            defaults.set(portSettings, forKey: "\(PREFIX)portSettings")
            defaults.set(printer.modelName, forKey: "\(PREFIX)modelName")
            defaults.set(printer.macAddress, forKey: "\(PREFIX)macAddress")
            defaults.set(emulation.rawValue, forKey: "\(PREFIX)emulation")
            defaults.set(paperSize.rawValue, forKey: "\(PREFIX)paperSize")
            
            printer.selected = true
        }
        else {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "\(PREFIX)portName")
            defaults.removeObject(forKey: "\(PREFIX)portSettings")
            defaults.removeObject(forKey: "\(PREFIX)modelName")
            defaults.removeObject(forKey: "\(PREFIX)macAddress")
            defaults.removeObject(forKey: "\(PREFIX)emulation")
            defaults.removeObject(forKey: "\(PREFIX)paperSize")
        }
    }
    
    class func getDefaultPrinter() -> StarPrinterInfo?
    {
        guard
            let portName : String = UserPrefs.loadFromDisk(key: "\(PREFIX)portName"),
            let modelName : String = UserPrefs.loadFromDisk(key: "\(PREFIX)modelName"),
            let macAddress : String = UserPrefs.loadFromDisk(key: "\(PREFIX)macAddress"),
            let portInfo = PortInfo(portName: portName, macAddress: macAddress, modelName: modelName)
        else { return nil }
        
        let printer = StarPrinterInfo(portInfo: portInfo)
        printer.selected = true
        
        return printer
    }
    
    class func printImage(_ image: UIImage, completion: @escaping (StarPrintResult?) -> Void)
    {
        let defaults = UserDefaults.standard
        
        guard
            let emulationId = defaults.object(forKey: "\(PREFIX)emulation") as? Int,
            let emulation = StarIoExtEmulation.init(rawValue: emulationId),
            let width = defaults.object(forKey: "\(PREFIX)paperSize") as? Int,
            let portName = defaults.string(forKey: "\(PREFIX)portName"),
            let portSettings = defaults.string(forKey: "\(PREFIX)portSettings"),
            let commands = createDataForImage(image, emulation: emulation, width: width, bothScale: true) // to test bothScale
            else {
                completion(nil)
                return
            }
        
        DispatchQueue.global(qos: .background).async
        {
            //timeout: 10000mS
            _ = Communication.sendCommands(commands, portName: portName, portSettings: portSettings, timeout: 10000, completionHandler: { (communicationResult: CommunicationResult) in
                let result = StarPrintResult(success: (communicationResult.result == .success), title: "Communication Result", message: Communication.getCommunicationResultMessage(communicationResult))
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
    
    class func isDefaultPrinterActive(completion: @escaping (Bool) -> Void)
    {
        let defaults = UserDefaults.standard
        
        guard
            let portName = defaults.string(forKey: "\(PREFIX)portName"),
            let portSettings = defaults.string(forKey: "\(PREFIX)portSettings")
        else {
            completion(false)
            return
        }
        
        DispatchQueue.global(qos: .background).async
        {
            guard let starIoExtManager = StarIoExtManager(type: .standard, portName: portName, portSettings: portSettings, ioTimeoutMillis: 10000)
            else {
                completion(false)
                return
            }
            
            starIoExtManager.disconnect()
            let isConnected = starIoExtManager.connect()
            starIoExtManager.disconnect()
            
            DispatchQueue.main.async {
                completion(isConnected)
            }
        }
    }
    
    private static func createDataForImage(_ image : UIImage, emulation: StarIoExtEmulation, width: Int, bothScale: Bool) -> Data?
    {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        builder.appendBitmap(image, diffusion: false, width: width, bothScale: bothScale)
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        builder.endDocument()
        
        return builder.commands.copy() as? Data
    }
}

struct StarPrintResult
{
    let success : Bool
    let title : String
    let message : String
}

class StarPrinterInfo
{
    let portName : String
    let modelName : String
    let macAddress : String
    var selected = false
    
    init(portInfo : PortInfo)
    {
        self.portName = portInfo.portName
        self.modelName = portInfo.modelName
        self.macAddress = portInfo.macAddress
        selected = false
    }
}

enum PaperSizeIndex: Int {
    case twoInch = 384
    case threeInch = 576
    case fourInch = 832
    case escPosThreeInch = 512
    case dotImpactThreeInch = 210
}
