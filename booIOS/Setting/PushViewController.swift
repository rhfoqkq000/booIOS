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
    
    var normalResult_body:JSON = [:]
    var circleResult_body:JSON = [:]
    
    let userDefaults = UserDefaults.standard
    
    let con = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        TestSingleton._sharedInstance.testString = "FUCKFUCK"
        //        print(TestSingleton._sharedInstance.testString!)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func pushTestAction(_ sender: AnyObject) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/getNormalNotis?user_id=\(self.userDefaults.string(forKey: "id")!)"
        let queue = DispatchQueue(label: "xyz.dongaboomin.normalNotis", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.normalResult_body = json["result_body"]
                                    print("목록불러오기 result_code 1")
                                }else{
                                    print("PushViewController getJSON result code not matched")
                                    self.con.toastText("불러오기 실패")
                                }
                            case .failure(let error):
                                self.con.toastText("불러오기 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
        //        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/auth/login"
        //        let parameters = ["email":"npe.dongauniv@gmail.com", "password":"Q!2dltnals"]
        //        let queue = DispatchQueue(label: "book.booIOS", qos: .utility, attributes: [.concurrent])
        //        Alamofire.request(todoEndpoint, method: .post, parameters: parameters, encoding:JSONEncoding(options:[])).validate().responseJSON(queue: queue, completionHandler : { response in
        //
        //                            switch response.result{
        //                            case .success(let value):
        //                                let json = JSON(value)
        //                                print("token ?:::::: \(json["token"].stringValue)")
        //
        //                                let todoFCMEndpoint: String = "https://www.dongaboomin.xyz:20433/circle/fcm"
        //                                let article = ["title":"TITLE", "body":"BODY", "contents":"CONTENTS"]
        //                                let fcmParam = ["article":article]
        //                                let authHeader = [ "Authorization" : "bearer "+json["token"].stringValue ]
        //                                let fcmQueue = DispatchQueue(label: "book.booIOS", qos: .utility, attributes: [.concurrent])
        //                                Alamofire.request(todoFCMEndpoint, method: .post, parameters: fcmParam, encoding:JSONEncoding(options:[]), headers : authHeader).validate().responseJSON(queue: fcmQueue, completionHandler : { response in
        //
        //                                    switch response.result{
        //                                    case .success(let value):
        //                                        let json = JSON(value)
        //                                        print(json["result_code"])
        //                                    case .failure(let error):
        //                                        print(error)
        //                                    }
        //
        //                                    DispatchQueue.main.async {
        //                                    }
        //                                }
        //                                )
        //
        //                            case .failure(let error):
        //                                print(error)
        //                            }
        //
        //                            DispatchQueue.main.async {
        //                            }
        //            }
        //        )
    }
    
    
    
    @IBAction func readButtonAction(_ sender: AnyObject) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let parameters: Parameters = ["notis_id": "48"]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/normal_read"
        let queue = DispatchQueue(label: "xyz.dongaboomin.normalRead", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    print("result_code matched ^^")
                                }else{
                                    print("normal_read result code not matched")
                                    self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                                }
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
    }
    
    
    @IBAction func circleListAction(_ sender: AnyObject) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/getCircleNotis?user_id=\(self.userDefaults.string(forKey: "id")!)"
        let queue = DispatchQueue(label: "xyz.dongaboomin.circleNotis", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.circleResult_body = json["result_body"]
                                    print("동아리쪽지목록불러오기^^")
                                }else{
                                    print("PushViewController getJSON result code not matched")
                                    self.con.toastText("불러오기 실패")
                                }
                            case .failure(let error):
                                self.con.toastText("불러오기 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
    }
    
    
    
    @IBAction func circleReadAction(_ sender: AnyObject) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let parameters: Parameters = ["circle_notis_id": "212"]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/circle_read"
        let queue = DispatchQueue(label: "xyz.dongaboomin.circleRead", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    print("동아리 쪽지 읽었당")
                                }else{
                                    print("normal_read result code not matched")
                                    self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                                }
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
    }
    
    
    
    @IBAction func normalDeleteAction(_ sender: AnyObject) {
        
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let targets = ["33", "36"]
        let parameters:[String:Any] = ["targets":targets]
        //        let params:[[String:Any]] = [["targets":targets]]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/removeNormalNotis"
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "application/json"
        //        ]
        let queue = DispatchQueue(label: "xyz.dongaboomin.removeNormalNotis", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    print("일반쪽지지웠당")
                                }else{
                                    print("normal_read result code not matched")
                                    self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                                }
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
    }
    
    
    
    @IBAction func circleDeleteAction(_ sender: AnyObject) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let targets = ["9", "12"]
        let parameters:[String:Any] = ["targets":targets]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/removeCircleNotis"
        let queue = DispatchQueue(label: "xyz.dongaboomin.removeCircleNotis", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    print("동아리쪽지지웠당")
                                }else{
                                    print("normal_read result code not matched")
                                    self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                                }
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패 - 로그아웃 후 재시도해주세요!")
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
    }
    
}
