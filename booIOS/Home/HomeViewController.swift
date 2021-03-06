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

    
    @IBOutlet weak var homeToday: UILabel!
    @IBOutlet weak var homeDayText: UILabel!
    
    @IBOutlet weak var timeSuperView: UIView!
    @IBOutlet weak var timeSubView: UIView!
    @IBOutlet weak var timeTableView: UITableView!
    
    @IBOutlet var menuSuperView: UIView!
    @IBOutlet weak var menuSubView: UIView!
    @IBOutlet weak var menuPickerView: UIPickerView!
    @IBOutlet weak var menuTextView: UITextView!
    
    let userDefaults = UserDefaults.standard
    
    var infoArr : Array = [TimeTableInfo]()
    
    let con : Constants = Constants()
    
    var getJSONResult_body:JSON = [:]
    
    var getResMenuResult_body:JSON = [:]
    
    let fakeToRealDic =
        [3:"09:00~09:30",4:"09:30~10:00",5:"10:00~10:30",6:"10:30~11:00",7:"11:00~11:30",
         8:"11:30~12:00",9:"12:00~12:30",10:"12:30~13:00",11:"13:00~13:30",12:"13:30~14:00",13:"14:00~14:30",14:"14:30~15:00",15:"15:00~15:30",16:"15:30~16:00",17:"16:00~16:30",18:"16:30~17:00",19:"17:00~17:30",20:"17:30~18:00",21:"18:00~18:25",22:"18:25~18:50",23:"18:50~19:15",24:"19:15~19:40",25:"19:40~20:05",26:"20:05~20:30",27:"20:30~20:55",28:"20:55~21:20",29:"21:20~21:45",30:"21:45~22:10"]
    
    let resArray:[String] = [ "강의동","국제관", "교직원", "승학교직원", "승학학생회관", "승학도서관"]
    
    let sectionArray:[String] = ["시간표", "식단"]
    
    var menuArray:[String] = []
    
    var monday = [TimeTableInfo]()
    var monday2 = [[String:Any]]()
    var tueday = [TimeTableInfo]()
    var tueday2 = [[String:Any]]()
    var wenday = [TimeTableInfo]()
    var wenday2 = [[String:Any]]()
    var thrday = [TimeTableInfo]()
    var thrday2 = [[String:Any]]()
    var friday = [TimeTableInfo]()
    var friday2 = [[String:Any]]()
    
    var day:String = ""
    
    var result:String = ""
    
    var mainManager = CBLManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.set(0, forKey: "notReadPush")

        timeTableView.backgroundColor = UIColor(red: 247/255, green: 148/255, blue: 122/255, alpha: 1.0)
        
        UserDefaults(suiteName:"group.xyz.dongaboomin.npe")?.set(userDefaults.string(forKey: "stuId"), forKey: "widgetStuId")
        UserDefaults(suiteName:"group.xyz.dongaboomin.npe")?.set(userDefaults.string(forKey: "stuPw"), forKey: "widgetStuPw")
        
        let date = Date()
        day = getTargetDay(targetDay: date)
//        day = "수"
        
        let formatter = DateFormatter()
        var result:String = ""
        formatter.dateFormat = "yyyy-MM-dd"
        result = formatter.string(from: date)
