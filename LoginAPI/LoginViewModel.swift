//
//  LoginViewModel.swift
//  RxAlamofire
//
//  Created by user on 2023/01/23.
//

import Foundation
import RxSwift
import RxRelay
class LoginViewModel {
    
    static let shared = LoginViewModel()
    
    private init() {
        
    }
    
    //var userInfo: Observable<LoginInfo>?
    //var userInfo2 = PublishSubject<LoginInfo>()
    var userInfo2 = PublishRelay<(StatusCode: Int, LoginInfo)>()
    
    var message = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    func login(email: String, password: String) {
        print(#file,#function)
//        LoginAPI.login(email: email, password: password)
//            .debug("LoginVM")
//            .bind(to: userInfo2)
//            .disposed(by: disposeBag)
        
        LoginAPI.login(email: email, password: password)
            .debug("LoginVM")
            .subscribe { info in
                print("lgin")
                self.userInfo2.accept(info)
            }
            .disposed(by: disposeBag)
    }
    
    func register(name: String, email: String, password: String) {
        print(#file,#function)
        LoginAPI.register(name: name, email: email, password: password)
            .debug()
            .bind(to: userInfo2)
            .disposed(by: disposeBag)
    }
    
    func tokenRefresh(refreshToken: String) {
        LoginAPI.tokenRefresh(refreshToken: refreshToken)
            .debug()
            .bind(to: userInfo2)
            .disposed(by: disposeBag)
    }
    
    func logout(accessToken: String) {
        LoginAPI.logout(accessToken: accessToken)
            .debug()
            .map{ $0 }
            .bind(to: message)
            .disposed(by: disposeBag)
    }
}
