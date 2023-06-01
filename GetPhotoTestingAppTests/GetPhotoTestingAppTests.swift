//
//  GetPhotoTestingAppTests.swift
//  GetPhotoTestingAppTests
//
//  Created by user on 31.05.2023.
//

import XCTest
@testable import GetPhotoTestingApp

final class GetPhotoTestingAppTests: XCTestCase {

    var mockProvider: MockDataProvider!
    var photoViewModel: PhotoViewModelProtocol!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockProvider = MockDataProvider()
        photoViewModel = PhotoViewModel(dataProvider: mockProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockProvider = nil
        photoViewModel = nil
        try super.tearDownWithError()
    }
    
    func test_fetchImage() {
        let promt = "ok"
        photoViewModel.fetchImage(imagePromt: promt)
        let completion = mockProvider.fetchImageCompletion.first
        completion?(.success(Data()))
        
        XCTAssertEqual(mockProvider.fetchImageCallCount, 1)
        XCTAssertEqual(mockProvider.fetchImagePromt.first, promt)
        XCTAssertEqual(photoViewModel.imageModel?.query, promt)
    }
    
    func test_saveToFavorite() {
        let promt = "1"
        photoViewModel.fetchImage(imagePromt: promt)
        let fetchImageCompletion = mockProvider.fetchImageCompletion.first
        fetchImageCompletion?(.success(Data()))
        let query = "ok"
        photoViewModel.saveToFavorite(query: query)
        
        let fetchFavoritesCompletion = mockProvider.fetchFavoritesCompletion.first
        fetchFavoritesCompletion?([ImageModel(imageData: Data(), saveDate: Date(), query: "1")])
        
        
        XCTAssertEqual(mockProvider.fetchImageCallCount, 1)
        XCTAssertEqual(mockProvider.fetchImagePromt.first, promt)
        
        XCTAssertEqual(mockProvider.fetchFavoritesCallCount, 1)
        XCTAssertEqual(mockProvider.saveImageModelCallCount, 1)
        XCTAssertEqual(mockProvider.saveImageModelModel.first?.imageData, photoViewModel.imageModel?.imageData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            photoViewModel.fetchImage(imagePromt: "")
        }
    }

}
