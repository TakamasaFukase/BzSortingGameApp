//
//  NameRegisterViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/05.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Firebase

class NameRegisterViewController: UIViewController, UITextFieldDelegate {
    //端末内だけのランキングデータをUserDefaultsに保存
    //オンラインランキングデータをFireStore経由で保存
    
    //前画面から引くつぐゲーム結果のデータ
    var totalScore:String = ""
    var userDefaultsRankingData:[[String]] = []
    var defaultstore: Firestore!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yesRegisterButton: UIButton!
    
    //名前が空欄だと登録ボタンを押せなくする　色もグレーにする
    @IBAction func changeRegisterButtonOnOff(_ sender: Any) {
        if !(nameTextField.text == "") {
            yesRegisterButton.isEnabled = true
            yesRegisterButton.setTitleColor(UIColor.systemPink, for: .normal)
        }else {
            yesRegisterButton.isEnabled = false
            yesRegisterButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    
    
    //世界ランキングへの登録（FireStoreへの保存）の有無を切り替えるスイッチ
    @IBOutlet weak var worldRankingOnOffSwitch: UISwitch!
    
    
    @IBAction func noRegisterButton(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //登録するを押した時の処理
    //UserDefaultsによってローカルランキングの保存と
    //FireStoreによって全国ランキングへの保存を行う
    @IBAction func yesRegisterButton(_ sender: Any) {
        //入力されたテキストを変数に入れる＆nilの場合はそこで止める
        guard let rankingName = nameTextField.text else {
            return
        }
        //テキストが空欄の場合はそこで止める
        if nameTextField.text == "" {
            return
        }
        
        let nameAndScoreArr = [rankingName, totalScore]
        let nameAndScoreDictionary:[String: String] = [rankingName: totalScore]
        
        //userDefaultsに保存（個人ランキング用）
        let userDefaults = UserDefaults.standard
        userDefaultsRankingData += [nameAndScoreArr]
        userDefaults.set(userDefaultsRankingData, forKey: "userDefaultsRankingData")
        userDefaults.synchronize()
        
        
        //スイッチボタンがONの時は、Firestoreに送信する（世界ランキング用）
        if worldRankingOnOffSwitch.isOn {
            defaultstore.collection("worldRankingData").addDocument(data: nameAndScoreDictionary)
        }
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalScoreLabel.text = "\(totalScore)点"
        
        yesRegisterButton.setTitleColor(UIColor.gray, for: .normal)
        
        //Firestoreへのコネクションの作成
        defaultstore = Firestore.firestore()
        
        nameTextField.delegate = self
        //UserDefaults内ランキングデータを一度取り出してloadedUdRankingDataに入れ直す
        let userDefaults = UserDefaults.standard
        let loadedUdRankingData = userDefaults.object(forKey: "userDefaultsRankingData")
        if (loadedUdRankingData as? [[String]]) != nil {
            userDefaultsRankingData = loadedUdRankingData as! [[String]]
        }
        
        //背景をぼかし処理
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        self.view.insertSubview(visualEffectView, at: 0)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
              self.view.endEditing(true)
          }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    


    

}
