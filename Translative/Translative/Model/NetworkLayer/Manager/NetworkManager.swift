//
//  NetworkManager.swift
//  Translative
//
//  Created by xdrond on 27.06.2020.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment: NetworkEnvironment = .basic
    static let GoogleAPIKey = Keys.googleDevKey
    private let router = Router<GoogleApi>()

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }

    func getTranslation(quote: String,
                        source: Language?,
                        target: Language,
                        completion: @escaping (_ translatedQuote: Translation?, _ error: String?) -> Void) {

        router.request(.translate(quote: quote,
                                  target: target,
                                  format: .text,
                                  source: source,
                                  model: .nmt)) { data, response, error in
            if error != nil {
                completion(nil, "Please check your internet connection.")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(Response.self, from: responseData)
                        completion(apiResponse.data.translations.first, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

}
