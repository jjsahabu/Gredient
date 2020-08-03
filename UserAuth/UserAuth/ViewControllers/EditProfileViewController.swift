//
//  EditProfileViewController.swift
//  UserAuth
//
//  Created by JJ Sahabu on 7/30/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import ResizingTokenField
import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
//    enum StorageType {
//        case userDefaults
//        case fileSystem
//    }
//
//    private func store(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
//        if let pngRepresentation = image.pngData() {
//            switch storageType {
//            case .fileSystem:
//                if let filePath = filePath(forKey: key) {
//                               do  {
//                                   try pngRepresentation.write(to: filePath,
//                                                               options: .atomic)
//                               } catch let err {
//                                   print("Saving file resulted in error: ", err)
//                               }
//                           }
//            case .userDefaults:
//                UserDefaults.standard.set(pngRepresentation, forKey: key)
//
//                // Save to user defaults
//            }
//        }
//    }
//
//    private func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
//        switch storageType {
//        case .fileSystem:
//            if let filePath = self.filePath(forKey: key),
//                let fileData = FileManager.default.contents(atPath: filePath.path),
//                let image = UIImage(data: fileData) {
//                return image
//            }
//        case .userDefaults:
//            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
//            let image = UIImage(data: imageData) {
//
//            return image
//            }
//        }
//        return nil
//
//    }
//
//    private func filePath(forKey key: String) -> URL? {
//        let fileManager = FileManager.default
//        guard let documentURL = fileManager.urls(for: .documentDirectory,
//                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
//
//        return documentURL.appendingPathComponent(key + ".png")
//    }
//
//

     var gateway = 0
    
    func TargetParse() {
     let allergies = UserDefaults.standard.string(forKey: "target") as! String
     let array = allergies.components(separatedBy: ", ") as Array
        print("array:", array)
        var holder: [Token] = []
        for items in array {
            var temp = Token(title: items)
            holder.append(temp)
        }
            print(holder)
            tokenField.append(tokens: holder)
        }
    


     
     class Token: ResizingTokenFieldToken, Equatable {
         
         static func == (lhs: Token, rhs: Token) -> Bool {
             return lhs === rhs
         }
         var title: String
         init(title: String) {
             self.title = title
         }
     }
    
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var tokenField: ResizingTokenField!
    @IBOutlet weak var SaveChangesButton: UIButton!
    
    func setupElements() {
        Utilities.styleFilledButton(SaveChangesButton)
    }
    
    
     private lazy var titles: [String] = { "Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elit".components(separatedBy: " ") }()
     private var randomTitle: String { return titles[Int(arc4random_uniform(UInt32(titles.count)))] }
     
     override func viewDidLoad() {
         super.viewDidLoad()
        
        setupElements()
        self.profileName.text = UserDefaults.standard.string(forKey: "profile") as! String
         
         tokenField.layer.borderWidth = 1
         tokenField.layer.borderColor = UIColor.darkGray.cgColor
         tokenField.preferredTextFieldReturnKeyType = .done
         tokenField.preferredTextFieldEnablesReturnKeyAutomatically = true
         tokenField.textFieldDelegate = self
         UIView.animate(withDuration: tokenField.animationDuration) {
//                        self.scrollView.layoutIfNeeded()
                    }

         let placeholder = "Type here…"
         tokenField.placeholder = placeholder
         
         tokenField.labelText = "Allergies: "
 //        let tokens: [Token] = [
 //            Token(title: "Lorem"),
 //            Token(title: "Ipsum")
 //        ]
         
 //        tokenField.append(tokens: tokens)
        TargetParse()
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
        
         let email = UserDefaults.standard.string(forKey: "email") as! String
         let target = self.stringifyTokens()
        
        UserDefaults.standard.set(target, forKey: "target")
        UserDefaults.standard.set(profileName.text, forKey: "profile")
        
         let semaphore = DispatchSemaphore(value: 0)
         let userid = self.profileName.text!
         
             let parameters = ["email": email,
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
                             //self.gateway = json["gateway"] as! Int
                           }
                               // handle json...
                       } catch let error {
                           print(error.localizedDescription)
                       }
                     semaphore.signal()
                     }).resume()
                 _ = semaphore.wait(wallTimeout: .distantFuture)

     }
    
    @IBAction func Save(_ sender: Any) {
        apiCall()
        dismiss(animated: true)
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

    
}
