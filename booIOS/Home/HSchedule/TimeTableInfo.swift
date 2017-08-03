//
//  TimeTableInfo.swift
//  booIOS
//
//  Created by pmkjkr on 2017. 7. 24..
//  Copyright © 2017년 univ. All rights reserved.
//

import Foundation

class TimeTableInfo {
    var index = Int()//숫자
    var type = String()//노말은 3개, 비정상은 3개 아닌것
    var title = String()
    var startTime = Int()
    var endTime = Int()
    var room = String()
    var time = String()
    var day = String()
    
    func convertToDictionary() -> [String : Any] {
        let dic: [String: Any] = ["index":index, "type":type, "title":title, "startTime":startTime, "endTime":endTime, "room":room, "time":time, "day":day]
        return dic
    }
}
