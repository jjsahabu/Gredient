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

//struct UserInformation {
//    let email: String
//    let target: String
//}

struct UserVariables {
    let email = ""
    let target = ""

    init (email: String, target: String) {
        self.email = email
        self.target = target
    }
}

class Global {
    static let sharedGlobal = Global()

    var member:[UserVariables] = []
}


class LoginViewController: UIViewController {
    
//    func parseJSON(data: Data) -> UserInformation? {
//
//        var returnValue: UserInformation?
//        do {
//            returnValue = try JSONDecoder().decode(UserInformation.self, from: data)
//        } catch {
//            print("Error took place: \(error.localizedDescription).")
//        }
//
//        return returnValue
//    }

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
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
    
    var event = "unchanged"
    
    var userEmail = ""
    var userTarget = ""
    
//    let singleton = Global.sharedGlobal
    
    func signIn(username: String, password: String) {
            let semaphore = DispatchSemaphore(value: 0)
            _ = Amplify.Auth.signIn(username: username, password: password) { result in
                switch result {
                case .success(_):
                    print("Sign in succeeded")
                    self.event = "success"
                case .failure(let error):
                    print("Sign in failed \(error)")
                    self.event = "failure"
                }
                semaphore.signal()
            }.resume()
            _ = semaphore.wait(wallTimeout: .distantFuture)
        }
    
        @objc func condom() {
            validateForm()
            //gateway()
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
            // Do any additional setup after loading the view.
    //        setUpElements()
        }
    
    
    func RetrieveUserData() {
        let semaphore = DispatchSemaphore(value: 0)
        let parameters = ["email": emailTextField.text]
               //real let parameters = ["email": emailTextField.text]
        
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
                    print("TEST")
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                        
                       // let data = Data(json.utf8)
                       //  _ = self.parseJSON(data:data)
                        self.userEmail = json["email"]! as! String
                        self.userTarget = json["target"]! as! String
                                            
                    }
                        // handle json...
                
                }
                
                catch let error {
                    print(error.localizedDescription)
                }
                semaphore.signal()

                }).resume()
                
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
//        let userInfo = UserVariables(globalData: self.userData)
//        singleton.member.append(userInfo)
//        print(singleton)

        }

@IBAction func loginTapped(_ sender: Any) {
    condom()
    let x = UserVariables(email: userEmail, target: userTarget)
//    let x = UserInformation(from: Decoder)
//    print("USER EMAIL:", self.userEmail)
//    print("USER TARGET:", self.userTarget)
    print(x.email)
    print(x.target)
        }
    
@IBAction func SignOutButton(_ sender: Any) {
    SIGNOUT()
    }
}
