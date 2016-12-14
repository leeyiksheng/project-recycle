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
import QuartzCore

class CurrentOrdersViewController: UIViewController {
    
    @IBOutlet weak var currentOrdersTableView: UITableView!
    
    var orderItemsArray: [RecycleOrder] = []
    var isInitialLoadingPhase: Bool = false
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray) {
        didSet {
            self.activityIndicator.center = self.view.center
            self.activityIndicator.startAnimating()
            self.view.addSubview(self.activityIndicator)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
        
        generateCurrentOrders(completion: { () -> () in
            self.isInitialLoadingPhase = true
            self.observeForDatabaseChanges()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func generateCurrentOrders(completion: @escaping () -> ()) {
        observeOrderIntializationCompletionNotification()
        generateCurrentProcessingOrders(completion: { () -> () in
            self.generateCurrentProcessedOrders(completion: { () -> () in
                completion()
            })
        })
    }
    
    func generateCurrentProcessedOrders(completion: @escaping () -> ()) {
        guard let currentUserUID : String = FIRAuth.auth()?.currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }
        
        let userDatabaseRef = FIRDatabase.database().reference(withPath: "users/\(currentUserUID)")
        
        userDatabaseRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            guard let userDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Please check if you have an Internet connection or if the database reference is valid.")
                return
            }
            
            guard let currentOrders = userDataDictionary["currentOrders"] as? [String] else {
                completion()
                return
            }
            
            for orderUID : String in currentOrders {
                let order = RecycleOrder.init(orderWithOrderUID: orderUID)
                self.orderItemsArray.append(order)
            }
            
            completion()
        })
    }
    
    func observeForDatabaseChanges() {
        guard let userUID = FIRAuth.auth()?.currentUser?.uid else { return }
        let userCurrentProcessingOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)/processingOrders")
        
        userCurrentProcessingOrdersDatabaseReference.observe(FIRDataEventType.childAdded, with: { (snapshot) in
            if self.isInitialLoadingPhase == false {
                guard let orderUID = snapshot.value as? String else {
                    print("Error: Snapshot is empty. Please check if database reference is valid.")
                    return
                }
            
                let order = RecycleOrder.init(orderWithOrderUID: orderUID)
                self.orderItemsArray.append(order)
            }
            
            self.isInitialLoadingPhase = false
        })
    }
    
    func observeOrderIntializationCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderIntializationCompletionNotification), name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil)
    }
    
    func handleOrderIntializationCompletionNotification(_ notification: Notification) {
        currentOrdersTableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    func generateCurrentProcessingOrders(completion: @escaping () -> ()) {
        guard let currentUserUID : String = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userDatabaseRef = FIRDatabase.database().reference(withPath: "users/\(currentUserUID)")
        
        userDatabaseRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            guard let userDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Please check if you have an Internet connection or if the database reference is valid.")
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
    
    func createFormattedDateWith(timeInterval: Double) -> String {
        let dateInTimeInterval = Date.init(timeIntervalSinceReferenceDate: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: dateInTimeInterval)
    }
}
extension CurrentOrdersViewController: UITableViewDelegate, UIScrollViewDelegate {
    
}

extension CurrentOrdersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if !orderItemsArray.isEmpty {
            self.currentOrdersTableView.separatorStyle = .singleLine
            return 1
        } else {
            self.activityIndicator.stopAnimating()
            let emptyMessageLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            emptyMessageLabel.text = "No orders placed :("
            emptyMessageLabel.textColor = UIColor.darkGreen
            emptyMessageLabel.numberOfLines = 0
            emptyMessageLabel.textAlignment = NSTextAlignment.center
            emptyMessageLabel.font = UIFont.init(name: "Helvetica", size: 20)
            emptyMessageLabel.sizeToFit()
            
            self.currentOrdersTableView.backgroundView = emptyMessageLabel
            self.currentOrdersTableView.separatorStyle = .none
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrentOrderTableViewCell
        
        if orderItemsArray[indexPath.row].creationTimestamp != nil {
            cell.creationTimestampLabel.text = createFormattedDateWith(timeInterval: orderItemsArray[indexPath.row].creationTimestamp!)
        } else {
            cell.creationTimestampLabel.text = "Error: Timestamp is nil."
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
