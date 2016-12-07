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
    
    var orderItemsArray: [RecycleOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
        
        generateCurrentOrders(completion: { () -> () in
            self.currentOrdersTableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func generateCurrentOrders(completion: @escaping () -> ()) {
        generateCurrentProcessingOrders(completion: { () -> () in
            self.generateCurrentProcessedOrders(completion: { () -> () in
                completion()
            })
        })
    }
    
    func generateCurrentProcessedOrders(completion: @escaping () -> ()) {
        guard let currentUserUID : String = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userDatabaseRef = FIRDatabase.database().reference(withPath: "users/\(currentUserUID)")
        
        userDatabaseRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            guard let userDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Please check if you have an Internet connection or the database reference is valid.")
                return
            }
            
            guard let currentOrders = userDataDictionary["currentOrders"] as? [String] else {
                completion()
                return
            }
            
            for orderUID : String in currentOrders {
                let order = CurrentRecycleOrder.init(currentOrderWithOrderUID: orderUID)
                self.orderItemsArray.append(order)
            }
            
            completion()
        })
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
            
            for orderUID : String in processingOrders {
                let order = RecycleOrder.init(orderWithOrderUID: orderUID)
                self.orderItemsArray.append(order)
            }
            
            completion()
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
        if orderItemsArray[indexPath.row] is RecycleOrder {
            let cell = tableView.dequeueReusableCell(withIdentifier: "processingCell", for: indexPath) as! CurrentOrderProcessingTableViewCell

            cell.creationTimestampLabel.text = "\(orderItemsArray[indexPath.row].creationTimestamp)"
            cell.receiverNameLabel.text = orderItemsArray[indexPath.row].receiverName
            cell.receiverContactLabel.text = orderItemsArray[indexPath.row].receiverContact
            cell.receiverAddressLabel.text = orderItemsArray[indexPath.row].receiverFormattedAddress
            cell.userIDLabel.text = orderItemsArray[indexPath.row].userUID
            
            for image: UIImage in orderItemsArray[indexPath.row].orderImages {
                cell.iconArray.append(image)
            }

        
            cell.imageCollectionView.reloadData()
        
            return cell
        } else if orderItemsArray[indexPath.row] is CurrentRecycleOrder {
            let cell = tableView.dequeueReusableCell(withIdentifier: "processedCell", for: indexPath) as! CurrentOrderProcessedTableViewCell
            
            cell.creationTimestampLabel.text = "\(orderItemsArray[indexPath.row].creationTimestamp)"
            cell.receiverNameLabel.text = "\(orderItemsArray[indexPath.row].receiverName)"
            cell.receiverContactLabel.text = "\(orderItemsArray[indexPath.row].receiverContact)"
            cell.receiverAddressLabel.text = "\(orderItemsArray[indexPath.row].receiverFormattedAddress)"
            
            for image: UIImage in orderItemsArray[indexPath.row].orderImages {
                cell.iconArray.append(image)
            }
            
            cell.imageCollectionView.reloadData()
            
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
}
