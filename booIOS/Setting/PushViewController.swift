//
//  PushViewController.swift
//  booIOS
//
//  Created by candy on 2017. 7. 25..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PushViewController: UIViewController {
    
    @IBOutlet var pushSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    
    let con = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPushPermit()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushSwitchAction(_ sender: AnyObject) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/change_push_permit?user_id=\(self.userDefaults.integer(forKey: "id"))"
        let queue = DispatchQueue(label: "xyz.dongaboomin.pushPermit", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    if json["result_body"] == 0{
                                        self.userDefaults.set(0, forKey: "pushEnable")
                                    }else{
                                        self.userDefaults.set(1, forKey: "pushEnable")
                                    }
                                }else{
                                    self.con.toastText("변경 실패")
                                }
                            case .failure(let error):
                                self.con.toastText("변경 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
        
    }
    
    func getPushPermit(){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let todoEndpoint: String = "http://www.dongaboomin.xyz:3000/getPushPermit?stuId=\(self.userDefaults.integer(forKey: "id"))"
        let queue = DispatchQueue(label: "xyz.dongaboomin.getPushPermit", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 200{
                                    if json["push_permit"]==1{
                                        self.pushSwitch.setOn(false, animated: true)
                                        self.pushSwitch.backgroundColor = UIColor.white
                                    }else{
                                        self.pushSwitch.setOn(true, animated: true)
                                    }
                                }else{
                                    self.con.toastText("변경 실패")
                                }
                            case .failure(let error):
                                self.con.toastText("변경 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
    }
    
    
}
