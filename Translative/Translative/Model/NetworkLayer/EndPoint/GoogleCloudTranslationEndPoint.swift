//
//  GoogleCloudTranslationEndPoint.swift
//  Translative
//
//  Created by xdrond on 27.06.2020.
//

import Foundation

// MARK: - Basic endpoints
// Translate:
// https://translation.googleapis.com/language/translate/v2
// Supported languages:
// https://translation.googleapis.com/language/translate/v2/languages
// Detecting languages:
// https://translation.googleapis.com/language/translate/v2/detect

enum NetworkEnvironment {
    case basic
    case advanced
}

public enum FormatParameters: String {
    case html
    case text
}

public enum ModelParameters: String {
    // Phrase-Based Machine Translation.
    case base
    // Neural Machine Translation
    case nmt
}

public enum GoogleApi {

    case translate(quote: String,
                   target: Language,
                   format: FormatParameters?,
                   source: Language?,
                   model: ModelParameters?)

    case detect(quote: String)

    case languageSupport(target: Language,
                         model: ModelParameters?)

    // place for v3 methods.
}

extension GoogleApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .basic: return "https://translation.googleapis.com/language/translate/v2/"
        case .advanced: return "https://translation.googleapis.com/v3/"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }

    var path: String {
        switch self {
        case .translate:
            return ""
        case .languageSupport:
            return "/languages"
        case .detect:
            return "/detect"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .translate:
            return .post
        case .languageSupport:
            return .get
        case .detect:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {

        case .translate(let quote,
                        let target,
                        let format,
                        let source,
                        let model):
            var urlParameters: Parameters = ["q": quote,
                                             "target": target.rawValue,
                                             "key": NetworkManager.GoogleAPIKey]

            if let format = format { urlParameters["format"] = format.rawValue }
            if let source = source { urlParameters["source"] = source.rawValue }
            if let model = model { urlParameters["model"] = model.rawValue }
            return .requestParameters(bodyParameters: nil, urlParameters: urlParameters)

        case .languageSupport(let target,
                              let model):
            var urlParameters: Parameters = ["target": target.rawValue,
                                             "key": NetworkManager.GoogleAPIKey]
            if let model = model { urlParameters["model"] = model.rawValue }
            return .requestParameters(bodyParameters: nil, urlParameters: urlParameters)

        case .detect(let quote):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["q": quote,
                                                      "key": NetworkManager.GoogleAPIKey])
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

}
