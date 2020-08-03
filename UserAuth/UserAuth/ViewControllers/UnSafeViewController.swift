//
//  UnSafeViewController.swift
//  UserAuth
//
//  Created by JJ Sahabu on 8/2/20.
//  Copyright © 2020 JJ Sahabu. All rights reserved.
//

import UIKit

class UnSafeViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupelements()

        // Do any additional setup after loading the view.
    }
    
    func setupelements() {
            Utilities.styleEditProfileButton(dismissButton)
    }
    
    @IBAction func Dismiss(_ sender: Any) {
        dismiss(animated: true)

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
