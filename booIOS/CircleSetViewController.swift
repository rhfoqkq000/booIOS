//
//  CircleSetViewController.swift
//  booIOS
//
//  Created by 정록헌 on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import Toaster

class CircleSetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var sectionButton: UIButton!
    @IBOutlet var CircleChangeTableView: UITableView!
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    
    @IBOutlet var updateCircleButton: UIButton!
    
    var result_body:JSON = [:]
    
    let userDefaults = UserDefaults()
    
    let con = Constants()
    
    let sectionsDropDownConfigure = DropDown()
    let majorDropDownConfigure = DropDown()
    
    let sections = ["경영대학", "사회과학대학"]
    let manage = ["경영학과", "국제관광학과", "국제무역학과", "경영정보학과"]
    let society = ["정치외교학과", "행정학과", "사회학과", "사회복지학과", "미디어커뮤니케이션학과","경제학과", "금융학과"]
    
    var majorList:[[String]] = []
    
    override func viewDidLoad() {
        majorList.append(manage)
        majorList.append(society)
        super.viewDidLoad()
        CircleChangeTableView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result_body.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CircleChangeCell", for: indexPath) as! CircleChangeViewCell
        cell.circleNameLabel.text = result_body[indexPath.row]["name"].stringValue
        cell.tag = result_body[indexPath.row]["id"].intValue
        return cell
    }
    
    @IBAction func majorDropDownAction(_ sender: Any) {
        let titleText = sectionButton.titleLabel?.text
        switch titleText! {
        case "경영대학":
            dropDownConfigure(dropDownConfigure: majorDropDownConfigure, button: majorButton, datasource: manage)
            break;
        case "사회과학대학":
            dropDownConfigure(dropDownConfigure: majorDropDownConfigure, button: majorButton, datasource: society)
            break;
        default:
            break;
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
            print(cell.tag)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
        
    }
    func getCircleNameJSON(targetMajor major : String ){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getCircle?major=\(major)"
        let todoEndpointEscapes = todoEndpoint.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let queue = DispatchQueue(label: "xyz.dongaboomin.getCircle", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpointEscapes!, method: .get).validate()
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
                                self.con.toastText("불러오기 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                self.CircleChangeTableView.reloadData()
                            }
            }
        )
    }
    
    @IBAction func sectionDropDownAction(_ sender: Any) {
        sectionsDropDownConfigure.anchorView = sectionButton
        sectionsDropDownConfigure.dataSource = sections
        sectionsDropDownConfigure.selectionAction = {[unowned self] (index,item) in
            self.sectionButton.setTitle(item, for: UIControlState.normal)
            self.majorButton.setTitle(self.majorList[index][0], for: UIControlState.normal)
        }
        sectionsDropDownConfigure.show()
        majorButton.isHidden = false
        searchButton.isHidden = false
        
    }
    func dropDownConfigure(dropDownConfigure conf:DropDown,button btn:UIButton,datasource list:Array<String>) {
        conf.anchorView = btn
        conf.dataSource = list
        conf.selectionAction = {(index,item) in
            btn.setTitle(item, for: UIControlState.normal)
        }
        conf.show()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        let majorText = majorButton.titleLabel?.text
        getCircleNameJSON(targetMajor: majorText!)
    }
    
    @IBAction func updateCircleButtonAction(_ sender: Any) {
        let rows = self.CircleChangeTableView.indexPathsForSelectedRows?.map{$0.row}
        var news = [Int]()
        if rows != nil {
            let user_id = userDefaults.string(forKey: "id")
            for row in rows! {
                let cell = self.CircleChangeTableView.cellForRow(at: IndexPath(row: row, section: 0))
                news.append(cell!.tag)
            }
            //            print(user_id)
            postSetCircleJSON(user_id: user_id!, news)
        } else {
            con.toastText("동아리/학회를 선택하세요")
        }
    }
    
    
    func postSetCircleJSON(user_id id:String,_ circles:[Int]){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/setCircle"
        let parameters = ["user_id":id,"circles":circles] as [String : Any]
        let queue = DispatchQueue(label: "xyz.dongaboomin.setCirlce", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters, encoding:JSONEncoding(options:[])).validate()
            
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    //                                    self.con.toastText("성공!")
                                }else{
                                    print("HomeViewController getJSON result code not matched")
                                    self.con.toastText("불러오기 실패")
                                }
                                
                            case .failure(let error):
                                self.con.toastText("아마도 서버가 맛간듯..")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                progressHUD.hide()
                                self.performSegue(withIdentifier: "mainSegue", sender: self)
                            }
            }
        )
    }
}

