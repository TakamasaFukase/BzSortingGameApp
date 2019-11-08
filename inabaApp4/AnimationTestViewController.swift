//
//  AnimationTestViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/06.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit

class AnimationTestViewController: UIViewController {

    var count = 0
    
    @IBOutlet weak var GoodLabel: UILabel!
    @IBOutlet weak var Misslabel: UILabel!
    @IBAction func animationButton(_ sender: Any) {
        
        if count % 4 ==  0 {
            Misslabel.center = self.view.center
            Misslabel.alpha = 1.0
            UIView.animate(withDuration: 0.4, delay: 0.0, animations: {
                self.Misslabel.center.y -= 100.0
                self.Misslabel.alpha = 0.0
            }, completion: nil)
        }else {
            GoodLabel.center = self.view.center
            GoodLabel.alpha = 1.0
            UIView.animate(withDuration: 0.4, delay: 0.0, animations: {
                self.GoodLabel.center.y -= 100.0
                self.GoodLabel.alpha = 0.0
            }, completion: nil)
        }
        count += 1
    }
    
    @IBAction func goodAnimation(_ sender: Any) {
        Misslabel.center = self.view.center
        Misslabel.alpha = 1.0
        
        count += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Misslabel.alpha = 0.0
        GoodLabel.alpha = 0.0
    }
    

 

}
