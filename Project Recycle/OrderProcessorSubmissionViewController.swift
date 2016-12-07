//
//  OrderProcessorSubmissionViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 07/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class OrderProcessorSubmissionViewController: UIViewController {

    @IBOutlet weak var driverTableView: UITableView!
    
    @IBOutlet weak var orderTimestampLabel: UILabel!
    @IBOutlet weak var orderUserIDLabel: UILabel!
    @IBOutlet weak var orderReceiverNameLabel: UILabel!
    @IBOutlet weak var orderReceiverContactLabel: UILabel!
    @IBOutlet weak var orderReceiverAddressLabel: UILabel!
    
    var driverArray : [Driver] = []
    var selectedDriver: Driver?
    var selectedOrder: RecycleOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedOrder == nil {
            let nilAlertController = UIAlertController.init(title: "Empty Order", message: "No order selected in previous view, please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            
            nilAlertController.addAction(okAction)
            present(nilAlertController, animated: true, completion: nil)
        }
        
        self.driverTableView.delegate = self
        self.driverTableView.dataSource = self
        
        populateDriverArrayFromDatabase(completion: { () -> () in
            self.driverTableView.reloadData()
        })
        
        populateSelectedOrderData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populateSelectedOrderData() {
        let orderCreationInTimeInterval = Date.init(timeIntervalSinceReferenceDate: selectedOrder!.creationTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        
        orderTimestampLabel.text = dateFormatter.string(from: orderCreationInTimeInterval)
        orderUserIDLabel.text = selectedOrder!.userUID
        orderReceiverNameLabel.text = selectedOrder!.receiverName
        orderReceiverContactLabel.text = selectedOrder!.receiverContact
        orderReceiverAddressLabel.text = selectedOrder!.receiverFormattedAddress
    }
    
    @IBAction func onProcessOrderButtonTouchUpInside(_ sender: UIButton) {
        removeSelectedOrderFromProcessingAndUserDatabase(completion: { () -> () in
            self.insertSelectedOrderIntoCurrentOrdersAndUserDatabase(completion: { () -> () in
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func populateDriverArrayFromDatabase(completion: @escaping () -> ()) {
        let driverDatabaseReference = FIRDatabase.database().reference(withPath: "drivers")
        
        driverDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                guard let driverRawDataDictionary = (child as! FIRDataSnapshot).value as? [String: AnyObject] else {
                    print("Error: Data not found. Please check if database reference is valid.")
                    return
                }

                let driver = Driver.init()
                
                if driverRawDataDictionary["assignedOrders"] == nil {
                    driver.assignedOrderUIDArray = []
                } else {
                    driver.assignedOrderUIDArray = driverRawDataDictionary["assignedOrders"] as! [String]
                }
                
                if driverRawDataDictionary["completedOrders"] == nil {
                    driver.completedOrderUIDArray = []
                } else {
                    driver.completedOrderUIDArray = driverRawDataDictionary["completedOrders"] as! [String]
                }
                
                driver.email = driverRawDataDictionary["email"] as! String
                driver.name = driverRawDataDictionary["name"] as! String
                driver.phoneNumber = driverRawDataDictionary["phoneNumber"] as! String
                driver.profileImage = driverRawDataDictionary["profileImage"] as! String
                
                self.driverArray.append(driver)
            }
            
            completion()
        })
    }
    
    func removeSelectedOrderFromProcessingAndUserDatabase(completion: @escaping () -> ()) {
        let processingOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/processing/\(selectedOrder!.orderUID)")
        let userProcessingOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(selectedOrder!.userUID)")
        
        fetchUserOrderUIDsFromDatabaseWith(databaseReference: userProcessingOrdersDatabaseReference, completion: { (uidArray) -> () in
            var orderUIDArray = uidArray
            
            guard let indexToBeRemoved = orderUIDArray.index(of: self.selectedOrder!.orderUID) else {
                print("Error: Could not find order ID in user database. Please check whether client has stale data or order ID is valid.")
                return
            }
            
            orderUIDArray.remove(at: indexToBeRemoved)
            
            let processingOrderUIDsUpdate = ["processingOrders": orderUIDArray]
            
            processingOrdersDatabaseReference.removeValue()
            userProcessingOrdersDatabaseReference.updateChildValues(processingOrderUIDsUpdate)
            
            completion()
        })
    }
    
    func insertSelectedOrderIntoCurrentOrdersAndUserDatabase(completion: @escaping () -> ()) {
        let currentOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/current")
        let userCurrentOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(selectedOrder!.userUID)")
        
        let newCurrentOrderDictionary: [String: Any] = ["formattedAddress": selectedOrder!.receiverFormattedAddress,
                                                        "driverAssigned": selectedDriver!.driverUID,
                                                        "orderCategories": ["aluminium": selectedOrder!.hasAluminium,
                                                                            "glass": selectedOrder!.hasGlass,
                                                                            "paper": selectedOrder!.hasPaper,
                                                                            "plastic": selectedOrder!.hasPlastic],
                                                        "orderCreatedOn": selectedOrder!.creationTimestamp,
                                                        "orderProcessedOn": Date.timeIntervalSinceReferenceDate,
                                                        "orderID": selectedOrder!.orderUID,
                                                        "receiverContact": selectedOrder!.receiverContact,
                                                        "receiverName": selectedOrder!.receiverName,
                                                        "userID": selectedOrder!.userUID]
        
        currentOrdersDatabaseReference.updateChildValues(newCurrentOrderDictionary)
        
        fetchUserOrderUIDsFromDatabaseWith(databaseReference: userCurrentOrdersDatabaseReference, completion: { (uidArray) -> () in
            var orderUIDArray = uidArray
            
            orderUIDArray.append(self.selectedDriver!.driverUID)
            
            let currentOrderUIDUpdate = ["currentOrders": orderUIDArray]
            userCurrentOrdersDatabaseReference.updateChildValues(currentOrderUIDUpdate)
            
            completion()
        })
    }
    
    private func fetchUserOrderUIDsFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: @escaping (_ uidArray: [String]) -> ()) {
        databaseReference.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let orderUIDArray = snapshot.value as? [String] else {
                let orderUIDArray : [String] = []
                completion(orderUIDArray)
                return
            }
            completion(orderUIDArray)
        })
    }
}

extension OrderProcessorSubmissionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDriver = driverArray[indexPath.row]
    }
}

extension OrderProcessorSubmissionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverCell", for: indexPath) as! DriverTableViewCell
        
        cell.driverName.text = driverArray[indexPath.row].name
        cell.assignedOrderCount.text = "\(driverArray[indexPath.row].assignedOrderUIDArray.count)"
        cell.completedOrderCount.text = "\(driverArray[indexPath.row].completedOrderUIDArray.count)"
        
        return cell
    }
}