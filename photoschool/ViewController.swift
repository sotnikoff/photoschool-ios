//
//  ViewController.swift
//  photoschool
//
//  Created by Mikhail Sotnikov on 09.08.2018.
//  Copyright © 2018 Mikhail Sotnikov. All rights reserved.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController {
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBAction private func logInTouch(_ sender: UIButton) {
        if let email = emailField.text, let pass = passwordField.text {
            sendAuthData(email: email, pass: pass)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    struct Auth: Codable {
        var user: User
        var auth_token: AuthToken
    }
    
    struct User: Codable {
        var email: String
    }
    
    struct AuthToken: Codable {
        var payload: Payload
        var token: String
    }
    
    struct Payload: Codable {
        var exp: Int
        var sub: Int
    }
    
    struct JSONPayload: Codable {
        var auth: AuthPayload
    }
    
    struct AuthPayload: Codable {
        var email: String
        var password: String
    }
    
    private func sendAuthData(email: String, pass: String){
        
        let JSONObject = JSONPayload(auth: AuthPayload(email: email, password: pass))
        guard let encodedJSONObject = try? JSONEncoder().encode(JSONObject) else {
            return
        }
        
        var request = URLRequest(url: URL(string: "https://highiso.photo/user_token")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedJSONObject
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let decoder = JSONDecoder()
            let result = try! decoder.decode(Auth.self, from: data)
            let keychain = KeychainSwift()
            print(result.auth_token.token)
            keychain.set(result.auth_token.token, forKey: "token")
            DispatchQueue.main.async {
               self.performSegue(withIdentifier: "AuthSegue", sender: self)
            }
        }
        task.resume()
    }
}
