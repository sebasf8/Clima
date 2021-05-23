//
//  MockTask.swift
//  ClimaTests
//
//  Created by Sebastian Fernandez on 22/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

class MockTask: URLSessionDataTask {
  private let data: Data?
  private let urlResponse: URLResponse?
  private let mockedError: Error?

  var completionHandler: ((Data?, URLResponse?, Error?) -> Void)!
  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    self.data = data
    self.urlResponse = urlResponse
    self.mockedError = error
    
  }
  override func resume() {
    DispatchQueue.main.async {
        self.completionHandler(self.data, self.urlResponse, self.mockedError)
    }
  }
}

