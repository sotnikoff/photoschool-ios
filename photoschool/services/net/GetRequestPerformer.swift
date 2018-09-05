//
//  GetRequestPerformer.swift
//  photoschool
//
//  Created by Mikhail Sotnikov on 04.09.2018.
//  Copyright © 2018 Mikhail Sotnikov. All rights reserved.
//

import Foundation

class GetRequestPerformer {
    static public func call(urlPath url: String, callback: @escaping (Data) -> Void){
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            callback(data)
        }
        task.resume()
    }
}
