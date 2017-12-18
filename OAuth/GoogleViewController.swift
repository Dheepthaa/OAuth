//
//  GoogleViewController.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 15/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
class GoogleViewController: UIViewController {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
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
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.name.text = Auth.auth().currentUser?.displayName!
        //print(Auth.auth().currentUser?.email)
        self.email.text = Auth.auth().currentUser?.email!
        let imageURL = Auth.auth().currentUser?.photoURL!
        let imageData = NSData(contentsOf: imageURL!)
        self.pic.image = UIImage(data: imageData! as Data)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

}
