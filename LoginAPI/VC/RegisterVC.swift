//
//  RegisterVC.swift
//  LoginAPI
//
//  Created by user on 2023/01/26.
//

import UIKit
import Toast

class RegisterVC: UIViewController {
    
    let manager = LoginViewModel.shared

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //회원가입시 토스트 메세지(성공 or 실패)
        manager.registerInfo
            .compactMap{ $1.message }
            .subscribe{ msg in
                self.view.makeToast(msg)
            }
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        guard let emailString = emailTextField.text else {
            print("이메일을 입력해주세요")
            return
        }
        
        guard let passwordString = passwordTextField.text else {
            print("비밀번호를 입력해주세요")
            return
        }
        
        manager.register(name: "횡성훈", email: emailString, password: passwordString)
    }
}
