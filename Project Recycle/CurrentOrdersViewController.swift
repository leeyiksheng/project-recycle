//
//  CurrentOrdersViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CurrentOrdersViewController: UIViewController {
    
    @IBOutlet weak var currentOrdersTableView: UITableView!
    
    var orderItemsArray: [CurrentRecycleOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
        
        generateCurrentOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func generateCurrentOrders() {
        guard let currentUserUID : String = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userDatabaseRef = FIRDatabase.database().reference(withPath: "users/\(currentUserUID)")
        var currentOrders : [String] = []
        
        userDatabaseRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let userDataDictionary = snapshot.value as? [String: AnyObject] else { return }
            currentOrders = userDataDictionary["currentOrders"] as! [String]
            for orderUID : String in currentOrders {
                let order = CurrentRecycleOrder.init(currentOrderWithOrderUID: orderUID)
                self.orderItemsArray.append(order)
            }
            self.currentOrdersTableView.reloadData()
        })
    }
}

extension CurrentOrdersViewController: UITableViewDelegate {
    
}

extension CurrentOrdersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentProcessedOrderCell", for: indexPath) as! CurrentOrderProcessedTableViewCell
        
        cell.timestampLabel.text = "\(orderItemsArray[indexPath.row].creationTimestamp)"
        cell.receiverNameLabel.text = "\(orderItemsArray[indexPath.row].receiverName)"
        cell.receiverContactLabel.text = "\(orderItemsArray[indexPath.row].receiverContact)"
        cell.receiverAddressLabel.text = "\(orderItemsArray[indexPath.row].receiverFormattedAddress)"
        cell.driverNameLabel.text = "\(orderItemsArray[indexPath.row].assignedDriver.name)"
        
        return cell
    }
}
