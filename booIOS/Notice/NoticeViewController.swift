//
//  NoticeViewController.swift
//  booIOS
//
//  Created by candy on 2017. 7. 13..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!

    var noticeArray=[noticeStruct]()
    let con = Constants()
    
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let todoEndpoint: String = "http://dongaboomin.xyz:8000/api/notice"
        let queue = DispatchQueue(label: "xyz.dongaboomin.notice", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 200{
                                    let result_body = json["result_body"]
                                    
                                    for i in 0..<result_body.count{
                                        let notice = noticeStruct(id: result_body[i]["id"].intValue, title: result_body[i]["title"].stringValue, contents: result_body[i]["contents"].stringValue, created_at: result_body[i]["created_at"].stringValue, updated_at: result_body[i]["updated_at"].stringValue)
                                        
                                        self.noticeArray.append(notice)
                                    }

                                }else{
                                    print("SeatViewController getJSON result code not matched")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell")! as! NoticeCell
        
        cell.noticeLabel.text = noticeArray[indexPath.row].title
        cell.dateLabel.text = noticeArray[indexPath.row].updated_at
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
       
        print("1")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("2")
        if segue.identifier == "noticeDetail" {
            let indexPath = self.tableview.indexPathForSelectedRow
            let senderController = segue.destination as! NoticeDetailViewController
            senderController.nTitle = noticeArray[(indexPath?.row)!].title
            senderController.nDate = noticeArray[(indexPath?.row)!].updated_at
            senderController.nContents = noticeArray[(indexPath?.row)!].contents
        }
    }
    
    
}
