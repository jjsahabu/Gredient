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
            
    func SIGNOUT() {
           _ = Amplify.Auth.signOut() { result in
           
       switch result {
       case .success:
           print("Successfully signed out")
       case .failure(let error):
           print("Sign out failed with error \(error)")
       }
       }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var testAccess = Global.sharedGlobal.member
//        print(testAccess)
        

        // Do any additional setup after loading the view.
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
