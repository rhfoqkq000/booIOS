//
//  TodayViewController.swift
//  titmetable
//
//  Created by candy on 2017. 8. 25..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var monArray: Array<UILabel>?
    @IBOutlet var tueArray: Array<UILabel>?
    @IBOutlet var wedArray: Array<UILabel>?
    @IBOutlet var thuArray: Array<UILabel>?
    @IBOutlet var friArray: Array<UILabel>?
    @IBOutlet var viewArray: Array<UIView>?
    @IBOutlet var bottomArray : Array<UIView>?
    @IBOutlet var topArray : Array<UIView>?
    
    @IBOutlet var allTimeView: UIView!
    
    var scheduleArray:JSON = [:]
    var blank:String = ""
    var lecBlank:String = ""
    
    let userDefaults = UserDefaults()
    
    let oneColor:UIColor = UIColor(red: 255/255, green: 231/255, blue: 150/255, alpha: 1.0)
    let twoColor:UIColor = UIColor(red: 251/255, green: 187/255, blue: 153/255, alpha: 1.0)
    let threeColor:UIColor = UIColor(red: 250/255, green: 243/255, blue: 223/255, alpha: 1.0)
    let fourColor:UIColor = UIColor(red: 199/255, green: 223/255, blue: 216/255, alpha: 1.0)
    let fiveColor:UIColor = UIColor(red: 160/255, green: 195/255, blue: 228/255, alpha: 1.0)
    let sixColor:UIColor = UIColor(red: 215/255, green: 203/255, blue: 233/255, alpha: 1.0)
    let sevenColor:UIColor = UIColor(red: 246/255, green: 211/255, blue: 228/255, alpha: 1.0)
    let eightColor:UIColor = UIColor(red: 233/255, green: 148/255, blue: 151/255, alpha: 1.0)
    let nineColor:UIColor = UIColor(red: 204/255, green: 203/255, blue: 203/255, alpha: 1.0)
    let tenColor:UIColor = UIColor(red: 161/255, green: 198/255, blue: 187/255, alpha: 1.0)
    let eleColor:UIColor =  UIColor(red: 244/255, green: 226/255, blue: 207/255, alpha: 1.0)
    let tweColor:UIColor = UIColor(red: 198/255, green: 207/255, blue: 221/255, alpha: 1.0)
    let thirColor:UIColor = UIColor(red: 214/255, green: 217/255, blue: 141/255, alpha: 1.0)
    let fourtColor:UIColor = UIColor(red: 222/255, green: 235/255, blue: 241/255, alpha: 1.0)
    let fivetColor:UIColor = UIColor(red: 228/255, green: 203/255, blue: 172/255, alpha: 1.0)
    let sixtColor:UIColor = UIColor(red: 255/255, green: 199/255, blue: 198/255, alpha: 1.0)
    
    var colorArray = [UIColor]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = CGSize(width:self.view.frame.size.width, height:110)
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        
        let scheBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        
        //                view 오른쪽에만 테두리 추가
        for i in 1..<(viewArray?.count)!{
            viewArray?[i].layer.addBorder(edge: [.left], color:scheBlack, thickness: 1.0)
        }
        
        //        view 밑에만 테두리 추가
        for j in 1..<(bottomArray?.count)!{
            bottomArray?[j].layer.addBorder(edge: [.top], color:scheBlack, thickness: 1.0)
        }

        topArray?[0].layer.addBorder(edge: [.top], color: scheBlack, thickness: 1.0)
