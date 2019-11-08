//
//  FireStoreTestViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/11/03.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Firebase

class FireStoreTestViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    enum textFieldKind:Int {
               case name = 1
               case message = 2
           }
    
    var defaultstore:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        nameTextField.delegate = self
        
        defaultstore = Firestore.firestore()
        
        defaultstore.collection("chat").addSnapshotListener {(snapShot, error) in
            guard let value = snapShot else {
                print("snapShot is nil")
                return
            }
        
            value.documentChanges.forEach {diff in
                if diff.type == .added {
                    let chatDataOp = diff.document.data() as? Dictionary<String, String>
                    print(diff.document.data())
                    guard let chatData = chatDataOp else {
                        return
                    }
                    guard let message = chatData["message"] else {
                        return
                    }
                    guard let name = chatData["name"] else {
                        return
                    }
                    
                    self.textView.text = "\(self.textView.text!)\n\(name) : \(message)"
                    
                }
            }
        }
    }// viewDidLoad (end)
    

}// class (end)

extension FireStoreTestViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("returnが押されたよ！！")
        textField.resignFirstResponder()
        
        if textField.tag == textFieldKind.name.rawValue {
            return true
        }
        
        guard let name = nameTextField.text else {
            return true
        }
        
        if nameTextField.text == "" {
            return true
        }
        
        guard let message = messageTextField.text else {
            return true
        }
        
        if messageTextField.text == "" {
            return true
        }
        
        let messageData:[String: String] = ["name":name, "message":message]
        
        defaultstore.collection("chat").addDocument(data: messageData)
        
        messageTextField.text = ""
        
        return true
    }
    
}
