//
//  PhotoCollectionViewController.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 12/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FacebookCore
private let reuseIdentifier = "PhotoCollectionViewCell"

class PhotoCollectionViewController: UICollectionViewController
{
    
    var images = [UIImage]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getLinks()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
       cell.photo.image = images[indexPath.row]
        return cell
    }
    
    func getLinks()
    {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        Request().getFBResult(onSuccess: {(photoLinks) -> () in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            for i in 0 ..< photoLinks.count
            {
                let imageURL = URL(string: photoLinks[i])
                let imageData = NSData(contentsOf: imageURL!)
                self.images.append(UIImage(data: imageData! as Data)!)
            }
          
            self.collectionView?.dataSource = self
            self.collectionView?.delegate = self
            
            if let layout = self.collectionView?.collectionViewLayout as? CustomLayout
            {
                layout.delegate = self   
            }
            self.collectionView?.reloadData()
            
        }, onError: {(isError) -> () in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            if isError == true
            {
                let alert = UIAlertController(title: "Alert", message: ("No permission "), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

}

extension PhotoCollectionViewController: CustomLayoutDelegate
{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return images[indexPath.item].size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return images[indexPath.item].size.width
    }
    
    
}
