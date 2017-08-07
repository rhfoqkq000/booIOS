//
//  ViewController.swift
//  seat
//
//  Created by rokhun on 2017. 7. 4..
//  Copyright © 2017년 rokhun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SeatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var seatTableView: UITableView!
    var result_body:JSON = [:]
    
    var result_body_pro:JSON = [:]
    
    let con = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeatCell", for: indexPath) as! SeatTableViewCell
        cell.backgroundColor = UIColor.clear
        
        if result_body.isEmpty {
            print("어이쿠 저런...")
            con.toastText("불러오기 실패")
        } else {
            let dicTemp = result_body[indexPath.row]
            
            cell.seatNameLabel.text = dicTemp["loc"].string!
            cell.seatTotalCountLabel.text = dicTemp["all"].string!
            cell.seatUserLabel.text = dicTemp["use"].string!
            cell.seatLeftLabel.text = dicTemp["remain"].string!
//            let utilDouble:Double = Double(dicTemp["util"].string!)!
//            if  utilDouble<49{
//                cell.seatUseRatingLabel.textColor = UIColor.green
//            } else if 50<utilDouble&&utilDouble<99 {
//                cell.seatUseRatingLabel.textColor = UIColor.yellow
//            } else if utilDouble==100{
//                cell.seatUseRatingLabel.textColor = UIColor.red
//            }
            let round = lround(Double(dicTemp["util"].string!)!)
            let uicolor = color(round)
            
            cell.seatUseRatingLabel.text = String(round)+"%"
            
            cell.seatUseRatingLabel.textColor = uicolor
        }


        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result_body.count
    }
    
    func getJSON(){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getWebSeat"
        let queue = DispatchQueue(label: "xyz.dongaboomin.seat", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.result_body = json["result_body"]
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
                                self.seatTableView.reloadData()
                            }
            }
        )
    }
    
    func color(_ round:Int) ->UIColor {
        if round >= 0 && round < 50 {
            return UIColor(red: 0/255, green: 187/255, blue: 16/255, alpha: 1.0)
        }else if round >= 50 && round < 100 {
            return UIColor(red: 184/255, green: 185/255, blue: 3/255, alpha: 1.0)
        }else {
            return UIColor(red: 213/255, green: 0/255, blue: 2/255, alpha: 1.0)
        }
    }
    
}
