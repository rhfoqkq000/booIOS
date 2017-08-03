//
//  LoginViewController.swift
//  Boo2
//
//  Created by pmkjkr on 2017. 7. 5..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import CoreTelephony
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var toEmptyButton: UIButton!
    
    @IBOutlet weak var centerView: UIView!
    let userDefaults = UserDefaults.standard
    
    let con = Constants()
    
    @IBAction func loginActionButton(_ sender: Any) {
        getJSON(idTextField.text!, pwTextField.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if userDefaults.string(forKey: "stuId") != nil && (userDefaults.string(forKey:"stuPw") != nil){
            getJSON(userDefaults.string(forKey: "stuId")!, userDefaults.string(forKey: "stuPw")!)
        }

        idTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        pwTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        toEmptyButton.layer.cornerRadius = 20;
        // Do any additional setup after loading the view.
       
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getJSON(_ id:String, _ pw:String){
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/login"
        let parameters = ["stuId":id, "stuPw":pw]
        let queue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
        var loginIsSuccess = ""
        Alamofire.request(todoEndpoint, method: .post, parameters:parameters, encoding:JSONEncoding(options:[])).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    loginIsSuccess = json["result_code"].stringValue
                                    
                                    //이미 앱 내부에 저장된 ID, PW값 유무를 판별해서 없으면 앱 내부에 저장, 있으면 그냥 넘어감
                                    if self.userDefaults.string(forKey: "stuId") != nil {
                                        print("값이 있음")
                                    }else{
                                        self.userDefaults.set(id, forKey:"stuId")
                                        self.userDefaults.set(pw, forKey:"stuPw")
                                        self.userDefaults.set(json["result_body"]["id"].stringValue, forKey: "id")
                                    }
                                    
                                    if self.userDefaults.object(forKey: "deviceInserted") == nil{
                                        print("디바이스 정보 입력 안된듯;")
                                        let device_id = UIDevice.current.identifierForVendor!.uuidString
                                        let os_enum = "IOS"
                                        let model = UIDevice.current.modelName
                                        let tOperator = CTTelephonyNetworkInfo().subscriberCellularProvider?.carrierName
                                        let systemVersion = UIDevice.current.systemVersion
                                        let token = InstanceID.instanceID().token()!
                                        print(token)
                                        let normalId = json["result_body"]["id"].stringValue
                                        
                                                                            print("device_id : \(device_id), os_enum : \(os_enum), model : \(model), operator : OK, api_level : \(systemVersion), push_service_id : \(token), normal_user_id : \(normalId)")
                                        
                                        let deviceInsertTodoEndpoint: String = "https://www.dongaboomin.xyz:20433/deviceInsert"
                                        let deviceInsertParameters = ["device_id":device_id, "os_enum":os_enum, "model":model, "operator":"YOO JEONG", "api_level":systemVersion, "push_service_id":token, "normal_user_id":normalId]
                                        let deviceInsertQueue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
                                        Alamofire.request(deviceInsertTodoEndpoint, method: .post, parameters: deviceInsertParameters, encoding: JSONEncoding(options:[])).validate()
                                            .responseJSON(queue: deviceInsertQueue,
                                                          completionHandler : { response in
                                                            
                                                            switch response.result{
                                                            case .success(let value):
                                                                let json = JSON(value)
                                                                if json["result_code"] == 1{
                                                                    self.userDefaults.set(22, forKey: "deviceInserted")
                                                                    print("욧시 디바이스정보가들어갔어")
                                                                    
                                                                }else{
                                                                    print("result code not matched")
                                                                }
                                                            case .failure(let error):
                                                                self.con.toastText("불러오기 실패")
                                                                print(error)
                                                            }
                                                            
                                                            DispatchQueue.main.async {
                                                                
                                                            }
                                            }
                                        )

                                    }else{
                                        print("디바이스 정보 입력된것갓은디;;")
                                        let device_id = UIDevice.current.identifierForVendor!.uuidString
                                        let token = InstanceID.instanceID().token()!
                                        let deviceUpdateTodoEndpoint: String = "https://www.dongaboomin.xyz:20433/deviceUpdate"
                                        let deviceUpdateParameters = ["device_id":device_id, "push_service_id":token]
                                        let deviceUpdateQueue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
                                        Alamofire.request(deviceUpdateTodoEndpoint, method: .post, parameters: deviceUpdateParameters, encoding: JSONEncoding(options:[])).validate()
                                            .responseJSON(queue: deviceUpdateQueue,
                                                          completionHandler : { response in
                                                            
                                                            switch response.result{
                                                            case .success(let value):
                                                                let json = JSON(value)
                                                                if json["result_code"] == 1{
                                                                    self.userDefaults.set(22, forKey: "deviceInserted")
                                                                    print("욧시 디바이스 정보가 고쳐졌어")
                                                                    
                                                                }else{
                                                                    print("result code not matched")
                                                                }
                                                            case .failure(let error):
                                                                self.con.toastText("불러오기 실패")
                                                                print(error)
                                                            }
                                                            
                                                            DispatchQueue.main.async {
                                                                
                                                            }
                                            }
                                        )
                                    }

                                }else{
                                    self.con.toastText("로그인 실패")
                                }

                            case .failure(let error):
                                print(error)
                                self.con.toastText("로그인 실패")
                            }
                            
                            DispatchQueue.main.async {
                                //UI 업데이트는 여기
//                                self.tableview.reloadData()
                                if loginIsSuccess == "1"{
                                    self.performSegue(withIdentifier: "loginSeque", sender: self)
                                }else{
                                    print("로그인 실패")
                                    self.con.toastText("로그인 실패")
                                }
                            
                            }
            }
        )
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        print("textFieldShouldReturn")
        loginActionButton((Any).self)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
}
