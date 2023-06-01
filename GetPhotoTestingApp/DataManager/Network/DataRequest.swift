//
//  DataRequest.swift
//  GetPhotoTestingApp
//
//  Created by user on 30.05.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol DataRequest {
    var baseUrl: String { get }
    var urlPath: String { get }
}

extension DataRequest {
    var baseUrl: String {
        return "https://dummyimage.com/150x200&text="
    }
}
