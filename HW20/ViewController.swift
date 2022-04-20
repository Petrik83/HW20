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

    @IBAction func generatePasswordBtnDidPressed(_ sender: Any) {
        let randomLength = Int.random(in: 3...4)
//        textField.isSecureTextEntry = true
        activityIndicator.startAnimating()
        textField.text = randomPassord(length: randomLength)
        generatePasswordBtn.isEnabled = false
        label.text = ""
        let textToGuess = textField.text ?? ""
        
        backgroundQueue.async {
            self.bruteForce(passwordToUnlock: textToGuess)
            
            DispatchQueue.main.async {
                self.label.text = self.textField.text
                self.activityIndicator.stopAnimating()
                self.textField.isSecureTextEntry = false
                self.generatePasswordBtn.isEnabled = true
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
    
    func bruteForce(passwordToUnlock: String) {
            let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

            var password: String = ""

            // Will strangely ends at 0000 instead of ~~~
            while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
    //             Your stuff here
                print(password)
                // Your stuff here
            }
            
            print(password)
        }
}


extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
}
