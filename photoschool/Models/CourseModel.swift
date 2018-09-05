//
//  Course.swift
//  photoschool
//
//  Created by Mikhail Sotnikov on 31.08.2018.
//  Copyright © 2018 Mikhail Sotnikov. All rights reserved.
//

import Foundation

class CourseModel {
    public var id : Int
    public var title: String
    public var description: String
    public var text: String
    public var image: String
    public var featured: Bool
    public var created_at: String
    public var updated_at: String
    
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
    
    struct CourseContainer: Codable {
        var course: Course
    }
    
    init(course: CourseContainer){
        self.id = course.course.id
        self.title = course.course.title
        self.description = course.course.description
        self.text = course.course.text
        self.image = course.course.image
        self.featured = course.course.featured
        self.created_at = course.course.created_at
        self.updated_at = course.course.updated_at
    }
    
    public static func find(id: Int, callback: @escaping (CourseModel) -> Void) {

        GetRequestPerformer.call(urlPath: "https://highiso.photo/api/courses/"+String(id), callback: { data in
            let decoder = JSONDecoder()
            let course = try! decoder.decode(CourseContainer.self, from: data)
            let model = CourseModel(course: course)
            callback(model)
        })
    }
}
