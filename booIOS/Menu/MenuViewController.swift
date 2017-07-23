//
//  MenuViewController.swift
//  booIOS
//
//  Created by candy on 2017. 7. 21..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

struct Ctrls {
    let empty = "EmptyViewController"
    let prof = "profController"
    let notice = "NoticeController"
    let site = "SiteViewController"
}

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var menuCollection: UICollectionView!
    
    var images = ["emptIcon","profIcon", "leIcon", "siteIcon", "noticeIcon", "changeIcon", "helpIcon", "logoutIcon", "crownIcon"]
    var titles = ["빈강", "To. 교수님", "쪽지함", "사이트", "공지사항","동이라/학회 변경", "설정/도움말", "로그아웃", "관리자로그인"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollection", for: indexPath) as! MenuCollectionViewCell
        
        cell.menuImage.image = UIImage(named: images[indexPath.row])
        cell.menuLabel.text = titles[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ctrls = Ctrls()
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(returnTargetCtrl(ctrls.empty),animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(returnTargetCtrl(ctrls.prof),animated: true)
            break
        case 2:
            break
        case 3:
            self.navigationController?.pushViewController(returnTargetCtrl(ctrls.site),animated: true)
            break
        case 4:
            self.navigationController?.pushViewController(returnTargetCtrl(ctrls.notice),animated: true)
            break
        case 5:
            break
        case 6:
            break
        case 7:
            break
        case 8:
            break
        default:
            print("오류에영")
        }
    }
    
    func returnTargetCtrl(_ idendtifier:String) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: idendtifier)

    }
}
