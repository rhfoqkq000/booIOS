//
//  HomeViewController.swift
//  booIOS
//
//  Created by candy on 2017. 7. 20..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var menuSubView: UIView!
    @IBOutlet weak var menuPickerView: UIPickerView!
    @IBOutlet weak var menuTextView: UITextView!
    

    let userDefaults = UserDefaults.standard
    
    var infoArr : Array = [TimeTableInfo]()
    
    let con : Constants = Constants()
    
    let fakeToRealDic =
        [3:"09:00~09:30",4:"09:30~10:00",5:"10:00~10:30",6:"10:30~11:00",7:"11:00~11:30",
         8:"11:30~12:00",9:"12:00~12:30",10:"12:30~13:00",11:"13:00~13:30",12:"13:30~14:00",13:"14:00~14:30",14:"14:30~15:00",15:"15:00~15:30",16:"15:30~16:00",17:"16:00~16:30",18:"16:30~17:00",19:"17:00~17:30",20:"17:30~18:00",21:"18:00~18:25",22:"18:25~18:50",23:"18:50~19:15",24:"19:15~19:40",25:"19:40~20:05",26:"20:05~20:30",27:"20:30~20:55",28:"20:55~21:20",29:"21:20~21:45",30:"21:45~22:10"]
    
    let resArray:[String] = ["국제관", "교직원", "강의동"]
    
    let sectionArray:[String] = ["시간표", "식단"]
    
    var menuArray:[String] = []
    
    var monday = [TimeTableInfo]()
    
    var tueday = [TimeTableInfo]()
    
    var wenday = [TimeTableInfo]()
    
    var thrday = [TimeTableInfo]()
    
    var friday = [TimeTableInfo]()
    
    var day:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJSON()
        
        let date = Date()
        //        day = getTargetDay(targetDay: date)
        day = "목"
        
        //        오늘 날짜 얻어오기
        let formatter = DateFormatter()
        var result:String = ""
        formatter.dateFormat = "yyyy-MM-dd"
        result = formatter.string(from: date)
        //        let result = "2017-07-21"
        
        if userDefaults.string(forKey: "mealDate") == nil{
            print("mealDate가 nil이라서 \(result)를 박음")
            userDefaults.set(result, forKey:"mealDate")
            getResMenu(targetDate: result)
        }else{
            if result == userDefaults.string(forKey: "mealDate"){
                print("result와 mealDate가 같음")
                let manager = CBLManager.sharedInstance()
                let database: CBLDatabase
                do {
                    // Create or open the database named app
                    database = try manager.databaseNamed("app")
                } catch {
                    print("Database creation or opening failed")
                    con.toastText("불러오기 실패")
                    return
                }
                let doc = database.document(withID: "meal")
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["inter"] as! String)
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["kyo"] as! String)
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["gang"] as! String)
                
                menuTextView.text = menuArray[0]
            }else{
//                print("result(\(result))와 mealDate(\(userDefaults.string(forKey: "mealDate")))가 다름")
                userDefaults.removeObject(forKey: "mealDate")
                userDefaults.set(result, forKey:"mealDate")
                getResMenu(targetDate: result)
            }
        }
        
