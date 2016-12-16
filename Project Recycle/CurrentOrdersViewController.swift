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
    
    //MARK - Interface Builder Outlets
    
    @IBOutlet weak var currentOrdersTableView: UITableView!
    
    //MARK - Order Item Arrays
    
    var currentOrderItemsArray: [RecycleOrder] = []
    var filteredCurrentOrderItemsArray: [RecycleOrder] = []
    var processingOrderItems: [RecycleOrder] = []
    var processedOrderItems: [RecycleOrder] = []
    
    //MARK - Firebase Database References
    
    let userProcessedOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(FIRAuth.auth()!.currentUser!.uid)/currentOrders")
    let userProcessingOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(FIRAuth.auth()!.currentUser!.uid)/processingOrders")
    
    //MARK - Miscellaneous Variables
    var isDatabaseEmpty : Bool = false
    var searchController = UISearchController(searchResultsController: nil)
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    //MARK: - View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
        
        setupSearchBar()
        setupActivityLoader()
        
        generateCurrentOrders(completion: { () -> () in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Main Order Generation Function
    
    func generateCurrentOrders(completion: @escaping () -> ()) {
        observeOrderIntializationCompletionNotification()
        
        fetchNewProcessedOrders()
        fetchNewProcessingOrders()
        
        observeRemovedProcessedOrders()
        observeRemovedProcessingOrders()
    }
    
    //MARK: - Order Fetching Observer Functions
    
    func fetchNewProcessingOrders() {
        userProcessingOrdersDatabaseReference.observe(FIRDataEventType.childAdded, with: { (snapshot) in
            guard let orderUID = snapshot.value as? String else {
                print("Error: Snapshot is empty, please check if database reference is valid.")
                self.isDatabaseEmpty = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            let order = RecycleOrder.init(processingOrderWithOrderUID: orderUID)
            self.currentOrderItemsArray.append(order)
        })
    }
    
    func fetchNewProcessedOrders() {
        userProcessedOrdersDatabaseReference.observe(FIRDataEventType.childAdded, with: { (snapshot) in
            guard let orderUID = snapshot.value as? String else {
                print("Error: Snapshot is empty, please check if database reference is valid.")
                self.isDatabaseEmpty = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            let order = RecycleOrder.init(processedOrderWithOrderUID: orderUID)
            self.currentOrderItemsArray.append(order)
        })
    }
    
    //MARK: - Order Removal Observer Functions
    
    func observeRemovedProcessingOrders() {
        userProcessingOrdersDatabaseReference.observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            guard let removedOrderID = snapshot.value as? String else {
                print("Error: Snapshot is nil.")
                return
            }
            
            guard let indexToBeRemoved: Int = self.processingOrderItems.index(where: {$0.orderUID == removedOrderID}) else {
                print("Error: No matching order ID found in local array. Please check for data corruption.")
                return
            }
            
            self.currentOrderItemsArray.remove(at: indexToBeRemoved)
            
            let currentOrderDeletionNotification = Notification(name: Notification.Name(rawValue: "CurrentOrderDeletionNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(currentOrderDeletionNotification)
        })
    }
    
    func observeRemovedProcessedOrders() {
        userProcessedOrdersDatabaseReference.observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            guard let removedOrderID = snapshot.value as? String else {
                print("Error: Snapshot is nil.")
                return
            }
            
            guard let indexToBeRemoved: Int = self.processedOrderItems.index(where: {$0.orderUID == removedOrderID}) else {
                print("Error: No matching order ID found in local array. Please check for data corruption.")
                return
            }
            
            self.currentOrderItemsArray.remove(at: indexToBeRemoved)
        })
    }
    
    //MARK: - Notification Observer Functions
    
    func observeOrderIntializationCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderIntializationCompletionNotification), name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCurrentOrderDeletionNotification(_:)), name: Notification.Name(rawValue: "CurrentOrderDeletionNotification"), object: nil)
    }
    
    //MARK: - Notification Handler Functions
    
    func handleCurrentOrderDeletionNotification(_ notification: Notification) {
        currentOrdersTableView.beginUpdates()
        
        currentOrdersTableView.endUpdates()
    }
    
    func handleOrderIntializationCompletionNotification(_ notification: Notification) {
        currentOrdersTableView.reloadData()
        
        // append to array OR remove from array
        // get the index path of changed thing
        // if added indexPath.row + 1
        // if removed = get the index of the removed row
        
        // update the datasource array
        // currentOrdersTableView.beginUpdates()
        // currentOrdersTableView.insertRows(at: <#T##[IndexPath]#>, with: <#T##UITableViewRowAnimation#>) // for add = use with .childAdded
        // currentOrdersTableView.deleteRows(at: <#T##[IndexPath]#>, with: <#T##UITableViewRowAnimation#>) // for delete = use with .childRemoved
        // currentOrdersTableView.reloadRows(at: <#T##[IndexPath]#>, with: <#T##UITableViewRowAnimation#>) // for udpate = use with .value
        // currentOrdersTableView.endUpdates()
        
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: - Miscellaneous Functions
    
    func setupActivityLoader() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
        print("Add subview: activityIndicator")
    }
    
    func setupSearchBar() {
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.forestGreen
        searchController.dimsBackgroundDuringPresentation = false
        
        currentOrdersTableView.tableHeaderView = searchController.searchBar
    }
    
    func createFormattedDateWith(timeInterval: Double) -> String {
        let dateInTimeInterval = Date.init(timeIntervalSinceReferenceDate: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: dateInTimeInterval)
    }
}

