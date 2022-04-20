//
//  ViewController.swift
//  HW20
//
//  Created by Александр Петрович on 04.04.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generatePasswordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var changeColorButton: UIButton!
    
    let bruteForce = BruteForce()

    let backgroundQueue = DispatchQueue(label: "bruteForce", qos: .utility)
    
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
    }

    @IBAction func generatePasswordButtonDidPressed(_ sender: Any) {
        let randomLength = Int.random(in: 3...3)
//        textField.isSecureTextEntry = true
        activityIndicator.startAnimating()
        textField.text = randomPassord(length: randomLength)
        generatePasswordButton.isEnabled = false
        label.text = ""
        let textToGuess = textField.text ?? ""
        
        backgroundQueue.async {
            self.bruteForce.bruteForce(passwordToUnlock: textToGuess)
            
            DispatchQueue.main.async {
                self.label.text = self.textField.text
                self.activityIndicator.stopAnimating()
                self.textField.isSecureTextEntry = false
                self.generatePasswordButton.isEnabled = true
            }
        }
    }
    
    @IBAction func changeColorButtonDidPressed(_ sender: Any) {
            isBlack.toggle()
    }
    
    func randomPassord(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}




