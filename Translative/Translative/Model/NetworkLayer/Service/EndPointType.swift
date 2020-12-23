//
//  EndPointType.swift
//  Translative
//
//  Created by xdrond on 27.06.2020.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}
