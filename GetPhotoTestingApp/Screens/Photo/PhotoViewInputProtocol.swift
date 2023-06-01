//
//  PhotoViewInputProtocol.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 31.05.2023.
//

import Foundation

protocol PhotoViewInputProtocol: AnyObject {
    func setImage(withData data: Data?)
    func setError(withText text: String, type: AlertType)
    func photoDidSaved()
}
