//
//  GuideDetailViewController.swift
//  Project Recycle
//
//  Created by Students on 12/9/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class GuideDetailViewController: UIViewController {
    @IBOutlet weak var titleVCLabel: UILabel!
    @IBOutlet weak var matImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    {
        didSet{
            nameLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var detailsText: UITextView!

    var matCat : String? = nil
    var matName : String? = nil
    var imageName : UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        titleVCLabel.text = matCat
        nameLabel.text = matName
        matImage.image = imageName
        
        if matName == "Newspaper"
        {
            exampleLabel.text = "TheStar, SinChewDaily & Utusan Malaysia"
            detailsText.text = "1. Stack up the newspaper. \n2. Use plastic rope to tie it up."
        }
        
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