//
        timeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        timeTableView.estimatedRowHeight = 10
        timeTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UIPickerView Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    //UIPickerView Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        menuTextView.text = menuArray[row]
        print("menuArray[row] : \(menuArray[row])")
        pickerView.reloadAllComponents()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnDayCount(targetDay: day)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
        var currentDay = [TimeTableInfo]()
        if day == "월"{
            currentDay = monday
        } else if day == "화"{
            currentDay = tueday
        } else if day == "수"{
            currentDay = wenday
        } else if day == "목"{
            currentDay = thrday
        } else if day == "금"{
            currentDay = friday
        }
        let sortedArr = currentDay.sorted { $0.startTime < $1.startTime }
        cell.titleLabel.text = sortedArr[indexPath.row].title
        cell.timeLabel.text = (fakeToRealDic[sortedArr[indexPath.row].startTime]?.components(separatedBy: "~")[0])!
        cell.roomLabel.text = sortedArr[indexPath.row].room


        return cell
    }
    
    
    
    func getJSON(){
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getTimeTable"
        let parameters = ["stuId" :"1124305", "stuPw" :"Ekfqlc152!"]
        
        let queue = DispatchQueue(label: "xyz.dongaboomin.TimeTable", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters, encoding:JSONEncoding(options:[])).validate()
            
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                let result_body = json["result_body"]
                                for i in 0..<result_body.count{
                                    
                                    let scheTime = result_body[i][6].string!
                                    let whitespace = NSCharacterSet.whitespaces
                                    if(!scheTime.trimmingCharacters(in: whitespace).isEmpty){
                                        
                                        let totalTime = scheTime.components(separatedBy: "-")
                                        let startTime = self.getStartTime(totalTime[0])
                                        let endTime = self.getEndTime(totalTime[1])
                                        let timeDiff = endTime-startTime
                                        
                                        let title = result_body[i][3].string!
                                        var info = TimeTableInfo()
                                        if timeDiff == 2 {
                                            if title == ""{
                                                let firstTime = result_body[i-1][6].string!.components(separatedBy: "-")
                                                let secondTime = result_body[i][6].string!.components(separatedBy: "-")
                                                info.index = i
                                                info.type = "normal"
                                                info.startTime = self.getStartTime(firstTime[0])
                                                info.endTime = self.getEndTime(firstTime[1])
                                                info.room = self.getRoom(result_body[i-1][6].string!)
                                                info.time = result_body[i-1][6].string!
                                                info.title = result_body[i-1][3].string!
                                                info.day = firstTime[0].substring(to: firstTime[0].index(after: firstTime[0].startIndex))
                                                
                                                self.infoArr.append(info)
                                                
                                                info = TimeTableInfo()
                                                info.index = i
                                                info.type = "normal"
                                                info.startTime = startTime
                                                info.endTime = endTime
                                                info.room = self.getRoom(result_body[i][6].string!)
                                                info.time = result_body[i][6].string!
                                                info.title = result_body[i-1][3].string!
                                                info.day =  secondTime[0].substring(to: secondTime[0].index(after: secondTime[0].startIndex))
                                                self.infoArr.append(info)
                                                
                                                //                                            self.codeArr.append(["index":"\(i)","type":"normal","title":result_body[i-1][3].string!,"startTime":String(self.getStartTime(firstTime[0])),"endTime":String(self.getEndTime(firstTime[1])),"room":self.getRoom(result_body[i-1][6].string!),"time":result_body[i-1][6].string!])
                                                //                                            self.codeArr.append(["index":"\(i)","type":"normal","title":result_body[i-1][3].string!,"startTime":String(startTime),"endTime":String(endTime),"room":self.getRoom(result_body[i][6].string!),"time":result_body[i][6].string!])
                                            }
                                        } else if timeDiff == 3 || timeDiff == 1{
                                            let diffTime = result_body[i][6].string!.components(separatedBy: "-")
                                            info = TimeTableInfo()
                                            info.index = i
                                            info.type = "abnormal"
                                            info.startTime = startTime
                                            info.endTime = endTime
                                            info.room = self.getRoom(result_body[i][6].string!)
                                            info.time = result_body[i][6].string!
                                            info.title = result_body[i][3].string!
                                            info.day = diffTime[0].substring(to: diffTime[0].index(after: diffTime[0].startIndex))
                                            self.infoArr.append(info)
                                            //                                            self.codeArr.append(["type":"abnormal","title":result_body[i][3].string!,"startTime":String(startTime),"endTime":String(endTime),"room":self.getRoom(result_body[i][6].string!),"time":result_body[i][6].string!])
                                        }
                                        
                                    }
                                }
                                self.refreshArr(targetArr: self.infoArr)
                            case .failure(let error):
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
//                                let card = self.makeCardView(view: self.timeUIView)
//                                self.timeUIView.insertSubview(card, belowSubview: self.timeTableView)
                                self.timeTableView.reloadData()
                            }
            }
        )
    }
    
    func getRoom(_ subject:String)->String{
        let room = (subject.components(separatedBy: " ")[0]).components(separatedBy: "(")[1]
        
        return room
    }
    
    func getStartTime(_ first:String) -> Int {
        return Int(first.substring(from: first.index(after: first.startIndex)))!
    }
    
    func getEndTime(_ second:String) -> Int {
        return Int(second.components(separatedBy: "(")[0])!
    }
    
    func refreshArr(targetArr timeArr:[TimeTableInfo]){
        for i in 0..<timeArr.count{
            if (timeArr[i].day == "월") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                monday.append(reInfo)
            } else if (timeArr[i].day == "화") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                tueday.append(reInfo)
            } else if (timeArr[i].day == "수") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                wenday.append(reInfo)
            } else if (timeArr[i].day == "목") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                thrday.append(reInfo)
            } else if (timeArr[i].day == "금") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                friday.append(reInfo)
            }
        }
    }
    
    func getTargetDay(targetDay day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: day)
    }
    
    func returnDayCount(targetDay day:String) -> Int {
        var count:Int = 0
        if day == "월"{
            count =  monday.count
        } else if day == "화"{
            count = tueday.count
        } else if day == "수"{
            count = wenday.count
        } else if day == "목"{
            count = thrday.count
        } else if day == "금"{
            count = friday.count
        }
        return count
    }
    
    
    func getResMenu(targetDate date:String){
        let todoEndpoint: String = "http://www.dongaboomin.xyz:3000/meal?date=\(date)"
        let queue = DispatchQueue(label: "book.booIOS", qos: .utility, attributes: [.concurrent])
        
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 200{
                                    var inter : String = ""
                                    var gang  : String = ""
                                    var bumin_kyo  : String = ""
                                    inter = json["result_body"]["inter"].stringValue
                                    gang = json["result_body"]["gang"].stringValue
                                    bumin_kyo = json["result_body"]["bumin_kyo"].stringValue
                                    
                                    self.setCouchbase(date: date, gang: self.htmlToStr(gang).string, kyo: self.htmlToStr(bumin_kyo).string, inter: self.htmlToStr(inter).string)
                                    
                                    self.menuArray.append(self.htmlToStr(inter).string)
                                    self.menuArray.append(self.htmlToStr(bumin_kyo).string)
                                    self.menuArray.append(self.htmlToStr(gang).string)
                                    
                                }else{
                                    self.con.toastText("불러오기 실패")
                                    print("result_code not matched")
                                }
                                
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패")
                            }
                            
                            DispatchQueue.main.async {
                                self.menuTextView.text = self.menuArray[0]
//                                let card = self.makeCardView(view: self.menuUIView)
//                                self.menuUIView.insertSubview(card, belowSubview: self.menuSubView)
                            }
            }
        )
    }
    
    func htmlToStr(_ htmlStr : String)->NSAttributedString{
        let htmlToStrResult = try! NSAttributedString(
            data: htmlStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        return htmlToStrResult
    }
    
    
    func setCouchbase(date:String, gang:String, kyo:String, inter:String){
        let manager = CBLManager.sharedInstance()
        let database: CBLDatabase
        do {
            // Create or open the database named app
            database = try manager.databaseNamed("app")
        } catch {
            print("Database creation or opening failed")
            con.toastText("불러오기 실패")
            return
        }
        let doc = database.document(withID: "meal")
        
        let properties:[String:Any] = ["gang":gang, "kyo":kyo, "inter":inter, "date":date]
        var info = MenuInfo()
        info.gang = gang
        info.inter = inter
        info.kyo = kyo
        
        do{
            try doc?.update({(newRev)->Bool in
                newRev["mealMenu"] = properties
                return true
            })
        }catch{
            print("DB 입력 실패")
        }
    }
}
