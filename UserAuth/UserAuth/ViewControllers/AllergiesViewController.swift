//
//  AllergiesViewController.swift
//  UserAuth
//
//  Created by JJ Sahabu on 7/19/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit
import Alamofire

class AllergiesViewController: UIViewController {

    //ROOM FOR TOKEN TEXT FIELD //
    
    //JJ CAN YOU WRITE ME PLEASE I WANT TO BE WRITTEN INTO REALITY //
    
    //END HERE //
    
    let parameters = ["email": "jjsahabu@gmail.com",
                    "new_target": "peanuts, wheat, isaac"] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func UpdateTarget() {
        
       let url = URL(string: "https://u7rgg7ryma.execute-api.us-west-2.amazonaws.com/dev/user-preferences/update")!
       
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
                   
                   }
                       // handle json...
               
               } catch let error {
                   print(error.localizedDescription)
               }
           })
           task.resume()
           
       }
    
        
    @IBAction func updateButton(_ sender: Any) {
        UpdateTarget()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
