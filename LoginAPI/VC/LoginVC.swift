//
//  LoginVC.swift
//  LoginAPI
//
//  Created by user on 2023/01/26.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var tokenLabel: UILabel!
    
    var name: String = ""
    
    var email: String = ""
    
    var accessToken: String = ""
    
    var refreshToken: String = ""
    
    let manager = LoginViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "name: \(name)"
        
        emailLabel.text = "email: \(email)"
        
        tokenLabel.text = "refreshToken: \(refreshToken)"
        
//        manager.userInfo2.compactMap{$0.1.data?.token?.refreshToken}
//            .bind(to: tokenLabel.rx.text)
        manager.message
            .debug()
            .subscribe{ msg in
                self.view.makeToast(msg)
        }
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        manager.logout(accessToken: accessToken)
    }
    
    @IBAction func refreshTokenBtnTapped(_ sender: Any) {
        manager.tokenRefresh(refreshToken: refreshToken)
    }
}
