//
//  chooseRankingTypeViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/05.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit

class chooseRankingTypeViewController: UIViewController {

    @IBOutlet weak var toWorldRankingButton: UIButton!
    @IBOutlet weak var toLocalRankingButton: UIButton!
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toWorldRankingButton.layer.borderColor = UIColor.blue.cgColor
        toWorldRankingButton.layer.borderWidth = 2.0
        toWorldRankingButton.layer.cornerRadius = 30.0
        toLocalRankingButton.layer.borderColor = UIColor.blue.cgColor
        toLocalRankingButton.layer.borderWidth = 2.0
        toLocalRankingButton.layer.cornerRadius = 30.0
        
        //背景をぼかし処理
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        self.view.insertSubview(visualEffectView, at: 0)
    }
    

   
}
