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


    lazy var pickUpAddressTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.allowsMultipleSelectionDuringEditing = true
        tv.layer.cornerRadius = 10
        tv.backgroundColor = UIColor.viewLightGray
        tv.separatorStyle = .none
        tv.bounces = false
        tv.register(PickupAddressTableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()



    lazy var confirmButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonFonts()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(submitOrder), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.isEnabled = false
        return button
    }()

    let noOrdersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.largeTitleFonts()
        label.textColor = UIColor.forestGreen
        label.textAlignment = .center
        label.text = "No Address Found :("
        return label
    }()

    func submitOrder() {
        if confirmButton.isEnabled && confirmButton.isUserInteractionEnabled {
            confirmButton.isEnabled = false
            confirmButton.isUserInteractionEnabled = false
            guard let index = self.selectedRow else {return}
            observeOrderInitializationCompletionNotification()
            let orderToSubmit = OrderList[index]
            let order = RecycleOrder.init(orderWithUserUID: orderToSubmit.userUID, addressID: OrderList[index].addressID, hasAluminium: categoriesChoosed.hasAluminium, hasGlass: categoriesChoosed.hasGlass, hasPaper: categoriesChoosed.hasPaper, hasPlastic: categoriesChoosed.hasPlastic)
        }
    }

    func observeOrderInitializationCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderInitializationCompletionNotification(_:)), name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil)
    }

    func handleOrderInitializationCompletionNotification(_ notification: Notification) {
        let order = notification.object as! RecycleOrder
        order.submitOrder()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil)
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
    var navigationBarHeight : CGFloat = 0



    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddAddress))
        navigationItem.title = "Select Pick Up Address"
        navigationBarHeight = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        navigationController?.navigationBarAttributes()
        navigationItem.navigationItemAttributes()
        view.backgroundColor = UIColor.viewLightGray
        view.addSubview(confirmButton)
        view.addSubview(pickUpAddressTableView)

        self.pickUpAddressTableView.delegate = self
        self.pickUpAddressTableView.dataSource = self
        setupPickUpAddressTableView()
        setupConfirmButton()
        fetchAddressesID()


        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if OrderList.count == 0 {
            self.myActivityIndicator.stopAnimating()
            self.view.addSubview(self.noOrdersLabel)
            self.setupNoOrdersLabel()
        }
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
        self.myActivityIndicator.stopAnimating()
    }

    func fetchAddresses(addressIDs: (String)) {
        ref.child("addresses").child(addressIDs).observe(.value, with: {(snapshot) in



            if let dictionary = snapshot.value as? [String:AnyObject] {

                let name = (dictionary["receiverName"] as! String?)!
                let contact = (dictionary["receiverContact"] as! String?)!
                let formattedAddress = (dictionary["formattedAddress"] as! String?)!
                let recycleObject = NewAddresses.init(UID: self.currentUser, address: formattedAddress, receiverName: name, receiverContact: contact)
                recycleObject.addressID = addressIDs

                self.OrderList.append(recycleObject)

                if self.OrderList.count > 0 {
                    DispatchQueue.main.async(execute: {
                        self.noOrdersLabel.removeFromSuperview()
                    })
                }


                DispatchQueue.main.async(execute: {
                    self.pickUpAddressTableView.reloadData()
                    self.myActivityIndicator.stopAnimating()
                })

            }

        }, withCancel: nil)
    }

    func setupPickUpAddressTableView() {
        pickUpAddressTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight + 8).isActive = true
        pickUpAddressTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pickUpAddressTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pickUpAddressTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }

    func setupConfirmButton() {
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    func setupNoOrdersLabel() {
        noOrdersLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noOrdersLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }


    //MARK: -> TableView Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PickupAddressTableViewCell
        
        
        let customSelectedView = UIView()
        let gradient = CAGradientLayer()
        gradient.frame = customSelectedView.bounds
        gradient.gradientBackground()
        customSelectedView.layer.insertSublayer(gradient, at: 0)
        customSelectedView.backgroundColor = UIColor.textLightGray
        
        let firstAddress = OrderList[indexPath.row]
        
        cell.selectedBackgroundView = customSelectedView
        
        cell.contentView.backgroundColor = UIColor.viewLightGray
        cell.receiverNameDetailsLabel.text = firstAddress.name
        cell.addressDescriptionLabel.text = firstAddress.formattedAddress
        cell.contactNODetailsLabel.text = firstAddress.contact

        return cell
    }



    //MARK: -> TableView Delegates

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let addressChosed = self.OrderList[indexPath.row]
        addressChosed.deleteAddress()
        
        if addressChosed.noAddressString {
            self.OrderList = []
            self.pickUpAddressTableView.reloadData()
            self.myActivityIndicator.stopAnimating()
            self.view.addSubview(self.noOrdersLabel)
            self.setupNoOrdersLabel()
        }

        if OrderList.count == 0 {
            self.pickUpAddressTableView.reloadData()
            self.myActivityIndicator.stopAnimating()
            self.view.addSubview(self.noOrdersLabel)
            self.setupNoOrdersLabel()
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = pickUpAddressTableView.frame.size.height / 2
        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        confirmButton.isEnabled = true
        confirmButton.isUserInteractionEnabled = true
        print(44)
    }

    


}
