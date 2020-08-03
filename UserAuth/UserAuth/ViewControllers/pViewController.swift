//
//  ViewController.swift
//  tester
//
//  Created by Chelsea Shu on 7/20/20.
//  Copyright © 2020 Chelsea Shu. All rights reserved.
//

import UIKit

class pViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var result = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    private var imagePicker: UIImagePickerController!
    private var imageString: String!
    
    private var didJustTakePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        //takePhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didJustTakePhoto {
            takePhoto()
        }
    }
    
    private func takePhoto() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera //change back to .photoLibary when in sim
        imagePicker.allowsEditing = true
    
//        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
        spinner.startAnimating()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        didJustTakePhoto = true
        imagePicker.dismiss(animated: true) {
            self.didJustTakePhoto = false
        }
        if let image = info[.editedImage] as? UIImage {
            
            imageView.image = image
            imageString = convertImageToBase64String(img: image)
            print(imageString)
            send()
            
            
        } else {
            print("ERROR: bad image")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         imagePicker.dismiss(animated: true)
        tabBarController?.selectedIndex = 0
    }
    
    private func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    private func send() {
        
        let email = UserDefaults.standard.string(forKey: "email") as! String
        let allergies = UserDefaults.standard.string(forKey: "target") as! String
        let parameters = ["image64": imageString,
                          "target": allergies,
                          "uid": email
            ] as [String : Any]
        
        let url = URL(string: "https://0g0teltzwj.execute-api.us-west-2.amazonaws.com/production")!
        
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
        _ = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
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
                    self.result = json["result"] as? String ?? "error"
                    print("RESULT IS", self.result)
                    
                    DispatchQueue.main.async { // Correct
                        
                        print(self.result)
                        if self.result == "unsafe" {
                            self.performSegue(withIdentifier: "unsafe", sender: self)
                            print("YOU'VE REACHED THE UNSAFE IF")
                            
                        } else if self.result == "safe" {
                            self.performSegue(withIdentifier: "safe", sender: self)
                            print("YOU'VE REACHED THE SAFE IF")
                        }
                        else {
                            print("An unexpected error occured")
                        }
                    }
                }
                // handle json...
                
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
    }
}
