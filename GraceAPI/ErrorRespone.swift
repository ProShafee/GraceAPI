//
//  ErrorRespone.swift
//  GraceAPI
//
//  Created by Shafee Rehman on 29/03/2025.
//

import Foundation

public struct ErrorResponse: Codable {
    var status: Int
    var title: String
    var message: String
    var dismissTitle: String
}
