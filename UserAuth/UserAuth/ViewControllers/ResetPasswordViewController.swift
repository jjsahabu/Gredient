//
//  ResetPasswordViewController.swift
//  UserAuth
//
//  Created by Isaac Chau on 7/23/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Amplify
import Alamofire

class ResetPasswordViewController: UIViewController {

    var event = 0
    var user = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    
    func resetPassword(username: String) {
        let semaphore = DispatchSemaphore(value: 0)

        _ = Amplify.Auth.resetPassword(for: username) { result in

            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(info)")
                    self.event = 1

                case .done:
                    print("Reset completed")
                }
            } catch {
                self.event = 2
                print("Reset password failed with error \(error)")
            }
        semaphore.signal()
        }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
    }
    
    func validateForm() {
        
        user = emailTextField.text as! String
        
        resetPassword(username: user)
        
        print(user, "reset their password")
        print("validate event", self.event)
        
        if self.event == 1 {
            print("sent password reset confirmation code")
            self.performSegue(withIdentifier: "confirmResetSegue", sender: self)
        }
        else if self.event == 2 {
            self.errorLabel.text = "Your credentials could not be verified. Please try again."
        }
        else {
            self.errorLabel.text = "u suk isaac"
        }
    }

    @objc func condom() {
        validateForm()
    }
    
    func setUpElements () {
            Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(resetPasswordButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        condom()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! ResetPasswordConfirmationViewController
    vc.email = user
    
}
}