//        let result = "2017-07-15"
        
        if userDefaults.string(forKey: "mealDate") == nil{
            userDefaults.set(result, forKey:"mealDate")
            getResMenu(targetDate: result)
        }else{
            if result == userDefaults.string(forKey: "mealDate"){
                let manager = CBLManager.sharedInstance()
                let database: CBLDatabase
                do {
                    database = try manager.databaseNamed("app")
                } catch {
                    con.toastText("불러오기 실패")
                    return
                }
                let doc = database.document(withID: "meal")
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["gang"] as! String)
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["inter"] as! String)
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["kyo"] as! String)
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["hadan_kyo"] as! String)
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["hadan_gang"] as! String)
                menuArray.append((doc?.properties?["mealMenu"] as! [String:Any])["library"] as! String)
                
                //매일매일 날짜를 기록하는데 현재 날짜와 기록된 날짜가 다르면 통신해서 받아온다 
                //그리고 그걸 DB에 넣는다
                //DB에 들어있는 내용을 텍스트뷰에 넣는다
                let pattern = "^\\n"
                let trim = menuArray[0].removingWhitespaces()
                if (trim.matches(pattern)) {
                    menuTextView.text = "메뉴가 없당!"
                } else {
                    menuTextView.text = menuArray[0]
                }
                do{
                    try database.close()
                }catch{
                    return
                }
            }else{
                userDefaults.removeObject(forKey: "mealDate")
                userDefaults.set(result, forKey:"mealDate")
                getResMenu(targetDate: result)
            }
        }
        
        mainManager = CBLManager.sharedInstance()
        let database: CBLDatabase
        do {
            database = try mainManager.databaseNamed("app")
        } catch {
            con.toastText("불러오기 실패")
            return
        }
        //        let doc2 = database.document(withID: "1124305HOME")!
        //        do{
        //            try doc2.delete();
        //        }catch{
        //            print("Database deleting failed")
        //            con.toastText("삭제 실패")
        //            return
        //        }
        let doc = database.document(withID: userDefaults.string(forKey: "stuId")!+"HOME")!
        if (doc.properties == nil) {
            getJSON()
        }else{
            if doc.properties?["monSchedule"] != nil{
                monday2 = doc.properties?["monSchedule"] as! [[String:Any]]
            }
            if doc.properties?["tueSchedule"] != nil{
                tueday2 = doc.properties?["tueSchedule"] as! [[String:Any]]
            }
            if doc.properties?["wenSchedule"] != nil{
                wenday2 = doc.properties?["wenSchedule"] as! [[String:Any]]
            }
            if doc.properties?["thrSchedule"] != nil{
                thrday2 = doc.properties?["thrSchedule"] as! [[String:Any]]
            }
            if doc.properties?["friSchedule"] != nil{
                friday2 = doc.properties?["friSchedule"] as! [[String:Any]]
            }
        }
        
        do{
            try database.close()
        }catch{
            return
        }
        
        timeTableView.reloadData()
        timeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        timeTableView.estimatedRowHeight = 10
        timeTableView.rowHeight = UITableViewAutomaticDimension
        
//        홈 위에 날짜
        var now:String = ""
        var allNow: String = ""
        formatter.dateFormat = "yyyy년 M월 d일"
        now = formatter.string(from: date)
        allNow = "\(now) \(day)요일"
        homeToday.text = allNow
        
//        홈 위 텍스트
        getHomeText()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UIPickerView Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pattern = "^\\n"
        let trim = menuArray[row].removingWhitespaces()
        if (trim.matches(pattern)) {
            menuTextView.text = "메뉴가 없당!"
        } else {
            menuTextView.text = menuArray[row]
        }
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = resArray[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 17) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnDayCount(targetDay: day)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
//        if userDefaults.object(forKey: "isScheSaved") == nil{
//            var currentDay = [TimeTableInfo]()
//            if day == "월"{
//                currentDay = monday
//            } else if day == "화"{
//                currentDay = tueday
//            } else if day == "수"{
//                currentDay = wenday
//            } else if day == "목"{
//                currentDay = thrday
//            } else if day == "금"{
//                currentDay = friday
//            }
//            let sortedArr = currentDay.sorted { $0.startTime < $1.startTime }
//            cell.titleLabel.text = sortedArr[indexPath.row].title
//            cell.timeLabel.text = (fakeToRealDic[sortedArr[indexPath.row].startTime]?.components(separatedBy: "~")[0])!
//            cell.roomLabel.text = sortedArr[indexPath.row].room
//            print("titleLabel :: \(sortedArr[indexPath.row].title), timeLabel :: \((fakeToRealDic[sortedArr[indexPath.row].startTime]?.components(separatedBy: "~")[0])!), roomLabel :: \(sortedArr[indexPath.row].room)")
//            cell.backgroundColor = UIColor(red: 247/255, green: 148/255, blue: 122/255, alpha: 1.0)
//            
////            self.userDefaults.set(10, forKey: "isScheSaved")
////            print("박았다 ㄹㅇ루")
//
//        }else{
            var currentDay = [[String:Any]]()
            if day == "월"{
                currentDay = monday2
            } else if day == "화"{
                currentDay = tueday2
            } else if day == "수"{
                currentDay = wenday2
            } else if day == "목"{
                currentDay = thrday2
            } else if day == "금"{
                currentDay = friday2
            }
            if currentDay.count != 0 {

                var currentDay2 = [TimeTableInfo]()
                for i in 0..<currentDay.count{
                    let info = TimeTableInfo()
                    info.room = currentDay[i]["room"] as! String
                    info.day = currentDay[i]["day"] as! String
                    info.title = currentDay[i]["title"] as! String
                    info.endTime = currentDay[i]["endTime"] as! Int
                    info.type = currentDay[i]["type"] as! String
                    info.time = currentDay[i]["time"] as! String
                    info.startTime = currentDay[i]["startTime"] as! Int
                    info.index = currentDay[i]["index"] as! Int
                    currentDay2.append(info)
                }
                let sortedArr = currentDay2.sorted { $0.startTime < $1.startTime }
                
                cell.titleLabel.text = sortedArr[indexPath.row].title
                cell.timeLabel.text = (fakeToRealDic[sortedArr[indexPath.row].startTime]?.components(separatedBy: "~")[0])!
                cell.roomLabel.text = sortedArr[indexPath.row].room
                cell.backgroundColor = UIColor(red: 247/255, green: 148/255, blue: 122/255, alpha: 1.0)
            }else{
                
            }
            
