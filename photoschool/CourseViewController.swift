//
//  CourseViewController.swift
//  photoschool
//
//  Created by Mikhail Sotnikov on 22.08.2018.
//  Copyright © 2018 Mikhail Sotnikov. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var courseID: Int = 0
    
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
    
    struct Task: Codable {
        var id: Int
        var course_id: Int
        var title: String
        var description: String
        var allowed: Bool
        var created_at: String
        var updated_at: String
    }
    
    struct CourseData: Codable {
        var course: Course
        var tasks: [Task]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.courseID)
        
        var request = URLRequest(url: URL(string: "https://highiso.photo/api/courses/"+String(self.courseID))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let decoder = JSONDecoder()
            let course = try! decoder.decode(CourseData.self, from: data)
            print(course)
            DispatchQueue.main.async {
                self.titleLabel.text? = course.course.title
                self.descriptionLabel.text? = course.course.description
            }
            let url = URL(string: course.course.image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                    self.imageView.contentMode = UIViewContentMode.scaleAspectFill
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
