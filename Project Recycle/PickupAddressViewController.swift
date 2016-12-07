//
//  PickupAddressViewController.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/2/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PickupAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var pickUpAddressLabel: UILabel!{
        didSet{
            pickUpAddressLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    @IBOutlet weak var pickUpAddressTableView: UITableView!{
        didSet{
            pickUpAddressTableView.layer.cornerRadius = 10
            pickUpAddressTableView.allowsMultipleSelectionDuringEditing = true
        }
    }
    
    lazy var confirmButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(submitOrder), for: .touchUpInside)
        return button
    }()
    
    func submitOrder() {
        
        guard let index = self.selectedRow else {return}
        let orderToSubmit = OrderList[index]
        let submit = RecycleOrder.init(orderWithUserUID: orderToSubmit.userUID, hasAluminium: categoriesChoosed.hasAluminium, hasGlass: categoriesChoosed.hasGlass, hasPaper: categoriesChoosed.hasPaper, hasPlastic: categoriesChoosed.hasPlastic)
        
        submit.submitOrder()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    let currentUser : String = {
        guard let thisUser = FIRAuth.auth()?.currentUser?.uid else {
            return ""
        }
        return thisUser
    }()
    
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var selectedRow: Int?
    var categoriesChoosed = CategoriesChosen()
    var OrderList = [NewAddresses]()
    var ref: FIRDatabaseReference!
    var addressUID = "addressUniqueId"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "addAddress"), style: .plain, target: self, action: #selector(handleAddAddress))
        navigationItem.title = "Select Pick Up Address"
        view.backgroundColor = UIColor.viewLightGray
        view.addSubview(confirmButton)
        
        self.pickUpAddressTableView.delegate = self
        self.pickUpAddressTableView.dataSource = self
        setupConfirmButton()
        fetchAddressesID()
        
        
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.pickUpAddressTableView.reloadData()
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleAddAddress() {
        let nextController = AlternativeAddressViewController()
        let navController = UINavigationController(rootViewController: nextController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func fetchAddressesID() {
        ref.child("users").child(self.currentUser).child("addressID").observe(.value, with:
            {(snapshot) in
                if let dictionary = snapshot.value as? [String] {
                    print(dictionary)
                    self.OrderList = []
                    
                    for values in dictionary {
                        self.fetchAddresses(addressIDs: values)
                    }
                }
                
        }, withCancel: nil)
    }
    
    func fetchAddresses(addressIDs: (String)) {
        ref.child("addresses").child(addressIDs).observe(.value, with: {(snapshot) in
            
            DispatchQueue.main.async(execute: {
                self.myActivityIndicator.startAnimating()
            })
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                
                let name = (dictionary["receiverName"] as! String?)!
                let contact = (dictionary["receiverContact"] as! String?)!
                let formattedAddress = (dictionary["formattedAddress"] as! String?)!
                let recycleObject = NewAddresses.init(UID: self.currentUser, address: formattedAddress, receiverName: name, receiverContact: contact)
                recycleObject.addressID = addressIDs
                
                self.OrderList.append(recycleObject)
                
                DispatchQueue.main.async(execute: {
                    self.pickUpAddressTableView.reloadData()
                    self.myActivityIndicator.stopAnimating()
                })
                
            }
            
        }, withCancel: nil)
    }
    
    
    func setupConfirmButton() {
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    
    //MARK: -> TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PickupAddressTableViewCell
        
        let firstAddress = OrderList[indexPath.row]
        
        cell.receiverNameDetailsLabel.text = firstAddress.name
        cell.addressDescriptionLabel.text = firstAddress.formattedAddress
        cell.contactNODetailsLabel.text = firstAddress.contact
        cell.otherNoDetailsLabel.text = firstAddress.contact
        
        return cell
    }
    
    
    //MARK: -> TableView Delegates
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let addressChosed = self.OrderList[indexPath.row]
        addressChosed.deleteAddress()
        fetchAddressesID()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        print(44)
    }
    
    
    
    
}

