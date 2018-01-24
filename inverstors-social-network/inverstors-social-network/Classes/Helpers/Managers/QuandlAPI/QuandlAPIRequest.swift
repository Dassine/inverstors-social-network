//
//  QuandlAPIRequest.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-20.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class QuandlAPIRequest {
    
    enum ReturnFormat: String{
        case json
        case xml
        case csv
    }
    
    let apiKey = "wqLdeRyNDRAAsyzxgu4S"
    let baseURL = "https://www.quandl.com/api/v3/datasets"
    var startDate: Date
    var endDate: Date
    
    var dataBase_code = "WIKI"
    var tickerSymbol: String
    var returnFormat: ReturnFormat = .json
    
    init(withTickerSymbol tickerSymbol: String, forStartDate startDate: Date, forEndDate endDate: Date, withDataBaseCode dataBaseCode: String = "WIKI", withReturnFormat returnFormat: ReturnFormat = .json) {
    
        self.returnFormat = returnFormat
        self.dataBase_code = dataBaseCode
        self.tickerSymbol = tickerSymbol
        self.startDate = startDate
        self.endDate = endDate
    }

    private func getDataRequestURLString() -> String {
        //Build Quandl API Request URL
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDateStr = dateFormatter.string(from: self.startDate)
        let endDateStr = dateFormatter.string(from: self.endDate)
        
        let urlWithRequestParameters = "\(baseURL)/\(dataBase_code)/\(self.tickerSymbol)/data.\(returnFormat.rawValue)?start_date=\(startDateStr)&end_date=\(endDateStr)&api_key=\(apiKey)"
        
        return urlWithRequestParameters
    }

    func getURLRequest() -> URLRequest {
        let urlString = getDataRequestURLString()
        return URLRequest(url: URL(string: urlString)!)
    }
}
