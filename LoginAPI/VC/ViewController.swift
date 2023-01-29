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
    
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    
    let manager = LoginViewModel.shared
    
    let disposeBag = DisposeBag()
    
    var statusCode: Int = 0
    
    var userInfo: [String:String] = ["name":"", "email":"", "refreshToken":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = "adgagsag23@naver.com"
        passwordTextField.text = "password1414"
        
        setBinding()
        
        autoLoginSwitch.isOn = UserDefaults.standard.bool(forKey: "autoLogin")
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
//        manager.userInfo2
//            .map{$0}
//            .subscribe{
//            print("event On")
//        }
        
        manager.loginInfo
            .compactMap{$0}
            .subscribe { event in
                //statusCode가 200이면 화면이동
                if event.0 == 200 {
                    
                    print("pushVC")
                    let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    loginVc.accessToken = event.1.data?.token?.accessToken ?? ""
                    loginVc.refreshToken = event.1.data?.token?.refreshToken ?? ""
                    loginVc.name = event.1.data?.user?.name ?? ""
                    loginVc.email = event.1.data?.user?.email ?? ""
                    self.navigationController?.pushViewController(loginVc, animated: true)
                    //자동로그인이 켜져있으면 사용자정보(토큰) 유저디폴트에 저장해두기
                    
                    if UserDefaults.standard.bool(forKey: "autoLogin") {
                        print("자동로그인 on")
                        
                        UserDefaults.standard.setValue(event.1.data?.token?.accessToken, forKey: "accessToken")
                        UserDefaults.standard.setValue(event.1.data?.token?.refreshToken, forKey: "refreshToken")
                    }
                    
                } else {
                    print("loginNo")
                    self.view.makeToast(event.1.message)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        let emailString = emailTextField.text ?? ""

        let passwordString = passwordTextField.text ?? ""
        
        manager.login(email: emailString, password: passwordString)
    }
    
    @IBAction func autoLoginSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(autoLoginSwitch.isOn, forKey: "autoLogin")
        print(UserDefaults.standard.bool(forKey: "autoLogin"))
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        let registerVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(registerVc, animated: true)
    }
}

