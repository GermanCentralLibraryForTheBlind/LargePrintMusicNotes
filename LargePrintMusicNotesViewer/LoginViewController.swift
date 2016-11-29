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
    
    
    @IBAction func login(_ sender: AnyObject) {
        
        let username = self.userName.text
        let password = self.password.text
        
        // Validate the text fields
        if username!.characters.count  < 1 {
            showAlert("Ungültig", alertMessage: "Bitte geben Sie einen Nutzernamen ein.");
        } else if password!.characters.count < 1 {
            showAlert("Ungültig", alertMessage: "Bitte geben Sie das Passwort ein.");
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            
            self.connector.getUserData(username!, password: password!) {
                
                (compositionsJSON, error) in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                self.compositionsJSON = compositionsJSON
                
                if(error == nil) {
                    
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "Compositions", sender:self)
                    }
                } else {
                    
                    self.showAlert("Anmeldung fehlgeschlagen", alertMessage: error!);
                    
                }
                return
            }
        }
        
    }
    
    
    
    func showAlert(_ title: String, alertMessage : String) {
        
        let alertController = UIAlertController(title: title,
                                                message: alertMessage,
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CompositionsViewController {
            let compositionsViewController : CompositionsViewController = segue.destination as! CompositionsViewController
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
    
    
    
    
}
