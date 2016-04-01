// Created by Lars Voigt.
//
//The MIT License (MIT)
//Copyright (c) 2016 German Central Library for the Blind (DZB)
//Permission is hereby granted, free of charge, to any person obtaining a copy 
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    var connector = RESTConnector()
    var compositionsJSON = [[String:AnyObject]]()
    
    
    @IBAction func login(sender: AnyObject) {
        
        let username = self.userName.text
        let password = self.password.text
        
        self.connector.loginRequest(username!, password: password!) {
            
            (compositionsJSON, error) in
            
            self.compositionsJSON = compositionsJSON
            print("responseObject = \(compositionsJSON); error = \(error)")
            
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("Compositions", sender:self)
            }
            return
        }
        
        //        // Validate the text fields
        //        if username!.characters.count  < 5 {
        //            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
        //            alert.show()
        //
        //        } else if password!.characters.count < 8 {
        //            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
        //            alert.show()
        //
        //        } else {
        //            // Run a spinner to show a task in progress
        //            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        //            spinner.startAnimating()
        
        
        
        //            // Send a request to login
        //            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
        //
        //                // Stop the spinner
        //                spinner.stopAnimating()
        //
        //                if ((user) != nil) {
        //                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
        //                    alert.show()
        //
        //                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
        //                        self.presentViewController(viewController, animated: true, completion: nil)
        //                    })
        //
        //                } else {
        //                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
        //                    alert.show()
        //                }
        //            })
        //      }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is CompositionsViewController {
            let compositionsViewController : CompositionsViewController = segue.destinationViewController as! CompositionsViewController
            compositionsViewController.populateTable(compositionsJSON)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
