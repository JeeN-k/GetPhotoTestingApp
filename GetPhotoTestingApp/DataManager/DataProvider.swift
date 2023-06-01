//
//  DataProvider.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import Foundation

protocol DataProviderProtocol {
    func fetchImage(imagePromt: String, completion: @escaping ((Result<Data, RequestErrors>) -> Void))
    func fetchFavorites(_ completion: @escaping (([ImageModel]) -> Void))
    func saveImageModel(with imageModel: ImageModel, completion: @escaping ((Bool) -> Void))
    func removeImageFromFavorites(imageModel: ImageModel)
    func removeLatestImage()
}

class DataProvider: DataProviderProtocol {
    private let networkService = NetworkService.instance
    private let coreDataService = CoreDataService.instance
    
    func fetchImage(imagePromt: String, completion: @escaping ((Result<Data, RequestErrors>) -> Void)) {
        if let imageModel = coreDataService.fetchByQuery(query: imagePromt) {
            completion(.success(imageModel.imageData))
            return
        }
        let imageRequest = ImageRequest(urlPath: imagePromt)
        networkService.request(imageRequest) { result in
            completion(result)
        }
    }
    
    func fetchFavorites(_ completion: @escaping (([ImageModel]) -> Void)) {
        coreDataService.fetchAllFavorites { models in
            completion(models)
        }
    }
    
    func saveImageModel(with imageModel: ImageModel, completion: @escaping ((Bool) -> Void)) {
        coreDataService.addFavoriteImage(imageModel: imageModel) { isSaved in
            completion(isSaved)
        }
    }
    
    func removeImageFromFavorites(imageModel: ImageModel) {
        coreDataService.removeImageFromFavorites(imageModel: imageModel)
    }
    
    func removeLatestImage() {
        coreDataService.removeLatestImage()
    }
}
