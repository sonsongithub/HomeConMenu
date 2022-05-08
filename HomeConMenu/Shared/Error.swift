//
//  Error.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/08.
//

import Foundation

enum HomeConMenuError: Error {
    case characteristicTypeError
    case actionSetCharacteristicsCountError
    case primaryHomeNotFound
    case actionSetNotFound
    case characteristicNotFound
    case characteristicValueNil
    
    var localizedDescription: String {
        switch self {
        case .characteristicTypeError:
            return "Can not get expected type value from the characteristic."
        case .actionSetCharacteristicsCountError:
            return "The count of target values and current ones do not match."
        case .primaryHomeNotFound:
            return "Primary home is not found."
        case .actionSetNotFound:
            return "No action sets which have the specified unique identifier are found."
        case .characteristicNotFound:
            return "No characteristics which have the specified unique identifier are found."
        case .characteristicValueNil:
            return "Value of the specified characteristic is nil."
        }
    }
}
