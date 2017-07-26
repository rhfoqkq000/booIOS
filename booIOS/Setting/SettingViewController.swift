//
//  SettingViewController.swift
//  booIOS
//
//  Created by candy on 2017. 7. 24..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

struct SettingCtrls {
    let push = "PushViewController"
    let developer = "DeveloperViewController"
    let version = "VersionViewController"
}


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let titles = ["문의하기", "푸쉬알림", "약관 및 정책", "오픈소스", "앱 정보", "개발자정보"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //    테이블 행수 얻기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    //    셀 내용 변경하기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingTableCell") as! SettingTableViewCell
        cell.settingLabel.text = titles[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctrls = SettingCtrls()
        switch indexPath.row {
        case 0:
            let answerMail = "npe.dongauniv@gmail.com"
            let url = URL(string: "mailto:\(answerMail)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break
        case 1:
            navigationController?.pushViewController(returnTargetCtrl(ctrls.push), animated: true)
            break
        case 2:
            UIApplication.shared.open(NSURL(string: "https://www.dongaboomin.xyz:20433/privacy")! as URL)
            break
        case 3:
            break
        case 4:
            navigationController?.pushViewController(returnTargetCtrl(ctrls.version), animated: true)
            break
        case 5:
            navigationController?.pushViewController(returnTargetCtrl(ctrls.developer), animated: true)
            break
        default:
            print("읭?")
            break
        }
    }
    func returnTargetCtrl(_ idendtifier:String) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: idendtifier)
        
    }
}