extension CurrentOrdersViewController: UITableViewDelegate {
    
}

extension CurrentOrdersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            filterContentForSearchText(searchBar.text!)
        } else {
            return
        }
    }
}

extension CurrentOrdersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != nil {
            filterContentForSearchText(searchController.searchBar.text!)
            currentOrdersTableView.reloadData()
        } else {
            return
        }
    }
}

extension CurrentOrdersViewController: UITableViewDataSource {
    func filterContentForSearchText(_ searchText: String) {
        filteredCurrentOrderItemsArray = currentOrderItemsArray.filter({ (orderItem: RecycleOrder) -> Bool in
            return orderItem.keywords.lowercased().contains(searchText.lowercased())
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !currentOrderItemsArray.isEmpty {
            self.currentOrdersTableView.separatorStyle = .none
            return 1
        } else {
            if isDatabaseEmpty {
                let emptyMessageLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                
                emptyMessageLabel.text = "No orders placed :("
                emptyMessageLabel.textColor = UIColor.darkGreen
                emptyMessageLabel.numberOfLines = 0
                emptyMessageLabel.textAlignment = NSTextAlignment.center
                emptyMessageLabel.font = UIFont.init(name: "San Francisco Text", size: 20)
                emptyMessageLabel.sizeToFit()
                
                self.currentOrdersTableView.backgroundView = emptyMessageLabel
                self.currentOrdersTableView.separatorStyle = .none
            } else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCurrentOrderItemsArray.count == 0 {
            if searchController.searchBar.isFirstResponder {
                
                let emptyMessageLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                
                emptyMessageLabel.text = "No results found."
                emptyMessageLabel.textColor = UIColor.darkGreen
                emptyMessageLabel.numberOfLines = 0
                emptyMessageLabel.textAlignment = NSTextAlignment.center
                emptyMessageLabel.font = UIFont.init(name: "San Francisco Text", size: 20)
                emptyMessageLabel.sizeToFit()
                
                self.currentOrdersTableView.backgroundView = emptyMessageLabel
                self.currentOrdersTableView.separatorStyle = .none
                
                return 0
            } else {
                return currentOrderItemsArray.count
            }
        } else {
            return filteredCurrentOrderItemsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrentOrderTableViewCell
        
        cell.layer.backgroundColor = UIColor.viewLightGray.cgColor
        
        cell.overlayView.layer.cornerRadius = 20.0
        cell.overlayView.layer.masksToBounds = true
        
        let orderItem: RecycleOrder
        
        if filteredCurrentOrderItemsArray.count == 0 {
            orderItem = currentOrderItemsArray[indexPath.row]
        } else {
            orderItem = filteredCurrentOrderItemsArray[indexPath.row]
        }
        
        if orderItem.creationTimestamp != nil {
            cell.creationTimestampLabel.text = createFormattedDateWith(timeInterval: orderItem.creationTimestamp!)
            cell.creationTimestampLabel.smallTitleFonts()
        } else {
            cell.creationTimestampLabel.text = "Error: Timestamp is nil."
            cell.creationTimestampLabel.smallTitleFonts()
        }
        
        if orderItem.receiverName != nil {
            cell.receiverNameLabel.text = orderItem.receiverName!
            cell.receiverNameLabel.mediumTitleFonts()
        } else {
            cell.receiverNameLabel.text = "Error: Receiver name is nil."
            cell.receiverNameLabel.mediumTitleFonts()
        }
        
        if orderItem.receiverContact != nil {
            cell.receiverContactLabel.text = orderItem.receiverContact!
            cell.receiverContactLabel.mediumTitleFonts()
        } else {
            cell.receiverContactLabel.text = "Error: Receiver contact is nil."
            cell.receiverContactLabel.mediumTitleFonts()
        }
        
        if orderItem.receiverFormattedAddress != nil {
            cell.receiverAddressTitleLabel.mediumTitleFonts()
            cell.receiverAddressLabel.text = orderItem.receiverFormattedAddress!
            cell.receiverAddressLabel.smallTitleFonts()
        } else {
            cell.receiverAddressTitleLabel.mediumTitleFonts()
            cell.receiverAddressLabel.text = "Error: Receiver formatted address is nil."
            cell.receiverAddressLabel.smallTitleFonts()
        }
        
        if orderItem.assignedDriver != nil {
            cell.orderStateLabel.text = "Processed"
            cell.orderStateLabel.largeTitleFonts()
            cell.driverNameLabel.text = orderItem.assignedDriver?.name
            cell.driverNameLabel.mediumTitleFonts()
        } else {
            cell.orderStateLabel.text = "Processing"
            cell.orderStateLabel.largeTitleFonts()
            cell.driverNameLabel.text = "Assignment pending"
            cell.driverNameLabel.mediumTitleFonts()
        }
        
        cell.iconArray.removeAll()
        
        if orderItem.hasAluminium != nil {
            aluminiumImage: if orderItem.hasAluminium! {
                guard let aluminiumImage = UIImage.init(named: "highlightedAluminiumIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break aluminiumImage
                }
                cell.iconArray.append(aluminiumImage)
            } else {
                guard let aluminiumImage = UIImage.init(named: "aluminiumIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break aluminiumImage
                }
                cell.iconArray.append(aluminiumImage)
            }
        }
        
        if orderItem.hasGlass != nil {
            glassImage: if orderItem.hasGlass! {
                guard let glassImage = UIImage.init(named: "highlightedGlassIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break glassImage
                }
                cell.iconArray.append(glassImage)
            } else {
                guard let glassImage = UIImage.init(named: "glassIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break glassImage
                }
                cell.iconArray.append(glassImage)
            }
        }
        
        if orderItem.hasPaper != nil {
            paperImage: if orderItem.hasPaper! {
                guard let paperImage = UIImage.init(named: "highlightedPaperIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break paperImage
                }
                cell.iconArray.append(paperImage)
            } else {
                guard let paperImage = UIImage.init(named: "paperIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break paperImage
                }
                cell.iconArray.append(paperImage)
            }
        }
        
        if orderItem.hasPlastic != nil {
            plasticImage: if orderItem.hasPlastic! {
                guard let plasticImage = UIImage.init(named: "highlightedPlasticIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break plasticImage
                }
                cell.iconArray.append(plasticImage)
            } else {
                guard let plasticImage = UIImage.init(named: "plasticIcon") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break plasticImage
                }
                cell.iconArray.append(plasticImage)
            }
        }
        
        cell.imageCollectionView.reloadData()
        
        return cell
    }
}
