//
//  NetworkLogger.swift
//  Translative
//
//  Created by xdrond on 10.07.2020.
//

import Foundation

final class NetworkLogger {

    static func log(request: URLRequest) {
        print("\n - - - - - - - - - ⬆️ OUTGOING NETWORK - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - - - OUTGOING END - - - - - - - - - - - \n") }

        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }

        print(logOutput)
    }

    static func log(response: URLResponse) {
        print("\n - - - - - - - - - ⬇️ INCOMING NETWORK - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - - - INCOMING END - - - - - - - - - - - \n") }

        let urlAsString = response.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let mimeType = response.mimeType ?? ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        let logOutput = """
        URL: \(urlAsString) \n\n
        MIME type: \(mimeType) \n
        QUERY: \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        print(logOutput)
    }
}
