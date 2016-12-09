//
//  DriverAssignmentCompletionViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 08/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DriverAssignmentCompletionViewController: UIViewController {

    @IBOutlet weak var driverTableView: UITableView!
    
    var driverArray: [Driver] = []
    var selectedDriver: Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverTableView.delegate = self
        driverTableView.dataSource = self
        
        populateDriverArrayFromDatabase(completion: { () -> () in
            self.driverTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                
                driver.driverUID = driverRawDataDictionary["driverID"] as! String
                driver.email = driverRawDataDictionary["email"] as! String
                driver.name = driverRawDataDictionary["name"] as! String
                driver.phoneNumber = driverRawDataDictionary["phoneNumber"] as! String
                driver.profileImage = driverRawDataDictionary["profileImage"] as! String
                
                self.driverArray.append(driver)
            }
            
            completion()
        })
    }
    
    func saveSelectedDriver(selectedIndex: Int) {
        selectedDriver = driverArray[selectedIndex]
    }
}

extension DriverAssignmentCompletionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveSelectedDriver(selectedIndex: indexPath.row)
        
        let driverAssignmentCompletionSubmissionViewController = storyboard?.instantiateViewController(withIdentifier: "Driver Assignment Completion Submission") as! DriverAssignmentCompletionSubmissionViewController
        driverAssignmentCompletionSubmissionViewController.selectedDriver = selectedDriver
        
        present(driverAssignmentCompletionSubmissionViewController, animated: true, completion: nil)
    }
}

extension DriverAssignmentCompletionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "driverCell")!
        
        cell.textLabel?.text = driverArray[indexPath.row].name
        cell.detailTextLabel?.text = "Assigned orders: \(driverArray[indexPath.row].assignedOrderUIDArray.count)"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverArray.count
    }
}
