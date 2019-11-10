//
//  menuViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/05.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import SafariServices

class menuViewController: UIViewController {
    
    
    @IBOutlet weak var contactDeveloperButton: UIButton!
    @IBAction func contactDeveloperButton(_ sender: Any) {
        openSafariView(urlString: developerContactURL)
    }
    
    
    
    @IBOutlet weak var exitMenuButton: UIButton!
    @IBAction func exitMenuButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let developerContactURL = "https://www.instagram.com/fukase_1783/"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactDeveloperButton.layer.borderColor = UIColor.blue.cgColor
        contactDeveloperButton.layer.borderWidth = 2.0
        contactDeveloperButton.layer.cornerRadius = 20.0
        
        exitMenuButton.layer.borderColor = UIColor.blue.cgColor
        exitMenuButton.layer.borderWidth = 2.0
        exitMenuButton.layer.cornerRadius = 30.0

    }
    
    func openSafariView(urlString: String) {
        let safariVC = SFSafariViewController(url: NSURL(string: urlString)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
   

}
