//
//  SpeGradeViewController.swift
//  Boo2
//
//  Created by pmkjkr on 2017. 7. 7..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import Toaster

class AchiveViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //userDefaults = shraredPreferences
    let userDefaults = UserDefaults.standard
    
    var jsonGrade:JSON = [:]
    
    var jsonDetail:JSON = [:]
    
    let con = Constants()
    
    let TotalSpeList = ["전체학기성적", "일부학기성적"]
    var yearList:[String] = []
    //테이블뷰에서 쓰이는 연도+학기
    var yearTermList:[String] = []
    
    var resultArr = [[GradeInfo]]()
    var year = ["2011 1","2011 2","2015 1","2015 2","2016 1","2016 2","2017 1"]
    var infosArr = [GradeInfo]()
    var fillArr = [Int]()
    var checkList:[Int] = []

    var checkBlank = 0
    
    //전체학기, 일부학기
    let dropDown = DropDown()
    //연도
    let secondDropDown = DropDown()
    //세부사항
    let thirdDropDown = DropDown()
    
    let detailSpeDict:[String:String] = ["전학기":"00", "전적학교인정":"00", "1학기":"10", "계절학기(하기)":"11", "2학기":"20", "계절학기(동기)":"21", "협정대학이수":"30", "협정대학이수(1학기)":"31", "협정대학이수(하계)":"32", "협정대학이수(2학기)":"33", "협정대학이수(동계)":"34", "1학기국내협정대학이수":"50", "1학기국외협정대학이수":"51", "하계국내협정대학":"52", "하계국외협정대학":"53", "2학기국내협정대학이수":"60", "2학기국외협정대학이수":"61", "동계국내협정대학":"62", "동계국외협정대학":"63"]
    var detailSpeList:[String] = []

    @IBOutlet weak var achievedGradeLabel: UILabel!
    @IBOutlet weak var averageGradeLabel: UILabel!
    //전체학기, 일부학기 드랍다운 출력 버튼
    @IBOutlet var dropdownButton: UIButton!
    //연도 출력 버튼
    @IBOutlet var dropdownSpeButton: UIButton!
    //세부사항 출력 버튼
    @IBOutlet var dropdownDetailButton: UIButton!
    @IBOutlet var speGradeTableView: UITableView!
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var partButton: UIButton!

    @IBOutlet weak var partView: UIView!
    
    
    //전체 일부학기 드랍다운 액션
    @IBAction func dropdownButtonAction(_ sender: AnyObject) {
        dropDown.anchorView = dropdownButton
        dropDown.dataSource = TotalSpeList
        dropDown.selectionAction = {[unowned self](index, item) in
            self.dropdownButton.setTitle(item, for: UIControlState.normal)
            if item == "일부학기성적" {
                self.dropdownSpeButton.isHidden = false
                self.dropdownDetailButton.isHidden = false
                self.partButton.isHidden = false
                self.allButton.isHidden = true
            }else if item == "전체학기성적"{
                self.dropdownSpeButton.isHidden = true
                self.dropdownDetailButton.isHidden = true
                self.partButton.isHidden = true
                self.allButton.isHidden = false
            }
        }
        dropDown.show()
    }
    
    //연도 드랍다운 액션
    @IBAction func dropdownSpeButtonAction(_ sender: AnyObject) {
        secondDropDown.anchorView = dropdownSpeButton
        secondDropDown.dataSource = yearList
        secondDropDown.selectionAction = {[unowned self] (index,item) in
            self.dropdownSpeButton.setTitle(item, for: UIControlState.normal)
        }
        secondDropDown.show()
    }
    
    //기타등등 드랍다운 액션
    @IBAction func dropdownDetailButtonAction(_ sender: AnyObject) {
        thirdDropDown.anchorView = dropdownDetailButton
        thirdDropDown.selectionAction = {[unowned self] (index,item) in
            self.dropdownDetailButton.setTitle(item, for: UIControlState.normal)
        }
        thirdDropDown.show()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownSpeButton.isHidden = true
        dropdownDetailButton.isHidden = true
        partButton.isHidden = true
        partView.isHidden = true
        
        
        //현재 연도 구함
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year =  Int(components.year!)
        
        //학번에서 앞 두자리 잘라서 입학한 연도 구함
        let stuId = userDefaults.string(forKey:"stuId")
        let index = stuId?.index((stuId?.startIndex)!, offsetBy: 2)
        let admissionYear = Int("20"+(stuId?.substring(to: index!))!)!
        
        for i in admissionYear...year{
            yearList.append(String(i))
        }
        
        detailSpeList = Array(detailSpeDict.keys)
        thirdDropDown.dataSource = detailSpeList
        
        dropdownButton.layer.cornerRadius = 8
        dropdownSpeButton.layer.cornerRadius = 8
        dropdownDetailButton.layer.cornerRadius = 8
        allButton.layer.cornerRadius = 8
        partButton.layer.cornerRadius = 8
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yearTerm", for: indexPath) as! AchiveCustomCell
        cell.backgroundColor = UIColor.clear
        cell.lectureName.text! = resultArr[indexPath.section][indexPath.row].lecName
        cell.lectureGrade.text! = resultArr[indexPath.section][indexPath.row].grade
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(resultArr[section][0].year)년도 \(resultArr[section][0].term)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return checkList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        con.toastText("이수구분 : \(resultArr[indexPath.section][indexPath.row].seperator), 학점 : \(resultArr[indexPath.section][indexPath.row].point)")
    }
    
    
    
    //전체확인버튼
    @IBAction func getGradeButtonAction(_ sender: AnyObject) {
        partView.isHidden = false
        if dropdownButton.currentTitle == "전체학기성적"{
            getJSON(userDefaults.string(forKey: "stuId")!, userDefaults.string(forKey: "stuPw")!, "", "")
            
        }else{
            con.toastText("항목을 선택해주세요.")
        }
    }
    
