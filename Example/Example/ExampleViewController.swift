//
//  ExampleViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/7/4.
//

import UIKit

class ExampleViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? ExampleCryptorViewController else { return }
        
        switch segue.identifier {
        case "encrypt":
            nextVC.operation = .encrypt
        case "decrypt":
            nextVC.operation = .decrypt 
        default:
            break
        }
    }


}
