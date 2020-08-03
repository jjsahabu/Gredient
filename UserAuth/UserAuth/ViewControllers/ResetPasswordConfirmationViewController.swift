//
//  ResetPasswordConfirmationViewController.swift
//  UserAuth
//
//  Created by Isaac Chau on 7/23/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins


class ResetPasswordConfirmationViewController: UIViewController {
    
    var email = ""

    @IBOutlet weak var ConfirmationText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmResetButton: UIButton!
    
    var confirmation = 0
    
    func confirmResetPassword(username: String,
                                newPassword: String,
                                confirmationCode: String) {

        let semaphore = DispatchSemaphore(value: 0)

        _ = Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode) { result in
                switch result {
                case .success:
                    print("Password reset confirmed")
                    self.confirmation = 1
                case .failure(let error):
                    self.confirmation = 2
                    print("Reset password failed with error \(error)")
                }
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
    }
        
    @objc func condom() {
            validateForm()
        }
        
        func validateForm() {
            guard let conf: String = ConfirmationText.text, !conf.isEmpty else { return }
            guard let newPassword: String = passwordText.text, !newPassword.isEmpty else { return }
            
            confirmResetPassword(username: email, newPassword: newPassword, confirmationCode: conf)
            
            if self.confirmation == 1 {
                self.performSegue(withIdentifier: "returnToLogin", sender: self)
            }
            else if self.confirmation == 2 {
                self.errorLabel.text = "Invalid Email or Confirmation Code"
            }
            else {
                self.errorLabel.text = "An unexpected error occured. Please try again."
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func confirm(_ sender: Any) {
        condom()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    func setUpElements() {
            Utilities.styleTextField(ConfirmationText)
            Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(confirmResetButton)
    }

    
}
