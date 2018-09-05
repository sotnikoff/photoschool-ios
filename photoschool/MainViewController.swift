//
//  MainViewController.swift
//  photoschool
//
//  Created by Mikhail Sotnikov on 13.08.2018.
//  Copyright © 2018 Mikhail Sotnikov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var courseID: Int = 0
    @IBOutlet var tableView: UITableView!
    var tableData = [FailableDecodable<Course>]()
    
    struct Course: Codable {
        var id: Int
        var title: String
        var description: String
        var text: String
        var image: String
        var featured: Bool
        var created_at: String
        var updated_at: String
    }
    
    struct FailableDecodable<Base : Decodable> : Decodable {
        let base: Base?
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.base = try? container.decode(Base.self)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].base?.title
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.courseID = (tableData[indexPath.row].base?.id)!
        self.performSegue(withIdentifier: "CourseViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseViewSegue" {
            guard let destinationVC = segue.destination as? CourseViewController else {
                return
            }
            destinationVC.courseID = self.courseID
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = URLRequest(url: URL(string: "https://highiso.photo/api/courses")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let decoder = JSONDecoder()
            let courses = try! decoder.decode([FailableDecodable<Course>].self, from: data)
            self.tableData = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
