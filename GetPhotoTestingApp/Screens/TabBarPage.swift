//
//  TabBarPage.swift
//  GetPhotoTestingApp
//
//  Created by user on 30.05.2023.
//

import Foundation

enum TabBarPage {
    case photo
    case favorites
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .photo
        case 1:
            self = .favorites
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .photo:
            return "Фото"
        case .favorites:
            return "Избранное"
            
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .photo:
            return 0
        case .favorites:
            return 1
            
        }
    }
    
    func pageImageName() -> String {
        switch self {
        case .photo:
            return "photo"
        case .favorites:
            return "heart"
        }
    }
    
    func selectedPageName() -> String {
        switch self {
        case .photo:
            return "photo.fill"
        case .favorites:
            return "heart.fill"
        }
    }
}
