//
//  CameraViewController.swift
//  CodepathInstagram
//
//  Created by Sarn Wattanasri on 3/4/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


protocol CameraViewControllerDelegate {
    func didSendPhoto( cameraViewController: CameraViewController )
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    var delegate: CameraViewControllerDelegate!
    
    override func viewDidLoad() {
                    
        super.viewDidLoad()
        let imageView = profileImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imageTapped(img: AnyObject)
    {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            profileImageView.image = editedImage
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
    }
    
        
    @IBAction func onSubmit(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Post.postPFFileFromImage(profileImageView.image, withCaption: captionField.text) { (success: Bool, error: NSError?) -> Void in
            if success {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                print("Posted to Parse")
                
                //self.delegate.didSendPhoto(self)
                
                self.profileImageView.image = nil
                self.captionField.text = ""
                
            }
            else {
                print("Can't post to parse")
            }
        }
    }
    
}