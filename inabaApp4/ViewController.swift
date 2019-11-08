//
//  ViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/08/04.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Koloda

class ViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    //画像の読み込み
    let ina1 = UIImage(named: "ina1")
    let ina2 = UIImage(named: "ina2")
    let ina3 = UIImage(named: "ina3")
    let ina4 = UIImage(named: "ina4")
    let ina5 = UIImage(named: "ina5")
    let ina6 = UIImage(named: "ina6")
    let ina7 = UIImage(named: "ina7")
    let ina8 = UIImage(named: "ina8")
    let ina9 = UIImage(named: "ina9")
    let ina10 = UIImage(named: "ina10")
    let tak1 = UIImage(named: "tak1")
    let tak2 = UIImage(named: "tak2")
    let tak3 = UIImage(named: "tak3")
    let tak4 = UIImage(named: "tak4")
    let tak5 = UIImage(named: "tak5")
    let tak6 = UIImage(named: "tak6")
    let tak7 = UIImage(named: "tak7")
    let tak8 = UIImage(named: "tak8")
    let howToReady = UIImage(named: "howToReady")
    let howTo1 = UIImage(named: "howTo1")
    let howTo2 = UIImage(named: "howTo2")
    
    
    
    var inaOrTakPictures: [(UIImage, Bool)] = []
    var yesIsInaba:[Bool] = []
    //各採点項目をDouble型で計算するために最初から少数型にしておく
    var scoreCount = 0.0
    var missCount = 0.0
    var previousPictureIndex = 0
    //制限時間カウント初期値
    var timeCount:Double = 20.00
    //0.463秒ごとを取得する関数で使う（音楽のリズムと合わせるための秒数）
    var timeDistanceChecker:Double = 20.00
    
    
    
    //BGMを再生するためのインスタンスを生成
    var audioPlayer: AVAudioPlayer!
    
    //左右フリック時のアニメーションを実装するためのKolodaView
    @IBOutlet weak var kolodaView: KolodaView!
    
    //正誤表示用のラベル　アニメーションさせる
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var missLabel: UILabel!
    
    //遊び方を伝える画像を画面下部に表示する　（２枚の画像を交互に）
    @IBOutlet weak var howToPlayImageView: UIImageView!
    
    //タイトルへ戻る（ゲーム中止ボタン）
    @IBOutlet weak var quitGameButton: UIButton!
    @IBAction func quitGameButton(_ sender: Any) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    //カウントが始まるまでの間、Ready?と表示するラベル
    @IBOutlet weak var ReadySetGoLabel: UILabel!

    //ここに正解数を表示
    @IBOutlet weak var scoreLabel: UILabel!
    //タイムカウント（残り時間）を表示するラベル (等幅フォントにする設定も一番下のextentionで設定）
    @IBOutlet weak var timeCountLabel: UILabel! {
        didSet {
            timeCountLabel.font = timeCountLabel.font.monospacedDigitFont
        }
    }
    

    
    