//        }
            
        return cell
    }
    
    
    
    func getJSON(){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getTimeTable"
        let parameters:[String:Any] = ["stuId" :userDefaults.string(forKey: "stuId")!, "stuPw" :userDefaults.string(forKey: "stuPw")!]
        
        let queue = DispatchQueue(label: "xyz.dongaboomin.TimeTable", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters, encoding:JSONEncoding(options:[])).validate()
            
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.getJSONResult_body = json["result_body"]
                                }else{
                                    self.con.toastText("불러오기 실패")
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                let result_body = self.getJSONResult_body
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
                                progressHUD.hide()

                                self.refreshArr(targetArr: self.infoArr)

                                let database: CBLDatabase
                                do {
                                    database = try self.mainManager.databaseNamed("app")
                                } catch {
//                                    print("viewDidLoad : Database creation or opening failed")
                                    self.con.toastText("불러오기 실패")
                                    return
                                }
                                let doc = database.document(withID: self.userDefaults.string(forKey: "stuId")!+"HOME")!

                                if doc.properties?["monSchedule"] != nil{
                                    self.monday2 = doc.properties?["monSchedule"] as! [[String:Any]]
                                }
                                if doc.properties?["tueSchedule"] != nil{
                                    self.tueday2 = doc.properties?["tueSchedule"] as! [[String:Any]]
                                }
                                if doc.properties?["wenSchedule"] != nil{
                                    self.wenday2 = doc.properties?["wenSchedule"] as! [[String:Any]]
                                }
                                if doc.properties?["thrSchedule"] != nil{
                                    self.thrday2 = doc.properties?["thrSchedule"] as! [[String:Any]]
                                }
                                if doc.properties?["friSchedule"] != nil{
                                    self.friday2 = doc.properties?["friSchedule"] as! [[String:Any]]
                                }
                                
                                do{
                                    try database.close()
                                }catch{
                                    return
                                }
                                
                                self.timeTableView.reloadData()
                                
                                self.userDefaults.set(10, forKey: "isScheSaved")
                            }
            }
        )
    }
    
    func getRoom(_ subject:String)->String{
        let room_no = subject.characters.index(of: "(")
        let room_de = subject.substring(from: room_no!)
        let room = room_de.substring(from: room_de.index(after: room_de.startIndex)).components(separatedBy: " ")[0]
        
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
                reInfo.day = timeArr[i].day
                reInfo.type = timeArr[i].type
                reInfo.time = timeArr[i].time
                reInfo.index = timeArr[i].index
                monday.append(reInfo)
                setCouchbase(day: "monSchedule", dayArr: monday)
            } else if (timeArr[i].day == "화") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                reInfo.day = timeArr[i].day
                reInfo.type = timeArr[i].type
                reInfo.time = timeArr[i].time
                reInfo.index = timeArr[i].index
                tueday.append(reInfo)
                setCouchbase(day: "tueSchedule", dayArr: tueday)
            } else if (timeArr[i].day == "수") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                reInfo.day = timeArr[i].day
                reInfo.type = timeArr[i].type
                reInfo.time = timeArr[i].time
                reInfo.index = timeArr[i].index
                wenday.append(reInfo)
                setCouchbase(day: "wenSchedule", dayArr: wenday)
            } else if (timeArr[i].day == "목") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                reInfo.day = timeArr[i].day
                reInfo.type = timeArr[i].type
                reInfo.time = timeArr[i].time
                reInfo.index = timeArr[i].index
                thrday.append(reInfo)
                setCouchbase(day: "thrSchedule", dayArr: thrday)
            } else if (timeArr[i].day == "금") {
                let reInfo = TimeTableInfo()
                reInfo.title = timeArr[i].title
                reInfo.startTime = timeArr[i].startTime
                reInfo.endTime = timeArr[i].endTime
                reInfo.room = timeArr[i].room
                reInfo.day = timeArr[i].day
                reInfo.type = timeArr[i].type
                reInfo.time = timeArr[i].time
                reInfo.index = timeArr[i].index
                friday.append(reInfo)
                setCouchbase(day: "friSchedule", dayArr: friday)
            }
        }
    }
    
    func setCouchbase(day:String, dayArr:[TimeTableInfo]){
        let subManager = CBLManager.copy(self.mainManager)
        let database: CBLDatabase
        do {
            database = try subManager().databaseNamed("app")
        } catch {
//            print("HomeViewController Database creation or opening failed")
            con.toastText("불러오기 실패")
            return
        }
        let doc = database.document(withID: userDefaults.string(forKey: "stuId")!+"HOME")!
        if (doc.properties == nil){
//            print("doc.properties가 nil인것갓은디")
            do {
                let dicArray = dayArr.map{ $0.convertToDictionary() }
                try doc.update({(newRev)->Bool in
                    newRev[day] = dicArray
                    return true
                })
            } catch {
//                print("Can't save document in database")
                return
            }
//            print("새로 생성된 Document ID :: \(doc.documentID)")
        }else{
//            print("doc.properties가 nil이아닌것갓은디")
            let dicArray = dayArr.map{ $0.convertToDictionary() }
            do{
                try doc.update({(newRev)->Bool in
                    newRev[day] = dicArray
                    return true
                })
            }catch{
                con.toastText("불러오기 실패")
                return
            }
            if doc.properties![day] != nil{
//                for i in 0..<(doc.properties?[day] as! [[String:Any]]).count{
//                    print("nil이 아니라면 :: \((doc.properties?[day] as! [[String:Any]])[i]["title"]!)")
//                }
            }else{
                do {
                    let dicArray = dayArr.map{ $0.convertToDictionary() }
                    try doc.update({(newRev)->Bool in
                        newRev[day] = dicArray
                        return true
                    })
//                    print("nil이라면 :: \((doc.properties?[day] as! [[String:Any]])[0]["title"]!)")
                } catch {
                    con.toastText("불러오기 실패")
//                    print("nil이라면 Can't save document in database")
                    return
                }
            }
        }
//        print("대체 \(day)엔 뭐가 들어있냐 :: \((doc.properties?[day] as! [[String:Any]]))")
        do{
            try database.close()
        }catch{
//            print("HomeViewController database closing failed")
            return
        }
    }
    
    func getTargetDay(targetDay day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: day)
    }
    
    func returnDayCount(targetDay day:String) -> Int {
//        if userDefaults.object(forKey: "isScheSaved") != nil{
            var count:Int = 0
            if day == "월"{
                count =  monday2.count
            } else if day == "화"{
                count = tueday2.count
            } else if day == "수"{
                count = wenday2.count
            } else if day == "목"{
                count = thrday2.count
            } else if day == "금"{
                count = friday2.count
            }
//            print("returnDayCount에서 \(count) 리턴함")

            return count
//        }else{
//            var count:Int = 0
//            if day == "월"{
//                count =  monday.count
//            } else if day == "화"{
//                count = tueday.count
//            } else if day == "수"{
//                count = wenday.count
//            } else if day == "목"{
//                count = thrday.count
//            } else if day == "금"{
//                count = friday.count
//            }
//            print("returnDayCount에서 isScheSaved가 nil임 그래서 \(count) 리턴함")
//            return count
//        }
    }

    
    
    func getResMenu(targetDate date:String){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "http://www.dongaboomin.xyz:3000/meal?date=\(date)"
        let queue = DispatchQueue(label: "xyz.dongaboomin.res", qos: .utility, attributes: [.concurrent])
        
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            
                            switch response.result{
                            case .success(let value):
                                self.getResMenuResult_body = JSON(value)
                                
                                
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패")
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                let json = self.getResMenuResult_body
                                if json["result_code"] == 200{
                                    var inter : String = ""
                                    var gang  : String = ""
                                    var bumin_kyo  : String = ""
                                    var hadan_kyo : String = ""
                                    var hadan_gang  : String = ""
                                    var library  : String = ""
                                    inter = json["result_body"]["inter"].stringValue
                                    gang = json["result_body"]["gang"].stringValue
                                    bumin_kyo = json["result_body"]["bumin_kyo"].stringValue
                                    hadan_kyo = json["result_body"]["hadan_kyo"].stringValue
                                    hadan_gang = json["result_body"]["hadan_gang"].stringValue
                                    library = json["result_body"]["library"].stringValue
                                    
                                    self.setMenuCouchbase(date: date, gang: self.htmlToStr(gang).string, kyo: self.htmlToStr(bumin_kyo).string, inter: self.htmlToStr(inter).string, hadan_kyo: self.htmlToStr(hadan_kyo).string, hadan_gang: self.htmlToStr(hadan_gang).string, library: self.htmlToStr(library).string)
                                    
                                    self.menuArray.append(self.htmlToStr(gang).string)
                                    self.menuArray.append(self.htmlToStr(inter).string)
                                    self.menuArray.append(self.htmlToStr(bumin_kyo).string)
                                    self.menuArray.append(self.htmlToStr(hadan_kyo).string)
                                    self.menuArray.append(self.htmlToStr(hadan_gang).string)
                                    self.menuArray.append(self.htmlToStr(library).string)
                                    
                                }else{
                                    self.con.toastText("불러오기 실패")
                                
                                }
                                
                                //기록된 날짜와 현재 날짜가 다르면 통신하는데
                                //그 통신된 날짜의 첫번째(강의동)를 텍스트뷰에 넣는다
                                let pattern = "^\\n"
                                let trim = self.menuArray[0].removingWhitespaces()
                                if (trim.matches(pattern)) {
                                    self.menuTextView.text = "메뉴가 없당!"
                                } else {
                                    self.menuTextView.text = self.menuArray[0]
                                }
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
    
    
    func setMenuCouchbase(date:String, gang:String, kyo:String, inter:String, hadan_kyo:String, hadan_gang:String, library:String){
        let manager = CBLManager.sharedInstance()
        let database: CBLDatabase
        do {
            database = try manager.databaseNamed("app")
        } catch {
            con.toastText("불러오기 실패")
            return
        }
        let doc = database.document(withID: "meal")
        
        let properties:[String:Any] = ["gang":gang, "kyo":kyo, "inter":inter, "date":date, "hadan_kyo":hadan_kyo, "hadan_gang":hadan_gang, "library":library]
        var info = MenuInfo()
        info.gang = gang
        info.inter = inter
        info.kyo = kyo
        info.hadan_kyo = hadan_kyo
        info.hadan_gang = hadan_gang
        info.library = library
        
        do{
            try doc?.update({(newRev)->Bool in
                newRev["mealMenu"] = properties
                return true
            })
        }catch{
        }
        do{
            try database.close()
        }catch{
            return
        }
    }
    
    
    func getHomeText(){
        let todoEndpoint: String = "http://www.dongaboomin.xyz:8000/api/greet"
        let todoEndpointEscapes = todoEndpoint.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let queue = DispatchQueue(label: "xyz.dongaboomin.res", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpointEscapes!, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            var greetText: String = ""
                            
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 200{
                                    greetText = json["result_body"]["greetText"].stringValue
                                }else{
                                    self.con.toastText("불러오기 실패")
                                }
                                
                            case .failure(let error):
                                self.con.toastText("불러오기 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                //UI 업데이트는 여기
                                self.homeDayText.text = greetText
                            }
            }
        )
    }
    
    
    @IBAction func titmeTableRefreshAction(_ sender: AnyObject) {
        
        infoArr.removeAll()
        monday.removeAll()
        monday2.removeAll()
        tueday.removeAll()
        tueday2.removeAll()
        wenday.removeAll()
        wenday2.removeAll()
        thrday.removeAll()
        thrday2.removeAll()
        friday.removeAll()
        friday2.removeAll()
        
        userDefaults.removeObject(forKey: "isScheSaved")
        
        let subManager = CBLManager.copy(mainManager)
        let database: CBLDatabase
        do {
            database = try subManager().databaseNamed("app")
        } catch {
            con.toastText("불러오기 실패")
            return
        }
        let doc2 = database.document(withID: userDefaults.string(forKey: "stuId")!+"HOME")!
        do{
            try doc2.delete()
        }catch{
            con.toastText("불러오기 실패")
            return
        }
        getJSON()
        do{
            try database.close()
        }catch{
            con.toastText("불러오기 실패")
            return
        }
        timeTableView.reloadData()
    }
    
    
    
}
