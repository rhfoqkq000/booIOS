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

        print("로그인 시작부분이야")
        
        if userDefaults.string(forKey: "stuId") != nil && (userDefaults.string(forKey:"stuPw") != nil) && (userDefaults.string(forKey: "id") != nil){
            let progressHUD = ProgressHUD(text: "로딩 중입니다...")
            self.view.addSubview(progressHUD)
            progressHUD.show()
            let device_id = UIDevice.current.identifierForVendor!.uuidString
            let token = InstanceID.instanceID().token()!
            let deviceUpdateTodoEndpoint: String = "https://www.dongaboomin.xyz:20433/deviceUpdate"
            let deviceUpdateParameters = ["device_id":device_id, "push_service_id": token]
            let deviceUpdateQueue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
            var isUpdated = 0
            Alamofire.request(deviceUpdateTodoEndpoint, method: .post, parameters: deviceUpdateParameters, encoding: JSONEncoding(options:[])).validate()
                .responseJSON(queue: deviceUpdateQueue,
                              completionHandler : { response in
                                
                                switch response.result{
                                case .success(let value):
                                    let json = JSON(value)
                                    if json["result_code"] == 1{
                                        self.userDefaults.set(22, forKey: "deviceInserted")
                                        isUpdated = 1
                                        print("욧시 로그인 없이 디바이스 정보가 고쳐졌어")
                                        
                                    }else{
                                        self.con.toastText("로그인 실패")
                                        print("result code not matched")
                                    }
                                case .failure(let error):
                                    self.con.toastText("로그인 실패")
                                    print(error)
                                }
                                
                                DispatchQueue.main.async {
                                    progressHUD.hide()
                                    if isUpdated == 1{
                                        self.performSegue(withIdentifier: "loginSeque", sender: self)
                                    }else{
                                        print("isUpdated not matched")
                                        self.con.toastText("로그인 실패")
                                    }
                                    
                                }
                }
            )
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
    
    
    func getUserCircle(_ id:String, _ pw:String,_ loginIsSuccess:String) {
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/getUserCircle"
        let parameters = ["user_id":id]
        var isGetUserCirlce = 0
        let queue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .post, parameters:parameters, encoding:JSONEncoding(options:[])).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    let result_body = json["result_body"]
                                    if result_body.count == 0{
                                        isGetUserCirlce = 1
                                    }
                                }else{
                                    print("getUserCircle-Login result code not matched")
                                    self.con.toastText("불러오기 실패")
                                }
                            case .failure(let error):
                                self.con.toastText("불러오기 실패")
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                if isGetUserCirlce == 0 {
                                    if loginIsSuccess == "1"{
                                        self.performSegue(withIdentifier: "loginSeque", sender: self)
                                    }else{
                                        print("로그인 실패")
                                        self.con.toastText("로그인 실패")
                                    }
                                } else {
                                    self.performSegue(withIdentifier: "circleSetSegue", sender: self)
                                }
                            }
            }
        )
    }

    

    func getJSON(_ id:String, _ pw:String){
        let progressHUD = ProgressHUD(text: "로딩 중입니다...")
        self.view.addSubview(progressHUD)
        progressHUD.show()
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
//                                        let tOperator = CTTelephonyNetworkInfo().subscriberCellularProvider?.carrierName
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
                                                                    
                                                                    self.getUserCircle(self.userDefaults.string(forKey: "id")!,pw,loginIsSuccess)

                                                                    
                                                                    
                                                                }else if json["result_code"] == 2{
                                                                    self.getUserCircle(self.userDefaults.string(forKey: "id")!,pw,loginIsSuccess)

                                                                    print("디바이스 정보 입력 후의 result code not matched")
                                                                }else{
                                                                                                                                        self.con.toastText("로그인 실패")
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
                                                                    
                                                                    
                                                                    self.getUserCircle(self.userDefaults.string(forKey: "id")!,pw,loginIsSuccess)

                                                                    
                                                                    
                                                                }else{
                                                                    self.con.toastText("로그인 실패! 앱을 재실행해주세요.")
                                                                    print("디바이스 정보 고쳐지고 나서 result code not matched")
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
                                    print("비밀번호 틀린것같음")
                                    self.con.toastText("로그인 실패")
                                }

                            case .failure(let error):
                                print(error)
                                self.con.toastText("로그인 실패")
                            }
                            
                            DispatchQueue.main.async {
                                //UI 업데이트는 여기
                                print("UIUPDATE START")
                                progressHUD.hide()
//                                self.getUserCircle(self.userDefaults.string(forKey: "id")!,pw,loginIsSuccess)

                            
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
