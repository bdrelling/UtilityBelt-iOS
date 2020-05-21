// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
@testable import Lincoln
import XCTest

final class LincolnTests: XCTestCase {
    func testLogging() throws {
        self.log("Wow") { event in
            XCTAssertEqual("Wow", event.item as? String)
        }
    }
    
    private func log(_ item: Any, completion: @escaping (LogEvent) -> Void) {
        // Create an expectation
        let expectation = self.expectation(description: "Log item '\(String(describing: item))'.")
        
        // Create a test logger to handle the log events
        let logger = TestLogger(expectation: expectation, completion: completion)
        
        // Register it to the shared Lincoln instance
        Lincoln.shared.register(logger)
        
        // Log an item through the same Lincoln instance
        Lincoln.shared.log(item)
        
        // Wait for expectations to complete
        self.wait(for: [logger.expectation], timeout: 0.1)
    }
}

struct TestLogger: LogHandler {
    let expectation: XCTestExpectation
    let completion: (LogEvent) -> Void
    
    func log(_ event: LogEvent) {
        self.completion(event)
        
        self.expectation.fulfill()
    }
}