//        
        colorArray = [oneColor,twoColor,threeColor,fourColor,fiveColor,sixColor,sevenColor,eightColor,nineColor,tenColor,eleColor,tweColor,thirColor,fourtColor,fivetColor,sixtColor]
        
        getJSON()

    }
    @available(iOS 10.0, *)
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
//            self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(3.2)*view.frame.size.height)
            self.preferredContentSize = CGSize(width: 0, height: 400)
        }else if activeDisplayMode == .compact{
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110)
        }
    }
    
    func getJSON(){
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getTimeTable"
        let parameters = ["stuId" :(UserDefaults(suiteName: "group.xyz.dongaboomin.npe")?.string(forKey: "widgetStuId"))!, "stuPw" :(UserDefaults(suiteName: "group.xyz.dongaboomin.npe")?.string(forKey: "widgetStuPw"))!]
//                let parameters = ["stuId" : "1419142", "stuPw" : "tlsfkaus1!"]
        let queue = DispatchQueue(label: "xyz.dongaboomin.widget", qos: .utility, attributes: [.concurrent])
        
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters, encoding:JSONEncoding(options:[])).validate()
            
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.scheduleArray = json["result_body"]
                                }else{
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                //UI 업데이트는 여기
                                for i in 0..<self.scheduleArray.count{
                                    
                                    let start = self.scheduleArray[i][6].string!
                                    let startTime = start.components(separatedBy: "-")[0]
                                    var realTime:Int = 0
                                    
                                    let whitespace = NSCharacterSet.whitespaces
                                    if !start.trimmingCharacters(in: whitespace).isEmpty{
                                        //      ex)12교시는 한시반 배열로는 9번째
                                        realTime = Int(startTime.substring(from: startTime.index(after: startTime.startIndex)))!-3
                                    }
                                    
                                    //                                    과목명
                                    let lectureName = self.scheduleArray[i][3].string!
                                    
                                    //           요일
                                    let index = startTime.index(startTime.startIndex, offsetBy: 1)
                                    let day = startTime.substring(to: index)
                                    
                                    switch day {
                                    case "월":
                                        self.setText(self.monArray!,i,start, realTime, lectureName)
                                        self.setColor(self.monArray!, i, start, realTime, lectureName)
                                        break
                                        
                                    case "화":
                                        self.setText(self.tueArray!, i, start, realTime, lectureName)
                                        self.setColor(self.tueArray!, i, start, realTime, lectureName)
                                        break
                                        
                                    case "수":
                                        self.setText(self.wedArray!, i, start, realTime, lectureName)
                                        self.setColor(self.wedArray!, i, start, realTime, lectureName)
                                        break
                                        
                                    case "목":
                                        self.setText(self.thuArray!, i, start, realTime, lectureName)
                                        self.setColor(self.thuArray!, i, start, realTime, lectureName)
                                        break
                                        
                                    case "금":
                                        self.setText(self.friArray!, i, start, realTime, lectureName)
                                        self.setColor(self.friArray!, i, start, realTime, lectureName)
                                        break
                                    default:
                                        break
                                    }
                                }
                                     self.view.reloadInputViews()
                            }
            }
        )
        
    }
    func setText(_ array : Array<UILabel>,_ i :Int, _ getStart :String, _ realTime :Int, _ lectureName :String){
        
        //       강의실 자르기
//        let room = (getStart.components(separatedBy: " ")[0]).components(separatedBy: "(")[1]
        let room_no = getStart.characters.index(of: "(")
        let room_de = getStart.substring(from: room_no!)
        let room = room_de.substring(from: room_de.index(after: room_de.startIndex)).components(separatedBy: " ")[0]
        
        //       과목명
        if lectureName != "" {
            blank = lectureName
            array[realTime+1].text = lectureName
            
        }else{
            array[realTime+1].text = blank
        }
        //        라벨 집어넣기
        array[realTime].text = room
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func setColor(_ array : Array<UILabel>,_ i :Int, _ getStart :String, _ realTime :Int, _ lectureName :String){
        let getEndTime = (getStart.components(separatedBy: "-")[1]).components(separatedBy: "(")[0]
        let realEndTime = Int(getEndTime)!-3
        let diff = realEndTime - realTime
        
        if diff == 1{
            array[realTime].layer.backgroundColor = colorArray[i].cgColor
            array[realTime+1].layer.backgroundColor = colorArray[i].cgColor
        }else if diff == 2 {
            if lectureName != "" {
                array[realTime].layer.backgroundColor = colorArray[i].cgColor
                array[realTime+1].layer.backgroundColor = colorArray[i].cgColor
                array[realTime+2].layer.backgroundColor = colorArray[i].cgColor
            }else {
                array[realTime].layer.backgroundColor = colorArray[i-1].cgColor
                array[realTime+1].layer.backgroundColor = colorArray[i-1].cgColor
                array[realTime+2].layer.backgroundColor = colorArray[i-1].cgColor
            }
        }else if diff == 3 {
            array[realTime].layer.backgroundColor = colorArray[i].cgColor
            array[realTime+1].layer.backgroundColor = colorArray[i].cgColor
            array[realTime+2].layer.backgroundColor = colorArray[i].cgColor
            array[realTime+3].layer.backgroundColor = colorArray[i].cgColor
        }
    }
    
}
