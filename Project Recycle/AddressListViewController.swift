//
//  AddressListViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 19/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddressListViewController: UIViewController {
    
    @IBOutlet weak var addressListTableView: UITableView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addressListTitle: UILabel! {
        didSet {
            addressListTitle.toolbarLabelTitle()
        }
    }
    
    let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\((FIRAuth.auth()?.currentUser?.uid)!)/addressID")
    
    var addressListArray: [NewAddresses] = []
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityLoader()
        initializeObservers()
        
        addressListTableView.dataSource = self
        addressListTableView.delegate = self
        addressListTableView.separatorStyle = .none
        
        generateAddressList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onBackButtonTouchUpInside(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDeleteButtonTouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func onAddButtonTouchUpInside(_ sender: Any) {
       let editAlertController = UIAlertController(title: "Adding a new receiver", message: "", preferredStyle: .alert)
        
        editAlertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name"
            textField.keyboardType = .namePhonePad
            textField.font = UIFont(name: "San Francisco Text", size: 20)
        })
        
        editAlertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Contact"
            textField.keyboardType = .namePhonePad
            textField.font = UIFont(name: "San Francisco Text", size: 20)
        })
        
        editAlertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Formatted address"
            textField.keyboardType = .asciiCapable
            textField.font = UIFont(name: "San Francisco Text", size: 20)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if editAlertController.textFields![0].text != nil && editAlertController.textFields![1].text != nil && editAlertController.textFields![2].text != nil {
                let formattedAddress = editAlertController.textFields![2].text
                let receiverContact = editAlertController.textFields![1].text
                let receiverName = editAlertController.textFields![0].text
            
                let newAddress = NewAddresses(UID: (FIRAuth.auth()?.currentUser?.uid)!, address: formattedAddress!, receiverName: receiverName!, receiverContact: receiverContact!)
            
                newAddress.submitAddress()
            } else {
                return
            }
        })
        
        editAlertController.addAction(cancelAction)
        editAlertController.addAction(saveAction)
        
        present(editAlertController, animated: true, completion: nil)
    }
    
    func setupActivityLoader() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(self.activityIndicator)
        print("Add subview: activityIndicator")
    }
    
    //MARK: - Database Fetching & Observing Functions
    
    func generateAddressList() {
        fetchAddressIDArrayFromDatabase()
    }
    
    func fetchAddressIDArrayFromDatabase() {
        userDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value == nil {
                self.activityIndicator.stopAnimating()
                return
            }
        })
        
        userDatabaseReference.observe(.childAdded, with: { (snapshot) in
            if snapshot.value as? String == nil {
                print("Error: addressID is nil.")
                return
            } else {
                let addressID = snapshot.value as! String
                self.addressListArray.append(NewAddresses(withAddressID: addressID))
            }
        })
    }
    
    func initializeObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddressInitializationCompletionNotification), name: Notification.Name(rawValue: "addressInitializationCompletionNotification"), object: nil)
    }
    
    func handleAddressInitializationCompletionNotification() {
        activityIndicator.stopAnimating()
        addressListTableView.reloadData()
    }
}

extension AddressListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressListTableViewCell
        
        cell.overlayView.layer.cornerRadius = 4.0
        cell.shadowView.layer.shadowRadius = 4.0
        cell.shadowView.layer.cornerRadius = 4.0
        cell.selectionStyle = .none
        
        cell.receiverAddressImageView.image = UIImage(named: "UserIcon")
        cell.receiverAddressTextView.text = addressListArray[indexPath.row].formattedAddress
        cell.receiverAddressTextView.isEditable = false
        //cell.receiverAddressTextView.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0)
        cell.receiverAddressTextView.layer.borderColor = UIColor.forestGreen.cgColor
        cell.receiverAddressTextView.layer.borderWidth = 2
        cell.receiverAddressTextView.layer.cornerRadius = 2.0
        cell.receiverAddressTextView.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        
        cell.receiverNameImageView.image = UIImage(named: "UserIcon")
        cell.receiverNameTextField.text = addressListArray[indexPath.row].name
        cell.receiverNameTextField.borderStyle = .roundedRect
        cell.receiverNameTextField.isUserInteractionEnabled = false
        cell.receiverNameTextField.textColor = UIColor.black
        cell.receiverNameTextField.isEnabled = false
        cell.receiverNameTextField.layer.borderWidth = 2.0
        cell.receiverNameTextField.layer.borderColor = UIColor.forestGreen.cgColor
        
        cell.receiverContactImageView.image = UIImage(named: "PhoneIcon")
        cell.receiverContactTextField.text = addressListArray[indexPath.row].contact
        cell.receiverContactTextField.borderStyle = .roundedRect
        cell.receiverContactTextField.isUserInteractionEnabled = false
        cell.receiverContactTextField.textColor = UIColor.black
        cell.receiverContactTextField.isEnabled = false
        cell.receiverContactTextField.layer.borderWidth = 2.0
        cell.receiverContactTextField.layer.borderColor = UIColor.forestGreen.cgColor
        
        
        return cell
    }
}

extension AddressListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editAlertController = UIAlertController(title: "Editing a receiver", message: "", preferredStyle: .alert)
        
        editAlertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name"
            textField.text = self.addressListArray[indexPath.row].name
            textField.keyboardType = .namePhonePad
            textField.font = UIFont(name: "San Francisco Text", size: 20)
        })
        
        editAlertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Contact"
            textField.text = self.addressListArray[indexPath.row].contact
            textField.keyboardType = .namePhonePad
            textField.font = UIFont(name: "San Francisco Text", size: 20)
        })
        
        editAlertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Formatted address"
            textField.text = self.addressListArray[indexPath.row].formattedAddress
            textField.keyboardType = .asciiCapable
            textField.font = UIFont(name: "San Francisco Text", size: 20)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (alert) in
            if editAlertController.textFields![0].text != nil && editAlertController.textFields![1].text != nil && editAlertController.textFields![2].text != nil {
                
                let formattedAddress = editAlertController.textFields![2].text
                let receiverContact = editAlertController.textFields![1].text
                let receiverName = editAlertController.textFields![0].text
                
                let addressID = self.addressListArray[indexPath.row].addressID
                let addressToBeSaveDatabaseReference = FIRDatabase.database().reference(withPath: "addresses/\(addressID)")
                
                let addressDictionary: [String: String] = ["formattedAddress" : formattedAddress!,
                                                           "receiverContact" : receiverContact!,
                                                           "receiverName" : receiverName!,
                                                           "userID" : self.addressListArray[indexPath.row].userUID]
                
                addressToBeSaveDatabaseReference.updateChildValues(addressDictionary)
            } else {
                return
            }
        })
        
        editAlertController.addAction(cancelAction)
        editAlertController.addAction(saveAction)
        
        present(editAlertController, animated: true, completion: nil)
    }
}

extension AddressListViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
    }
}
