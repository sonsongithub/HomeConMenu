//
//  HCAccessoryType.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/10/09.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

#if !os(macOS)
import HomeKit
#endif

public enum HCAccessoryType: Int, CustomStringConvertible, Codable {
    case lightbulb    // A lightbulb accessory.
    case outlet    // An outlet accessory.
    case programmableSwitch    // A programmable switch accessory.
    case `switch`    // A switch accessory.
    case fan    // A fan accessory.
    case airPurifier    // An air purifier accessory.
    case thermostat    // A thermostat accessory.
    case airConditioner    // An air conditioner accessory.
    case airDehumidifier    // A dehumidifier accessory.
    case airHeater    // An air heater accessory.
    case airHumidifier    // A humidifier accessory.
    case window    // A window accessory.
    case windowCovering    // A window covering accessory.
    case door    // A door accessory.
    case doorLock    // A door lock accessory.
    case garageDoorOpener    // A garage door opener accessory.
    case videoDoorbell    // A video doorbell accessory.
    case sensor    // A sensor accessory.
    case securitySystem    // A security system accessory.
    case iPCamera    // A networked camera accessory.
    case sprinkler    // A sprinkler system accessory.
    case faucet    // A faucet accessory.
    case showerHead    // A shower head accessory.
    case bridge    // A bridge accessory.
    case rangeExtender    // A range extender accessory.
    case other    // An uncategorized accessory.
    case unknown

    public var description: String {
        switch self {
        case .lightbulb:
            return "A lightbulb accessory."
        case .outlet:
            return "An outlet accessory."
        case .programmableSwitch:
            return "A programmable switch accessory."
        case .switch:
            return "A switch accessory."
        case .fan:
            return "A fan accessory."
        case .airPurifier:
            return "An air purifier accessory."
        case .thermostat:
            return "A thermostat accessory."
        case .airConditioner:
            return "An air conditioner accessory."
        case .airDehumidifier:
            return "A dehumidifier accessory."
        case .airHeater:
            return "An air heater accessory."
        case .airHumidifier:
            return "A humidifier accessory."
        case .window:
            return "A window accessory."
        case .windowCovering:
            return "A window covering accessory."
        case .door:
            return "A door accessory."
        case .doorLock:
            return "A door lock accessory."
        case .garageDoorOpener:
            return "A garage door opener accessory."
        case .videoDoorbell:
            return "A video doorbell accessory."
        case .sensor:
            return "A sensor accessory."
        case .securitySystem:
            return "A security system accessory."
        case .iPCamera:
            return "A networked camera accessory."
        case .sprinkler:
            return "A sprinkler system accessory."
        case .faucet:
            return "A faucet accessory."
        case .showerHead:
            return "A shower head accessory."
        case .bridge:
            return "A bridge accessory."
        case .rangeExtender:
            return "A range extender accessory."
        case .other:
            return "An uncategorized accessory."
        case .unknown:
            return "Unknown"
        }
    }

#if !os(macOS)
    init(key: String) {
        switch key {
        case HMAccessoryCategoryTypeLightbulb:
            self = .lightbulb
        case HMAccessoryCategoryTypeOutlet:
            self = .outlet
        case HMAccessoryCategoryTypeProgrammableSwitch:
            self = .programmableSwitch
        case HMAccessoryCategoryTypeSwitch:
            self = .switch
        case HMAccessoryCategoryTypeFan:
            self = .fan
        case HMAccessoryCategoryTypeAirPurifier:
            self = .airPurifier
        case HMAccessoryCategoryTypeThermostat:
            self = .thermostat
        case HMAccessoryCategoryTypeAirConditioner:
            self = .airConditioner
        case HMAccessoryCategoryTypeAirDehumidifier:
            self = .airDehumidifier
        case HMAccessoryCategoryTypeAirHeater:
            self = .airHeater
        case HMAccessoryCategoryTypeAirHumidifier:
            self = .airHumidifier
        case HMAccessoryCategoryTypeWindow:
            self = .window
        case HMAccessoryCategoryTypeWindowCovering:
            self = .windowCovering
        case HMAccessoryCategoryTypeDoor:
            self = .door
        case HMAccessoryCategoryTypeDoorLock:
            self = .doorLock
        case HMAccessoryCategoryTypeGarageDoorOpener:
            self = .garageDoorOpener
        case HMAccessoryCategoryTypeVideoDoorbell:
            self = .videoDoorbell
        case HMAccessoryCategoryTypeSensor:
            self = .sensor
        case HMAccessoryCategoryTypeSecuritySystem:
            self = .securitySystem
        case HMAccessoryCategoryTypeIPCamera:
            self = .iPCamera
        case HMAccessoryCategoryTypeSprinkler:
            self = .sprinkler
        case HMAccessoryCategoryTypeFaucet:
            self = .faucet
        case HMAccessoryCategoryTypeShowerHead:
            self = .showerHead
        case HMAccessoryCategoryTypeBridge:
            self = .bridge
        case HMAccessoryCategoryTypeRangeExtender:
            self = .rangeExtender
        case HMAccessoryCategoryTypeOther:
            self = .other
        default:
            self = .unknown
        }
    }
#endif
}
