//
//  AuthRouter.swift
//  LoginAPI
//
//  Created by user on 2023/01/26.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case login(email: String, password: String)
    case register(name:String, email: String, password: String)
    case logout(acceseToken:String)
    case tokenRefresh(refreshToken:String)
    
    var baseURL: URL {
        return URL(string: "https://phplaravel-574671-2962113.cloudwaysapps.com/api/v1")!
    }
    
    var method: HTTPMethod {
        switch self {
        
        case .login: return .post
        case .register: return .post
            
        case .logout: return .post
        default: return .post
        }
    }
    
    var path: String {
        switch self {
        case .login: return "user/login"
        case .register: return "user/register"
        case .logout: return "user/logout"
        case .tokenRefresh: return "user/token-refresh"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .login: return ["accept":"application/json", "Content-Type":"application/json"]
        case .register: return ["accept":"application/json", "Content-Type":"application/json"]
        case .logout(let accessToken): return ["accept":"application/json", "Authorization":"Bearer \(accessToken)"]
        case .tokenRefresh: return ["accept":"application/json", "Content-Type":"application/json"]
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .login(let email, let password): return ["email":email, "password":password]
        case .register(let name, let email, let password): return ["name":name, "email":email, "password":password]
        case .logout: return [:]
        case .tokenRefresh(let refreshToken): return ["refresh_token":refreshToken]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appending(path: path)
        var request = URLRequest(url: url)
        
        request.method = method
        
        request.headers = header
        
        request.httpBody = try JSONEncoding.default.encode(request, with: parameter).httpBody
        
        return request
    }
    
}
