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

    @IBAction func onAddButtonTouchUpInside(_ sender: UIBarButtonItem) {
        
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
        
        cell.overlayView.layer.cornerRadius = 15.0
        
        cell.receiverAddressImageView.image = UIImage(named: "UserIcon")
        cell.receiverAddressTextView.text = addressListArray[indexPath.row].formattedAddress
        cell.receiverAddressTextView.isEditable = false
        cell.receiverAddressTextView.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0)
        
        cell.receiverNameImageView.image = UIImage(named: "UserIcon")
        cell.receiverNameTextField.text = addressListArray[indexPath.row].name
        cell.receiverNameTextField.borderStyle = .none
        cell.receiverNameTextField.isEnabled = false
        
        cell.receiverContactImageView.image = UIImage(named: "PhoneIcon")
        cell.receiverContactTextField.text = addressListArray[indexPath.row].contact
        cell.receiverContactTextField.borderStyle = .none
        cell.receiverContactTextField.isEnabled = false
        
        return cell
    }
}

extension AddressListViewController: UITableViewDelegate {
    
}
