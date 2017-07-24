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
    
    let sectionTitle = ["메뉴", "설정", "로그인/로그아웃"]
    let menuIcon = ["emptIcon","profIcon", "leIcon","siteIcon"]
    let settingIcon = ["noticeIcon", "changeIcon", "helpIcon"]
    let logIcon = ["logoutIcon", "crownIcon"]
    
    let menuTitle = ["빈강", "To. 교수님", "쪽지함", "사이트"]
    let settingTitle = ["공지사항","동아리/학회 변경", "설정/도움말"]
    let logTitle = ["로그아웃", "관리자로그인"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 3
        case 2:
            return 2
        default:
            print("??")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! HeaderCollectionReusableView
            
            headerView.headerTitle.text = sectionTitle[indexPath.section]
            reusableview = headerView
        }
         return reusableview
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollection", for: indexPath) as! MenuCollectionViewCell
        
        if indexPath.section==0 {
            cell.menuImage.image = UIImage(named: menuIcon[indexPath.row])
            cell.menuLabel.text = menuTitle[indexPath.row]
        } else if(indexPath.section==1){
            cell.menuImage.image = UIImage(named: settingIcon[indexPath.row])
            cell.menuLabel.text = settingTitle[indexPath.row]
        }else {
            cell.menuImage.image = UIImage(named: logIcon[indexPath.row])
            cell.menuLabel.text = logTitle[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ctrls = Ctrls()
        switch indexPath.section {
        case 0:
            switch indexPath.row{
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
            default:
                break
            }
            break
        case 1:
            switch  indexPath.row {
            case 0:
                self.navigationController?.pushViewController(returnTargetCtrl(ctrls.notice),animated: true)
                break
            default:
                break
            }
          break
        case 2:
            break
        default:
            print("오류에영")
        }
    }
    
    func returnTargetCtrl(_ idendtifier:String) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: idendtifier)

    }
}
