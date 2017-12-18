//
//  File.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 12/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FacebookCore
import ObjectMapper
import TwitterKit
class Request: NSObject
{
    var email = ""
    var name = ""
    var url = ""
    
    func getFBDetails(onSuccess: @escaping (String,String,String) -> (), onError: @escaping (Bool)-> ())
    {
        if let _ = FBSDKAccessToken.current()
        {
            let params = ["fields": "name,email,picture.width(100)"]
            FBSDKGraphRequest(graphPath: "me", parameters: params).start { (connection, result, error) in
                if error != nil{
                    print("Error")
                    onError(true)
                }
                else{
                    let resultDict = result! as! NSDictionary
                    let name = resultDict.object(forKey: "name") as! String
                    let email = resultDict.object(forKey: "email") as! String
                    let picture = resultDict.object(forKey: "picture") as! NSDictionary
                    let data = picture.object(forKey: "data") as! NSDictionary
                    let dp = data.object(forKey: "url") as! String
                    onSuccess(name,email,dp)
                    }
            }
        }
    }
    
    func getFBResult(onSuccess: @escaping ([String]) -> (), onError: @escaping (Bool)-> ())
    {
        
        var links = [String]()
        if let _ = FBSDKAccessToken.current()
        {
            let params = ["fields": "photos{picture}"]
            FBSDKGraphRequest(graphPath: "me", parameters: params).start { (connection, result, error) in
                if error != nil{
                    print("Error")
                    onError(true)
                }
                else{
                    let resultDict = result! as! NSDictionary
                    if resultDict.object(forKey: "photos") != nil
                    {
                        let photos = resultDict.object(forKey: "photos") as! NSDictionary
                        let data = photos.object(forKey: "data") as! NSArray
                        for i in 0 ..< data.count
                        {
                            let value = data[i] as! NSDictionary
                            let picture = value.object(forKey: "picture") as! String
                            links.append(picture)
                        }
                        onSuccess(links)
                    }
                    
                    else
                    {
                        onError(true)
                    }
                }
            }
        }
    }
    
    func getTwitterResult(onSuccess: @escaping (String,String,String,String) -> (), onError: @escaping (Bool)-> ())
    {
        var email1 = ""
        var flag = 0
        let client = TWTRAPIClient.withCurrentUser()
        let id = client.userID
        client.requestEmail { (email, error) in
            if error == nil
            {
                email1 = email!
                flag = 1
            }
            
        }
        client.loadUser(withID: id!) { (user, error) in
            if error == nil
            {
                if flag == 1
                {
                    onSuccess(user!.name,user!.screenName,user!.profileImageURL,email1)
                }
                else
                {
                    onError(true)
                }
            }
        }
        
    }
}
