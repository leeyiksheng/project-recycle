//
//  CurrentOrdersViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class CurrentOrdersViewController: UIViewController {

    @IBOutlet weak var currentOrdersTableView: UITableView!
    
    var orderItemsArray: [OrderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        
        if orderItemsArray[indexPath.row].isCompleted {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentProcessedOrderCell", for: indexPath) as! CurrentOrderProcessedTableViewCell
        
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentProcessingOrderCell", for: indexPath) as! CurrentOrderProcessingTableViewCell
            
            
            
            return cell
        }
    }
}
