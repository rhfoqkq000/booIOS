//
//  AttendLetterViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class AttendLetterViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         tableview.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //    테이블 행수 얻기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //    셀 내용 변경하기(tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //      view round처리
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendLetter")! as! AttendLetterCell
        cell.attendLetterMainView.layer.cornerRadius = 8
        cell.attendLetterSubView.viewroundCorners(corners: [.topLeft,.bottomLeft], radius: 8)
        
        return cell
    }
    
}