//------------------------- viewDidLoad ----------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //問題一覧の配列に画像と人物判別Bool値をセット
        setInaOrTakPictures()
        //問題の入った配列を最初に一度シャッフル
        inaOrTakPictures.shuffle()
        //カウントが動き出すまで見えない様にしておく
        kolodaView.isHidden = true
        //タイムカウントをラベルに表示
        timeCountLabel.text = String(format: "%.2f", timeCount)
        //スコアカウントをラベルに表示
        scoreLabel.text = "\(String(format: "%.0f", scoreCount))"
        //画面下部のスワイプ方向を示す画像を表示
        howToPlayImageView.image = howToReady
        
        //【遅延処理】1.00秒後にLabelの表示を　Ready? から Go! に変更する
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.00) {
            self.ReadySetGoLabel.text = "Go!"
            self.ReadySetGoLabel.font = self.ReadySetGoLabel.font.withSize(110)
        }
        
        //【遅延処理】1.75秒後に、↓の①、②、③、④を実行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.75) {
            //①タイマーを実行する
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.timerUpdate(timer:)), userInfo: nil, repeats: true)
            //②Go!と表示されているラベルを隠す
            if !self.ReadySetGoLabel.isHidden {
                self.ReadySetGoLabel.isHidden = true
            }
            //③kolodaViewの.isHiddenを解除して可視化＆左右にスワイプできるようにする
            if self.kolodaView.isHidden {
                self.kolodaView.isHidden = false
            }
            //④howToPlayImageの画像をhowTo1に切り替える
            self.howToPlayImageView.image = self.howTo1
        }
        
        //mp3音源の再生(クラスの下のextensionで設定したものを実行)
        playSound(name: "ultraSoulEditedForGame1")
        
        //スコア、タイマーラベルの見た目を設定
        scoreLabel.layer.borderColor = UIColor.gray.cgColor
        scoreLabel.layer.borderWidth = 3.0
        timeCountLabel.layer.borderColor = UIColor.gray.cgColor
        timeCountLabel.layer.borderWidth = 3.0
        
        //画像スワイプアニメーション Kolodaの設定
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        //文字列をアニメーションするまで透明にしておく
        goodLabel.alpha = 0.0
        missLabel.alpha = 0.0
        
        //画像スワイプ時の正誤判定の文字　　見やすい様に文字列を縁取りする
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
        
    }
