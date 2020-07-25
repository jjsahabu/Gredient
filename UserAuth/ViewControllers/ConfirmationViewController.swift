//
//  ConfirmationViewController.swift
//  UserAuth
//
//  Created by JJ Sahabu on 7/8/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins


class ConfirmationViewController: UIViewController {

    @IBOutlet weak var ConfirmationText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var finalUser = ""
    
    var confirmation = 0
    
    func confirmSignUp(for username: String, with confirmationCode: String) {
         let semaphore = DispatchSemaphore(value: 0)
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(_):
                print("Confirm signUp succeeded")
                self.confirmation = 1
                
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
                self.confirmation = 2
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
            
            confirmSignUp(for: finalUser, with: conf)
            print(finalUser)
            
            if self.confirmation == 1 {
                self.performSegue(withIdentifier: "access", sender: self)
            }
            else if self.confirmation == 2 {
                self.errorLabel.text = "Invalid Confirmation Code"
            }
            else {
                self.errorLabel.text = "An unexpected error occured. Please contact a help representative."
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func confirmButton(_ sender: Any) {
        condom()
    }
}
