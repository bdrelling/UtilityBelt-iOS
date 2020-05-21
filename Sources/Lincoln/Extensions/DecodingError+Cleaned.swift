// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension DecodingError {
    var cleanedDescription: String {
        switch self {
        case let .typeMismatch(type, context):
            return "Type mismatch for key '\(context.codingPath.jsonPath)'. Expected type '\(String(describing: type))'."
        case let .valueNotFound(type, context):
            return "Value not found for key '\(context.codingPath.jsonPath)' of type '\(String(describing: type))'."
        case let .keyNotFound(key, context):
            var allKeys = context.codingPath
            allKeys.append(key)
            
            return "Key '\(allKeys.jsonPath)' not found."
        case .dataCorrupted:
            return "Data corrupted."
        @unknown default:
            return self.localizedDescription
        }
    }
}

extension Array where Element == CodingKey {
    fileprivate var jsonPath: String {
        var path = ""
        
        for key in self {
            if let index = key.intValue {
                path += "[\(index)]"
            } else {
                path += ".\(key.stringValue)"
            }
        }
        
        return path.trimmingCharacters(in: CharacterSet(charactersIn: "."))
    }
}