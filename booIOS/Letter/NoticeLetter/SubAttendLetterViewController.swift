//
//  SubNoticeLetterViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubAttendLetterViewController: UIViewController {
    
    @IBOutlet weak var fromTo: UITextView!
    @IBOutlet weak var contentTitle: UITextView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var noAttendBT: UIButton!
    @IBOutlet weak var attendBT: UIButton!
    
    let con = Constants()
    
    var result_body: JSON = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        fromTo.textaddBorderBottom(height: 1, color: UIColor.darkGray)
        //        contentTitle.textaddBorderBottom(height: 1, color: UIColor.darkGray)
        
        noAttendBT.layer.cornerRadius = 5
        attendBT.layer.cornerRadius = 5
        
        fromTo.text = LetterSingleton._sharedInstance.noticeLetterName
        contentTitle.text = LetterSingleton._sharedInstance.noticeLetterTitle
        content.text = LetterSingleton._sharedInstance.noticeLetterBody
        
        adjustUITextViewHeight(content)
        adjustUITextViewHeight(content)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustUITextViewHeight(_ arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    
    
    @IBAction func AttendButtonAction(_ sender: AnyObject) {
        AttendSend(attend: "1", attendResult: "번째 참석공지 - 참석 처리되었습니다.")
    }
    
    
    @IBAction func NoAttendButtonAction(_ sender: AnyObject) {
        AttendSend(attend: "2", attendResult: "번째 참석공지 - 불참 처리되었습니다.")
    }
    
    func AttendSend(attend: String, attendResult: String){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let parameters: Parameters = ["circle_notis_id": LetterSingleton._sharedInstance.noticeLetterID!, "att":attend]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/change_att"
        let queue = DispatchQueue(label: "xyz.dongaboomin.changeAtt", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.result_body = json["result_body"]
                                    self.con.toastText("\(LetterSingleton._sharedInstance.noticeLetterID!)\(attendResult)")
                                }else{
                                    self.con.toastText("전송 실패")
                                }
                            case .failure(let error):
                                self.con.toastText("전송 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                
                            }
            }
        )
    }
    
}
