//
//  GetPhotoTestingAppUITests.swift
//  GetPhotoTestingAppUITests
//
//  Created by user on 01.06.2023.
//

import XCTest

final class GetPhotoTestingAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testButtonEnabling() {
        let textField = app.textFields["textField"]
        textField.typeText("Okay")
        
        let button = app.buttons["submitButton"]
        XCTAssert(button.isEnabled)
    }
    
    func testButtonDisabling() {
        let textField = app.textFields["textField"]
        let textFieldClearButton = textField.buttons["Clear text"]
        let button = app.buttons["submitButton"]
        
        textField.typeText("okay")
        textFieldClearButton.tap()
        
        XCTAssert(!button.isEnabled)
    }

    func testImageChanged() {
        let textField = app.textFields["textField"]
        let imageView = app.images["imageView"]
        let submitButton = app.buttons["submitButton"]
        let favotiteButton = app.buttons["favoriteButton"]
        
        textField.typeText("okay")
        submitButton.tap()
        
        sleep(5)
        
        XCTAssert(imageView.exists)
        XCTAssert(favotiteButton.isEnabled)
    }
}
