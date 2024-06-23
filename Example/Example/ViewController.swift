//
//  ViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/12.
//

import UIKit
import XZDataCryptor
import XZExtensions

class ViewController: UITableViewController {
    
    @IBOutlet weak var algorithmDetailLabel: UILabel!
    @IBOutlet weak var keyDetailLabel: UILabel!
    @IBOutlet weak var vectorDetailLabel: UILabel!
    @IBOutlet weak var roundsDetailLabel: UILabel!
    @IBOutlet weak var modeDetailLabel: UILabel!
    @IBOutlet weak var paddingDetailLabel: UILabel!
    
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 , indexPath.row == 0 else {
            return
        }
        UIPasteboard.general.string = self.resultLabel.text
    }

    @IBAction func unwindToSetAlgorithm(_ unwindSegue: UIStoryboardSegue) {
        let select = unwindSegue.source as! SelectViewController
        self.algorithmDetailLabel.text = select.value
    }
    
    @IBAction func unwindToSetKey(_ unwindSegue: UIStoryboardSegue) {
        let input = unwindSegue.source as! TextViewController
        self.keyDetailLabel.text = input.value
    }
    
    @IBAction func unwindToSetVector(_ unwindSegue: UIStoryboardSegue) {
        let input = unwindSegue.source as! TextViewController
        self.vectorDetailLabel.text = input.value
    }
    
    @IBAction func unwindToSetRounds(_ unwindSegue: UIStoryboardSegue) {
        let select = unwindSegue.source as! SelectViewController
        roundsDetailLabel.text = select.value
    }
    
    @IBAction func unwindToSetMode(_ unwindSegue: UIStoryboardSegue) {
        let select = unwindSegue.source as! SelectViewController
        modeDetailLabel.text = select.value
    }
    
    @IBAction func unwindToSetPadding(_ unwindSegue: UIStoryboardSegue) {
        let select = unwindSegue.source as! SelectViewController
        paddingDetailLabel.text = select.value
    }

    @IBAction func encryptButtonAction(_ sender: UIButton) {
        guard let data = self.dataTextField.text else { return }
        guard let data = data.data(using: .utf8) else { return }
        
        let algorithm = self.cryptorAlgorithm()
        let mode = self.cryptorMode()
        let padding = self.cryptorPadding()
        
        algorithm.rounds = Int(self.roundsDetailLabel.text!) ?? 0
    
        do {
            let cryptor = XZDataCryptor.init(operation: .encrypt, algorithm: algorithm, mode: mode, padding: padding)
            
            let data1 = try cryptor.crypt(data as Data)
            let data2 = try cryptor.final()
            let data = data1 + data2
            // let data = try XZDataCryptor.encrypt(data, algorithm: algorithm, mode: mode, padding: padding)
            self.resultLabel.text = (data as NSData).hexEncodedString(.uppercase)
        } catch {
            self.resultLabel.text = String.init(describing: error)
        }
    }
    
    @IBAction func decryptButtonAction(_ sender: UIButton) {
        guard let string = self.dataTextField.text else { return }
        let data = NSData.init(hexEncodedString: string)
        
        let algorithm = self.cryptorAlgorithm()
        let mode = self.cryptorMode()
        let padding = self.cryptorPadding()
        
        algorithm.rounds = Int(self.roundsDetailLabel.text!) ?? 0
        
        do {
            let cryptor = XZDataCryptor.init(operation: .decrypt, algorithm: algorithm, mode: mode, padding: padding)
            let data1 = try cryptor.crypt(data as Data)
            let data2 = try cryptor.final()
            let data = data1 + data2
            // let data = try XZDataCryptor.decrypt(data as Data, algorithm: algorithm, mode: mode, padding: padding)
            self.resultLabel.text = String.init(data: data, encoding: .utf8);
        } catch {
            self.resultLabel.text = String.init(describing: error)
        }
    }
    
    private func cryptorAlgorithm() -> XZDataCryptor.Algorithm {
        let key    = self.keyDetailLabel.text ?? ""
        let vector = self.vectorDetailLabel.text;
        switch algorithmDetailLabel.text {
        case "AES":
            return .AES(key: key, vector: vector)
        case "DES":
            return .DES(key: key, vector: vector)
        case "3DES":
            return .DES3(key: key, vector: vector)
        case "CAST":
            return .CAST(key: key, vector: vector)
        case "RC4":
            return .RC4(key: key, vector: vector)
        case "RC2":
            return .RC2(key: key, vector: vector)
        case "Blowfish":
            return .Blowfish(key: key, vector: vector)
        default:
            fatalError()
        }
    }
    
    private func cryptorMode() -> XZDataCryptor.Mode {
        switch modeDetailLabel.text {
        case "ECB":
            return .ECB
        case "CBC":
            return .CBC
        case "CFB":
            return .CFB
        case "CTR":
            return .CTR
        case "OFB":
            return .OFB
        case "RC4":
            return .RC4
        case "CFB8":
            return .CFB8
        default:
            fatalError()
        }
    }
    
    private func cryptorPadding() -> XZDataCryptor.Padding {
        switch paddingDetailLabel.text {
        case "none":
            return .none
        case "PKCS7":
            return .PKCS7
        default:
            fatalError()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "algorithm":
            let nextVC = segue.destination as! SelectViewController
            nextVC.value = algorithmDetailLabel.text
        case "key":
            let nextVC = segue.destination as! TextViewController
            nextVC.value = keyDetailLabel.text
        case "vector":
            let nextVC = segue.destination as! TextViewController
            nextVC.value = vectorDetailLabel.text
        case "rounds":
            let nextVC = segue.destination as! SelectViewController
            nextVC.value = roundsDetailLabel.text
        case "mode":
            let nextVC = segue.destination as! SelectViewController
            nextVC.value = modeDetailLabel.text
        case "padding":
            let nextVC = segue.destination as! SelectViewController
            nextVC.value = paddingDetailLabel.text
        default:
            break
        }
        
    }
    
    
}

