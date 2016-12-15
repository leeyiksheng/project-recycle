//
//  OrderHistoryViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var completedOrdersTableView: UITableView!
    var orderItemsArray: [RecycleOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completedOrdersTableView.delegate = self
        completedOrdersTableView.dataSource = self
        
        generateCompletedOrders(completion: { () -> () in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateCompletedOrders(completion: @escaping () -> ()) {
        observeOrderIntializationCompletionNotification()
        guard let currentUserUID: String = FIRAuth.auth()?.currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }
        
        let userDatabaseRef = FIRDatabase.database().reference(withPath: "users/\(currentUserUID)")
        
        userDatabaseRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let userDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Please check if you have an Internet connection or if the database reference is valid.")
                return
            }
            
            guard let completedOrders = userDataDictionary["completedOrders"] as? [String] else {
                print("Warning: completedOrders is nil in database snapshot. If unintentional, please check for download interruption or database corruption.")
                completion()
                return
            }
            
            for orderUID: String in completedOrders {
                let order = RecycleOrder.init(orderWithOrderUID: orderUID)
                self.orderItemsArray.append(order)
            }
            
            completion()
        })
    }
    
    func createFormattedDateWith(timeInterval: Double) -> String {
        let dateInTimeInterval = Date.init(timeIntervalSinceReferenceDate: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: dateInTimeInterval)
    }
    
    func observeOrderIntializationCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderIntializationCompletionNotification), name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil)
    }
    
    func handleOrderIntializationCompletionNotification(_ notification: Notification) {
        completedOrdersTableView.reloadData()
    }
}

extension OrderHistoryViewController: UITableViewDelegate {
    
}

extension OrderHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedOrderItemCell", for: indexPath) as! CompletedOrderTableViewCell
        
        if orderItemsArray[indexPath.row].creationTimestamp != nil {
            cell.completionTimestampLabel.text = createFormattedDateWith(timeInterval: orderItemsArray[indexPath.row].completionTimestamp!)
        } else {
            cell.completionTimestampLabel.text = "Error: Timestamp is nil."
        }
        
        if orderItemsArray[indexPath.row].receiverName != nil {
            cell.receiverNameLabel.text = orderItemsArray[indexPath.row].receiverName!
        } else {
            cell.receiverNameLabel.text = "Error: Receiver name is nil."
        }
        
        if orderItemsArray[indexPath.row].receiverContact != nil {
            cell.receiverContactLabel.text = orderItemsArray[indexPath.row].receiverContact!
        } else {
            cell.receiverContactLabel.text = "Error: Receiver contact is nil."
        }
        
        if orderItemsArray[indexPath.row].receiverFormattedAddress != nil {
            cell.receiverAddressLabel.text = orderItemsArray[indexPath.row].receiverFormattedAddress!
        } else {
            cell.receiverAddressLabel.text = "Error: Receiver formatted address is nil."
        }
        
        if orderItemsArray[indexPath.row].assignedDriver != nil {
            cell.orderStateLabel.text = "Processed"
            cell.driverNameLabel.text = orderItemsArray[indexPath.row].assignedDriver?.name
        } else {
            cell.orderStateLabel.text = "Processing"
            cell.driverNameLabel.text = "Assignment pending"
        }
        
        if orderItemsArray[indexPath.row].orderValue != nil {
            cell.orderStateLabel.text = "Completed"
            cell.orderValueLabel.text = "\(orderItemsArray[indexPath.row].orderValue!)"
        } else {
            cell.orderValueLabel.text = "Error: Order value is nil."
        }
        
        cell.iconArray.removeAll()
        
        if orderItemsArray[indexPath.row].hasAluminium != nil {
            aluminiumImage: if orderItemsArray[indexPath.row].hasAluminium! {
                guard let aluminiumImage = UIImage.init(named: "Aluminium") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break aluminiumImage
                }
                cell.iconArray.append(aluminiumImage)
            }
        }
        
        if orderItemsArray[indexPath.row].hasGlass != nil {
            glassImage: if orderItemsArray[indexPath.row].hasGlass! {
                guard let glassImage = UIImage.init(named: "Glass") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break glassImage
                }
                cell.iconArray.append(glassImage)
            }
        }
        
        if orderItemsArray[indexPath.row].hasPaper != nil {
            paperImage: if orderItemsArray[indexPath.row].hasPaper! {
                guard let paperImage = UIImage.init(named: "Paper") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break paperImage
                }
                cell.iconArray.append(paperImage)
            }
        }
        
        if orderItemsArray[indexPath.row].hasPlastic != nil {
            plasticImage: if orderItemsArray[indexPath.row].hasPlastic! {
                guard let plasticImage = UIImage.init(named: "Plastic") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break plasticImage
                }
                cell.iconArray.append(plasticImage)
            }
        }
        
        cell.imageCollectionView.reloadData()
        
        cell.layer.cornerRadius = 7.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2.0
        
        return cell
    }
}
