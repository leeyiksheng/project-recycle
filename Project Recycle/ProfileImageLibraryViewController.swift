//
//  ProfileImageLibraryViewController.swift
//  Project Recycle
//
//  Created by Students on 12/5/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ProfileImageLibraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var gallery: UIBarButtonItem!
    @IBOutlet weak var backProfile: UIBarButtonItem!
    @IBOutlet weak var confirmPic: UIBarButtonItem!
    
    var actionIndicator = UIActivityIndicatorView()
    let picker = UIImagePickerController()
    var chosenImage : UIImage?
    var currentImage: UIImage?
    var holdCurrentUserName : String?
    var delegate : ProfileImageLibraryViewControllerProtocol?

    
    @IBAction func shootPhoto(_ sender: UIBarButtonItem)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }
        else
        {
            noCamera()
        }
    }
    
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem)
    {
        picker.allowsEditing = true    //not editing
        picker.sourceType = .photoLibrary   //source from photo library
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!    //set the media types for all types of photo in library
        picker.modalPresentationStyle = .popover    //select a presentation style known as popover
        present(picker, animated: true, completion: nil)    //present the picker in a default full screen mode
        picker.popoverPresentationController?.barButtonItem = sender //set the reference point to pop up
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        actionIndicator.hidesWhenStopped = true
        
        self.view.backgroundColor = UIColor.viewLightGray
        frDBref = FIRDatabase.database().reference()
        
        titleLabel.toolbarLabelTitle()
        backProfile.buttonFonts()
        confirmPic.buttonFonts()
        gallery.buttonFonts()
        backProfile.tintColor = UIColor.forestGreen
        confirmPic.tintColor = UIColor.forestGreen
        gallery.tintColor = UIColor.forestGreen
        camera.tintColor = UIColor.forestGreen
        
        
        imageView?.layer.borderWidth = 2
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView?.layer.masksToBounds = false
        imageView?.layer.borderColor = nil
        imageView?.clipsToBounds = true
        
        self.activityRun()
        fetchUserImage()
        picker.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func activityRun()
    {
        let container = UIView()
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        container.tag = 100
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        
        self.actionIndicator.frame = CGRect (x: 0, y: 0, width: 40, height: 40)
        self.actionIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.actionIndicator.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)
        
        loadingView.addSubview(self.actionIndicator)
        container.addSubview(loadingView)
        self.view.addSubview(container)
        self.actionIndicator.startAnimating()

    }
    
    func activityStop()
    {
        self.actionIndicator.stopAnimating()
        if let viewWithTag = self.view.viewWithTag(100)
        {
            viewWithTag.removeFromSuperview()
        }

    }
    
    private func fetchUserImage()
    {
        let currentUser = User()
        currentUser.initWithCurrentUser { () -> () in
            self.holdCurrentUserName = currentUser.name
            if currentUser.profileImage == "default" || currentUser.profileImage == ""
            {
                self.imageView.image = UIImage(named: "noone")
                self.activityStop()
            }
            else
            {
                Downloader.getDataFromUrl(url: URL.init(string: currentUser.profileImage)!, completion: { (data, response, error) in
                    
                    if error != nil
                    {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.imageView?.image = UIImage(data:data!)
                        self.activityStop()
                        
                    }
                })
            }
        }
    }
    
    func noCamera()
    {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imageView.image = editImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.image = originalImage
        }
        
        imageView.contentMode = .scaleAspectFit
        
        dismiss(animated: true, completion: nil)
//        self.willMove(toParentViewController: nil)
//        self.view.removeFromSuperview()
//        self.removeFromParentViewController()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
//        self.willMove(toParentViewController: nil)
//        self.view.removeFromSuperview()
//        self.removeFromParentViewController()

    }
    
    
    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: {
            self.delegate?.dismissViewController(catchImage: self.imageView.image!)
        })
    }

    @IBAction func ConfirmButtonPressed(_ sender: UIBarButtonItem)
    {
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_Images").child("\(imageName).png")
        let uploadData = UIImagePNGRepresentation(imageView.image!)
        storageRef.put(uploadData!, metadata: nil, completion: { (metadata, error) in
            if error != nil
            {
                print(error?.localizedDescription)
                return
            }
        let proImageUrl = metadata?.downloadURL()?.absoluteString
        let changeProfileImage = FIRAuth.auth()?.currentUser?.uid
            frDBref.child("users/\(changeProfileImage!)/profileImage").setValue(proImageUrl!)
        })
        
//        self.dismiss(animated: true, completion: nil) // not a good practice
        self.dismiss(animated: true, completion: {
            self.delegate?.dismissViewController(catchImage: self.imageView.image!)
        })
        
    }
    

}
