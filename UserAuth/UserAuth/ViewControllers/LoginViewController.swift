//
//  LoginViewController.swift
//  Login Page
//
//  Created by JJ Sahabu on 6/4/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Amplify
import Alamofire

//struct UserVariables {
//    let email: String
//    let target: String
//
//    init (email: String, target: String) {
//        self.email = email
//        self.target = target
//    }
//}
//
//class Global {
//    static let sharedGlobal = Global()
//
//    var member:[UserVariables] = []
//}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var event = "unchanged"
    
    var userEmail = ""
    var userTarget = ""
    var userProfile = ""
    
    //let singleton = Global.sharedGlobal
    
    func signIn(username: String, password: String) {
        let semaphore = DispatchSemaphore(value: 0)
        _ = Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(_):
                print("Sign in succeeded")
                self.event = "success"
                UserDefaults.standard.set(self.emailTextField.text, forKey: "email")
            case .failure(let error):
                print("Sign in failed \(error)")
                self.event = "failure"
            }
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
    }
    
    @objc func wrapper() {
        validateForm()
    }
    
    func validateForm() {
        guard let user: String = emailTextField.text, !user.isEmpty else { return }
        guard let pass: String = passwordTextField.text, !pass.isEmpty else { return}
        signIn(username: user, password: pass)
        print("This works!")
        print(user, pass)
        if self.event == "success" {
            RetrieveUserData()
            self.performSegue(withIdentifier: "success", sender: self)
        }
        else if self.event == "failure" {
            self.errorLabel.text = "Your credentials could not be verified. Please try again."
        }
        else {
            self.errorLabel.text = "u suk isaac"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        if let email = UserDefaults.standard.value(forKey: "email") as? String {
            emailTextField.text = email
            RetrieveUserData()
            self.performSegue(withIdentifier: "success", sender: self)
        }
    }
    
    func RetrieveUserData() {
        let semaphore = DispatchSemaphore(value: 0)
        let parameters = ["email": emailTextField.text]
        
        let url = URL(string: "https://u7rgg7ryma.execute-api.us-west-2.amazonaws.com/dev/user-preferences")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let _: Void = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                    
                    self.userEmail = json["email"]! as! String
                    self.userTarget = json["target"]! as! String
                    self.userProfile = json["id"]! as! String
                    
//                    let globalData = UserVariables(email: self.userEmail, target: self.userTarget)
//                    self.singleton.member.append(globalData)
                    
                    UserDefaults.standard.set(self.userTarget, forKey: "target")
                    UserDefaults.standard.set(self.userTarget, forKey: "target")


                    
                }
                // handle json...
                
            }
                
            catch let error {
                print(error.localizedDescription)
            }
            semaphore.signal()
            
        }).resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        wrapper()
    }
    
    func setUpElements () {
            Utilities.styleTextField(emailTextField)
            Utilities.styleTextField(passwordTextField)
            Utilities.styleFilledButton(loginButton)
    }
}
