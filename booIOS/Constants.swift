//
//  Constants.swift
//  booIOS
//
//  Created by candy on 2017. 7. 26..
//  Copyright © 2017년 univ. All rights reserved.
//

import Foundation
import RNCryptor
import Toaster

class Constants {
    static let encryptionPassword = "BooIOSEncryptionPassword"
    let userDefaults = UserDefaults.standard
    
    func decryptText(_ data:Data) -> String{
        do{
            let decryptedText = try RNCryptor.decrypt(data: self.userDefaults.data(forKey: "encryptedText")!, withPassword: Constants.encryptionPassword)
            let encrypts = String(data: decryptedText, encoding: String.Encoding.utf8)
            print("복호화된 encryptedText : \(encrypts!)")
            return encrypts!
        }catch{
            print("복호화 에러")
            self.toastText("로그인 실패")
            return "NO"
        }
    }
    
    func toastText(_ text:String){
        let toast = Toast(text: text, duration:Delay.short)
        toast.show()
    }
}
