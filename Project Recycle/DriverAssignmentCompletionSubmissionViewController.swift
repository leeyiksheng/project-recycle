//
//  DriverAssignmentCompletionSubmissionViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 08/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DriverAssignmentCompletionSubmissionViewController: UIViewController {
    
    @IBOutlet weak var assignedOrdersTableView: UITableView!
    @IBOutlet weak var orderValueTextField: UITextField! {
        didSet {
            orderValueTextField.delegate = self
            orderValueTextField.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var completeOrderButton: UIButton!
    var assignedOrdersArray: [CurrentRecycleOrder] = []
    var selectedDriver: Driver?
    var selectedOrder: CurrentRecycleOrder?
    var numberOfOrdersInDatabase: Int = 0
    var isOrderValueValid: Bool = false
    var isAssignedOrderSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignedOrdersTableView.delegate = self
        assignedOrdersTableView.dataSource = self
        
        populateAssignedOrdersArrayFromDatabase(completion: { () -> () in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populateAssignedOrdersArrayFromDatabase(completion: @escaping () -> ()) {
        self.observeDataFetchCompletionNotification()
        
        fetchAssignedOrderUIDsFromDatabaseWith(driverUID: selectedDriver!.driverUID, completion: { () -> () in
            self.assignedOrdersTableView.reloadData()
        })
    }
    
    func fetchAssignedOrderUIDsFromDatabaseWith(driverUID: String, completion: @escaping () -> ()) {
        let assignedOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "drivers/\(selectedDriver!.driverUID)/assignedOrders")
        
        assignedOrdersDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var orderUIDArray: [String] = []
            
            if snapshot.exists() {
                orderUIDArray = snapshot.value as! [String]
            } else {
                orderUIDArray = []
            }
            
            self.numberOfOrdersInDatabase = orderUIDArray.count
            
            for orderUID : String in orderUIDArray {
                let order = CurrentRecycleOrder.init(currentOrderWithOrderUID: orderUID)
                self.assignedOrdersArray.append(order)
            }
            
            completion()
        })
    }
    
    func observeDataFetchCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataFetchCompletionNotification(_:)), name: Notification.Name(rawValue: "DataFetchCompletionNotification"), object: nil)
    }
    
    func handleDataFetchCompletionNotification(_ notification: Notification) {
        if self.assignedOrdersArray.count == self.numberOfOrdersInDatabase {
            self.assignedOrdersTableView.reloadData()
        }
    }
    
    func createFormattedDateWith(timeInterval: Double) -> String {
        let dateInTimeInterval = Date.init(timeIntervalSinceReferenceDate: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        
        return dateFormatter.string(from: dateInTimeInterval)
    }
    
    @IBAction func onCompleteOrderButtonTouchUpInside(_ sender: UIButton) {
        removeSelectedOrderFromCurrentAndUserDatabase(completion: { () -> () in
            self.removeSelectedOrderFromDriverAssignedOrdersDatabase(completion: { () -> () in
                self.insertSelectedOrderIntoCompletedOrdersAndUserDatabase(completion: { () -> () in
                    self.insertSelectedOrderIntoDriverOrderCompletions(completion: { () -> () in
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        })
    }
    
    func removeSelectedOrderFromCurrentAndUserDatabase(completion: @escaping () -> ()) {
        let userCurrentOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(selectedOrder!.userUID)/currentOrders")
        
        userCurrentOrdersDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var orderUIDArray: [String] = []
            
            if snapshot.exists() {
                orderUIDArray = snapshot.value as! [String]
            } else {
                print("Error: Processing order database is empty. Please check if user database reference is valid or order UID is valid.")
                return
            }
            
            guard let indexToBeRemoved = orderUIDArray.index(of: self.selectedOrder!.orderUID) else {
                print("Error: Could not find order ID in user database. Please check whether client has stale data or order ID is valid.")
                return
            }
            
            orderUIDArray.remove(at: indexToBeRemoved)
            
            let currentOrderUIDsUpdate = ["currentOrders": orderUIDArray]
            let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(self.selectedOrder!.userUID)")
            let currentOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/current/\(self.selectedOrder!.orderUID)")
            
            currentOrdersDatabaseReference.removeValue()
            userDatabaseReference.updateChildValues(currentOrderUIDsUpdate)
            
            completion()
        })
    }
    
    func removeSelectedOrderFromDriverAssignedOrdersDatabase(completion: @escaping () -> ()) {
        let driverAssignedOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "drivers/\(selectedOrder!.assignedDriver.driverUID)")
        
        driverAssignedOrdersDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var orderUIDArray: [String] = []
            
            if snapshot.exists() {
                orderUIDArray = snapshot.value as! [String]
            }
            
            guard let indexToBeRemoved = orderUIDArray.index(of: self.selectedOrder!.orderUID) else {
                print("Error: Could not find order ID in user database. Please check whether client has stale data or order ID is valid.")
                return
            }
            
            orderUIDArray.remove(at: indexToBeRemoved)
            
            let assignedOrderUIDsUpdate = ["assignedOrders": orderUIDArray]
            let driverDatabaseReference = FIRDatabase.database().reference(withPath: "drivers/\(self.selectedOrder!.assignedDriver.driverUID)")
            
            driverDatabaseReference.updateChildValues(assignedOrderUIDsUpdate)
            
        })
    }
    
    func insertSelectedOrderIntoCompletedOrdersAndUserDatabase(completion: @escaping () -> ()) {
        let completedOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/current/\(selectedOrder!.orderUID)")
        
        let orderValue: Double = Double(orderValueTextField.text!)!
        
        let newCompletedOrderDictionary: [String: Any] = ["formattedAddress": selectedOrder!.receiverFormattedAddress,
                                                          "driverAssigned": selectedDriver!.driverUID,
                                                          "orderCategories": ["aluminium": selectedOrder!.hasAluminium,
                                                                              "glass": selectedOrder!.hasGlass,
                                                                              "paper": selectedOrder!.hasPaper,
                                                                              "plastic": selectedOrder!.hasPlastic],
                                                          "orderCompletedOn": Date.timeIntervalSinceReferenceDate,
                                                          "orderCreatedOn": selectedOrder!.creationTimestamp,
                                                          "orderProcessedOn": selectedOrder!.processedTimestamp,
                                                          "orderValue": orderValue,
                                                          "orderID": selectedOrder!.orderUID,
                                                          "receiverContact": selectedOrder!.receiverContact,
                                                          "receiverName": selectedOrder!.receiverName,
                                                          "userID": selectedOrder!.userUID]
        
        completedOrdersDatabaseReference.updateChildValues(newCompletedOrderDictionary)
        
        let userCompletedOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(selectedOrder!.userUID)/completedOrders/\(selectedOrder!.orderUID)")
        
        userCompletedOrdersDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var orderUIDArray: [String] = []
            
            if snapshot.exists() {
                orderUIDArray = snapshot.value as! [String]
            } else {
                orderUIDArray = []
            }
            
            orderUIDArray.append(self.selectedOrder!.orderUID)
            
            let completedOrderUIDsUpdate = ["completedOrders": orderUIDArray]
            let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(self.selectedOrder!.userUID)")
            
            userDatabaseReference.updateChildValues(completedOrderUIDsUpdate)
            
            completion()
        })
        
        
    }
    
    func insertSelectedOrderIntoDriverOrderCompletions(completion: @escaping () -> ()) {
        let driverCompletedOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "drivers/\(selectedOrder!.assignedDriver.driverUID)")
        
        driverCompletedOrdersDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var orderUIDArray: [String] = []
            
            if snapshot.exists() {
                orderUIDArray = snapshot.value as! [String]
            }
            
            orderUIDArray.append(self.selectedOrder!.orderUID)
            
        })
    }
}

extension DriverAssignmentCompletionSubmissionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
}

extension DriverAssignmentCompletionSubmissionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedOrdersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AssignedOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "assignedOrderCell", for: indexPath) as! AssignedOrderTableViewCell
        
        cell.receiverNameLabel.text = assignedOrdersArray[indexPath.row].receiverName
        cell.receiverAddressLabel.text = assignedOrdersArray[indexPath.row].receiverFormattedAddress
        cell.processedTimestampLabel.text = createFormattedDateWith(timeInterval: assignedOrdersArray[indexPath.row].processedTimestamp)
        
        return cell
    }
}

extension DriverAssignmentCompletionSubmissionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isAssignedOrderSelected = true
        selectedOrder = assignedOrdersArray[indexPath.row]
    }
}
