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

import Alamofire
import SwiftyJSON

class RESTConnector {
    
    //let endpoint = "http://musiclargeprint-tttttest.rhcloud.com/"
    let endpoint = "http://dacapolp.dzb.de:13857/DaCapoLP/"
    let login = "login/"
    let list = "list/"
    let show = "show/"
    
    
    func getUserData(_ userName : String, password : String, completionHandler: @escaping ([[String:AnyObject]], String?) -> Void) {
        
        var parameters: [String:Any] = [:]
        
        Alamofire.request(self.endpoint + self.login, method: .get,  parameters: parameters).responseJSON {
            
            response in
            
            switch response.result {
                
            case .success:
                
                if let JSON = response.result.value {
                  //  print("Did receive JSON data: \(JSON)")
                    let jsonData = JSON as! [String:Any]
                    let csrf_token = jsonData["csrf_token"] as! String;
                    
                    parameters = ["username" : userName, "password" : password , "csrfmiddlewaretoken" : csrf_token]
                    
                } else {
                    completionHandler([[String:AnyObject]](), "JSON(csrf_token) data is nil.");
                }
                
                Alamofire.request(self.endpoint + self.login, method: .post, parameters: parameters).responseJSON {
                    
                    response in
                    
                    
                    switch response.result {
                        
                    case .success:
                        
                        Alamofire.request(self.endpoint + self.list, method: .get).responseJSON {
                            
                            response in
                            
                            switch response.result {
                                
                            case .success(let value):
                                if let resData = JSON(value)["files"].arrayObject {
                                    completionHandler(resData as! [[String:AnyObject]], nil)
                                }
                                break
                            case .failure:
                                completionHandler([[String:AnyObject]](), self.getErrorMessage(response))
                                break
                            }
                        }
                        
                        break
                    case .failure:
                        completionHandler([[String:AnyObject]](), self.getErrorMessage(response))
                        break
                    }
                }
                
            case .failure:
                completionHandler([[String:AnyObject]](), self.getErrorMessage(response))
                break
            }
        }
    }
    
    
    func getErrorMessage(_ response: Alamofire.DataResponse<Any>) -> String {
        
        let message : String
        if let httpStatusCode = response.response?.statusCode {
            switch(httpStatusCode) {
            case 400:
                message = "Nutzername oder Passwort nicht vorhanden."
            case 401:
                message = "Der eingegebene Nutzername und/oder das Passwort ist nicht gültig."
            case 404:
                message = "Der gewünschte Service steht zur Zeit nicht zur Verfügung."
            case 500:
                message = "Der Service arbeitet fehlerhaft, bitte kontaktieren Sie einen DZB-Mitarbieter."
            case 503:
                message = "Der Service ist nicht verfügbar, bitte kontaktieren Sie einen DZB-Mitarbieter."
                
            default:
                message = "Status Code: " + String(httpStatusCode);
            }
        } else {
            message = response.result.error!.localizedDescription;
        }
        
        //  print("error: " + message);
        return message;
    }
}
