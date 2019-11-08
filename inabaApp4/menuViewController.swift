//
//  menuViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/05.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit

class menuViewController: UIViewController {
    
    
    @IBOutlet weak var exitMenuButton: UIButton!
    @IBAction func exitMenuButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        exitMenuButton.layer.borderColor = UIColor.blue.cgColor
        exitMenuButton.layer.borderWidth = 2.0
        exitMenuButton.layer.cornerRadius = 30.0

    }
    

   

}
