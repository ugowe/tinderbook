//
//  Profile.swift
//  Tinderbook
//
//  Created by Ugowe on 10/11/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation


class Profile {
    
    enum GenderType: Int {
        case GenderTypeFemale = 0
        case GenderTypeMale = 1
    }
    
    struct Interest {
        var id: String
        var name: String
    }
    
    struct Job {
        var companyId: String?
        var company: String?
        
        var titleId: String?
        var title: String?
    }
    
    struct School {
        var id: String?
        var name: String?
        var year: String?
        var type: String?
    }
    
    struct Photo {
        enum PhotoSize: Int {
            case Size640 = 0
            case Size320 = 1
            case Size172 = 2
            case Size84 = 3
        }
        
        var photoURL: String?
        
        // [640x640], 320x320, 172x172, 84x84 are resolutions
        // => photos[i]["processed_files"][x]["url"]
        
        func photoWithSize(size: PhotoSize) -> Photo {
            return Photo(photoURL: nil)
        }
    }
    
    var id: String
    var name: String
    var birthdate: String // => "1996-09-04T00:00:00.000Z"
    var distance: Int?
    var bio: String
    var gender: GenderType
    
    var photos: [Photo] = []
    var jobs: [Job]? = []
    var schools: [School]? = []
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["_id"] as! String
        self.name = dictionary["name"] as! String
        self.birthdate = dictionary["birth_date"] as! String
        self.distance = dictionary["distance_mi"] as? Int
        self.bio = dictionary["bio"] as! String
        self.gender = GenderType(rawValue: dictionary["gender"] as! Int)!
        
        for photo in dictionary["photos"] as! [NSDictionary] {
            let photoURL = photo["url"] as! String
            let photoObject = Photo(photoURL: photoURL)
            
            photos.append(photoObject)
        }
        
        for job in dictionary["jobs"] as! [[String: AnyObject]] {
            let companyId = job["company"]?["id"] as? String
            let companyName = job["company"]?["name"] as? String
            
            let jobId = job["title"]?["id"] as? String
            let jobName = job["title"]?["name"] as? String
            
            let job = Job(companyId: companyId, company: companyName, titleId: jobId, title: jobName)
            jobs?.append(job)
        }
        
        for school in dictionary["schools"] as! [[String: AnyObject]] {
            let schoolId = school["id"] as? String
            let schoolName = school["name"] as? String
            let schoolYear = school["year"] as? String
            let schoolType = school["type"] as? String
            
            let school = School(id: schoolId, name: schoolName, year: schoolYear, type: schoolType)
            schools?.append(school)
        }
    }
}
