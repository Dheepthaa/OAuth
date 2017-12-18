//
//  ViewController.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 11/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKShareKit
import FacebookCore
import FacebookLogin
import TwitterKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
    @IBOutlet weak var loginButton3: UIButton!
    @IBOutlet weak var loginButton2: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var links = [String]()
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error) != nil
        {
            return
        }
       
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error
            {
                self.alert(error: error)
                return
            }
            UserDefaults.standard.set("google", forKey: "App")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resultViewController = storyboard.instantiateViewController(withIdentifier: "GoogleViewController") as! GoogleViewController
            self.navigationController?.pushViewController(resultViewController, animated: true)
            return
            
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewDesign()
    }
    
    func viewDesign()
    {
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true
        loginButton2.layer.cornerRadius = loginButton2.frame.height/2
        loginButton2.clipsToBounds = true
        loginButton3.layer.cornerRadius = loginButton2.frame.height/2
        loginButton3.clipsToBounds = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        #imageLiteral(resourceName: "bg").draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginFacebook(_ sender: UIButton) {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email","user_photos"], from: self) { (result, error) in
            if let error = error
            {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else
            {
                print("Failed to get access token")
                return
            }
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error
                {
                    self.alert(error: error)
                    return
                }
               UserDefaults.standard.set("fb", forKey: "App")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let resultViewController = storyboard.instantiateViewController(withIdentifier: "FacebookViewController") as! FacebookViewController
                self.navigationController?.pushViewController(resultViewController, animated: true)
                return
                
            })
            
        }
    }
    
    @IBAction func loginTwitter(_ sender: UIButton) {
        
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                
                return
            }
            let credential = TwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error
                {
                    self.alert(error: error)
                    return
                }
               UserDefaults.standard.set("twit", forKey: "App")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let resultViewController = storyboard.instantiateViewController(withIdentifier: "TwitterViewController") as! TwitterViewController
                self.navigationController?.pushViewController(resultViewController, animated: true)
                return
                
            }
        })
    }
    
    func alert(error: Error)
    {
        print("Login error: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loginGoogle()
    {
        if UserDefaults.standard.string(forKey: "App") != "google"
        {
            GIDSignIn.sharedInstance().signOut()
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    
    
}


