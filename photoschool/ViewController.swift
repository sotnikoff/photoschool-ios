//
//  ViewController.swift
//  photoschool
//
//  Created by Mikhail Sotnikov on 09.08.2018.
//  Copyright © 2018 Mikhail Sotnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func logInTouch(_ sender: UIButton) {
        if let email = emailField.text, let pass = passwordField.text {
            sendAuthData(email: email, pass: pass)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendAuthData(email: String, pass: String){
        let json: [String: Any] = ["auth":["email": email, "password": pass]]
        if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
            var request = URLRequest(url: URL(string: "https://highiso.photo/user_token")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
        }
    }
}
