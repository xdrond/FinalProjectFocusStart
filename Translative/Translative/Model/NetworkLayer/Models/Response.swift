//
//  Response.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import Foundation

struct Response: Codable {
    let data: DataStruct
}

struct DataStruct: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
    let detectedSourceLanguage: String?
}
