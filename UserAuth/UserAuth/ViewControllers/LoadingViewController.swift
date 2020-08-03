//
//  LoadingViewController.swift
//  UserAuth
//
//  Created by JJ Sahabu on 7/27/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
//    var target = Global.sharedGlobal.member[0].target
//    var result = ""

     // send()
    }
    
//    private func send() {
//
//            let parameters = ["image64": imageString,
//                              "target": target //TO UPDATE //
//                ] as [String : Any]
//
//            let url = URL(string: "https://0g0teltzwj.execute-api.us-west-2.amazonaws.com/production")!
//
//            let session = URLSession.shared
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//
//            //let semaphore = DispatchSemaphore(value: 0)
//
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//            //create dataTask using the session object to send data to the server
//            _ = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//                guard error == nil else {
//                    return
//                }
//
//                guard let data = data else {
//                    return
//                }
//
//                do {
//                    //create json object from data
//                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                        print(json)
//                        self.result = json["result"] as? String ?? "error"
//                        print("RESULT IS", self.result)
//
//                        DispatchQueue.main.async { // Correct
//
//                            print(self.result)
//                            if self.result == "unsafe" {
//                                self.performSegue(withIdentifier: "unsafe", sender: self)
//                                print("YOU'VE REACHED THE UNSAFE IF")
//
//                            } else if self.result == "safe" {
//                                self.performSegue(withIdentifier: "safe", sender: self)
//                                print("YOU'VE REACHED THE SAFE IF")
//                            }
//                            else {
//                                print("An unexpected error occured")
//                            }
//                        }
//                    }
//                    // handle json...
//
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//                //semaphore.signal()
//
//            }).resume()
//
//            //_ = semaphore.wait(wallTimeout: .distantFuture)
//
//
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
