//
//  ExampleTextViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/14.
//

import UIKit

class ExampleTextViewController: UIViewController {
    
    var value: String?

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textField.text = value
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChanged(_:)), name: UITextField.textDidChangeNotification, object: self.textField)
    }
    
    @objc func textFieldTextChanged(_ sender: Notification) {
        self.value = textField.text
    }
    
}
