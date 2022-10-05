//
//  NetworkManager.swift
//  Radius_Assignment
//
//  Created by Adwait Barkale on 02/08/22.
//

import Foundation

/// This Class will be responsible for making Api Calls
class NetworkManager {
    
    // MARK: - Variable Declarations
    static let shared = NetworkManager()
    
    // MARK: - User Defined Functions
    
    /// Function call to hit api with endpoint and return response
    /// - Parameters:
    ///   - url: Endpoint
    ///   - completion: Success Flag, JSON Response
    func callApi(withURL url: String,completion: @escaping (_ isSuccess: Bool, _ jsonResponse: String) -> Void) {
        let session = URLSession(configuration: .default)
        if let url = URL(string: url) {
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // Give Error Message
                    completion(false, error?.localizedDescription ?? StringConstants.shared.unexpectedError)
                } else if data != nil {
                    // We got response data
                    let jsonResponse = String(decoding: data ?? Data(), as: UTF8.self)
                    completion(true,jsonResponse)
                } else {
                    // No Error, with Data Nil
                    completion(false, StringConstants.shared.unexpectedError)
                }
            }
            task.resume()
        } else {
            // Failure while generating URL Object
            completion(false, StringConstants.shared.urlGenerationError)
        }
    }
    
}
