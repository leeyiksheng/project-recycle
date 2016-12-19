//
//  AddressListViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 19/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddressListViewController: UIViewController {

    @IBOutlet weak var addressListTableView: UITableView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\((FIRAuth.auth()?.currentUser?.uid)!)")
    
    var addressListArray: [NewAddresses] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onBackButtonTouchUpInside(_ sender: UIBarButtonItem) {
        
    }

    @IBAction func onAddButtonTouchUpInside(_ sender: UIBarButtonItem) {
        
    }
    
    //MARK: - Database Fetching & Observing Functions
    
    func generateAddressList() {
        
    }
}

extension AddressListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressListTableViewCell
        
        return cell
    }
}

extension AddressListViewController: UITableViewDelegate {
    
}
