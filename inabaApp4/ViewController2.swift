//
//  ViewController2.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/08/30.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Foundation

class ViewController2: UIViewController, UITextFieldDelegate {

    
    var rslt:[[String]] = []
    var rankingList:[[String]] = []
    let otsukare = UIImage(named: "otsukare")
    let shoutingResult = UIImage(named: "shoutingResult")
    
    @IBOutlet weak var shoutingResultImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var weakPointLabel: UILabel!
     //５項目のスコアLabelをまとめて操作をするためCollectionOutlet接続（配列）にする
    @IBOutlet var scoreLabelArray: [UILabel]!
    
    //名前登録画面へ遷移する時にトータルスコアの値を受け渡す
    @IBOutlet weak var toNameRegisterVCButton: UIButton!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNameRegisterVC" {
            let nextView = segue.destination as! NameRegisterViewController
            nextView.totalScore = rslt[0][0]
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        resultImage.image = otsukare
        shoutingResultImage.image = shoutingResult
        
        toNameRegisterVCButton.layer.borderColor = UIColor.red.cgColor
        toNameRegisterVCButton.layer.borderWidth = 2.0
        toNameRegisterVCButton.layer.cornerRadius = 20.0
        
        //総合得点を小数点の左右で大きさを変えて別のlabelに表示するため２つに分離
        let separatedTotalScore = rslt[0][0].components(separatedBy: ".")
        resultLabel.text = "\(separatedTotalScore[0])"
        resultLabel2.text = ". \(separatedTotalScore[1])点"
        
        
        //下で作成した70%以下しかとれていない採点項目の配列のうち、特に点数の低い項目２つに対応するアドバイスを表示
        weakPointLabel.text = "\n\(findWeakPoint()[0][0])\n\(findWeakPoint()[1][0])"
        
    }
    
    
    
    //５つの採点項目それぞれをラベルに表示させると同時に、50％以下の項目を判別して以下の操作を行う。
    //①70％以下の項目のうち得点の低い２項目についてのアドバイスの表示
    //②70％以下の項目の得点表示部分を赤色にする
    private func findWeakPoint() ->[[String]] {
        
        //per〜　→ 各採点項目をそれぞれ100点満点に換算して計算
        //str〜　→ [アドバイス, ◯◯％, 点数]
        let perScoreCount = (Double(rslt[0][1])! * 2.5) //→正解数に関してだけ上限がない為、ここでは40回を100%として計算
        let strPerScoreCount = ["・正解数を増やそう！", String(perScoreCount), "【正解数】\(rslt[0][1])回(点)"]
        let perRecovery = (Double(rslt[0][2])! * 6.67)
        let strPerRecovery = ["・ミスをしても冷静でいよう！", String(perRecovery), "【冷静さ】\(rslt[0][2])点/15点中"]
        let perAccuracy = (Double(rslt[0][3])! * 10)
        let strPerAccuracy = ["・ミスの割合を減らそう！", String(perAccuracy), "【正確さ】\(rslt[0][3])点/10点中"]
        let perStamina = (Double(rslt[0][4])! * 20)
        let strPerStamina = ["・後半もペースを落とさずに！", String(perStamina), "【スタミナ】\(rslt[0][4])点/5点中"]
        let perSpeed = (Double(rslt[0][5])! * 3.33)
        let strPerSpeed = ["・ミスを恐れずスピードを上げよう！", String(perSpeed), "【スピード】\(rslt[0][5])点/30点中"]
        
        //上記で作成した各配列をまとめて格納
        let checkWeaknessArr = [strPerScoreCount, strPerRecovery, strPerAccuracy, strPerStamina, strPerSpeed]
        var weakPointArr:[[String]] = []
        //１つずつ採点項目を取り出して以下の操作を順番に行う
        for (index,checkWeakOrNot) in checkWeaknessArr.enumerated() {
            //まず各項目の点数をそれぞれ対応するラベルに表示(５つのラベルをOutletCollection（配列）にしてる為）
            scoreLabelArray[index].text = checkWeaknessArr[index][2]
            //70%以下の項目は文字色を赤にする　＋　weakPointArrに格納
            if Double(checkWeakOrNot[1])! < 70.0 {
                scoreLabelArray[index].textColor = UIColor.red
                weakPointArr += [checkWeakOrNot]
            }
        }
        
        if weakPointArr.isEmpty {
            weakPointArr += [[" バランスよく点が取れています♪", ""], [" この調子で頑張りましょう！", ""]]
        }else if weakPointArr.count == 1 {
            weakPointArr.insert(["    決して悪くないですよ♪", ""],at:1)
        }else {
            //各要素の中の要素１を一度Double型に変換してから数字の小さい順にソート
            weakPointArr.sort{Double($0[1])! < Double($1[1])!}
        }
        
        return weakPointArr
    }
    
    
}
