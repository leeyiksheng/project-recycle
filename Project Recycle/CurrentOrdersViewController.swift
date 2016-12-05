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
    
    var orderItemsArray: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func generateCurrentOrders() -> [Order] {
        guard let currentUserUID : String = FIRAuth.auth()?.currentUser?.uid else {
            return []
        }
        
        let userDatabaseRef = FIRDatabase.database().reference(withPath: "users/\(currentUserUID)")
        let currentOrders : [String] = userDatabaseRef.value(forKey: "currentOrders") as! [String]
        
        for orderUID : String in currentOrders {
            
        }
        
        return []
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
        
        //        if orderItemsArray[indexPath.row].isCompleted {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "currentProcessedOrderCell", for: indexPath) as! CurrentOrderProcessedTableViewCell
        //
        //
        //
        //            return cell
        //        } else {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "currentProcessingOrderCell", for: indexPath) as! CurrentOrderProcessingTableViewCell
        //
        //
        //
        //            return cell
        //        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentProcessedOrderCell", for: indexPath) as! CurrentOrderProcessedTableViewCell
        
        
        
        return cell
    }
}
