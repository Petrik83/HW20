//
//  BruteForce.swift
//  HW20
//
//  Created by Александр Петрович on 20.04.2022.
//

import Foundation

class BruteForce {
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""
        
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
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
        var string: String = string
        if string.count <= 0 {
            string.append(characterAt(index: 0, array))
        }
        else {
            guard string.last != nil else { return "" }

            string.replace(at: string.count - 1,
                        with: characterAt(index: (indexOf(character: string.last!, array) + 1) % array.count, array))
            
            if indexOf(character: string.last!, array) == 0 {
                guard string.last != nil else { return "" }

                string = String(generateBruteForce(String(string.dropLast()), fromArray: array)) + String(string.last!)
            }
        }
        return string
    }
}





