//
//  ViewController.swift
//  tester
//
//  Created by Chelsea Shu on 7/20/20.
//  Copyright © 2020 Chelsea Shu. All rights reserved.
//

import UIKit

class pViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
//    var target = Global.sharedGlobal.member
    var result = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    private var imagePicker: UIImagePickerController!
    private var imageString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        takePhoto()
    }
    
    private func takePhoto() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
            imageString = convertImageToBase64String(img: image)
            print(imageString)
        } else {
            print("ERROR: bad image")
        }
    }
    
    private func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    @IBAction func send() {
        
        let parameters = ["image64": imageString,
            "oem": 1,
            "psm": 3,
            "lang": "eng",
            "target": "dairy, wheat, peanuts" //TO UPDATE //
            ] as [String : Any]
        
        let url = URL(string: "https://2m4to2m67f.execute-api.us-west-2.amazonaws.com/dev")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
        
        
        let semaphore = DispatchSemaphore(value: 0)

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
                        }
                       }
                           // handle json...
                   
                   } catch let error {
                       print(error.localizedDescription)
                   }
                semaphore.signal()

                }).resume()
        
               _ = semaphore.wait(wallTimeout: .distantFuture)

                print(result)
                if result == "unsafe" {
                    self.performSegue(withIdentifier: "unsafe", sender: self)
                    print("YOU'VE REACHED THE UNSAFE IF")
                    
              } else if result == "safe" {
                    self.performSegue(withIdentifier: "safe", sender: self)
                    print("YOU'VE REACHED THE SAFE IF")
        }
                else {
                    print("An unexpected error occured")
        }
    }
}
