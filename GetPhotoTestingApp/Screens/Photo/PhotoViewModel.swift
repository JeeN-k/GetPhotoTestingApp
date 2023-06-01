//
//  PhotoViewModel.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import Foundation

protocol PhotoViewModelProtocol {
    var imageModel: ImageModel? { get }
    func fetchImage(imagePromt: String)
    func saveToFavorite(query: String)
}

final class PhotoViewModel: PhotoViewModelProtocol {
    var imageModel: ImageModel?
    private var dataProvider: DataProviderProtocol
    weak var view: PhotoViewInputProtocol?
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchImage(imagePromt: String) {
        
        dataProvider.fetchImage(imagePromt: imagePromt) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.imageModel = ImageModel(imageData: data,
                                             saveDate: Date(),
                                             query: imagePromt)
                self.view?.setImage(withData: imageModel?.imageData)
            case .failure(let error):
                self.view?.setError(withText: error.rawValue, type: .negative)
            }
        }
    }
    
    func saveToFavorite(query: String) {
        guard let imageModel else { return }
        dataProvider.fetchFavorites { models in
            self.checkAndRemoveLatestIfNeeded(models: models)
        }
        dataProvider.saveImageModel(with: imageModel) { [weak self] isSaved in
            guard let self else { return }
            if isSaved {
                self.view?.photoDidSaved()
            } else {
                self.view?.setError(withText: "Вы уже сохранили эту картинку", type: .warning)
            }
        }
    }
    
    private func checkAndRemoveLatestIfNeeded(models: [ImageModel]) {
        if models.count >= 10 {
            dataProvider.removeLatestImage()
        }
    }
}