//------------- viewDidLoad 最後尾 -------------------------------
    
    
    
    
    
    //---------------タイマーの設定--------------
    var timer:Timer!
    
    //タイマーで指定間隔ごとに呼ばれる関数
    @objc func timerUpdate(timer: Timer) {
        let lowwerTime = 0.00
        timeCount = max(timeCount - 0.01, lowwerTime)
        let strTimeCount = String(format: "%.2f", timeCount)
        let twoDigitTimeCount = timeCount > 10 ? "\(strTimeCount)" : "0\(strTimeCount)"
        timeCountLabel.text = twoDigitTimeCount
        getHalfWayScoreCount()
        changeHowToImage()
        
        //タイマーが0になったらタイマーを破棄して結果画面へ遷移
        if timeCount <= 0 {
            timer.invalidate()
            if swipeSpeedArr.isEmpty {
                noAnswerAlert()
            }else {
                //ソウルッ！の後の爆発のタイミングに合わせるための遅延処理
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.28) {
                    self.performSegue(withIdentifier: "toResult", sender: nil)
                }
            }
        }
    }
    //----------------------------------------
    
    
    
    //問題一覧の配列に画像と人物判別Bool値をセット
    private func setInaOrTakPictures() {
        inaOrTakPictures = [
            (ina1, true),
            (ina2, true),
            (ina3, true),
            (ina4, true),
            (ina5, true),
            (ina6, true),
            (ina7, true),
            (ina8, true),
            (ina9, true),
            (ina10, true),
            (tak1, false),
            (tak2, false),
            (tak3, false),
            (tak4, false),
            (tak5, false),
            (tak6, false),
            (tak7, false),
            (tak8, false)
            ] as! [(UIImage, Bool)]
    }
    
    
    //問題の入った配列を再シャッフルして配列の後ろに追加（kolodaViewのindexがどんどん増えていくため）
    private func shuffleAndAppendQuestion() {
        let shuffledQuestion = inaOrTakPictures.shuffled()
        inaOrTakPictures += shuffledQuestion
    }
    
    
    //無回答でタイマーが０になった時にアラートを表示する
    private func noAnswerAlert() {
        let noAnswerAlertTitle = "回答数が０です！"
        let noAnswerAlertMessage = "結果を表示するには\n１回以上回答してください"
        
        let alert = UIAlertController(title: noAnswerAlertTitle, message: noAnswerAlertMessage, preferredStyle: UIAlertController.Style.alert)
        
        //再挑戦するを押した場合、ゲーム内容をリセットしてもう一度ゲームが始まる
        let defaultAction = UIAlertAction(title: "再挑戦する", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) -> Void in
            if !self.audioPlayer.isPlaying {
                self.audioPlayer.play()
            }
            self.timer.invalidate()
            self.resetAll()
        })
        //タイトルへ戻るを押した場合、タイトルへ戻る
        let cancelAction = UIAlertAction(title: "タイトルへ戻る", style: UIAlertAction.Style.cancel, handler:{(action: UIAlertAction!) -> Void in
            self.timer.invalidate()
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //ゲームをリセット(タイマーも再設定)
    private func resetAll() {
        kolodaView.isHidden = true
        ReadySetGoLabel.isHidden = false
        ReadySetGoLabel.text = "Ready?"
        ReadySetGoLabel.font = self.ReadySetGoLabel.font.withSize(55)
        howToPlayImageView.image = howToReady
        scoreCount = 0
        missCount = 0
        timeCount = 20.00
        timeDistanceChecker = 20.00
        timeCountLabel.text = String(format: "%.2f", timeCount)
        recoveryCheckCount = 0.0
        recoveryCheckArr.removeAll()
        halfWayScoreCount.removeAll()
        swipeSpeedArr.removeAll()
        setInaOrTakPictures()
        inaOrTakPictures.shuffle()
        
        //【遅延処理】1.00秒後にLabelの表示を　Ready? から Go! に変更する
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.00) {
            self.ReadySetGoLabel.text = "Go!"
            self.ReadySetGoLabel.font = self.ReadySetGoLabel.font.withSize(110)
        }
        
        
        //【遅延処理】1.75秒後に、↓の①、②、③、④を実行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.75) {
            //①タイマーを実行する
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.timerUpdate(timer:)), userInfo: nil, repeats: true)
            
            //②Go!と表示されているラベルを隠す
            if !self.ReadySetGoLabel.isHidden {
                self.ReadySetGoLabel.isHidden = true
            }
            
            //③ImageView1の.isHiddenを解除して可視化＆左右にフリックできるようにする
            if self.kolodaView.isHidden {
                self.kolodaView.isHidden = false
            }
            
            //④howToPlayImageの画像をhowTo1に切り替える
            self.howToPlayImageView.image = self.howTo1
        }
    }
    
    //--------------【KolodaView】----------------
    //画像スワイプ時のアニメーションの設定
    
    //出題画像枚数に終わりはないので、適当に超えないであろう数値を入れておく
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 300
    }
    
    //表示する内容を設定
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let imageView = UIImageView(frame: koloda.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = inaOrTakPictures[index].0
        yesIsInaba += [inaOrTakPictures[index].1]
        koloda.addSubview(imageView)
        view.bringSubviewToFront(goodLabel)
        view.bringSubviewToFront(missLabel)
        return imageView
    }
    
    //スワイプできる方向を指定（左右のみ）
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right]
    }
    //スワイプ判定の距離を指定（片手で親指で動かしても反応するちょうどいい距離に設定）
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return 0.2
    }
    
    
    //スワイプ完了時の処理
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        swipeSpeedChecker()
        beforeSwipeTime = timeCount
        scoreLabel.text = "\(String(format: "%.0f", scoreCount))"
        //swipeSpeedArrはスピード項目の計算に使う配列だが、.countを総スワイプ回数として代用する
        //kolodaViewが参照する画像配列の要素が範囲外にならない様に、シャッフルし直して配列の後ろに足す。
        if swipeSpeedArr.count % 14 == 0 {
            shuffleAndAppendQuestion()
        }
            switch direction {
            //画像を右にスワイプの場合
            case .right:
                if yesIsInaba[swipeSpeedArr.count - 1] == true {
                    scoreCount += 1
                    recoveryNow()
                    goodLabelAppear()
                }else {
                    missCount += 1
                    foundMissAndExpectRecovery()
                    missLabelAppear()
                }
            //画像を左にスワイプの場合
            case .left:
                if yesIsInaba[swipeSpeedArr.count - 1] == false {
                    scoreCount += 1
                    recoveryNow()
                    goodLabelAppear()
                }else {
                    missCount += 1
                    foundMissAndExpectRecovery()
                    missLabelAppear()
                }
            default:
                break
            }
        }
    //---------------- KolodaView 最後尾 -----------------------------------
    
    
    
    //正解した時に表示するGood!のアニメーション設定
    func goodLabelAppear() {
        goodLabel.center = self.view.center
        goodLabel.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.goodLabel.center.y -= 120.0
            self.goodLabel.alpha = 0.0
        }, completion: nil)
    }
    
    //ミスした時に表示するMiss!のアニメーション設定
    func missLabelAppear() {
        missLabel.center = self.view.center
        missLabel.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.missLabel.center.y -= 120.0
            self.missLabel.alpha = 0.0
        }, completion: nil)
    }
    
    //0.463秒ごとに画面下部の画像２枚を繰り返し交互に表示する設定（曲のリズムに合わせるための秒数）
    func changeHowToImage() {
        if (timeDistanceChecker - timeCount) >= 0.463 {
            timeDistanceChecker = timeCount
            if howToPlayImageView.image == howTo1 {
                howToPlayImageView.image = howTo2
            }else if howToPlayImageView.image == howTo2 {
                howToPlayImageView.image = howTo1
            }
        }
    }
    
    
    
    //-----------各採点項目のうち、前準備が必要なものをここで設定----------------
        //【②リカバリー項目】ミスした後4回以内にミスをしているかどうかチェックする
        var recoveryCheckArr:[Double] = []
        //ミス直後から次のミスまでの間隔を見る変数。ミス直後に０になり、その後正解するごとに＋１していく。最大値は４。
        //ゲーム終了時にはこの変数の平均値を出し、それが４に近いほどこの項目の得点は高くなる。（ノーミスならこの項目は無条件で満点）
        var recoveryCheckCount = 0.0
        private func recoveryNow() {
            let upperRecoveryCheckCount = 4.0
            recoveryCheckCount = min(recoveryCheckCount + 1.0, upperRecoveryCheckCount)
        }
        private func foundMissAndExpectRecovery() {
            if !recoveryCheckArr.isEmpty {
                recoveryCheckArr[recoveryCheckArr.count - 1] = recoveryCheckCount
            }
            recoveryCheckArr += [4.0]
            recoveryCheckCount = 0.0
        }
        
        //【④スタミナ項目】制限時間が半分を切った時点での正解数を記録する
        var halfWayScoreCount:[Double] = []
        private func getHalfWayScoreCount() {
            if timeCount < 10 && halfWayScoreCount.isEmpty {
                halfWayScoreCount += [scoreCount]
            }
        }
        
        //【⑤スピード項目】画像表示からスワイプまでの秒数を計測して配列に格納する（正解した場合だけ計測する）
        var beforeSwipeTime = 20.00
        var swipeSpeedArr:[Double] = []
        private func swipeSpeedChecker() {
            let swipeSpeed = (beforeSwipeTime - timeCount)
            swipeSpeedArr += [swipeSpeed]
        }
    //------------------------------------------------



    

    //----------ゲーム終了時に各採点項目を計算する--------------
    private func finalScoringAndGetResult() -> [[String]] {

        //①正答数=そのまま得点 （この項目のみ上限は無し。仮に全ての項目の合計が100点を超える場合も後で100点に修正される）
        let scoreOfCorrectAmount = scoreCount
        let strScoreOfCorrectAmount = String(format: "%.0f", scoreCount)
        
        //②リカバリー項目の計算
        if recoveryCheckArr.isEmpty {
            recoveryCheckArr += [4.0]
        }
        let sumRecoveryCheckArr = recoveryCheckArr.reduce(0){(num1, num2) -> Double in
            num1 + num2
        }
        let averageRecovery = (sumRecoveryCheckArr / Double(recoveryCheckArr.count))
        let scoreOfAverageRecovery = (averageRecovery * 3.75)
        let strScoreOfAverageRecovery = String(format: "%.1f", scoreOfAverageRecovery)
        let resultOfAverageRecovery = String(format: "%.1f", averageRecovery)
        
        //③正確性項目の計算
        let scoreOfAccuracy = ((scoreCount / (scoreCount + missCount)) * 10)
        let resultOfAccuracy = String(format: "%.1f", scoreOfAccuracy)
        
        //④スタミナ項目の計算  初期得点は５点で、後半10秒の正解数が前半よりも１つ少ないごとに−１点。５個以上少ない場合は０点になる
        let lowwerLimitStamina = 0.0
        let differenceOfHalfWayScoreCount = max(halfWayScoreCount[0] - (scoreCount - halfWayScoreCount[0]), lowwerLimitStamina)
        var scoreOfStamina = max(5 - differenceOfHalfWayScoreCount, lowwerLimitStamina)
        
        var strScoreOfStamina = String(format: "%.1f", scoreOfStamina)
        
        if halfWayScoreCount[0] == 0 {
            scoreOfStamina = 0.0
            strScoreOfStamina = "0"
        }
        
        //⑤スピード項目の計算（平均秒数の他にも最速、最遅も出しておく）
        let sumSwipeSpeed = swipeSpeedArr.reduce(0){(num1, num2) -> Double in
            num1 + num2
        }
        let upperLimitSpeed = 1.0
        let swipeSpeedAverage = (sumSwipeSpeed / Double(swipeSpeedArr.count))
                                //↓平均0.35秒以下だと満点
        let scoreOfAverageSpeed = min((0.35 / swipeSpeedAverage), upperLimitSpeed) * 30
        let strScoreOfAverageSpeed = String(format: "%.1f", scoreOfAverageSpeed)
        let resultOfAverageSpeed = String(format: "%.2f", swipeSpeedAverage)
        let minSwipeTime = String(format: "%.2f", swipeSpeedArr.min()!)
        let maxSwipeTime = String(format: "%.2f", swipeSpeedArr.max()!)
        
        
        //表示する各数値を整数表示のString型に変換しておく
        let strScoreCount = String(format: "%.0f", scoreCount)
        let strMissCount = String(format: "%.0f", missCount)
        let strFirstHalfScoreCount = String(format: "%.0f", halfWayScoreCount[0])
        let strSecondHalfScoreCount = String(format: "%.0f", (scoreCount - halfWayScoreCount[0]))
        
        ////トータルスコア　（５つの項目の得点を合算）（①正解数が上限無しのためTotalで100点を超えないよう上限を設定）
        let upperLimitTotalScore = 100.0
        let totalScore = min((scoreOfCorrectAmount + scoreOfAverageRecovery + scoreOfAccuracy + scoreOfStamina + scoreOfAverageSpeed), upperLimitTotalScore)
        let strTotalScore = String(format: "%.3f", totalScore)
        
        //合算したトータルスコアと各評価項目の点数
        let finalScoreArr:[String] = [strTotalScore, strScoreOfCorrectAmount, strScoreOfAverageRecovery, resultOfAccuracy, strScoreOfStamina, strScoreOfAverageSpeed]
        
        //各評価項目の結果など（点数換算する前の記録） [正答数、リカバリー、ミス数、前半正答数、後半正答数、平均秒数、最速秒数、最遅秒数】
        let finalResultArr:[String] = [strScoreCount, strMissCount, resultOfAverageRecovery, strFirstHalfScoreCount, strSecondHalfScoreCount, resultOfAverageSpeed, minSwipeTime, maxSwipeTime]
        
        let scoreAndResult = [finalScoreArr, finalResultArr]
        
        
        return scoreAndResult
    }
    //---------------ここまで採点-----------------
    
    
    
    
    //-----得点と結果が入ったfinalScoringAndGetResult()をViewController2に渡す------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            let nextView = segue.destination as! ViewController2
            
            nextView.rslt = finalScoringAndGetResult()
        }
    }//----------------------------------
    
}



//オーディオの設定・BGMを流すため
extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: "ultraSoulEditedForGame1", ofType: "mp3") else {
                print("音源ファイルが見つかりません")
                return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch {
            
        }
    }
}
    
    

//タイムカウント（0.01秒刻みで動く）を等幅フォントにして左右のブレをなくす設定
extension UIFont {
    var monospacedDigitFont: UIFont {
        let oldFontDescriptor = fontDescriptor
        let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType, UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        let fontDescriptor = self.addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }
}
