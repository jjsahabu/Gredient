//
//  ViewController.swift
//  Login Page
//
//  Created by JJ Sahabu on 6/4/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Amplify

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
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
        setUpElements()
        //SIGNOUT()
        // Do any additional setup after loading the view.
//    setUpElements()
    
    }

    func setUpElements () {
        Utilities.styleHollowButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
//
}

}
