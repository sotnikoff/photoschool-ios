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
    @IBOutlet private var imageView: UIImageView!
    
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
        
        CourseModel.find(id: self.courseID, callback: { course in
            print(course.id)
            DispatchQueue.main.async {
                self.titleLabel.text? = course.title
                self.descriptionLabel.text? = course.description
            }
            let url = URL(string: course.image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                    self.imageView.contentMode = UIViewContentMode.scaleAspectFill
                }
            }
        })
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
