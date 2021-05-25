//
//  YelpService.swift
//  ShowMeAround
//
//  Created by Behzad Dogahe on 5/24/21.
//

import Foundation

enum AppError: Error {
    case invalidAPIKey
    case someOtherErrorFromYelp
    case urlSessionError
    case parseError
    case badSearchTerm
    case missingAPiKeyInPlist
}

extension AppError {
    var description: String {
        switch self {
        case .invalidAPIKey:
            return "Make sure you have entered a valid Yelp API_KEY in the file YelpAPI.plist in the project under the key named API_KEY"
        case .urlSessionError:
            return "Network Error."
        case .someOtherErrorFromYelp:
            return "Error from Yelp API."
        case .parseError:
            return "Error parsing Yelp Data."
        case .badSearchTerm:
            return "There is a problem in your search term."
        case .missingAPiKeyInPlist:
            return "Make sure you have entered a valid Yelp API_KEY in the file YelpAPI.plist in the project under the key named API_KEY"
        }
    }
}

class YelpService {
    
    static let shared = YelpService(session: .shared)
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }

    func getBusiness(_ term: String, _ latitude: Double, _ longitude: Double, _ token: String, completion: @escaping (Result<YelpBusinessResponse, AppError>) -> Void) {
        
        guard let searchTerm = term.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            completion(.failure(AppError.badSearchTerm))
            return
        }
        
        if let url = URL(string:
                            "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&term=\(searchTerm)") {
            var request = URLRequest(url: url)
            
            let headers = ["content-type": "application/json", "Authorization": "Bearer \(token)"]
            request.allHTTPHeaderFields = headers
            
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    completion(.failure(AppError.urlSessionError))
                    return
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        if httpResponse.statusCode == 401 || httpResponse.statusCode == 400 {
                            completion(.failure(AppError.invalidAPIKey))
                            return
                        } else if httpResponse.statusCode != 200 {
                            completion(.failure(AppError.someOtherErrorFromYelp))
                            return
                        }
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    print(json)
                                }
                                let response = try JSONDecoder().decode(YelpBusinessResponse.self, from: data)
                                completion(.success(response))
                                return
                            } catch {
                                print(error)
                                completion(.failure(AppError.parseError))
                            }
                            
                        } else {
                            completion(.failure(AppError.someOtherErrorFromYelp))
                        }
                    }
                }
            }.resume()
        }
    }
    
}

