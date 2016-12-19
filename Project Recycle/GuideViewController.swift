//
//  GuideViewController.swift
//  Project Recycle
//
//  Created by Students on 12/6/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    lazy var sortLabel: UILabel = {
        let label = UILabel()
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleFilter))
        label.largeTitleFonts()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SORT BY"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.backgroundColor = UIColor.viewLightGray
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    lazy var guideTableView: UITableView = {
       let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = 320


        tv.register(GuideTableViewCell.self, forCellReuseIdentifier: "cell2")
        return tv
    }()
    
    lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor.viewLightGray
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    
    var categories = ["All", "Appliances", "Batteries", "Electronics", "Fluorescent Lights", "Furniture", "Glass", "Metals", "Paper", "Plastic", "Textiles"]
    var holdCategories : String = ""
    var recylables = [GeneralRecylables]()
    var filterRecylables = [GeneralRecylables]()
    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            
            searchController.searchBar.tintColor = UIColor.white
        }
    }
    
    var i = 0
    var navigationBarHeight : CGFloat = 0
    var tabBarHeight : CGFloat = 0
    var showSearchBar = true
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sortLabel)
        view.addSubview(guideTableView)
        view.addSubview(pickerView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .done, target: self, action: #selector(handleSearch))
        navigationItem.title = "Disassembly Guide"
        navigationController?.navigationBarAttributes()
        navigationItem.navigationItemAttributes()
        navigationBarHeight = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        
        
        self.tabBarHeight = (self.tabBarController?.tabBar.frame.height)!

        
        
        pickerView.isHidden = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchBar.barTintColor = UIColor.textDarkGray
        searchController.dimsBackgroundDuringPresentation = false
        setupSortLabel()
        setupGuideTableView()
        setupPickerView()
        
        assignMaterialsToArray()
    }
    

    func handleSearch() {
        if showSearchBar {
            guideTableView.tableHeaderView = searchController.searchBar
            showSearchBar = false
        } else {
            guideTableView.tableHeaderView = nil
            showSearchBar = true
        }
        
    }
    
    func handleFilter() {
        if pickerView.isHidden == true
        {
            sortLabel.text = "DONE"
            pickerView.isHidden = false
            
        }
        else
        {
            
            sortLabel.text = holdCategories
            pickerView.isHidden = true
        }
    }
    

    
    func assignMaterialsToArray()
    {
        recylables = [
            GeneralRecylables(category: "Appliances", synopsis:"Air Conditioners is a type of machine that mixed up of different type of materials.", materialName: "Air Conditioners", matImage: UIImage (named: "AC")!),
            GeneralRecylables(category: "Appliances", synopsis:"Microwaves, a machine that use mostly contains of metals and electrical wirings.", materialName: "Microwaves", matImage: UIImage(named: "microwave")!),
            GeneralRecylables(category: "Appliances", synopsis:"A refrigerator is the most heavy and complex things to be recycled.", materialName: "Refrigerators, Freezers", matImage: UIImage(named: "refridge")!),
            GeneralRecylables(category: "Appliances", synopsis:"Small appliances such as blender, water heater and etc can be recycled as well.", materialName: "Small Household Appliances", matImage: UIImage(named: "SHA")!),
            GeneralRecylables(category: "Appliances", synopsis:"The others appliances can be recycled to provide a better living environment.", materialName: "Other Major Appliances", matImage: UIImage(named: "OA")!),
            GeneralRecylables(category: "Batteries", synopsis:"In the 90's, most of the things are powered up by alkaline batteries", materialName: "Alkaline Batteries", matImage: UIImage (named: "alkaline")!),
            GeneralRecylables(category: "Batteries", synopsis:"Something small as button batteries can be recycled instead into the thrash.", materialName: "Button Batteries", matImage: UIImage (named: "button")!),
            GeneralRecylables(category: "Batteries", synopsis:"Rechargeable Batteries not only can be rechargeable, but it also could be recylcable", materialName: "Rechargeable Batteries", matImage: UIImage (named: "Energizer")!),
            GeneralRecylables(category: "Electronics", synopsis:"Instead of stacking smart phones in your house, why dont just trade in or recycle it.", materialName: "Cell Phones, Smart Phones", matImage: UIImage (named: "bom")!),
            GeneralRecylables(category: "Electronics", synopsis:"If it's unfixible, try to dismantle it and pass it to us.", materialName: "Computers, Laptops & Tablets", matImage: UIImage (named: "laptop")!),
            GeneralRecylables(category: "Electronics", synopsis:"No matter fat or thin, heavy or light, we always take it in.", materialName: "TV & Monitors", matImage: UIImage (named: "tv")!),
            GeneralRecylables(category: "Fluorescent Lights", synopsis:"It doesn't mean it can't give us light when it can't give you the light.", materialName: "Bulbs", matImage: UIImage (named: "bulb")!),
            GeneralRecylables(category: "Fluorescent Lights", synopsis:"The size of tube is big so start recycle it as we can paid you.", materialName: "Tubes", matImage: UIImage (named: "tube")!),
            GeneralRecylables(category: "Furniture", synopsis:"Not everybody is capable to afford a sofa.", materialName: "Household Furniture", matImage: UIImage (named: "sofa")!),
            GeneralRecylables(category: "Furniture", synopsis:"We do see much more than you do in what it's contain.", materialName: "Mattresses", matImage: UIImage (named: "mattress")!),
            GeneralRecylables(category: "Furniture", synopsis:"You never know it helps a lot in the residencial area.", materialName: "Office Furniture", matImage: UIImage (named: "office")!),
            GeneralRecylables(category: "Glass", synopsis:"Juss pass its to us and we'll handle the rest.", materialName: "Mixed Glass", matImage: UIImage (named: "mixed")!),
            GeneralRecylables(category: "Glass", synopsis:"Well done on the separating job, splendid work indeed.", materialName: "Separated Glass", matImage: UIImage (named: "sep")!),
            GeneralRecylables(category: "Glass", synopsis:"It could be recyclable and it can be in new shape once more.", materialName: "Window Glass", matImage: UIImage (named: "window")!),
            GeneralRecylables(category: "Metals", synopsis:"Do more after what you enjoy the contains of it.", materialName: "Aluminium Cans", matImage: UIImage (named: "cans")!),
            GeneralRecylables(category: "Metals", synopsis:"Don't mind it if we paid less, the recycle job still done.", materialName: "Ferrous Metals", matImage: UIImage (named: "ferrous")!),
            GeneralRecylables(category: "Metals", synopsis:"It's a bit much complex than ferrous metal, but we still finish up for you.", materialName: "Nonferrous Metals", matImage: UIImage (named: "nonferrous")!),
            GeneralRecylables(category: "Paper", synopsis:"There's much more thing you can do with than recycyle it.", materialName: "Books", matImage: UIImage (named: "books")!),
            GeneralRecylables(category: "Paper", synopsis:"Researchers found out that most of the arts are from cardboard.", materialName: "Cardboard", matImage: UIImage (named: "cardboard")!),
            GeneralRecylables(category: "Paper", synopsis:"There's so much thing we can do about it then just differentiate them.", materialName: "Mixed Paper  ", matImage: UIImage (named: "papermixed")!),
            GeneralRecylables(category: "Paper", synopsis:"Recycle with the knowledge you gain today.", materialName: "Newspaper", matImage: UIImage (named: "newspaper")!),
            GeneralRecylables(category: "Paper", synopsis:"It's our turn to use it after the foods and drinks.", materialName: "Polycoated Cardboard", matImage: UIImage (named: "milk")!),
            GeneralRecylables(category: "Paper", synopsis:"Your secret are always safe with us.", materialName: "Shredded Paper", matImage: UIImage (named: "tear")!),
            GeneralRecylables(category: "Plastic", synopsis:"It's always reusable when it deals with agriculture.", materialName: "Agriculture Plastic", matImage: UIImage (named: "agri")!),
            GeneralRecylables(category: "Plastic", synopsis:"We do always lack of containers.", materialName: "Bottles, Jugs and Tubs", matImage: UIImage (named: "p-jug")!),
            GeneralRecylables(category: "Plastic", synopsis:"Unresolved material such as this, recycle is always the best solution for it.", materialName: "Packing Peanuts & Foam Blocks", matImage: UIImage (named: "p-foam")!),
            GeneralRecylables(category: "Plastic", synopsis:"You can always go grocery with it as long as it doesn't have hole with it.", materialName: "Plastic Film & Grocery Bags", matImage: UIImage (named: "p-bag")!),
            GeneralRecylables(category: "Plastic", synopsis:"Try plant something on it if it's empty.", materialName: "Plastic Nursery Pots", matImage: UIImage (named: "p-pot")!),
            GeneralRecylables(category: "Plastic", synopsis:"Use it wisely or else recycle to us.", materialName: "Plastic Office Supplies", matImage: UIImage (named: "p-tools")!),
            GeneralRecylables(category: "Plastic", synopsis:"The hardest part always is about the differentiate the thing.", materialName: "Mixed Plastic and Other", matImage: UIImage (named: "mixed-p")!),
            GeneralRecylables(category: "Textiles", synopsis:"Many textile stuff we can build it from what we collect", materialName: "Clothing, Shoe, and Fabrics", matImage: UIImage (named: "cloth")!),
            GeneralRecylables(category: "Textiles", synopsis:"Recycle it or else dumping might get you punishment.", materialName: "Flags", matImage: UIImage (named: "flags")!),
        ]
    }
    
    
    func setupSortLabel() {
        sortLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: self.navigationBarHeight).isActive = true
        sortLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sortLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sortLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupGuideTableView() {
        guideTableView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor).isActive = true
        guideTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        guideTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        guideTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupPickerView() {
        pickerView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pickerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: self.view.frame.height - tabBarHeight - 50 - navigationBarHeight).isActive = true
    }
    
    
    func moveToNextViewController() {
        let nextController = GuideDetailViewController()
        
        if filterRecylables.count == 0 {
        
            let tempI = recylables[i]
            nextController.matName = tempI.materialName
            nextController.matCat = tempI.category
            nextController.desc = tempI.synopsis
            nextController.imageName = tempI.matImage
        } else {
            let tempI = filterRecylables[i]
            nextController.matName = tempI.materialName
            nextController.matCat = tempI.category
            nextController.desc = tempI.synopsis
            nextController.imageName = tempI.matImage
        }
        

        
        let navController = UINavigationController(rootViewController: nextController)
        self.present(navController, animated: true, completion: nil)
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
        filterRecylables = recylables.filter{$0.category.contains("\(holdCategories)")}
        guideTableView.reloadData()
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
        if filterRecylables.count == 0
        {
            return recylables.count
        }
        else
        {
            return filterRecylables.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! GuideTableViewCell
        let recylable : GeneralRecylables
        if filterRecylables.count == 0
        {
            recylable = recylables[indexPath.row]
        }
        else
        {
            recylable = filterRecylables[indexPath.row]
        }
        cell.backgroundColor = UIColor.viewLightGray
        cell.materialName.text = recylable.materialName
        cell.materialName.textColor = UIColor.forestGreen
        cell.desc.text = recylable.synopsis
        cell.backImage.image = recylable.matImage
        return cell
        
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        if filterRecylables.count != 0
        {
        filterRecylables = filterRecylables.filter({ (recycle : GeneralRecylables) -> Bool in
            return recycle.materialName.lowercased().contains(searchText.lowercased())
        })
        }
        else
        {
            filterRecylables = recylables.filter({ (recycle : GeneralRecylables) -> Bool in
                return recycle.materialName.lowercased().contains(searchText.lowercased())
            })

        }
        guideTableView.reloadData()
    }
}

extension GuideViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        i = indexPath.row
        self.moveToNextViewController()
    }
}
