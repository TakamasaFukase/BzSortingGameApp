//
//  RankingWorldViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/03.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Firebase

class RankingWorldViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var defaultstore:Firestore!
    
    let ranking1 = UIImage(named: "ranking1")
    let ranking2 = UIImage(named: "ranking2")
    let ranking3 = UIImage(named: "ranking3")
    let ranking4 = UIImage(named: "ranking4")
    
    var dicToArrRankingData:[[String]] = []
    var rankingPictures:[UIImage] = []
    
    @IBOutlet weak var worldRankingTableView: UITableView!
    @IBOutlet weak var exitWorldRankingButton: UIButton!
    
    
    @IBAction func exitWorldRankingButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        worldRankingTableView.dataSource = self
        worldRankingTableView.delegate = self
        
        //FireStoreに保存されているデータを受け取る
        defaultstore = Firestore.firestore()
        defaultstore.collection("worldRankingData").addSnapshotListener {(snapShot, error) in
            guard let value = snapShot else {
                print("snapShot is nil")
                return
            }
            
            value.documentChanges.forEach {diff in
                if diff.type == .added {
                    guard let dictionary = diff.document.data() as? [String: String] else {
                        print("空or代入できませんでした")
                        print(diff.document.data())
                        return
                    }
                    let indexArr0 = Array(dictionary.keys)
                    let index0 = indexArr0[0]
                    let indexArr1 = Array(dictionary.values)
                    let index1 = indexArr1[0]
                    self.dicToArrRankingData += [[index0, index1]]
                    
                    print("出力\(self.dicToArrRankingData)")
                }
            }
        }
        
        rankingPictures += [ranking1!, ranking2!, ranking3!, ranking4!]
        
        exitWorldRankingButton.layer.borderColor = UIColor.red.cgColor
        exitWorldRankingButton.layer.borderWidth = 2.0
        exitWorldRankingButton.layer.cornerRadius = 25.0
        
        
    }// viewDidLoad (end)
    
    
    //TableViewの設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dicToArrRankingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        
        let sortedWorldRankingData = dicToArrRankingData.sorted(by: {Double($0[1])! > Double($1[1])!})
        
        let oneOfWorldRankingData = sortedWorldRankingData[indexPath.row]
        cell.textLabel?.text = oneOfWorldRankingData[0]
        cell.detailTextLabel?.text = "\(oneOfWorldRankingData[1])点"
        if indexPath.row == 0 {
            cell.imageView?.image = rankingPictures[0]
        }else if indexPath.row == 1 {
            cell.imageView?.image = rankingPictures[1]
        }else if indexPath.row == 2 {
            cell.imageView?.image = rankingPictures[2]
        }else {
            cell.imageView?.image = rankingPictures[3]
        }
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    

}