//    일부확인버튼
    @IBAction func getGradeButton2Action(_ sender: AnyObject) {
        partView.isHidden = false
        if dropdownButton.currentTitle == "일부학기성적"{
            if dropdownSpeButton.currentTitle != "년도" && dropdownDetailButton.currentTitle != "선택해주세요."{
            getJSON(userDefaults.string(forKey: "stuId")!, userDefaults.string(forKey: "stuPw")!, dropdownSpeButton.title(for: UIControlState.normal)!, detailSpeDict[dropdownDetailButton.title(for: UIControlState.normal)!]!)
            }else{
                con.toastText("항목을 선택해주세요.")

            }
        }else{
            con.toastText("항목을 선택해주세요.")
        }
    }
    
    func getJSON(_ id:String, _ pw:String, _ year:String, _ smt:String){
        let todoEndpoint: String = "https://dongaboomin.xyz:20433/donga/getSpeGrade"
        let parameters = ["stuId":id, "stuPw":pw, "year":year, "smt":smt]
        let queue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters:parameters, encoding:JSONEncoding(options:[])).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.jsonDetail = json["result_body"]["detail"]
                                    self.jsonGrade = json["result_body"]
                                    self.fillArr = []
                                    self.resultArr = []
                                    self.checkList = []
                                    self.infosArr = []
                                    
                                    var info = GradeInfo()
                                    var fillIdx = 0
                                    let jsonDetail = self.jsonDetail
                                    for i in 1..<jsonDetail.count{
                                        if self.checkWhiteSpace(jsonDetail[i][0].stringValue) == true {
                                            info.year = jsonDetail[fillIdx][0].stringValue
                                            info.term = jsonDetail[fillIdx][1].stringValue
                                            info.lecName = jsonDetail[i][3].stringValue
                                            info.seperator = jsonDetail[i][4].stringValue
                                            info.point = jsonDetail[i][5].stringValue
                                            info.grade = jsonDetail[i][6].stringValue
                                            
                                            self.infosArr.append(info)
                                            if i == jsonDetail.count-1 {
                                                self.fillArr.append(i+1)
                                            }
                                        } else {
                                            fillIdx = i
                                            info.year = jsonDetail[fillIdx][0].stringValue
                                            info.term = jsonDetail[fillIdx][1].stringValue
                                            info.lecName = jsonDetail[i][3].stringValue
                                            info.seperator = jsonDetail[i][4].stringValue
                                            info.point = jsonDetail[i][5].stringValue
                                            info.grade = jsonDetail[i][6].stringValue
                                            
                                            self.infosArr.append(info)
                                            self.fillArr.append(fillIdx)
                                            if i == jsonDetail.count-1 {
                                                self.fillArr.append(i+1)
                                            }
                                        }
                                    }
                                    for i in 0..<self.fillArr.count {
                                        if i < self.fillArr.count-1 {
                                            self.checkList.append(abs(self.fillArr[i] - self.fillArr[i+1]))
                                        }
                                    }
                                    for i in 0..<self.fillArr.count {
                                        if i == 1 {
                                            let tempArr = self.infosArr[0..<self.fillArr[i]-1]
                                            print("tempArr1 : \(i),\(tempArr)\n")
                                            self.resultArr.append(Array(tempArr))
                                        } else if (i>1) {
                                            if i < self.fillArr.count {
                                                let tempArr = self.infosArr[self.fillArr[i-1]-1..<self.fillArr[i]-1]
                                                print("tempArr2 : \(i),\(tempArr)\n")
                                                self.resultArr.append(Array(tempArr))
                                            }
                                        }
                                    }
                                }else{
                                    print("AchievViewController result_code not matched")
                                    self.con.toastText("불러오기 실패")
                                }
                                
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패")
                            }
                            
                            DispatchQueue.main.async {
                                //UI 업데이트는 여기
                                self.achievedGradeLabel.text = self.jsonGrade["allGrade"].stringValue
                                self.averageGradeLabel.text = self.jsonGrade["avgGrade"].stringValue
                                self.speGradeTableView.reloadData()
//                                self.speGradeTableView.reloadSections([self.checkList.count-1], with: .none)
//                                self.speGradeTableView.reloadData()
                            }
            }
        )
    }
    
    
    func checkWhiteSpace(_ string:String)->Bool{
        let whitespace = NSCharacterSet.whitespaces
        return string.trimmingCharacters(in: whitespace).isEmpty
    }

    
}
