//
//  KolodaViewTestViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/06.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Koloda

class KolodaViewTestViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {

    var images:[UIImage] = []
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var missLabel: UILabel!
    
    
    @IBAction func leftSwipeButton(_ sender: Any) {
        kolodaView.swipe(.left)
    }
    @IBAction func rightSwipeButton(_ sender: Any) {
        kolodaView.swipe(.right)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        while let imageInaba = UIImage(named: "ina\(images.count + 1)") {
            images += [imageInaba]
        }
        while let imageTak = UIImage(named: "tak\(images.count - 9)") {
            images += [imageTak]
        }

        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        //縁取りして目立つ文字列を作成する
        let goodText = "Good!"
        let attributes1: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 80.0),
            .foregroundColor : UIColor.systemPink,
            .strokeColor : UIColor.white,
            .strokeWidth : -1.0
        ]
        goodLabel.attributedText = NSAttributedString(string: goodText, attributes: attributes1)
        
        let missText = "Miss!"
        let attributes2: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 80.0),
            .foregroundColor : UIColor.systemBlue,
            .strokeColor : UIColor.white,
            .strokeWidth : -1.0
        ]
        missLabel.attributedText = NSAttributedString(string: missText, attributes: attributes2)
        
        
        //アニメーションするまで透明にしておく
        goodLabel.alpha = 0.0
        missLabel.alpha = 0.0
        
    }
    
    //枚数
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return images.count
    }
    //ドラッグのスピード
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    //表示内容
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let imageView = UIImageView(frame: koloda.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = images[index]
        koloda.addSubview(imageView)
        view.bringSubviewToFront(goodLabel)
        view.bringSubviewToFront(missLabel)
        return imageView
    }
    
    
    //ドラッグをやめたら呼ばれる
    func kolodaDidResetCard(_ koloda: KolodaView) {
        print("resetされました")
    }
    
    //ドラッグ中に呼ばれる
    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        print("dragなう")
        return true
    }
    
    //スワイプ完了時の処理
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .right:
            print("稲葉方向にスワイプ")
            goodLabel.center = self.view.center
            goodLabel.alpha = 1.0
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.goodLabel.center.y -= 120.0
                self.goodLabel.alpha = 0.0
            }, completion: nil)

            
        case .left:
            print("松本方向にスワイプ")
            missLabel.center = self.view.center
            missLabel.alpha = 1.0
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.missLabel.center.y -= 120.0
                self.missLabel.alpha = 0.0
            }, completion: nil)
        default:
            print("左右以外にスワイプ")
        }
    }
    
    //スワイプできる方向を指定（左右のみ）
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right]
    }
    //スワイプ判定の距離を指定（片手で親指で動かしても反応するちょうどいい距離に設定）
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return 0.2
    }
    
    
    

    

}
