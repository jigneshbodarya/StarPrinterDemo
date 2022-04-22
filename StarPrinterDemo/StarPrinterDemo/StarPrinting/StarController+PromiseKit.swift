//
//  StarController+PromiseKit.swift
//  CellarPass Table App
//
//  Created by Cristian Miehs on 21/02/2018.
//  Copyright © 2018 CellarPass. All rights reserved.
//

import UIKit
import PromiseKit

extension StarController
{
    class func listPrinters() -> Promise<[StarPrinterInfo]>
    {
        return Promise { seal in
            listPrinters(completion: { (infoList) in
                seal.fulfill(infoList)
            })
        }
    }
    
    class func printImage(_ image: UIImage) -> Promise<StarPrintResult>
    {
        return Promise { seal in
            printImage(image, completion: { (result) in
                guard let result = result else {
                    seal.reject(GlobalError.defaultError(message: "Could not print image"))
                    return
                }
                
                seal.fulfill(result)
            })
        }
    }
    
    class func printImage(_ image: UIImage) -> Promise<()>
    {
        return Promise { seal in
            printImage(image, completion: { (result) in
               guard let result = result else {
                seal.reject(GlobalError.defaultError(message: "Could not print image"))
                    return
                }
                
                if result.success {
                    seal.fulfill(())
                }
                else {
                    seal.reject(GlobalError.defaultError(message: result.title))
                }
            })
        }
    }
    
    class func isDefaultPrinterActive() -> Promise<Bool>
    {
        return Promise { seal in
            isDefaultPrinterActive { (isActive) in
                seal.fulfill(isActive)
            }
        }
    }
}
