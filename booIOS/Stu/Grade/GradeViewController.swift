//
//  ViewController.swift
//  grade
//
//  Created by rokhun on 2017. 7. 5..
//  Copyright © 2017년 rokhun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GradeViewController: UIViewController {
    
    
    @IBOutlet var dualMajor: UILabel!
    @IBOutlet var applyYear: UILabel!
    
    @IBOutlet var earlyGrauated: UILabel!
    @IBOutlet var subMajor: UILabel!
    
    @IBOutlet var avgGrade: UILabel!
    @IBOutlet var masterCon: UILabel!
    
    @IBOutlet var kyoZeroCollection: Array<UILabel>?
    @IBOutlet var needZeroCollection: Array<UILabel>?
    @IBOutlet var getZeroCollection: Array<UILabel>?
    @IBOutlet var resultZeroCollection: Array<UILabel>?
    
    @IBOutlet var majorOneCollection: Array<UILabel>?
    @IBOutlet var needOneCollection: Array<UILabel>?
    @IBOutlet var getOneCollection: Array<UILabel>?
    @IBOutlet var resultOneCollection: Array<UILabel>?
    
    @IBOutlet var titleCollection: [UILabel]!
    @IBOutlet var needCollection: [UILabel]!
    @IBOutlet var getCollection: [UILabel]!
    @IBOutlet var pmCollection: [UILabel]!
    
    
    @IBOutlet var needTwoLabel: UILabel!
    @IBOutlet var getTwoLabel: UILabel!
    @IBOutlet var resultTwoLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    var result_body:JSON = [:]
    
    let con = Constants()
    
    let userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getJSON(targetId: userDefaults.string(forKey:"stuId")!, targetPw: userDefaults.string(forKey:"stuPw")!)
        
        topView.layer.addBorder(edge: [.bottom], color: UIColor.darkGray, thickness: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSON(targetId id:String,targetPw pw:String){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let parameters: Parameters = ["stuId": userDefaults.string(forKey:"stuId")!,"stuPw":userDefaults.string(forKey:"stuPw")!]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getGraduated"
//        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/getGradTest"

        let queue = DispatchQueue(label: "xyz.dongaboomin.grade", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
//        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.result_body = json["result_body"]
                                }else{
                                    self.con.toastText("불러오기 실패")
                                }
                                
                            case .failure(let error):
                                print(error)
                                self.con.toastText("불러오기 실패")
                            }
                            
                            DispatchQueue.main.async {
                                let info = self.result_body["info"]
                                self.dualMajor.text = info["multi"].string!
                                self.applyYear.text = info["year"].string!
                                self.earlyGrauated.text = info["early"].string!
                                self.subMajor.text = info["sub"].string!
                                self.avgGrade.text = info["avgGrade"].string!
                                self.masterCon.text = info["smart"].string!
                                
                                var arrTitle = self.result_body["title2"].array!
                                let needArr = self.result_body["need"].array!
                                let getArr = self.result_body["get"].array!
                                let resultArr = self.result_body["pm"].array!
                                arrTitle.append("자유선택");
                                print("얌마얌마 arrTitle.count :::::: \(arrTitle.count), titleCollection.count :: \(self.titleCollection.count), needCollection.count:: \(self.needCollection.count), needArr.count::\(needArr.count), getArr.count::\(getArr.count), resultArr.count::\(resultArr.count)")


                                for i in 0..<arrTitle.count{
                                    print("iiiiiiiii::::::\(i)")
                                    if arrTitle[i] != ""{
                                        self.titleCollection[i].text = arrTitle[i].stringValue
                                    }
                                    if needArr[i+1] != ""{
                                        self.needCollection[i].text = needArr[i+1].stringValue
                                    }
                                    if getArr[i+1] != ""{
                                        self.getCollection[i].text = getArr[i+1].stringValue
                                    }
                                    if resultArr[i+1] != ""{
                                        self.pmCollection[i].text = resultArr[i+1].stringValue
                                        let resultZeroString = resultArr[i+1].string!.substring(to: resultArr[i+1].string!.index(after: resultArr[i+1].string!.startIndex))
                                        if resultZeroString == "-"{
                                                self.pmCollection[i].textColor = UIColor.red
                                        }
                                    }
                                }
                                
//                                for idx in 0...3{
//                                    self.kyoZeroCollection?[idx].text = self.subStringMajorTitle(title: arrTitle[idx].string!)
//                                    self.needZeroCollection?[idx].text = needArr[idx+1].string!
//                                    self.getZeroCollection?[idx].text = getArr[idx+1].string!
//                                    let resultZeroString = resultArr[idx+1].string!.substring(to: resultArr[idx+1].string!.index(after: resultArr[idx+1].string!.startIndex))
//                                    if resultZeroString == "-"{
//                                        self.resultZeroCollection?[idx].textColor = UIColor.red
//                                    }
//                                    self.resultZeroCollection?[idx].text = resultArr[idx+1].string!
//                                    if idx < 2 {
//                                        self.majorOneCollection?[idx].text = arrTitle[idx+6].string!
//                                        self.needOneCollection?[idx].text = needArr[idx+7].string!
//                                        self.getOneCollection?[idx].text = getArr[idx+7].string!
//                                        self.resultOneCollection?[idx].text = resultArr[idx+7].string!
//                                        let resultOneString = resultArr[idx+7].string!.substring(to: resultArr[idx+7].string!.index(after: resultArr[idx+7].string!.startIndex))
//                                        if resultOneString == "-"{
//                                            self.resultOneCollection?[idx].textColor = UIColor.red
//                                        }
//                                    }
//                                }
//                                
//                                self.needTwoLabel.text = needArr[10].string!
//                                self.getTwoLabel.text = getArr[10].string!
//                                self.resultTwoLabel.text = resultArr[10].string!
//                                let resultTwoString = resultArr[10].string!.substring(to: resultArr[10].string!.index(after: resultArr[10].string!.startIndex))
//                                if resultTwoString == "-"{
//                                    self.resultTwoLabel.textColor = UIColor.red
//                                }
                                
                                progressHUD.hide()

                            }
            }
        )
    }
    
    func subStringMajorTitle(title:String)->String{
        return title.substring(to: title.index(title.endIndex, offsetBy: -2));
    }

}

