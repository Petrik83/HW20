//
//  ViewController.swift
//  HW20
//
//  Created by Александр Петрович on 04.04.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generatePasswordBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var changeColorBtn: UIButton!
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                self.label.textColor = .white
            } else {
                self.view.backgroundColor = .white
                self.label.textColor = .black
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = ""
        textField.isSecureTextEntry = true
    }

    @IBAction func generatePasswordBtnDidPressed(_ sender: Any) {
        let randomLength = Int.random(in: 2...4)
        activityIndicator.startAnimating()
        textField.text = randomPassord(length: randomLength)
        bruteForce(passwordToUnlock: textField.text ?? "", length: randomLength)
        label.text = textField.text
        activityIndicator.stopAnimating()
    }
    
    @IBAction func changeColorBtnDidPressed(_ sender: Any) {
        isBlack.toggle()
    }
    
    func randomPassord(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func bruteForce(passwordToUnlock: String, length: Int) {
        var password: String = ""
        while password != passwordToUnlock {
            password = randomPassord(length: length)
            print(password)
        }
    }
}

