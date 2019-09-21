//
//  APIClient.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/08/04.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

struct APIClient {
    
    /// API Request
    static func request<T: APIRequest>(request: T) -> Promise<Decodable> {
        
        return Promise<Decodable> { resolver in
            
            // 端末の通信状態をチェック
            if !isReachable() {
                resolver.reject(APIError.connectionError)
                return
            }
            
            guard let urlRequest = request.makeURLRequest() else {
                resolver.reject(APIError.invalidRequest)
                return
            }
            print("urlRequest: \(urlRequest)")
            Alamofire.request(urlRequest).validate(statusCode: 200 ..< 300).responseData { dataResponse in
                
                // エラーチェック
                if let error = dataResponse.result.error {
                    let apiError = errorToAPIError(error: error, statusCode: dataResponse.response?.statusCode)
                    resolver.reject(apiError)
                    return
                }
                
                // レスポンスデータのnilチェック
                guard let responseData = dataResponse.result.value else {
                    resolver.reject(APIError.invalidResponse)
                    return
                }
                
                let result = self.decode(responseData: responseData, request: request)
                resolver.resolve(result.value, result.error)
            }
        }
    }
}

extension APIClient {
    
    /// ネットワーク状態をチェックする
    ///
    /// - Returns: true: ホストに接続成功, false: ホストに接続失敗
    private static func isReachable() -> Bool {
        if let reachabilityManager = NetworkReachabilityManager() {
            reachabilityManager.startListening()
            return reachabilityManager.isReachable
        }
        return false
    }
    
    /// ErrorをAPIErrorに変換する
    private static func errorToAPIError(error: Error, statusCode: Int?) -> APIError {
        print("HTTP status code:\(String(describing: statusCode))")
        if let error = error as? URLError {
            if error.code == .timedOut {
                print("timed out.")
                return .connectionError
            }
            if error.code == .notConnectedToInternet {
                print("Not connected to internet.")
                return .connectionError
            }
        }
        print("dataResponse.result.error:\(error)")
        return .others(error: error, statusCode: statusCode)
    }
    
    /// レスポンスデータをデコードする
    ///
    /// - Parameters:
    ///   - responseData: レスポンスデータ
    ///   - request: APIRequest
    /// - Returns: Promise<Decodable>
    private static func decode<T: APIRequest>(responseData: Data, request: T) -> Promise<Decodable> {
        return Promise<Decodable> { resolver in
            
            if let object = request.decode(data: responseData) {
                print("response:\(object)")
                resolver.fulfill(object)
                return
            }
            
            if let apiErrorObject = request.decode(errorResponseData: responseData) {
                print("apiErrorObject:\(apiErrorObject)")
                resolver.reject(APIError.errorResponse(errObject: apiErrorObject))
                return
            }
            
            print("Decoding failure.")
            resolver.reject(APIError.decodeError)
        }
    }
}
