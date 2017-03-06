//
//  ViewController.swift
//  Instagram-Demo
//
//  Created by Jose Guerrero on 3/6/17.
//  Copyright © 2017 Jose Guerrero. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            
            if user != nil{
                print("logged in")
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
            
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("yay, created user")
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
            else{
                print("\(error?.localizedDescription)")
                
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

