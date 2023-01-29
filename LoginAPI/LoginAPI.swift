//
//  LoginAPI.swift
//  RxAlamofire
//
//  Created by user on 2023/01/23.
//

import Foundation
import RxAlamofire
import RxSwift
import Alamofire

enum LoginAPI {
    enum ApiError : Error {
        
        case decodingError
        
        var info : String {
            switch self {
            case .decodingError:
                return "디코딩 에러입니다."
            }
        }
    }

    static let disposeBag = DisposeBag()
    
    static func register(name: String, email: String, password: String) -> Observable<(StatusCode: Int,LoginInfo)> {
        let request = AuthRouter.register(name: name, email: email, password: password)
        return RxAlamofire.requestData(request)
            .map { (response, data) -> (Int, LoginInfo) in
                do {
                    let info = try JSONDecoder().decode(LoginInfo.self, from: data)
                    return (response.statusCode, info)
                } catch {
                    throw ApiError.decodingError
                }
            }
//        let requestUrl = URL(string: baseUrl + "/user/register")
//        guard let url = requestUrl else { return Observable.empty() }
//        return RxAlamofire.requestData(.post, url, parameters: ["name":name, "email":email, "password":password], encoding: JSONEncoding.default, headers: ["accept":"application/json", "Content-Type":"application/json"])
//            .map{ (response, data) -> LoginInfo in
//                do {
//                    let info = try JSONDecoder().decode(LoginInfo.self, from: data)
//                    return info
//                } catch {
//                    print("catch")
//                    throw ApiError.decodingError
//                }
//            }
    }
    
    static func login(email: String, password: String) -> Observable<(StatusCode: Int,LoginInfo)> {
        print(#function)
        let request = AuthRouter.login(email: email, password: password)
        return RxAlamofire.requestData(request)
            .map { (response, data) -> (Int, LoginInfo) in
                do {
                    let info = try JSONDecoder().decode(LoginInfo.self, from: data)
                    return (response.statusCode, info)
                } catch {
                    throw ApiError.decodingError
                }
            }
            
    }
    
    static func logout(accessToken: String) -> Observable<(StatusCode: Int, LoginInfo)> {
        let request = AuthRouter.logout(acceseToken: accessToken)
        
        return RxAlamofire.requestData(request)
            .map { (response, data) -> (Int, LoginInfo) in
                do {
                    let info = try JSONDecoder().decode(LoginInfo.self, from: data)
                    return (response.statusCode, info)
                } catch {
                    throw ApiError.decodingError
                }
            }
    }
    
    static func tokenRefresh(refreshToken: String) -> Observable<(StatusCode: Int, LoginInfo)> {
        let request = AuthRouter.tokenRefresh(refreshToken: refreshToken)
        
        return RxAlamofire.requestData(request)
            .map { (response, data) -> (Int, LoginInfo) in
                do {
                    let info = try JSONDecoder().decode(LoginInfo.self, from: data)
                    return (response.statusCode, info)
                } catch {
                    throw ApiError.decodingError
                }
            }
    }
}
