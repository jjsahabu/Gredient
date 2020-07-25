//
//  ViewController.swift
//  UserAuth
//
//  Created by JJ Sahabu on 7/7/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

func signUp(username: String, password: String, email: String) {
    let userAttributes = [AuthUserAttribute(.email, value: email)]
    let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
    _ = Amplify.Auth.signUp(username: username, password: password, options: options) { result in
        switch result {
        case .success(let signUpResult):
            if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails))")
            } else {
                print("SignUp Complete")
            }
        case .failure(let error):
            print("An error occurred while registering a user \(error)")
        }
    }
}

func confirmSignUp(for username: String, with confirmationCode: String) {
    _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
        switch result {
        case .success(_):
                print("Confirm signUp succeeded")
        case .failure(let error):
            print("An error occurred while registering a user \(error)")
        }
    }
}



class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    @objc func condom() {
        validateForm()
    }
    
    func validateForm() {
        guard let user: String = usernameText.text, !user.isEmpty else { return }
        guard let pass: String = PasswordText.text, !pass.isEmpty else { return}
        
        signUp(username: user, password: pass, email: user)
        print("This works!")
        print(user, pass)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func PrintButton(_ sender: Any) {
        condom()
        self.performSegue(withIdentifier: "user", sender: self)

}

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfirmationViewController
        vc.finalUser = usernameText.text!
           
       }
}
