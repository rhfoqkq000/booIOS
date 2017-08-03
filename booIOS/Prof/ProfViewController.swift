//
//  ProfViewController.swift
//  prof
//
//  Created by candy on 2017. 7. 4..
//  Copyright © 2017년 candy. All rights reserved.
//

import UIKit
import Alamofire

class ProfViewController: UITableViewController{

    @IBOutlet weak var tableview: UITableView!
        
    let sections = ["경영대학", "사회과학대학"]
    let manage = ["경영학과", "국제관광학과", "국제무역학과", "경영정보학과"]
    let society = ["정치외교학과", "행정학과", "사회학과", "사회복지학과", "미디어커뮤니케이션학과","경제학과", "금융학과"]
    
    var profData: [Int : [String]] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profData = [0 : manage, 1 : society]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
//    섹션정하기
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
//    섹선 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
//    섹션 디자인
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width:tableView.frame.width, height: 60))
        
        let label = UILabel()
        label.text = sections[section]
        label.frame = CGRect(x:0, y:15, width:view.frame.size.width, height: 25)
        label.textAlignment = NSTextAlignment.center
        view.addSubview(label)
        
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (profData[section]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prof") as! ProfCell
        
        cell.departmentName.text = profData[indexPath.section]![indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profDetail" {
            let indexPath = self.tableview.indexPathForSelectedRow
            let senderMajor = segue.destination as! ProfDetailViewController
            
            senderMajor.major = profData[(indexPath?.section)!]![(indexPath?.row)!]
            
        }
    }
    
    //    텍스트뷰 높이 자동 조절
    override func viewWillAppear(_ animated: Bool) {
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
    }
    
}
