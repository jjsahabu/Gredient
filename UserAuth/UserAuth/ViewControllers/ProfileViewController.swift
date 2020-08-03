//
//  ProfileViewController.swift
//  UserAuth
//
//  Created by JJ Sahabu on 7/10/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Amplify

class ProfileViewController: UIViewController {
            
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var EditProfileButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    
    func SIGNOUT() {
        _ = Amplify.Auth.signOut() { result in
            
            switch result {
            case .success:
                print("Successfully signed out")
                UserDefaults.standard.removeObject(forKey: "email")
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    func setupElements() {
      Utilities.styleEditProfileButton(EditProfileButton)
      Utilities.styleSignOutButton(signOutButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let email = UserDefaults.standard.string(forKey: "email") as! String
        let target = UserDefaults.standard.string(forKey: "target") as! String
        let profile = UserDefaults.standard.string(forKey: "profile") as! String


        emailLabel.text = email
        targetLabel.text = target
        profileName.text = profile
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        SIGNOUT()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
