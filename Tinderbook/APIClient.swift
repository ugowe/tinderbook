//
//  APIClient.swift
//  Tinderbook
//
//  Created by Ugowe on 10/11/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    private let TINDER_AUTH_URL = "https://api.gotinder.com/auth"
    private let TINDER_GET_USERS_URL = "https://api.gotinder.com/user/recs"
    
    private var token: String?
    private var authenticated: Bool!
    
    init() {
        
    }
    
    // MARK: - Authentication
    
    /**
     Authenticates with Facebook token and returns Tinder token
     
     - returns: `success`, `token`
     */
    
    func authenticateUser(facebookToken: String, completion: @escaping (_ success: Bool, _ token: String?, _ profile: PersonalProfile?) -> ()) {
        let parameters = ["facebook_token" : facebookToken ]
        
        Alamofire.request(TINDER_AUTH_URL, method: .post, parameters: parameters).responseJSON { (response) in
            
            if response.response?.statusCode == 401 {
                completion(false, nil, nil)
            } else {
                guard let JSON = response.result.value as? [String: AnyObject] else {fatalError("Unable to retrieve JSON")}
                let profile = PersonalProfile(dictionary: JSON["user"] as! [String : AnyObject])
                
                if let token = JSON["token"]  {
                    self.token = token as? String
                    completion(true, self.token, profile)
                }
            }
            
        }
    }
    
    // MARK: - API Functions
    
    /**
     Returns 11 user profile objects
     
     - returns: `success`, `[STProfile]`
     */
    func getRecommendations(completion: @escaping (_ success: Bool, _ profiles: [Profile]?) -> ()) {
        
        guard let token = token else {completion(false, nil); return}
        let headers = ["X-Auth-Token" : token]
        
        Alamofire.request(TINDER_GET_USERS_URL, method: .get, headers: headers).responseJSON { (response) in
            
            if response.response?.statusCode == 401 {
                completion(false, nil)
            } else {
                guard let JSON = response.result.value as? [String: AnyObject] else {fatalError("Unable to retrieve JSON")}
                var profiles: [Profile] = []
                
                for profile in JSON["results"] as! [[String: AnyObject]] {
                    profiles.append(Profile(dictionary: profile))
                }
                completion(true, profiles)
            }
        }
    }
}
