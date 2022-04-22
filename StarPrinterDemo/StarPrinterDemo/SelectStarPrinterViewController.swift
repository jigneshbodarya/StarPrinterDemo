//
//  SelectStarPrinterViewController.swift
//  CellarPass Table App
//
//  Created by Cristian Miehs on 21/02/2018.
//  Copyright © 2018 CellarPass. All rights reserved.
//

import UIKit
import PromiseKit
//BaseViewController,
class SelectStarPrinterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK: - Outlets & Variables
    @IBOutlet weak var tableView: UITableView!
    
    var listItems = [StarPrinterInfo]()
    
    //MARK: - Promise
    private var promise : (promise: Promise<StarPrinterInfo>, resolver: Resolver<StarPrinterInfo>)?

    func show(in vc: UIViewController, sender: UIButton, printerList: [StarPrinterInfo]) -> Promise<StarPrinterInfo>
    {
        self.listItems = printerList
        promise = Promise<StarPrinterInfo>.pending()
        self.modalPresentationStyle = .popover

        let popover = self.popoverPresentationController!
        popover.delegate = vc as? UIPopoverPresentationControllerDelegate
        popover.permittedArrowDirections = .any

        popover.sourceView = sender
        popover.sourceRect = sender.bounds

        vc.present(self, animated: true, completion: nil)
        return promise!.promise
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelsTableViewCell") as! TwoLabelsTableViewCell
        cell.selectionStyle = .none
        
        let item = listItems[indexPath.row]
        cell.firstLabel.text = item.modelName
        cell.secondLabel.text = "\(item.portName) | \(item.macAddress)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = listItems[indexPath.row]
        
        promise?.resolver.fulfill(item)
        promise = nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
