//
//  QuandlAPIClient.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-20.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class QuandlAPIClient {
    
    typealias QuandlCompletionHandler = (String, [String: Any]?,NSError?) -> (Void)
    
    static let sharedClient = QuandlAPIClient()
    
    let kReasonForFailure = "reasonForFailure"
    let kHttpStatusCode = "httpStatusCode"

    var session = URLSession.shared
    
    private func performURLRequest(urlRequest: URLRequest, forCompanyName companyName: String, withCompletionHandler completion: @escaping QuandlCompletionHandler){
        
        //Perform Quandl API Request
        let _ = session.dataTask(with: urlRequest, completionHandler: {
            
            data, response, error in

            guard let httpResponse = response as? HTTPURLResponse else {
                
                var userInfoDict = [String: Any]()
                userInfoDict[self.kReasonForFailure] = "Failed to connect to the server, no HTTP status code obtained"

                let error = NSError(domain: "APIRequestError", code: 0, userInfo: userInfoDict)
                self.session.invalidateAndCancel()
                
                completion(companyName,nil, error)
                
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                
                var userInfoDict = [String: Any]()
                userInfoDict[self.kReasonForFailure] = "Connect to the server with a status code other than 200"
                userInfoDict[self.kHttpStatusCode] = httpResponse.statusCode
    
                let error = NSError(domain: "APIRequestError", code: 0, userInfo: userInfoDict)
                self.session.invalidateAndCancel()
                
                completion(companyName,nil, error)
                
                return
            }
            
            if (data != nil) {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    completion(companyName,jsonData, nil)
                } catch let error as NSError {
                    completion(companyName,nil, error)
                }
            } else {
                var userInfoDict = [String: Any]()
                userInfoDict[self.kReasonForFailure] = "Nil values obtained for JSON data"
                
                let error = NSError(domain: "APIRequestError", code: 0, userInfo: userInfoDict)
                
                completion(companyName,nil, error)
            }
            
        }).resume()
    }
    
    private func performURLRequest(withTicker ticker: String, withStartDate startDate: Date, withEndDate endDate: Date, withJSONTaskCompletionHandler completion: @escaping QuandlCompletionHandler){
        //Build Quandle API Requet
        let quandlAPIRequest = QuandlAPIRequest(withTickerSymbol: ticker, forStartDate: startDate, forEndDate: endDate, withDataBaseCode: "WIKI", withReturnFormat: .json)
        
        let urlRequest = quandlAPIRequest.getURLRequest()

        performURLRequest(urlRequest: urlRequest,forCompanyName: ticker, withCompletionHandler: completion)
    }
    
    var persistDataCompletionHandler: QuandlCompletionHandler = {
        
        companyName, jsonData, error in
        if(jsonData != nil){
            let jsonReader = JSONReader()
            jsonReader.saveQuandlData(forCompanyName: companyName, forJSONResponseDict: jsonData!)
        } else {
            print("An error occurred while attempting to get the JSON data: \(error!)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QuandlError"), object: nil)
        }
    }
    
    func performDataPersistAPIRequest(with ticker: String, startDate: Date, endDate: Date) {
        
        self.performURLRequest(withTicker: ticker, withStartDate: startDate, withEndDate: endDate, withJSONTaskCompletionHandler: self.persistDataCompletionHandler)
    }
    
}
