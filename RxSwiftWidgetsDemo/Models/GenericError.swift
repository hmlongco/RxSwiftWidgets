//
//  GenericError.swift
//  Widgets
//
//  Created by Michael Long on 3/30/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation

enum GenericError: Error, LocalizedError {

    case description(String)

    public var errorDescription: String? {
        if case .description(let description) = self {
            return description
        }
        return "Unknown error occurred. Please try again later."
    }
    
}
