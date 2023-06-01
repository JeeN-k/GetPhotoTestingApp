//
//  FavoritesViewModel.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import Foundation

protocol FavoritesViewModelProtocol {
    var models: [ImageModel] { get }
    func fetchModels()
    func viewModelForCell(indexPath: IndexPath) -> FavoritesCellViewModel
    func removeImageAt(indexPath: IndexPath)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    private var dataProvider: DataProviderProtocol
    var models: [ImageModel] = []
    weak var view: FavoritesViewInputProtocol?
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchModels() {
        dataProvider.fetchFavorites { [weak self] models in
            guard let self else { return }
            self.models = models
            self.view?.didFetchImages()
        }
    }
    
    func viewModelForCell(indexPath: IndexPath) -> FavoritesCellViewModel {
        return FavoritesCellViewModel(imageModel: models[indexPath.row])
    }
    
    func removeImageAt(indexPath: IndexPath) {
        let imageModel = models.remove(at: indexPath.row)
        dataProvider.removeImageFromFavorites(imageModel: imageModel)
    }
}
