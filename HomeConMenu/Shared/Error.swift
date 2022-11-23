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
    
    case distributedNotificationHasNoString
    case stringCannotBeConvertedToData
    case jsonCannotBeConvertedToString
    
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
            
        case .distributedNotificationHasNoString:
            return "DistributedNotification does not have any string object."
        case .stringCannotBeConvertedToData:
            return "String can not been encoded to Data."
        case .jsonCannotBeConvertedToString:
            return "JSON can not been encoded to String."
        }
    }
}
