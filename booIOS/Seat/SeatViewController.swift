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
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON()
        
        if userDefaults.object(forKey: "isFirstSeat") == nil {
            con.toastText("각 줄을 터치하시면 좌석현황을 보여드립니다.")
            userDefaults.set(0, forKey: "isFirstSeat")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false;
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
            con.toastText("불러오기 실패")
        } else {
            let dicTemp = result_body[indexPath.row]
            
            cell.seatNameLabel.text = dicTemp["loc"].string!
            cell.seatTotalCountLabel.text = dicTemp["all"].string!
            cell.seatUserLabel.text = dicTemp["use"].string!
            cell.seatLeftLabel.text = dicTemp["remain"].string!
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seatDetail" {
            let indexPath = self.seatTableView.indexPathForSelectedRow
            let no = (indexPath?.row)!+1
            let senderController = segue.destination as! SeatDetailViewController
            senderController.sendURL = "http://168.115.33.207/WebSeat/roomview5.asp?room_no=\(no)"
        }
    }

    
    func getJSON(){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "http://www.dongaboomin.xyz:3000/getWebSeat"
        let queue = DispatchQueue(label: "xyz.dongaboomin.seat", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 200{
                                    self.result_body = json["result_body"]
                                }else{
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
