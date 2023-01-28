//
//  ViewController.swift
//  LoginAPI
//
//  Created by user on 2023/01/23.
//

import UIKit
import RxAlamofire
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let manager = LoginViewModel.shared
    
    let disposeBag = DisposeBag()
    
    var statusCode: Int = 0
    
    var userInfo: [String:String] = ["name":"", "email":"", "refreshToken":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = "adgagsag23@naver.com"
        passwordTextField.text = "password1414"
        
        setBinding()
    }
    
    func setBinding() {
        //        manager.userInfo2
        //            .debug("MVC")
        //            .compactMap{ $1.message }
        //            .subscribe{ message in
        //                print(message)
        //            }
        //            .disposed(by: disposeBag)
//        userInfo["name"] = "213"
//
//        manager.userInfo2
//            .compactMap{$0.0}
//            .subscribe { statusCode in
//                self.statusCode = statusCode
//            }
//            .disposed(by: disposeBag)
//
//        manager.userInfo2
//            .compactMap{$1.data}
//            .subscribe{ data in
//                self.userInfo["name"] = data.user?.name
//                self.userInfo["email"] = data.user?.email
//                self.userInfo["refreshToken"] = data.token?.refreshToken
//            }
//            .disposed(by: disposeBag)
        manager.userInfo2
            .map{$0}
            .subscribe{
            print("event On")
        }
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let emailString = emailTextField.text else {
            print("이메일을 입력해주세요")
            return
        }

        guard let passwordString = passwordTextField.text else {
            print("비밀번호를 입력해주세요")
            return
        }
        
        manager.login(email: emailString, password: passwordString)
        
        //statusCode가 200이면 화면이동
        //로그인 할때마다 한번씩 더실행됨
        manager.userInfo2
            .compactMap{$0}
            .subscribe { event in
                if event.0 == 200 {
                    print("pushVC")
                    let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    loginVc.accessToken = event.1.data?.token?.accessToken ?? ""
                    loginVc.refreshToken = event.1.data?.token?.refreshToken ?? ""
                    loginVc.name = event.1.data?.user?.name ?? ""
                    loginVc.email = event.1.data?.user?.email ?? ""
                    self.navigationController?.pushViewController(loginVc, animated: true)
                    
                } else {
                    print("loginNo")
                    self.view.makeToast(event.1.message)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        let registerVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(registerVc, animated: true)
    }

}

