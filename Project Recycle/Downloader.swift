//
//  Downloader.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 29/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation

class Downloader {
    static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
