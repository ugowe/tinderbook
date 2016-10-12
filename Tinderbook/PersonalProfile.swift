//
//  PersonalProfile.swift
//  Tinderbook
//
//  Created by Ugowe on 10/11/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation

class PersonalProfile : Profile {
    
    var discoverable: Bool
    var genderFilter: GenderType
    
    var lastActiveTime: String
    var createdAtTime: String
    
    var distanceFilter: Int
    var ageFilterMin: Int
    var ageFilterMax: Int
    
    var interests: [Interest] = []
    
    override init(dictionary: [String: AnyObject]) {
        self.discoverable = dictionary["discoverable"] as! Bool
        self.genderFilter = GenderType(rawValue: dictionary["gender_filter"] as! Int)!
        
        self.lastActiveTime = dictionary["active_time"] as! String
        self.createdAtTime = dictionary["create_date"] as! String
        
        self.distanceFilter = dictionary["distance_filter"] as! Int
        self.ageFilterMin = dictionary["age_filter_min"] as! Int
        self.ageFilterMax = dictionary["age_filter_max"] as! Int
    
        for interest in dictionary["interests"] as! [[String: AnyObject]] {
            let interest = Interest(id: interest["id"] as! String, name: interest["name"] as! String)
            interests.append(interest)
        }
        
        super.init(dictionary: dictionary)
    }
}
