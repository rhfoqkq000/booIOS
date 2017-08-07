//
//  MasterViewController.swift
//  Boo2
//
//  Created by pmkjkr on 2017. 7. 5..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import Toaster

class EmptyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var dayDropdownButton: UIButton!
    let dayDropdown = DropDown()
    @IBOutlet var firstTimeDropdownButton: UIButton!
    let firstTimeDropdown = DropDown()
    @IBOutlet var secondTimeDropdownButton: UIButton!
    let secondTimeDropdown = DropDown()
    
    let con = Constants()
    
    @IBOutlet var selectButton: UIButton!
    
    let dayList = ["월", "화", "수", "목", "금"]
    let fromTimeList = ["3(09:00~09:30)", "4(09:30~10:00)", "5(10:00~10:30)", "6(10:30~11:00)", "7(11:00~11:30)", "8(11:30~12:00)", "9(12:00~12:30)", "10(12:30~13:00)", "11(13:00~13:30)", "12(13:30~14:00)", "13(14:00~14:30)", "14(14:30~15:00)", "15(15:00~15:30)", "16(15:30~16:00)", "17(16:00~16:30)", "18(16:30~17:00)", "19(17:00~17:30)", "20(17:30~18:00)"]
    
    var toTimeList:[String] = []
    
    var selectedDay = ""
    
    var numberOfList:JSON = [:]
    
    @IBOutlet var tableview: UITableView!

    
    @IBAction func dayDropdownButtonAction(_ sender: AnyObject) {
        dayDropdown.anchorView = dayDropdownButton
        dayDropdown.dataSource = dayList
        dayDropdown.selectionAction = {[unowned self](index, item) in
            self.dayDropdownButton.setTitle(item, for: UIControlState.normal)
        }
        dayDropdown.show()
    }
    
    @IBAction func firstTimeDropdownButtonAction(_ sender: AnyObject) {
        firstTimeDropdown.anchorView = firstTimeDropdownButton
        firstTimeDropdown.dataSource = fromTimeList
        firstTimeDropdown.selectionAction = {[unowned self](index, item) in
            self.firstTimeDropdownButton.setTitle(item, for: UIControlState.normal)
            self.toTimeList = []
            for i in index..<self.fromTimeList.count{
                self.toTimeList.append(self.fromTimeList[i])
            }
            self.secondTimeDropdownButton.setTitle(self.toTimeList[0], for: UIControlState.normal)
        }
        firstTimeDropdown.show()
    }
    
    
    @IBAction func secondTimeDropdownButtonAction(_ sender: AnyObject) {
        secondTimeDropdown.anchorView = secondTimeDropdownButton
        secondTimeDropdown.dataSource = toTimeList
        secondTimeDropdown.selectionAction = {[unowned self](index, item) in
            self.secondTimeDropdownButton.setTitle(item, for: UIControlState.normal)
        }
        secondTimeDropdown.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayDropdownButton.layer.cornerRadius = 8
        dayDropdown.layer.cornerRadius = 8
        firstTimeDropdownButton.layer.cornerRadius = 8
        firstTimeDropdown.layer.cornerRadius = 8
        secondTimeDropdownButton.layer.cornerRadius = 8
        secondTimeDropdown.layer.cornerRadius = 8
        selectButton.layer.cornerRadius = 8
        
        tableview.isHidden = true
    }

    //select button
    @IBAction func showEmptyRoom(_ sender: AnyObject) {
        let dayString = dayDropdownButton.currentTitle
        if dayString == "월"{
            selectedDay = "1"
        }else if dayString == "화"{
            selectedDay = "2"
        }else if dayString == "수"{
            selectedDay = "3"
        }else if dayString == "목"{
            selectedDay = "4"
        }else if dayString == "금"{
            selectedDay = "5"
        }
        print("day:\(selectedDay), from:\(substringFirstCharacter(firstTimeDropdownButton.currentTitle!)), to:\(substringFirstCharacter(secondTimeDropdownButton.currentTitle!))")
        getJSON(selectDay: selectedDay, toTime: substringFirstCharacter(secondTimeDropdownButton.currentTitle!), fromTime: substringFirstCharacter(firstTimeDropdownButton.currentTitle!))
        
        tableview.isHidden = false
    }
    
    func substringFirstCharacter(_ string:String)->String{
        return string.components(separatedBy: "(")[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! EmptyRoomCustomCell
        cell.backgroundColor = UIColor.clear
        cell.emptyRoomLabel.text! = numberOfList[indexPath.row]["room_no"].stringValue
        return cell
    }

    
    func getJSON(selectDay day:String, toTime to:String, fromTime from:String){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/empty/room?day=\(day)&from=\(from)&to=\(to)"
        let queue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.numberOfList = json["result_body"]
                                }else{
                                    self.con.toastText("불러오기 실패")
                                }
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패")
                            }
                            
                            DispatchQueue.main.async {
                                //UI 업데이트는 여기
                                progressHUD.hide()
                                self.tableview.reloadData()
                            }
            }
        )
    }

}
