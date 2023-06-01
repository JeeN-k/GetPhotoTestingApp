//
//  FavoritesCellViewModel.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import Foundation

struct FavoritesCellViewModel {
    let imageData: Data
    let query: String
    
    init(imageModel: ImageModel) {
        self.imageData = imageModel.imageData
        self.query = imageModel.query
    }
}
