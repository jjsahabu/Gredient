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

class SignUpViewController: UIViewController {
    
    var result = 0
    var errorMessage: [Any] = []

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @objc func wrapper() {
        validateForm()
    }
    
    func validateForm() {
        guard let user: String = usernameText.text, !user.isEmpty else { return }
        guard let pass: String = PasswordText.text, !pass.isEmpty else { return}
        
        signUp(username: user, password: pass, email: user)
        
        if result == 1 {
            self.performSegue(withIdentifier: "user", sender: self)

        } else if result == 2 {
            self.errorLabel.text = "An error occurred while registering a user \(errorMessage[0])"
        } else {
            print("An unexpected error occured")
    }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         setUpElements()
        
    }


    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfirmationViewController
        vc.finalUser = usernameText.text!
           
       }
    func signUp(username: String, password: String, email: String) {
        let semaphore = DispatchSemaphore(value: 0)
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        _ = Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                self.result = 1
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                self.result = 2
                self.errorMessage = [error]
            }
        semaphore.signal()

        }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)

    }
    
    
    @IBAction func signupAction(_ sender: Any) {
        wrapper()
    }
    
    func setUpElements () {
            Utilities.styleTextField(usernameText)
            Utilities.styleTextField(PasswordText)
            Utilities.styleFilledButton(signUpButton)
    }
}
