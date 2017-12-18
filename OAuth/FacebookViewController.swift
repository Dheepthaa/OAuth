//
//  FacebookViewController.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 18/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import Firebase
class FacebookViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
        self.navigationItem.setHidesBackButton(true, animated:true)
        getDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func getDetails()
    {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Request().getFBDetails(onSuccess: { (name, email, dp) in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.name.text = name
            self.email.text = email
            let imageURL = URL(string: dp)
            let imageData = NSData(contentsOf: imageURL!)
            let image = UIImage(data: imageData! as Data)!
            self.pic.image = image
        }, onError: {(error) -> () in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Alert", message: ("Could not fetch details"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    @IBAction func viewPhotos(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "PhotoCollectionViewController") as! PhotoCollectionViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    @objc func signOut()
    {
        let firebaseAuth = Auth.auth()
        do
        {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
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
    
}
