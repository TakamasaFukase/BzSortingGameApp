//
//  TopPageViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/08/31.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import AVFoundation


class TopPageViewController: UIViewController {
    
    //BGMを再生するためのインスタンスを宣言しておく
    var audioPlayer: AVAudioPlayer!
    
    let titleLogo = UIImage(named: "titleLogo")
    var titleAnimation:[UIImage] = []
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var toRankingButton: UIButton!
    @IBOutlet weak var toWorldRankingButton: UIButton!
    @IBOutlet weak var titleImage: UIImageView!
    
    
    @IBAction func startButton(_ sender: Any) {
        //パラパラアニメーションの設定
        titleImage.animationImages = titleAnimation
        //↓アニメーション全体の秒数（画像１枚あたりの秒数ではない）
        titleImage.animationDuration = 2.0
        titleImage.animationRepeatCount = 1
        titleImage.startAnimating()
        
        //遅延処理の設定　パラパラアニメーションが終わったタイミングで実行するため
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.9) {
          print("3秒たったので画面遷移しまーす")
            self.performSegue(withIdentifier: "toGamePlay", sender: nil)
        }
        
        //MP3音源を再生
        audioPlayer.play()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleImage.image = titleLogo
        startButton.layer.borderColor = UIColor.blue.cgColor
        startButton.layer.borderWidth = 2.0
        startButton.layer.cornerRadius = 30.0
        toRankingButton.layer.borderColor = UIColor.blue.cgColor
        toRankingButton.layer.borderWidth = 2.0
        toRankingButton.layer.cornerRadius = 20.0
        toRankingButton.titleLabel?.numberOfLines = 0
        toRankingButton.titleLabel?.textAlignment = NSTextAlignment.center
        toWorldRankingButton.layer.borderColor = UIColor.blue.cgColor
        toWorldRankingButton.layer.borderWidth = 2.0
        toWorldRankingButton.layer.cornerRadius = 20.0
        toWorldRankingButton.titleLabel?.numberOfLines = 0
        toWorldRankingButton.titleLabel?.textAlignment = NSTextAlignment.center
        //タイトルアニメーション用の画像をまとめて読込＆配列に格納
        while let titleAnimationImage = UIImage(named: "title\(titleAnimation.count)") {
            titleAnimation += [titleAnimationImage]
        }
        
        //MP3音源の再生準備関数(クラスの下のextensionで設定したもの)
        //再生待機状態にする
        playSound(name: "ultraSoulEditedForTitle1")
        
    }
    
}


//オーディオの設定・アニメーションと連動した音声を流すため
extension TopPageViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: "ultraSoulEditedForTitle1", ofType: "mp3") else {
                print("音源ファイルが見つかりません")
                return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch {
            
        }
    }
}
