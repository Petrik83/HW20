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
        setupQueue()
    }

    @IBAction func generatePasswordButtonDidPressed(_ sender: Any) {
        if bruteForce.isExecuting {
            backgroundQueue.cancelAllOperations()
        }
        
        let randomLength = Int.random(in: 3...4)
        let textToGuess = randomPassord(length: randomLength)
        
        startBruteForceSetupView(text: textToGuess)
        bruteForce = BruteForce(passwordToUnlock: textToGuess)

        backgroundQueue.addOperation(bruteForce)
        backgroundQueue.addOperation {
            self.mainQueue.addOperation {
                self.finishBruteForceSetupView(text: textToGuess)
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
    
    func setupView() {
        textField.isSecureTextEntry = true
    }
    
    func setupQueue() {
        backgroundQueue.maxConcurrentOperationCount = 1
    }
    
    func startBruteForceSetupView(text: String) {
        textField.isSecureTextEntry = true
        label.text = ""
        activityIndicator.startAnimating()
        textField.text = text
    }
    
    func finishBruteForceSetupView(text: String) {
        textField.isSecureTextEntry = false
        label.text = text
        activityIndicator.stopAnimating()
    }
}

