//
//  ParameterEncoding.swift
//  Translative
//
//  Created by xdrond on 27.06.2020.
//

import Foundation

// MARK: - Get rid of Any type if possible.
/**
Get rid of Any type if possible.
*/
public typealias Parameters = [String: String]

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
