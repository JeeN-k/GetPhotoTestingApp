//
//  MockDataProvider.swift
//  GetPhotoTestingAppTests
//
//  Created by user on 31.05.2023.
//

import XCTest
@testable import GetPhotoTestingApp

final class MockDataProvider: DataProviderProtocol {

    private(set) var fetchImageCallCount = 0
    private(set) var fetchImagePromt: [String] = []
    private(set) var fetchImageCompletion: [(Result<Data, RequestErrors>) -> Void] = []
    
    private(set) var fetchFavoritesCallCount = 0
    private(set) var fetchFavoritesCompletion: [([ImageModel]) -> Void] = []
    
    private(set) var saveImageModelCallCount = 0
    private(set) var saveImageModelModel: [ImageModel] = []
    private(set) var saveImageModelCompletion: [(Bool) -> Void] = []
    
    private(set) var removeImageFromFavoritesCallCount = 0
    private(set) var removeImageFromFavoritesModel: [ImageModel] = []
    
    private(set) var removeLatestImageCallCount = 0
    
    
    func fetchImage(imagePromt: String, completion: @escaping ((Result<Data, RequestErrors>) -> Void)) {
        fetchImageCallCount += 1
        fetchImagePromt.append(imagePromt)
        fetchImageCompletion.append(completion)
    }
    
    func fetchFavorites(_ completion: @escaping (([ImageModel]) -> Void)) {
        fetchFavoritesCallCount += 1
        fetchFavoritesCompletion.append(completion)
    }
    
    func saveImageModel(with imageModel: ImageModel, completion: @escaping ((Bool) -> Void)) {
        saveImageModelCallCount += 1
        saveImageModelModel.append(imageModel)
        saveImageModelCompletion.append(completion)
    }
    
    func removeImageFromFavorites(imageModel: ImageModel) {
        removeImageFromFavoritesCallCount += 1
        removeImageFromFavoritesModel.append(imageModel)
    }
    
    func removeLatestImage() {
        removeLatestImageCallCount += 1
    }
}
