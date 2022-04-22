//
//  ViewController.swift
//  StarPrinterDemo
//
//  Created by Jignesh on 24/03/22.
//

import UIKit
import MBProgressHUD
import PromiseKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func searchPrinterTapped(_ sender: UIButton) {
        let listVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectStarPrinterViewController") as! SelectStarPrinterViewController
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Search for Printers\nPlease wait"
        hud.label.numberOfLines = 2

        firstly {
            return StarController.listPrinters()
        }
        .then { list -> Promise<StarPrinterInfo> in
            hud.hide(animated: true)
            return listVC.show(in: self, sender: sender, printerList: list)
        }
        .done { selectedPrinter -> () in
            listVC.dismiss(animated: true, completion: nil)
            StarController.setDefaultPrinter(selectedPrinter, paperSize: .threeInch)
        }
        .catch { error in

        }
    }
    
}

