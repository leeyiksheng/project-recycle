//
//  OrderProcessorViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 06/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OrderProcessorViewController: UIViewController {

    @IBOutlet weak var currentOrdersTableView: UITableView!
    
    var currentOrdersArray : [RecycleOrder] = []
    var selectedOrder: RecycleOrder?
    var numberOfOrdersInDatabase: Int = 0
    var selectedDriver: Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
        
        generateCurrentProcessingOrders(completion: { () -> () in
            self.currentOrdersTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateCurrentProcessingOrders(completion: @escaping () -> ()) {
        guard let currentUserUID : String = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userDatabaseRef = FIRDatabase.database().reference(withPath: "users/\(currentUserUID)")
        
        userDatabaseRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            guard let userDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Please check if you have an Internet connection or the database reference is valid.")
                return
            }
            
            guard let processingOrders = userDataDictionary["processingOrders"] as? [String] else {
                return
            }
            
            self.numberOfOrdersInDatabase = processingOrders.count
            self.observeDataFetchCompletionNotification()
            
            for orderUID : String in processingOrders {
                let order = RecycleOrder.init(orderWithOrderUID: orderUID)
                self.currentOrdersArray.append(order)
            }
        })
    }
    
    func observeDataFetchCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataFetchCompletionNotification(_:)), name: Notification.Name(rawValue: "DataFetchCompletionNotification"), object: nil)
    }
    
    func handleDataFetchCompletionNotification(_ notification: Notification) {
        if self.currentOrdersArray.count == self.numberOfOrdersInDatabase {
            self.currentOrdersTableView.reloadData()
        }
    }
    
    func saveSelectedOrder(index: Int) {
        selectedOrder = currentOrdersArray[index]
    }
}

extension OrderProcessorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveSelectedOrder(index: indexPath.row)
        
        let orderProcessorSubmissionViewController = storyboard?.instantiateViewController(withIdentifier: "Driver Selection") as! OrderProcessorSubmissionViewController
        orderProcessorSubmissionViewController.selectedOrder = selectedOrder
        
        present(orderProcessorSubmissionViewController, animated: true, completion: nil)
    }
}

extension OrderProcessorViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOrdersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "processingCell", for: indexPath) as! ProcessorTableViewCell
        
        cell.creationTimestampLabel.text = "\(currentOrdersArray[indexPath.row].creationTimestamp)"
        cell.receiverNameLabel.text = currentOrdersArray[indexPath.row].receiverName
        cell.receiverContactLabel.text = currentOrdersArray[indexPath.row].receiverContact
        cell.receiverAddressLabel.text = currentOrdersArray[indexPath.row].receiverFormattedAddress
        cell.userIDLabel.text = currentOrdersArray[indexPath.row].userUID
        
        return cell

    }
}
