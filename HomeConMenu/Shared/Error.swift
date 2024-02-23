//
//  Error.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/08.
//

import Foundation

enum HomeConMenuError: Error {
    case characteristicTypeError(String, UUID, String?, UUID)
    case actionSetCharacteristicsCountError(String, UUID, Int, Int)
    case primaryHomeNotFound
    case characteristicNotFound(UUID)
    case characteristicValueNil(UUID)
    case actionSetNotFound(UUID)
    
    var localizedDescription: String {
        switch self {
        case .characteristicTypeError:
            return "Can not get expected type value from the characteristic."
        case .actionSetCharacteristicsCountError(let name, let uuid, let targetCount, let currentCount):
            return "The count of target values and current ones do not match. - \(name) - \(uuid.uuidString) - target=\(targetCount) - current=\(currentCount)"
        case .primaryHomeNotFound:
            return "Primary home is not found."
        case .actionSetNotFound(let uuid):
            return "No action sets which have the specified unique identifier are found. - \(uuid.uuidString)"
        case .characteristicNotFound(let uuid):
            return "No characteristics which have the specified unique identifier are found. - \(uuid.uuidString)"
        case .characteristicValueNil(let uuid):
            return "Value of the specified characteristic is nil. - \(uuid.uuidString)"
        }
    }
}
