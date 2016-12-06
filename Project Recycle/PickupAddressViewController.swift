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
        }
    }
    
    var selectedRow: Int?
    var categoriesChoosed = CategoriesChosen()
    var OrderList = [RecycleOrder]()
    var ref: FIRDatabaseReference!
    var addressUID = "addressUniqueId"
    var currentUser = ""
    


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
        orderToSubmit.userUID = self.currentUser
        orderToSubmit.hasGlass = self.categoriesChoosed.hasGlass
        orderToSubmit.hasPaper = self.categoriesChoosed.hasPaper
        orderToSubmit.hasPlastic = self.categoriesChoosed.hasPlastic
        orderToSubmit.hasAluminium = self.categoriesChoosed.hasAluminium

        orderToSubmit.submitOrder()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        guard let thisUser = FIRAuth.auth()?.currentUser?.uid else {return}
        self.currentUser = thisUser
        self.OrderList = []
        fetchAddressesID()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "addAddress"), style: .plain, target: self, action: #selector(handleAddAddress))
        navigationItem.title = "Pick Up Address"
        view.backgroundColor = UIColor.viewLightGray
        view.addSubview(confirmButton)
        
        self.pickUpAddressTableView.delegate = self
        self.pickUpAddressTableView.dataSource = self
        
        observeCompletionNotification()
        
        setupConfirmButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.pickUpAddressTableView.reloadData()
    }
    

    func fetchAddressesID() {
        ref.child("users").child(self.currentUser).child("addressID").observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String] {
                print(dictionary)
                
                for values in dictionary {
                    self.fetchAddresses(addressIDs: values)
                }
            }
            
            }, withCancel: nil)
    }
    
    func fetchAddresses(addressIDs: (String)) {
        ref.child("addresses").child(addressIDs).observe(.value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:String] {
                let recycleObject = RecycleOrder()
                recycleObject.receiverName = (dictionary["receiverName"] as! String?)!
                recycleObject.receiverContact = (dictionary["receiverContact"] as! String?)!
                recycleObject.receiverFormattedAddress = (dictionary["formattedAddress"] as! String?)!
            
            self.OrderList.append(recycleObject)
            DispatchQueue.main.async(execute: {
                self.pickUpAddressTableView.reloadData()
            })
                
            }
            
            }, withCancel: nil)
    }
    
    
    func observeCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDataFetchingCompletion), name: Notification.Name(rawValue: "UserDataFetchingCompletion"), object: nil)
    }
    
    func handleUserDataFetchingCompletion(_ notification: Notification) {
        pickUpAddressTableView.reloadData()
    }
    
    
//    func createNewAddress(newAddress: RecycleOrder) {
//        self.OrderList.append(newAddress)
  //      pickUpAddressTableView.reloadData()
    //}
    
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleAddAddress() {
        let nextController = AlternativeAddressViewController()
        let navController = UINavigationController(rootViewController: nextController)
        self.present(navController, animated: true, completion: nil)
    }

    
    func setupConfirmButton() {
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    
    
    // TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PickupAddressTableViewCell
        
        let firstAddress = OrderList[indexPath.row]
        
        cell.receiverNameDetailsLabel.text = firstAddress.receiverName
        cell.addressDescriptionLabel.text = firstAddress.receiverFormattedAddress
        cell.contactNODetailsLabel.text = firstAddress.receiverContact
        cell.otherNoDetailsLabel.text = firstAddress.receiverContact
        
        return cell
    }
   
    
    // TableView Delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        print(44)
    }
    
    
  
    
}

