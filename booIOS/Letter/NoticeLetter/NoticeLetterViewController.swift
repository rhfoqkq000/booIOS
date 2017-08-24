//
//  NoticeLetterViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoticeLetterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    let userDefaults = UserDefaults.standard
    
    var result_body:JSON = [:]
    
    let con = Constants()
    
    var countOfLetters:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        
        getNormalNoticeList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getNormalNoticeList(){
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
                                    self.result_body = json["result_body"]
                                    self.countOfLetters = self.result_body.count
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
                                self.tableview.reloadData()
                            }
            }
        )
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let progressHUD = ProgressHUD(text: "로딩 중입니다...")
            self.view.addSubview(progressHUD)
            progressHUD.show()
            let targets = [self.result_body[indexPath.row]["id"].stringValue]
            let parameters:[String:Any] = ["targets":targets]
            let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/removeNormalNotis"
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
                                        self.con.toastText("삭제 실패")
                                    }
                                case .failure(let error):
                                    print(error)
                                    self.con.toastText("삭제 실패")
                                }
                                
                                DispatchQueue.main.async {
                                    progressHUD.hide()
                                    self.getNormalNoticeList()
                                    //                                    self.tableview.reloadData()
                                    //                                    self.result_body.remove(at: indexPath.row)
                                    //                                    self.result_body.
                                    //                                    self.tableview.deleteRows(at: [indexPath], with: .fade)
                                }
                }
            )
        }
    }
    
    //    테이블 행수 얻기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfLetters
    }
    
    //    셀 내용 변경하기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeLetter")! as! NoticeLetterCell
        cell.noticeLetterMainView.layer.cornerRadius = 8
        cell.noticeLetterSubView.viewroundCorners(corners: [.topLeft,.bottomLeft], radius: 8)
        
        cell.noticeLetterDate.text = result_body[indexPath.row]["getTime"].stringValue
        cell.noticeLetterName.text = result_body[indexPath.row]["title"].stringValue
        cell.noticeLetterTitle.text = result_body[indexPath.row]["body"].stringValue
//        if result_body[indexPath.row]["read_check"].stringValue == "1"{
//            cell.noticeLetterSubView.backgroundColor = UIColor.blue
//        }else{
//            cell.noticeLetterSubView.backgroundColor = UIColor.red
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
//        if result_body[indexPath.row]["read_check"] == 0{
//            userDefaults.set(userDefaults.integer(forKey: "notReadPush")-1, forKey: "notReadPush")
//            UIApplication.shared.applicationIconBadgeNumber = userDefaults.integer(forKey: "notReadPush")
//            print("앱 뱃지 \(userDefaults.integer(forKey: "notReadPush"))로 줄어듬 ^0^")
//        }
        
        print("공지아이디는 \(self.result_body[indexPath.row]["id"])")
        let parameters: Parameters = ["notis_id": self.result_body[indexPath.row]["id"]]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/normal_read"
        let queue = DispatchQueue(label: "xyz.dongaboomin.normalRead", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    print("읽기 성공")
                                }else{
                                    print("normal_read result code not matched")
                                    self.con.toastText("통신 오류")
                                }
                            case .failure(let error):
                                print(error)
                                self.con.toastText("통신 오류")
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
//                                let cell = self.tableview.cellForRow(at: indexPath) as! NoticeLetterCell
//                                cell.noticeLetterSubView.backgroundColor = UIColor.blue
                            }
            }
        )
        
        LetterSingleton._sharedInstance.noticeLetterBody = result_body[indexPath.row]["contents"].stringValue
        LetterSingleton._sharedInstance.noticeLetterName = result_body[indexPath.row]["title"].stringValue
        LetterSingleton._sharedInstance.noticeLetterTitle = result_body[indexPath.row]["body"].stringValue
        LetterSingleton._sharedInstance.noticeLetterID = result_body[indexPath.row]["id"].stringValue
    }
    
}
