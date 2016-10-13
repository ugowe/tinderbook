//
//  TableViewController.swift
//  Tinderbook
//
//  Created by Ugowe on 10/11/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    
    let tinderbook = APIClient()
    var profile: Profile? = nil
    let token = "myToken"
    
    func authenticate(completion: @escaping (_ authenticated: Bool) -> ()) {
        tinderbook.authenticateUser(facebookToken: token) { (success, token, profile) in
            if success {
                print("You have been authenticated! Your Tinder token: \(token)")
                self.profile = profile
                completion(true)
            } else {
                print("Unable to authenticate with Facebook token: (\(self.token))")
                completion(false)
            }
        }
    }
    
    func fetchRecommendations() {
        tinderbook.getRecommendations { (success, profiles) in
            if success {
                if let profiles = profiles {
                    self.viewProfiles(profiles: profiles)
                }
            } else {
                print("Unable to fetch recommendations. Inspect your Tinder token")
            }
        }
    }
    
    func viewProfiles(profiles: [Profile]) {
        for profile in profiles {
        print("\(profile.name) is \(profile.distance!) mi away from you.")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Profile" : "Recommendations"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCellId = "profileCell"
        let recommendationCellId = "recommendationCell"
        
        if indexPath.section == 0 {
            let profileCell = tableView.dequeueReusableCell(withIdentifier: profileCellId, for: indexPath) as! ProfileTableViewCell
            
            // Set image, name, details
            
            profileCell.profileImageView.image = UIImage(named: "empty-user")
            profileCell.nameLabel.text = "Jesse, 30"
            
            return profileCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:recommendationCellId, for: indexPath) as! ProfileTableViewCell
            
            // Set image, name, age, distance
            
            cell.profileImageView.image = UIImage(named: "empty-user")
            cell.nameLabel.text = "Jane, 30"
            cell.distanceLabel?.text = "3 mi away"
            
            return cell
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticate { (authenticated) in
            self.fetchRecommendations()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
