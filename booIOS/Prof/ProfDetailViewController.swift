//
//  ProfDetailTableViewController.swift
//  prof
//
//  Created by candy on 2017. 7. 4..
//  Copyright © 2017년 candy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableview: UITableView!
    
    
//    선택한 셀의 학과를 받아오기 위한 값
    var major :String = ""
    var profArray:JSON = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("넘어온 데이터 : \(major)")
        getJSON(targetDate: major)
    }
    
    func getJSON(targetDate major:String){
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getPro?major=\(major)"
        let todoEndpointEscapes = todoEndpoint.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let queue = DispatchQueue(label: "com.example.boo", qos: .utility, attributes: [.concurrent])
        indicator.startAnimating()
        Alamofire.request(todoEndpointEscapes!, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                         
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                self.profArray = json["result_body"]
                          
                            case .failure(let error):
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                //                        print("Main: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                
                                //UI 업데이트는 여기
                                self.indicator.stopAnimating()
                                self.tableview.reloadData()
                              
                            }
            }
        )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "majorCell", for: indexPath) as! ProfDetailCell
        
        if profArray.isEmpty {
            print("어이쿠 저런...")
        } else {
            let dicTemp = profArray[indexPath.row]
            
            
            cell.profName.text = dicTemp["name"].string!
            cell.profMajor.text = dicTemp["major"].string!
            
            let email = dicTemp["email"].string
            let tel = dicTemp["tel"].string
            let callImage = UIImage(named: "callFill")
            let mailImage = UIImage(named: "mailFill")
            let emptyCallImage = UIImage(named: "callEmpty")
            let emptyMailImage = UIImage(named: "mailEmpty")
            
            if email == "." && tel == "." {
                cell.profMail.setBackgroundImage(emptyCallImage, for: .normal)
                cell.profCall.setBackgroundImage(emptyCallImage, for: .normal)
            }else if email != "." && tel == "."{
                cell.profMail.setBackgroundImage(mailImage, for: .normal)
                cell.profCall.setBackgroundImage(emptyCallImage, for: .normal)
            }else if email == "." && tel != "."{
                cell.profMail.setBackgroundImage(emptyMailImage, for: .normal)
                cell.profCall.setBackgroundImage(callImage, for: .normal)
            }else{
                cell.profMail.setBackgroundImage(mailImage, for: .normal)
                cell.profCall.setBackgroundImage(callImage, for: .normal)
            }
            
            cell.profMail.tag = indexPath.row
            cell.profCall.tag = indexPath.row
        }

//        셀 배경 없애기
        cell.backgroundColor = UIColor.clear
     
        return cell
        
    }
 
    //    텍스트뷰 높이 자동 조절
    override func viewWillAppear(_ animated: Bool) {
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
//    전화버튼
    @IBAction func callAction(_ sender: Any) {
        let call = sender as! UIButton
        let proTel = profArray[call.tag]["tel"]
        
        let url = URL(string: "tel://\(proTel)")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
//    메일버튼
    @IBAction func mailAction(_ sender: Any) {
        let mail = sender as! UIButton
        let proMail = profArray[mail.tag]["email"]
        print("mail : \(proMail)")
        
        let url = URL(string: "mailto:\(proMail)")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    

}
