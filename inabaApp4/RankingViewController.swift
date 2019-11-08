//
//  RankingViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/10/20.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Foundation

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let ranking1 = UIImage(named: "ranking1")
    let ranking2 = UIImage(named: "ranking2")
    let ranking3 = UIImage(named: "ranking3")
    let ranking4 = UIImage(named: "ranking4")
    
    var userDefaultsRankingData:[[String]] = []
    var rankingPictures:[UIImage] = []
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitRankingButton: UIButton!
    @IBOutlet weak var resetRankingButton: UIButton!
    
    @IBAction func exitRankingButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //ランキングをリセット(userDefaultsに空の配列を上書き保存）
    @IBAction func resetRankingButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaultsRankingData.removeAll()
        userDefaults.set(userDefaultsRankingData, forKey: "userDefaultsRankingData")
        userDefaults.synchronize()
        tableView.reloadData()

    }
    
    
    //TableViewの設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaultsRankingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        let sortedRankingData = userDefaultsRankingData.sorted(by: {Double($0[1])! > Double($1[1])!})
        
        let oneOfRankingData = sortedRankingData[indexPath.row]
        cell.textLabel!.text = oneOfRankingData[0]
        cell.detailTextLabel!.text = "\(oneOfRankingData[1])点"
        if indexPath.row == 0 {
            cell.imageView?.image = rankingPictures[0]
        }else if indexPath.row == 1 {
            cell.imageView?.image = rankingPictures[1]
        }else if indexPath.row == 2 {
            cell.imageView?.image = rankingPictures[2]
        }else {
            cell.imageView?.image = rankingPictures[3]
        }
        
        //空白セルのみ区切り線を非表示にする
        tableView.tableFooterView = UIView()
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //userDefaultsを使った保存データの取り出し
        let userDefaults = UserDefaults.standard
        let loadedUdRankingData = userDefaults.object(forKey: "userDefaultsRankingData")
        if (loadedUdRankingData as? [[String]]) != nil {
            userDefaultsRankingData = loadedUdRankingData as! [[String]]
        }

        
        tableView.reloadData()
        print(userDefaultsRankingData)
        
        rankingPictures += [ranking1!, ranking2!, ranking3!, ranking4!]
        
        exitRankingButton.layer.borderColor = UIColor.red.cgColor
        exitRankingButton.layer.borderWidth = 2.0
        exitRankingButton.layer.cornerRadius = 25.0
        resetRankingButton.layer.borderColor = UIColor.purple.cgColor
        resetRankingButton.layer.borderWidth = 2.0
        resetRankingButton.layer.cornerRadius = 25.0
    }
    
}
