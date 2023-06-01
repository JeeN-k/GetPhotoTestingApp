//
//  CoreDataService.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import CoreData
import Foundation

protocol CoreDataServiceProtocol {
    func addFavoriteImage(imageModel: ImageModel, completion: @escaping ((Bool) -> Void))
    func fetchAllFavorites(_ completion: @escaping (([ImageModel]) -> Void))
    func removeImageFromFavorites(imageModel: ImageModel)
    func removeLatestImage()
    func fetchByQuery(query: String) -> ImageModel?
}

class CoreDataService: NSObject {
    
    static let instance: CoreDataServiceProtocol = CoreDataService()
    fileprivate var managedObjectContext: NSManagedObjectContext
    
    override init() {
        let persistentStore = PersistentStore()
        self.managedObjectContext = persistentStore.context
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
}

extension CoreDataService: CoreDataServiceProtocol {
    func addFavoriteImage(imageModel: ImageModel, completion: @escaping ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "query = %@", imageModel.query as CVarArg)
        let result = fetchFirst(ImageMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if managedObject == nil {
                updateAndSave(imageModel: imageModel)
                completion(true)
            } else {
                completion(false)
            }
        case .failure(_):
            print("Couldn't fetch ImageMO to check existence")
        }
    }
    
    func fetchByQuery(query: String) -> ImageModel? {
        let predicate = NSPredicate(format: "query = %@", query as CVarArg)
        let result = fetchFirst(ImageMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let managedObject {
                return ImageModel(imageMO: managedObject)
            }
        case .failure(_):
            print("Couldn't fetch ImageMO to check existence")
        }
        return nil
    }
    
    func fetchAllFavorites(_ completion: @escaping (([ImageModel]) -> Void)) {
        do {
            let fetchRequest = NSFetchRequest<ImageMO>(entityName: "ImageMO")
            let imageMO = try managedObjectContext.fetch(fetchRequest)
            let imageModels = imageMO.map({ ImageModel(imageMO: $0) })
            completion(imageModels)
        } catch {
            print(error)
        }
    }
    
    func removeImageFromFavorites(imageModel: ImageModel) {
        let predicate = NSPredicate(format: "id = %@", imageModel.id as CVarArg)
        let result = fetchFirst(ImageMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let imageMO = managedObject {
                managedObjectContext.delete(imageMO)
            }
        case .failure(_):
            print("Couldn't fetch TodoMO to save")
        }
        saveData()
    }
    
    func removeLatestImage() {
        let fetchRequest = NSFetchRequest<ImageMO>(entityName: "ImageMO")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let images = try managedObjectContext.fetch(fetchRequest)
            if let oldestImage = images.first {
                managedObjectContext.delete(oldestImage)
                saveData()
            }
        } catch let error as NSError {
            NSLog("Error fetching: \(error), \(error.userInfo)")
        }
    }

}

extension CoreDataService {
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    private func updateAndSave(imageModel: ImageModel) {
        let predicate = NSPredicate(format: "id = %@", imageModel.id as CVarArg)
        let result = fetchFirst(ImageMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let imageMO = managedObject {
                update(imageMO: imageMO, from: imageModel)
            } else {
                imageMO(from: imageModel)
            }
        case .failure(_):
            print("Couldn't fetch JourneyMO to save")
        }
        
        saveData()
    }
    
    private func imageMO(from image: ImageModel) {
        let imageMO = ImageMO(context: managedObjectContext)
        imageMO.id = image.id
        update(imageMO: imageMO, from: image)
    }
    
    private func update(imageMO: ImageMO, from imageModel: ImageModel) {
        imageMO.date = imageModel.saveDate
        imageMO.imageData = imageModel.imageData
        imageMO.query = imageModel.query
    }
}

extension ImageModel {
    fileprivate init(imageMO: ImageMO) {
        self.id = imageMO.id ?? UUID()
        self.imageData = imageMO.imageData ?? Data()
        self.saveDate = imageMO.date ?? Date()
        self.query = imageMO.query ?? ""
    }
}
