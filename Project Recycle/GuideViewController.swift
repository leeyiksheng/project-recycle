//
//  GuideViewController.swift
//  Project Recycle
//
//  Created by Students on 12/6/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var guideTableView: UITableView!
    {
        didSet{
            guideTableView.dataSource = self
        }
    }
    @IBOutlet weak var pickerView: UIPickerView!
    {
        didSet{
            pickerView.dataSource = self
            pickerView.delegate = self
        }
    }
    
    var categories = ["All", "Appliances", "Batteries", "Electronics", "Fluorescent Lights", "Furniture", "Glass", "Metals", "Paper", "Plastic", "Textiles"]
    var holdCategories : String = ""
    var recylables = [GeneralRecylables]()
    var filterRecylables = [GeneralRecylables]()
    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            
            searchController.searchBar.tintColor = UIColor.white
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchBar.barTintColor = UIColor.green
        searchController.dimsBackgroundDuringPresentation = false
        guideTableView.tableHeaderView = searchController.searchBar
        
        assignMaterialsToArray()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton)
    {
        if pickerView.isHidden == true
        {
            sender.setTitle("Confirm", for: .normal)
            pickerView.isHidden = false
            pickerView.backgroundColor = UIColor.gray
            
            
        }
        else
        {
            
            sender.setTitle("Filter", for: .normal)
            recylables.filter{$0.category.contains(holdCategories)}
            pickerView.isHidden = true
            guideTableView.reloadData()
        }
    }
    
    func assignMaterialsToArray()
    {
        recylables = [
            GeneralRecylables(category: "Appliances", materialName: "Air Conditioners", matImage: UIImage (named: "AC")!),
            GeneralRecylables(category: "Appliances", materialName: "Microwaves", matImage: UIImage(named: "microwave")!),
            GeneralRecylables(category: "Appliances", materialName: "Refrigerators, Freezers", matImage: UIImage(named: "refridge")!),
            GeneralRecylables(category: "Appliances", materialName: "Small Household Appliances", matImage: UIImage(named: "SHA")!),
            GeneralRecylables(category: "Appliances", materialName: "Other Major Appliances", matImage: UIImage(named: "OA")!),
            GeneralRecylables(category: "Batteries", materialName: "Alkaline Batteries", matImage: UIImage (named: "alkaline")!),
            GeneralRecylables(category: "Batteries", materialName: "Button Batteries", matImage: UIImage (named: "button")!),
            GeneralRecylables(category: "Batteries", materialName: "Rechargeable Batteries", matImage: UIImage (named: "Energizer")!),
            GeneralRecylables(category: "Electronics", materialName: "Cell Phones, Smart Phones", matImage: UIImage (named: "bom")!),
            GeneralRecylables(category: "Electronics", materialName: "Computers, Laptops & Tablets", matImage: UIImage (named: "laptop")!),
            GeneralRecylables(category: "Electronics", materialName: "TV & Monitors", matImage: UIImage (named: "tv")!),
            GeneralRecylables(category: "Fluorescent Lights", materialName: "Bulbs", matImage: UIImage (named: "bulb")!),
            GeneralRecylables(category: "Fluorescent Lights", materialName: "Tubes", matImage: UIImage (named: "tube")!),
            GeneralRecylables(category: "Furniture", materialName: "Household Furniture", matImage: UIImage (named: "sofa")!),
            GeneralRecylables(category: "Furniture", materialName: "Mattresses", matImage: UIImage (named: "mattress")!),
            GeneralRecylables(category: "Furniture", materialName: "Office Furniture", matImage: UIImage (named: "office")!),
            GeneralRecylables(category: "Glass", materialName: "Mixed Glass", matImage: UIImage (named: "mixed")!),
            GeneralRecylables(category: "Glass", materialName: "Separated Glass", matImage: UIImage (named: "sep")!),
            GeneralRecylables(category: "Glass", materialName: "Window Glass", matImage: UIImage (named: "window")!),
            GeneralRecylables(category: "Metals", materialName: "Aluminium Cans", matImage: UIImage (named: "cans")!),
            GeneralRecylables(category: "Metals", materialName: "Ferrous Metals", matImage: UIImage (named: "ferrous")!),
            GeneralRecylables(category: "Metals", materialName: "Nonferrous Metals", matImage: UIImage (named: "nonferrous")!),
            GeneralRecylables(category: "Paper", materialName: "Books", matImage: UIImage (named: "books")!),
            GeneralRecylables(category: "Paper", materialName: "Cardboard", matImage: UIImage (named: "cardboard")!),
            GeneralRecylables(category: "Paper", materialName: "Mixed Paper", matImage: UIImage (named: "papermixed")!),
            GeneralRecylables(category: "Paper", materialName: "Newspaper", matImage: UIImage (named: "newspaper")!),
            GeneralRecylables(category: "Paper", materialName: "Polycoated Cardboard", matImage: UIImage (named: "milk")!),
            GeneralRecylables(category: "Paper", materialName: "Shredded Paper", matImage: UIImage (named: "tear")!),
            GeneralRecylables(category: "Plastic", materialName: "Agriculture Plastic", matImage: UIImage (named: "agri")!),
            GeneralRecylables(category: "Plastic", materialName: "Bottles, Jugs and Tubs", matImage: UIImage (named: "p-jug")!),
            GeneralRecylables(category: "Plastic", materialName: "Packing Peanuts & Foam Blocks", matImage: UIImage (named: "p-foam")!),
            GeneralRecylables(category: "Plastic", materialName: "Plastic Film & Grocery Bags", matImage: UIImage (named: "p-bag")!),
            GeneralRecylables(category: "Plastic", materialName: "Plastic Nursery Pots", matImage: UIImage (named: "p-pot")!),
            GeneralRecylables(category: "Plastic", materialName: "Plastic Office Supplies", matImage: UIImage (named: "p-tools")!),
            GeneralRecylables(category: "Plastic", materialName: "Mixed Plastic and Other", matImage: UIImage (named: "mixed-p")!),
            GeneralRecylables(category: "Textiles", materialName: "Clothing, Shoe, and Fabrics", matImage: UIImage (named: "cloth")!),
            GeneralRecylables(category: "Textiles", materialName: "Flags", matImage: UIImage (named: "flags")!),
        ]
    }

}

extension GuideViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension GuideViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        holdCategories = categories[row]
    }
}

extension GuideViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension GuideViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension GuideViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return filterRecylables.count
        }
        return recylables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GuideTableViewCell
        let recylable : GeneralRecylables
        if searchController.isActive && searchController.searchBar.text != ""
        {
            recylable = filterRecylables[indexPath.row]

        }
        else
        {
            recylable = recylables[indexPath.row]
        }
        cell.materialName.text = recylable.materialName
        cell.materialCategory.text = recylable.category
        cell.backImage.image = recylable.matImage
        return cell
        
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filterRecylables = recylables.filter({ (recycle : GeneralRecylables) -> Bool in
            return recycle.materialName.lowercased().contains(searchText.lowercased())
        })
        guideTableView.reloadData()
    }
}
