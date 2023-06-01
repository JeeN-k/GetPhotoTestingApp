//
//  ImageModel.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import Foundation

struct ImageModel {
    var id: UUID = UUID()
    var imageData: Data
    var saveDate: Date
    var query: String
}
