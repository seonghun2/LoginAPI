//
//  LoginVC.swift
//  LoginAPI
//
//  Created by user on 2023/01/26.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var tokenLabel: UILabel!
    
    var name: String = ""
    
    var email: String = ""
    
    var accessToken: String = ""
    
    var refreshToken: String = ""
    
    let manager = LoginViewModel.shared
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        nameLabel.text = "name: \(name)"
        
        emailLabel.text = "email: \(email)"
        
        tokenLabel.text = "refreshToken: \(refreshToken)"
       
        manager.refreshToken
            .bind(to: tokenLabel.rx.text)
            .disposed(by: disposeBag)
        
        manager.refreshToken
            .compactMap{$0}
            .subscribe{ token in
                self.refreshToken = token
            }
            .disposed(by: disposeBag)
        
        manager.logoutInfo
            .compactMap{ $0.0 }
            .subscribe { statuscode in
                if statuscode == 200 {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        manager.tokenRefreshInfo
            .compactMap{ $0 }
            .subscribe { statuscode, info in
                if statuscode == 200 {
                    self.refreshToken = (info.data?.token?.refreshToken)!
                    self.accessToken = (info.data?.token?.accessToken)!
                }
            }//.disposed(by: disposeBag) 안해주면 무슨문제?
        
        manager.tokenRefreshInfo
            .compactMap{ $0.1.data?.token?.refreshToken }
            .bind(to: tokenLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        manager.logout(accessToken: accessToken)
        
    }
    
    @IBAction func refreshTokenBtnTapped(_ sender: Any) {
        manager.tokenRefresh(refreshToken: refreshToken)

    }
}
