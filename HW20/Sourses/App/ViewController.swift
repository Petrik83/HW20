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
    @IBOutlet weak var generatePasswordButton: UIButton!
    
    let backgroundQueue = OperationQueue()
    let bruteForceQueue = OperationQueue()
    let mainQueue = OperationQueue.main
    
    var bruteForce = BruteForce()
    
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
        setupView()
    }
    
    @IBAction func generatePasswordButtonDidPressed(_ sender: Any) {
        
        let randomLength = Int.random(in: 3...15)
        let textToGuess = randomPassord(length: randomLength)
        let separatedTextToGuessArray = textToGuess.components(withLength: 3)
        
        let startBruteForceSetupViewOperation = BlockOperation {
            self.mainQueue.addOperation {
                self.startBruteForceSetupView(text: textToGuess)
            }
        }
        
        let BruteForceOperation = BlockOperation {
            for text in separatedTextToGuessArray {
                self.backgroundQueue.addOperation {
                    self.bruteForce.bruteForce(passwordToUnlock: text)
                }
            }
            self.backgroundQueue.waitUntilAllOperationsAreFinished()
        }
        
        BruteForceOperation.completionBlock = {
            self.mainQueue.addOperation {
                self.finishBruteForceSetupView(text: textToGuess)
            }
        }
        
        bruteForceQueue.addOperation(startBruteForceSetupViewOperation)
        bruteForceQueue.addOperation(BruteForceOperation)
    }
    
    @IBAction func changeColorButtonDidPressed(_ sender: Any) {
        isBlack.toggle()
    }
    
    func randomPassord(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).compactMap{ _ in letters.randomElement() })
    }
    
    func setupView() {
        textField.isSecureTextEntry = true
    }
    
    func startBruteForceSetupView(text: String) {
        textField.isSecureTextEntry = true
        label.text = ""
        activityIndicator.startAnimating()
        textField.text = text
        generatePasswordButton.isEnabled = false
    }
    
    func finishBruteForceSetupView(text: String) {
        textField.isSecureTextEntry = false
        label.text = text
        activityIndicator.stopAnimating()
        generatePasswordButton.isEnabled = true
    }
}

