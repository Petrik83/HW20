//
//  ViewController.swift
//  HW20
//
//  Created by Александр Петрович on 04.04.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    

    let backgroundQueue = OperationQueue()
    let mainQueue = OperationQueue.main
    var bruteForce = BruteForce(passwordToUnlock: "")
    
    var labeltext: String = "" {
    
        willSet {
            self.label.text = newValue
        }
    }
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
        backgroundQueue.maxConcurrentOperationCount = 1
        textField.isSecureTextEntry = true

    }

    @IBAction func generatePasswordButtonDidPressed(_ sender: Any) {
        if bruteForce.isExecuting {
            backgroundQueue.cancelAllOperations()
            
        }
        
        let randomLength = Int.random(in: 3...3)
        textField.isSecureTextEntry = true
        label.text = ""
        let textToGuess = randomPassord(length: randomLength)
        activityIndicator.startAnimating()
        textField.text = textToGuess
        bruteForce = BruteForce(passwordToUnlock: textToGuess)

        backgroundQueue.addOperation(bruteForce)

        backgroundQueue.addOperation {
            self.mainQueue.addOperation {
                self.label.text = textToGuess
                self.activityIndicator.stopAnimating()
                self.textField.isSecureTextEntry = false
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

