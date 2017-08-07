//
//  ResViewController.swift
//  res
//
//  Created by candy on 2017. 6. 26..
//  Copyright © 2017년 candy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!


    //        오늘 날짜 얻어오기
    let date = Date()
    let formatter = DateFormatter()
    var result:String = ""
    var count = 0.0
    
    let name = [ "종합강의동","국제관", "교직원"]
    var content = [String?]()
    var cell = ResCell()
    
    let con = Constants()
    
    var convert = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        셀 선 없애기
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        
//        오늘 날짜 얻어오기
        formatter.dateFormat = "yyyy-MM-dd"
        result = formatter.string(from: date)
        self.dateLabel.text = result
        print(date)
        
        convert = formatter.date(from: dateLabel.text!)!
        getJSON(targetDate: result)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getJSON(targetDate date:String){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "http://www.dongaboomin.xyz:3000/meal?date=\(date)"
            let queue = DispatchQueue(label: "book.booIOS", qos: .utility, attributes: [.concurrent])
            
            Alamofire.request(todoEndpoint, method: .get).validate()
                .responseJSON(queue: queue,
                              completionHandler : { response in
                        var inter : String = ""
                        var gang  : String = ""
                        var bumin_kyo  : String = ""
                        self.content.removeAll()
                                
                        switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            if json["result_code"] == 200{
                                inter = json["result_body"]["inter"].stringValue
                                gang = json["result_body"]["gang"].stringValue
                                bumin_kyo = json["result_body"]["bumin_kyo"].stringValue
                            }else{
                                self.con.toastText("불러오기 실패")
                                print("ResViewController result code not matched")
                            }
                        case .failure(let error):
                            self.con.toastText("불러오기 실패")
                            print(error)
                        }

                                
                        DispatchQueue.main.async {
                            let interStr = try! NSAttributedString(
                                data: inter.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                documentAttributes: nil)
                            
                            let gangStr = try! NSAttributedString(
                                data: gang.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                documentAttributes: nil)
                            
                            let buminStr = try! NSAttributedString(
                                data: bumin_kyo.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                documentAttributes: nil)
                            print(interStr)
                            
                            self.content.append(gangStr.string)
                            self.content.append(interStr.string)
                            self.content.append(buminStr.string)

                            
//                          callback
                            progressHUD.hide()
                            self.tableview.reloadData()
                            
                        }
                }
            )
    }
    
    //    테이블 행수 얻기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    //    셀 내용 변경하기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "resCell")! as! ResCell
        if content.isEmpty {
            print("식당 값이 없당")
        } else {
            let pattern = "^\\n"
            let trim = content[indexPath.row]?.removingWhitespaces()
            if (trim!.matches(pattern)) {
                cell.resContent.text = "메뉴가 없당!"
            } else {
                
                cell.resContent.text = content[indexPath.row]!
            }

        cell.resName.text = name[indexPath.row]
//          셀 배경 없애기
        cell.backgroundColor = UIColor.clear

            
        }
        return cell
    }
    
//    텍스트뷰 높이 자동 조절
    override func viewWillAppear(_ animated: Bool) {
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func resLeftButton(_ sender: Any) {
        count -= 86400.0
        
        let minus = convert + count
        let pre = formatter.string(from: minus)
        dateLabel.text = pre
        getJSON(targetDate: pre)
    }
    
    @IBAction func resRightButton(_ sender: Any) {
        count += 86400.0
        
        let plus = convert + count
        let next = formatter.string(from: plus)
        dateLabel.text = next
        getJSON(targetDate: next)
    }
}

