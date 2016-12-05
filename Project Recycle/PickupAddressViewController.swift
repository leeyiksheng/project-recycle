//
//  PickupAddressViewController.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/2/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class PickupAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var pickUpAddressLabel: UILabel!{
        didSet{
            pickUpAddressLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    @IBOutlet weak var pickUpAddressTableView: UITableView!{
        didSet{
            pickUpAddressTableView.layer.cornerRadius = 10
        }
    }
    

    let confirmButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        return button
    }()
    
    var selectedRow: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "addAddress"), style: .plain, target: self, action: #selector(handleAddAddress))
        navigationItem.title = "Pick Up Address"
        view.backgroundColor = UIColor.viewLightGray
        view.addSubview(confirmButton)
        
        self.pickUpAddressTableView.delegate = self
        self.pickUpAddressTableView.dataSource = self
        
        
        
        setupConfirmButton()

    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleAddAddress() {
        let nextController = AlternativeAddressViewController()
        let navController = UINavigationController(rootViewController: nextController)
        self.present(navController, animated: true, completion: nil)
    }

    func setupConfirmButton() {
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    
    
    // TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PickupAddressTableViewCell
        return cell
    }
   
    
    // TableView Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        print(44)
    }
    
  
    
}

