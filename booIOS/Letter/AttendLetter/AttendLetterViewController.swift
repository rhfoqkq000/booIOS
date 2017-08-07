//
//  AttendLetterViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AttendLetterViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    let userDefaults = UserDefaults.standard
    
    var result_body:JSON = [:]
    
    let con = Constants()
    
    var countOfAttendLetters:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        
        getCircleNoticeList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func getCircleNoticeList(){
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
                                    self.result_body = json["result_body"]
                                    self.countOfAttendLetters = self.result_body.count
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
    
    
    //    테이블 행수 얻기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfAttendLetters
    }
    
    //    셀 내용 변경하기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //      view round처리
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendLetter")! as! AttendLetterCell
        cell.attendLetterMainView.layer.cornerRadius = 8
        cell.attendLetterSubView.viewroundCorners(corners: [.topLeft,.bottomLeft], radius: 8)
        
        cell.attendLetterDate.text = result_body[indexPath.row]["getTime"].stringValue
        cell.attendLetterName.text = result_body[indexPath.row]["title"].stringValue
        cell.attendLetterTitle.text = result_body[indexPath.row]["body"].stringValue
        if result_body[indexPath.row]["read_check"].stringValue == "1"{
            //            print("\(indexPath.row)번째 칸의 read_check는 \(result_body[indexPath.row]["read_check"].stringValue)")
            cell.attendLetterSubView.backgroundColor = UIColor.blue
        }else{
            cell.attendLetterSubView.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let parameters: Parameters = ["circle_notis_id": self.result_body[indexPath.row]["id"]]
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
                                    self.con.toastText("통신 오류")
                                }
                            case .failure(let error):
                                print(error)
                                self.con.toastText("통신 오류")
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                let cell = self.tableview.cellForRow(at: indexPath) as! AttendLetterCell
                                cell.attendLetterSubView.backgroundColor = UIColor.blue
                            }
            }
        )
        
        LetterSingleton._sharedInstance.noticeLetterBody = result_body[indexPath.row]["contents"].stringValue
        LetterSingleton._sharedInstance.noticeLetterName = result_body[indexPath.row]["title"].stringValue
        LetterSingleton._sharedInstance.noticeLetterTitle = result_body[indexPath.row]["body"].stringValue
        LetterSingleton._sharedInstance.noticeLetterID = result_body[indexPath.row]["id"].stringValue
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let progressHUD = ProgressHUD(text: "로딩 중입니다...")
            self.view.addSubview(progressHUD)
            progressHUD.show()
            let targets = [self.result_body[indexPath.row]["id"].stringValue]
            let parameters:[String:Any] = ["targets":targets]
            let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/removeCircleNotis"
            let queue = DispatchQueue(label: "xyz.dongaboomin.removeNormalNotis", qos: .utility, attributes: [.concurrent])
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
                                        self.con.toastText("삭제 실패")
                                    }
                                case .failure(let error):
                                    print(error)
                                    self.con.toastText("삭제 실패")
                                }
                                
                                DispatchQueue.main.async {
                                    progressHUD.hide()
                                    self.getCircleNoticeList()
                                }
                }
            )
        }
    }
}
