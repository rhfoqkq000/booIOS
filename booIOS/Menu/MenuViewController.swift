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
    let setting = "SettingViewController"
    let login = "loginViewController"
    let letter = "LetterViewController"
    let circleChange = "CircleChangeViewController"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false;
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
//                빈강
            case 0:
                self.navigationController?.pushViewController(returnTargetCtrl(ctrls.empty),animated: true)
                break
//                To. 교수님
            case 1:
                self.navigationController?.pushViewController(returnTargetCtrl(ctrls.prof),animated: true)
                break
//                쪽지함
            case 2:
                  self.navigationController?.pushViewController(returnTargetCtrl(ctrls.letter),animated: true)
                break
//                사이트
            case 3:
                UIApplication.shared.open(NSURL(string: "http://donga.ac.kr")! as URL)
                break
            default:
                break
            }
            break
        case 1:
            switch indexPath.row {
//                공지사항
            case 0:
                self.navigationController?.pushViewController(returnTargetCtrl(ctrls.notice),animated: true)
                break
            //    동아리/학회 변경
            case 1:
                self.navigationController?.pushViewController(returnTargetCtrl(ctrls.circleChange),animated: true)
                break
//                설정/도움말
            case 2:
                self.navigationController?.pushViewController(returnTargetCtrl(ctrls.setting),animated: true)
                break
            default:
                break
            }
          break
        case 2:
            switch indexPath.row{
//                로그아웃
            case 0:
//                id, pw 날리기
                let userDefaults = UserDefaults.standard
                
                userDefaults.removeObject(forKey: "stuId")
                userDefaults.removeObject(forKey: "stuPw")
                userDefaults.removeObject(forKey: "id")
                userDefaults.removeObject(forKey: "deviceInserted")
                userDefaults.removeObject(forKey: "isScheSaved")
//                userDefaults.removeObject(forKey: "privacyAgreement")
            
//                화면 바꾸기
                let trans = self.storyboard!.instantiateViewController(withIdentifier: ctrls.login)
                trans.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(trans, animated: true)
                
                break
//                관리자로그인
            case 1:
                UIApplication.shared.open(NSURL(string: "http://booadmin.xyz")! as URL)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    func returnTargetCtrl(_ idendtifier:String) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: idendtifier)

    }
}
