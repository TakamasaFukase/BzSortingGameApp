//
//  detailRankingViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/04.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit

class detailRankingViewController: UIViewController {
    
    var text1 = ""
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func closeDetailRanking(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = text1
    }
    

    

}
