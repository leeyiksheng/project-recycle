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
    var emptyMessageLabel: UILabel = UILabel()
    
    var completedOrderItemsArray: [RecycleOrder] = []
    var filteredCompletedOrderItemsArray: [RecycleOrder] = []
    
    //MARK - Firebase Database References
    
    let userCompletedOrdersDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(FIRAuth.auth()!.currentUser!.uid)/completedOrders")
    
    //MARK - Miscellaneous Variables
    var isDatabaseEmpty : Bool = false
    var isTableViewBeingSorted : Bool = false
    var isUserSearchingTableView : Bool = false
    
    var searchController = UISearchController(searchResultsController: nil)
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.forestGreen
        
        return refreshControl
    }()
    
    //MARK: - View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableSortButton()
        
        completedOrdersTableView.delegate = self
        completedOrdersTableView.dataSource = self
        completedOrdersTableView.backgroundColor = UIColor.viewLightGray
        completedOrdersTableView.addSubview(refreshControl)
        completedOrdersTableView.isUserInteractionEnabled = false
        
        setupSearchBar()
        setupSearchResultsEmptyMessageLabel()
        setupActivityLoader()
        initializeObservers()
        
        
        generateCompletedOrders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateCompletedOrders() {
        observeOrderIntializationCompletionNotification()
        
        fetchCompletedOrders()
        observeRemovedCompletedOrders()
    }
    
    //MARK: - Order Fetching Observer Functions
    
    func fetchCompletedOrders() {
        userCompletedOrdersDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value as? [String] == nil {
                self.activityIndicator.stopAnimating()
                self.completedOrdersTableView.isUserInteractionEnabled = true
                self.isDatabaseEmpty = true
                self.completedOrdersTableView.separatorStyle = .none
                self.completedOrdersTableView.backgroundView = self.emptyMessageLabel
            }
        })
        
        userCompletedOrdersDatabaseReference.observe(FIRDataEventType.childAdded, with: { (snapshot) in
            guard let orderUID = snapshot.value as? String else {
                print("Error: Snapshot is empty, please check if database reference is valid.")
                self.isDatabaseEmpty = true
                self.activityIndicator.stopAnimating()
                self.completedOrdersTableView.isUserInteractionEnabled = true
                return
            }
            
            let order = RecycleOrder.init(completedOrderWithOrderUID: orderUID)
            self.completedOrderItemsArray.insert(order, at: 0)
        })
    }
    
    //MARK: - Order Removal Observer Functions
    
    func observeRemovedCompletedOrders() {
        userCompletedOrdersDatabaseReference.observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            guard let removedOrderID = snapshot.value as? String else {
                print("Error: Snapshot is nil.")
                return
            }
            
            guard let indexToBeRemoved: Int = self.completedOrderItemsArray.index(where: {$0.orderUID == removedOrderID}) else {
                print("Error: No matching order ID found in local array. Please check for data corruption.")
                return
            }
            
            self.completedOrderItemsArray.remove(at: indexToBeRemoved)
            
            let completedOrderDeletionNotification = Notification(name: Notification.Name(rawValue: "CompletedOrderDeletionNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(completedOrderDeletionNotification)
        })
    }
    
    //MARK: - Notification Observer Functions
    
    func observeOrderIntializationCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderIntializationCompletionNotification), name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCompletedOrderDeletionNotification(_:)), name: Notification.Name(rawValue: "CompletedOrderDeletionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDriverInitializationCompletionNotification), name: Notification.Name(rawValue: "DriverInitializationCompletionNotification"), object: nil)
    }
    
    //MARK: - Notification Handler Functions
    
    func handleDriverInitializationCompletionNotification() {
        completedOrdersTableView.reloadData()
    }
    
    func handleCompletedOrderDeletionNotification(_ notification: Notification) {
        completedOrdersTableView.beginUpdates()
        
        completedOrdersTableView.endUpdates()
    }
    
    func handleOrderIntializationCompletionNotification(_ notification: Notification) {
        completedOrdersTableView.reloadData()
        
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
        
        searchController.searchBar.isUserInteractionEnabled = true
        completedOrdersTableView.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    //MARK: - Notification Functions
    
    func initializeObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDidTapOrderStatusAscendingActionNotification), name: Notification.Name(rawValue: "userDidTapOrderStatusAscendingActionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDidTapOrderStatusDescendingActionNotification), name: Notification.Name(rawValue: "userDidTapOrderStatusDescendingActionNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDidTapTimeActionAscendingNotification), name: Notification.Name(rawValue: "userDidTapTimeActionAscendingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDidTapTimeActionDescendingNotification), name: Notification.Name(rawValue: "userDidTapTimeActionDescendingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserWillExitCompletedOrdersSegmentNotification), name: Notification.Name(rawValue: "userWillExitCompletedOrdersSegmentNotification"), object: nil)
    }
    
    func handleUserDidTapOrderStatusAscendingActionNotification() {
        sortContentForSortingCategory(category: "orderStatus", arrangement: "ascending")
        completedOrdersTableView.reloadData()
    }
    
    func handleUserDidTapOrderStatusDescendingActionNotification() {
        sortContentForSortingCategory(category: "orderStatus", arrangement: "descending")
        completedOrdersTableView.reloadData()
    }
    
    func handleUserDidTapTimeActionAscendingNotification() {
        sortContentForSortingCategory(category: "time", arrangement: "ascending")
        completedOrdersTableView.reloadData()
    }
    
    func handleUserDidTapTimeActionDescendingNotification() {
        sortContentForSortingCategory(category: "time", arrangement: "descending")
        completedOrdersTableView.reloadData()
    }
    
    func handleUserWillExitCompletedOrdersSegmentNotification() {
        if searchController.isActive {
            searchController.isActive = false
        }
    }
    
    func disableSortButton() {
        let disableSortButtonNotification = Notification(name: Notification.Name(rawValue: "disableSortButtonNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(disableSortButtonNotification)
    }
    
    func enableSortButton() {
        let enableSortButtonNotification = Notification(name: Notification.Name(rawValue: "enableSortButtonNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(enableSortButtonNotification)
    }
    
    func disableMenuSegmentedControl() {
        let disableMenuSegmentedControlNotification = Notification(name: Notification.Name(rawValue: "disableMenuSegmentedControlNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(disableMenuSegmentedControlNotification)
    }
    
    func enableMenuSegmentedControl() {
        let enableMenuSegmentedControlNotification = Notification(name: Notification.Name(rawValue: "enableMenuSegmentedControlNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(enableMenuSegmentedControlNotification)
    }
    
    //MARK: - Table View Refresh Functions
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        print("Refreshing table view.")
        
        userCompletedOrdersDatabaseReference.removeAllObservers()
        
        completedOrderItemsArray.removeAll()
        
        fetchCompletedOrders()
        
        completedOrdersTableView.reloadData()
        
        refreshControl.endRefreshing()
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
        searchController.searchBar.backgroundColor = UIColor.forestGreen
        searchController.dimsBackgroundDuringPresentation = false
        
        completedOrdersTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.isUserInteractionEnabled = false
    }
    
    func createFormattedDateWith(timeInterval: Double) -> String {
        let dateInTimeInterval = Date(timeIntervalSinceReferenceDate: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: dateInTimeInterval)
    }
    
    func setupSearchResultsEmptyMessageLabel() {
        emptyMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        emptyMessageLabel.text = "No orders found :("
        emptyMessageLabel.textColor = UIColor.darkGreen
        emptyMessageLabel.numberOfLines = 0
        emptyMessageLabel.textAlignment = NSTextAlignment.center
        emptyMessageLabel.font = UIFont(name: "San Francisco Text", size: 20)
        emptyMessageLabel.sizeToFit()
    }
    
    //MARK: - Debugging Functions
    
    func printAllOrderItemsOrderStatus(array: [RecycleOrder]) {
        for order : RecycleOrder in array {
            if order.orderStatus != nil {
                print(order.orderStatus!.rawValue)
            } else {
                print("Error: Order status is nil.")
            }
        }
    }
    
    func printAllOrderItemsCreationTimestamp(array: [RecycleOrder]) {
        for order : RecycleOrder in array {
            if order.creationTimestamp != nil {
                print(order.creationTimestamp!)
            } else {
                print("Error: creationTimestamp is nil.")
            }
        }
    }
}

extension OrderHistoryViewController: UITableViewDelegate {
    
}

extension OrderHistoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            filterContentForSearchText(searchBar.text!)
        } else {
            return
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isUserSearchingTableView = true
        disableSortButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isUserSearchingTableView = false
        enableSortButton()
    }
}

extension OrderHistoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != nil {
            filterContentForSearchText(searchController.searchBar.text!)
            completedOrdersTableView.reloadData()
        } else {
            return
        }
    }
}

extension OrderHistoryViewController: UITableViewDataSource {
    //MARK: - Search & Sort Functions
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCompletedOrderItemsArray = completedOrderItemsArray.filter({ (orderItem: RecycleOrder) -> Bool in
            return orderItem.keywords.lowercased().contains(searchText.lowercased())
        })
    }
    
    func sortContentForSortingCategory(category: String, arrangement: String) {
        isTableViewBeingSorted = true
        switch category {
        case "orderStatus":
            if arrangement == "ascending" {
                completedOrderItemsArray.sort(by: { ($0.0.orderStatus?.rawValue)! < ($0.1.orderStatus?.rawValue)!  })
                printAllOrderItemsOrderStatus(array: completedOrderItemsArray)
            } else if arrangement == "descending" {
                completedOrderItemsArray.sort(by: { ($0.0.orderStatus?.rawValue)! > ($0.1.orderStatus?.rawValue)! })
                printAllOrderItemsOrderStatus(array: completedOrderItemsArray)
            } else {
                print("Error: Invalid arrangement provided.")
            }
        case "time":
            if arrangement == "ascending" {
                completedOrderItemsArray.sort(by: { ($0.0.creationTimestamp)! < ($0.1.creationTimestamp)! })
                printAllOrderItemsCreationTimestamp(array: completedOrderItemsArray)
            } else if arrangement == "descending" {
                completedOrderItemsArray.sort(by: { ($0.0.creationTimestamp)! > ($0.1.creationTimestamp)! })
                printAllOrderItemsCreationTimestamp(array: completedOrderItemsArray)
            } else {
                print("Error: Invalid arrangement provided.")
            }
        default:
            isTableViewBeingSorted = false
            print("Error: No valid predicate provided for sorter.")
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !completedOrderItemsArray.isEmpty {
            completedOrdersTableView.backgroundView = UIView()
            completedOrdersTableView.separatorStyle = .none
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCompletedOrderItemsArray.count == 0 {
            if searchController.searchBar.isFirstResponder {
                completedOrdersTableView.backgroundView = emptyMessageLabel
                completedOrdersTableView.separatorStyle = .none
                return 0
            } else {
                completedOrdersTableView.backgroundView = UIView()
                completedOrdersTableView.separatorStyle = .none
                return completedOrderItemsArray.count
            }
        } else {
            completedOrdersTableView.backgroundView = UIView()
            completedOrdersTableView.separatorStyle = .none
            return filteredCompletedOrderItemsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompletedOrderTableViewCell
        
        cell.layer.backgroundColor = UIColor.viewLightGray.cgColor
        cell.overlayView.layer.cornerRadius = 4.0
        cell.overlayView.layer.masksToBounds = true
        
        let orderItem: RecycleOrder
        
        if filteredCompletedOrderItemsArray.count == 0 {
            orderItem = completedOrderItemsArray[indexPath.row]
        } else {
            orderItem = filteredCompletedOrderItemsArray[indexPath.row]
        }
        
        if orderItem.completionTimestamp != nil {
            cell.completionTimestampLabel.text = createFormattedDateWith(timeInterval: orderItem.completionTimestamp!)
            cell.completionTimestampLabel.smallTitleFonts()
            cell.completionTimestampLabel.textColor = UIColor.white
        } else {
            cell.completionTimestampLabel.text = "Error: Timestamp is nil."
            cell.completionTimestampLabel.smallTitleFonts()
            cell.completionTimestampLabel.textColor = UIColor.white
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
            cell.orderStateLabel.text = "Completed"
            cell.orderStateLabel.smallTitleFonts()
            cell.orderStateLabel.textColor = UIColor.white
            cell.headerView.backgroundColor = UIColor.forestGreen
            cell.driverNameLabel.text = orderItem.assignedDriver!.name
            cell.driverNameLabel.mediumTitleFonts()
        } else {
            print("Error: This order item is not a completed order. Please check the database.")
        }
        
        if orderItem.orderValue != nil {
            cell.orderValueLabel.text = "RM " + String(format: "%.2f", orderItem.orderValue!)
            cell.orderValueLabel.mediumTitleFonts()
        }
        
        cell.iconArray.removeAll()
        
        if orderItem.hasAluminium != nil {
            aluminiumImage: if orderItem.hasAluminium! {
                guard let aluminiumImage = UIImage.init(named: "ColorAluminium") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break aluminiumImage
                }
                cell.iconArray.append(aluminiumImage)
            } else {
                guard var aluminiumImage = UIImage.init(named: "GreyAluminium") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break aluminiumImage
                }
                aluminiumImage = aluminiumImage.alpha(value: 0.5)
                cell.iconArray.append(aluminiumImage)
            }
        }
        
        if orderItem.hasGlass != nil {
            glassImage: if orderItem.hasGlass! {
                guard let glassImage = UIImage.init(named: "ColorGlass") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break glassImage
                }
                cell.iconArray.append(glassImage)
            } else {
                guard var glassImage = UIImage.init(named: "GreyGlass") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break glassImage
                }
                glassImage = glassImage.alpha(value: 0.5)
                cell.iconArray.append(glassImage)
            }
        }
        
        if orderItem.hasPaper != nil {
            paperImage: if orderItem.hasPaper! {
                guard let paperImage = UIImage.init(named: "ColorPaper") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break paperImage
                }
                cell.iconArray.append(paperImage)
            } else {
                guard var paperImage = UIImage.init(named: "GreyPaper") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break paperImage
                }
                paperImage = paperImage.alpha(value: 0.5)
                cell.iconArray.append(paperImage)
            }
        }
        
        if orderItem.hasPlastic != nil {
            plasticImage: if orderItem.hasPlastic! {
                guard let plasticImage = UIImage.init(named: "ColorPlastic") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break plasticImage
                }
                cell.iconArray.append(plasticImage)
            } else {
                guard var plasticImage = UIImage.init(named: "GreyPlastic") else {
                    cell.iconArray.append(UIImage.init(named: "redErrorIcon")!)
                    break plasticImage
                }
                plasticImage = plasticImage.alpha(value: 0.5)
                cell.iconArray.append(plasticImage)
            }
        }
        
        cell.imageCollectionView.reloadData()
        
        return cell
    }
}
