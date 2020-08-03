//
//  FeaturesViewController.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import ResizingTokenField

class FeaturesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var profileName: UITextField!
    
    var email = ""
    
    var gateway = 0
    
    class Token: ResizingTokenFieldToken, Equatable {
        
        static func == (lhs: Token, rhs: Token) -> Bool {
            return lhs === rhs
        }
        
        var title: String
        
        init(title: String) {
            self.title = title
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tokenField: ResizingTokenField!
    @IBOutlet weak var SaveAllergyButton: UIButton!
    
    private lazy var titles: [String] = { "Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elit".components(separatedBy: " ") }()
    private var randomTitle: String { return titles[Int(arc4random_uniform(UInt32(titles.count)))] }
    
    func setupElements() {
        Utilities.styleFilledButton(SaveAllergyButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        
        tokenField.layer.borderWidth = 1
        tokenField.layer.borderColor = UIColor.darkGray.cgColor
        tokenField.preferredTextFieldReturnKeyType = .done
        tokenField.preferredTextFieldEnablesReturnKeyAutomatically = true
        tokenField.textFieldDelegate = self
        UIView.animate(withDuration: tokenField.animationDuration) {
                       self.scrollView.layoutIfNeeded()
                   }

        let placeholder = "Type here…"
        tokenField.placeholder = placeholder
        
        tokenField.labelText = "Allergies: "
//        let tokens: [Token] = [
//            Token(title: "Lorem"),
//            Token(title: "Ipsum")
//        ]
        
//        tokenField.append(tokens: tokens)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func stringifyTokens() -> String {
        return tokenField.tokens.map{$0.title.trimmingCharacters(in: .whitespacesAndNewlines)}.joined(separator: ", ")
    }
    
    // MARK: - Rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tokenField.invalidateLayout()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == tokenField.textField else { return true }
        guard let text = textField.text, !text.isEmpty else { return true }
        
        tokenField.append(tokens: [Token(title: text)])
        tokenField.text = nil
        return false
    }
    
    func apiCall () {
        let target = self.stringifyTokens()
        UserDefaults.standard.set(target, forKey: "target")
        let semaphore = DispatchSemaphore(value: 0)
        let userid = self.profileName.text!
        
            let parameters = ["email": self.email,
                          "target": target,
                          "profile": userid] as [String : Any]
        
        let url = URL(string: "https://ebbxirdgr9.execute-api.us-west-2.amazonaws.com/dev")!
              
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
                  let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                      guard error == nil else {
                          return
                      }

                      guard let data = data else {
                          return
                      }

                      do {
                          //create json object from data
                          if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                              print(json)
                            self.gateway = json["gateway"] as! Int
                          }
                              // handle json...
                      } catch let error {
                          print(error.localizedDescription)
                      }
                    semaphore.signal()
                    }).resume()
                _ = semaphore.wait(wallTimeout: .distantFuture)

    }
    
    
    @IBAction func confirmTokenButton(_ sender: Any) {
        let profile = self.profileName.text!
        apiCall()
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(profile, forKey: "profile")

        if self.gateway == 1 {
            self.performSegue(withIdentifier: "signupcomplete", sender: self)

        }else {
            print("You've encountered an error")
        }
    }
}

struct CustomConfiguration: DefaultTokenCellConfiguration {
    func cornerRadius(forSelected isSelected: Bool) -> CGFloat {
        return 0
    }
    
    func borderWidth(forSelected isSelected: Bool) -> CGFloat {
        return 1.0
    }
    
    func borderColor(forSelected isSelected: Bool) -> CGColor {
        return UIColor.red.cgColor
    }
    
    func textColor(forSelected isSelected: Bool) -> UIColor {
        return isSelected ? .green : .red
    }
    
    func backgroundColor(forSelected isSelected: Bool) -> UIColor {
        return isSelected ? .red : .green
    }
}
