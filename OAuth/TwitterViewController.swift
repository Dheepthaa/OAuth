//
//  TwitterViewController.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 14/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import TwitterKit

class TwitterViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.getDetails()
    }
    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do
        {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.set(nil, forKey: "App")
        if self == navigationController?.viewControllers[0]
        {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navController = UINavigationController(rootViewController: VC1)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func getDetails()
    {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        Request().getTwitterResult(onSuccess: {(name,screenName,picURL,email) -> () in
            
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.displayName.text =  name
            self.userName.text = "@"+screenName
            self.email.text = email
            let imageURL = URL(string: picURL)
            let imageData = NSData(contentsOf: imageURL!)
            let image = UIImage(data: imageData! as Data)!
            self.pic.image = image
            
        },onError: { (error) -> () in
           
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Alert", message: ("Could not fetch details"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
       
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
