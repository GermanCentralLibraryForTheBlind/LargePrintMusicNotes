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
    
    
    func showRequest(id : String,  completionHandler: (AnyObject, NSError?) -> Void) {
        
        
        let parameters: [String: AnyObject] = ["id": id]
        
        Alamofire.request(.GET, self.endpoint + self.show, parameters: parameters).responseData {
            
            response in
            
            print(response.request)
            print(response.response)
            print(response.result)
            //                completionHandler(responseObject: responseData.data, error: nil)
        }
    }
    
    func loginRequest(userName : String, password : String, completionHandler: ([[String:AnyObject]], NSError?) -> Void) {
        
        
        var parameters: [String: AnyObject] = [:]
        
        Alamofire.request(.GET, self.endpoint + self.login, parameters: parameters).responseJSON {
            response in
            
            if let JSON = response.result.value {
                print("Did receive JSON data: \(JSON)")
                parameters = ["username" : userName, "password" : password , "csrfmiddlewaretoken" : (JSON["csrf_token"] as? String)!]
            }
            else {
                print("JSON data is nil.")
            }
            
            
            Alamofire.request(.POST, self.endpoint + self.login, parameters: parameters).responseJSON {
                
                response in
                //                    print(response.request)
                //                    print(response.response)
                //print(response.result)
                
                
                Alamofire.request(.GET, self.endpoint + self.list).responseJSON {
                    
                    response in
                    
                    print(response.request)
                    print(response.response)
                    switch response.result {
                    case .Success(let value):
                        if let resData = JSON(value)["files"].arrayObject {
                            completionHandler(resData as! [[String:AnyObject]], nil)
                        }
                    case .Failure(let error):
                        completionHandler([[String:AnyObject]](), error)
                    }
                }
                
            }
            //}
        }
        
    }
}