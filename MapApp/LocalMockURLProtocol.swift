//
//  LocalMockURLProtocol.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import Foundation

class LocalMockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return request.url?.absoluteString == "https://api.example.com/coordinates"
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Load the local JSON file
        if let url = Bundle.main.url(forResource: "coordinates", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            
            // Create a fake HTTP response (Status 200 OK)
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: "HTTP/1.1",
                                           headerFields: ["Content-Type": "application/json"])!
            
            // Inform the client (URLSession) about the response and data
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            self.client?.urlProtocol(self, didFailWithError: NSError(domain: "Resource not found", code: 404))
        }
        
        // Signal that we are finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // Required, but can be empty for this use case
    }
}
