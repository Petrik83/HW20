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
    
    let backgroundQueue = DispatchQueue.global(qos: .utility)
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                self.label.textColor = .white
                self.activityIndicator.color = .white
            } else {
                self.view.backgroundColor = .white
                self.label.textColor = .black
                self.activityIndicator.color = .gray
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = ""
        textField.isSecureTextEntry = false
    }

    @IBAction func generatePasswordBtnDidPressed(_ sender: Any) {
        let randomLength = Int.random(in: 3...5)
        activityIndicator.startAnimating()
        textField.text = randomPassord(length: randomLength)
        
        backgroundQueue.async {
            self.bruteForce(passwordToUnlock: self.textField.text ?? "", length: randomLength)
            DispatchQueue.main.async {
                self.label.text = self.textField.text
                self.activityIndicator.stopAnimating()
            }
        }
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

