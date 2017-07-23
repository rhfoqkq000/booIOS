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
    
    @IBOutlet var needTwoLabel: UILabel!
    @IBOutlet var getTwoLabel: UILabel!
    @IBOutlet var resultTwoLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    var result_body:JSON = [:]
    
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
        let parameters: Parameters = ["stuId": userDefaults.string(forKey:"stuId")!,"stuPw":userDefaults.string(forKey:"stuPw")!]
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getGraduated"
        let queue = DispatchQueue(label: "xyz.dongaboomin.seat", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                self.result_body = json["result_body"]
                                
                            case .failure(let error):
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                let info = self.result_body["info"]
                                self.dualMajor.text = info["multi"].string!
                                self.applyYear.text = info["year"].string!
                                self.earlyGrauated.text = info["early"].string!
                                self.subMajor.text = info["sub"].string!
                                self.avgGrade.text = info["avgGrade"].string!
                                self.masterCon.text = info["smart"].string!
                                
                                let arrTitle = self.result_body["title2"].array!
                                let needArr = self.result_body["need"].array!
                                let getArr = self.result_body["get"].array!
                                let resultArr = self.result_body["pm"].array!
                                
                                
                                
                                for idx in 0...3{
                                    self.kyoZeroCollection?[idx].text = self.subStringMajorTitle(title: arrTitle[idx].string!)
                                    self.needZeroCollection?[idx].text = needArr[idx+1].string!
                                    self.getZeroCollection?[idx].text = getArr[idx+1].string!
                                    self.resultZeroCollection?[idx].text = resultArr[idx+1].string!
                                    if idx < 2 {
                                        self.majorOneCollection?[idx].text = arrTitle[idx+6].string!
                                        self.needOneCollection?[idx].text = needArr[idx+7].string!
                                        self.getOneCollection?[idx].text = getArr[idx+7].string!
                                        self.resultOneCollection?[idx].text = resultArr[idx+7].string!
                                    }
                                }
                                
                                self.needTwoLabel.text = needArr[10].string!
                                self.getTwoLabel.text = getArr[10].string!
                                self.resultTwoLabel.text = resultArr[10].string!
                                

                            }
            }
        )
    }
    
    func subStringMajorTitle(title:String)->String{
        return title.substring(to: title.index(title.endIndex, offsetBy: -2));
    }

}

