//
//  ServiceTypeBridge.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
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

#if !os(macOS)
import HomeKit
#endif

@objc(ServiceType)
public enum ServiceType: Int, CustomStringConvertible {
    case lightbulb    // A light bulb service.
    case lightSensor    // A light sensor service.
    case `switch`    // A switch service.
    case battery    // A battery service.
    case outlet    // An outlet service.
    case statefulProgrammableSwitch    // A stateful programmable switch service.
    case statelessProgrammableSwitch    // A stateless programmable switch service.
    case airPurifier    // An air purifier service.
    case airQualitySensor    // An air quality sensor service.
    case carbonDioxideSensor    // A carbon dioxide sensor service.
    case carbonMonoxideSensor    // A carbon monoxide sensor service.
    case smokeSensor    // A smoke sensor service.
    case heaterCooler    // A heater or cooler service.
    case temperatureSensor    // A temperature sensor service.
    case thermostat    // A thermostat service.
    case fan    // A fan service.
    case filterMaintenance    // A filter maintenance service.
    case humidifierDehumidifier    // A humidifier or dehumidifier service.
    case humiditySensor    // A humidity sensor service.
    case ventilationFan    // A ventilation fan service.
    case window    // A window service.
    case windowCovering    // A window covering service.
    case slats    // A slats service.
    case faucet    // A faucet service.
    case valve    // A valve service.
    case irrigationSystem    // An irrigation system service.
    case leakSensor    // A leak sensor service.
    case door    // A door service.
    case doorbell    // A doorbell service.
    case garageDoorOpener    // A garage door opener service.
    case lockManagement    // A lock management service.
    case lockMechanism    // A lock mechanism service.
    case motionSensor    // A motion sensor service.
    case occupancySensor    // An occupancy sensor service.
    case securitySystem    // A security system service.
    case contactSensor    // A contact sensor service.
    case cameraControl    // A camera control service.
    case cameraRTPStreamManagement    // A stream management service.
    case microphone    // A microphone service.
    case speaker    // An audio speaker service.
    case label    // A label namespace service used when an accessory supports multiple services of the same type.
    case accessoryInformation    // An accessory information service.
    case unknown

    public var description: String {
        switch self {
        case .lightbulb:
            return "A light bulb service."
        case .lightSensor:
            return "A light sensor service."
        case .switch:
            return "A switch service."
        case .battery:
            return "A battery service."
        case .outlet:
            return "An outlet service."
        case .statefulProgrammableSwitch:
            return "A stateful programmable switch service."
        case .statelessProgrammableSwitch:
            return "A stateless programmable switch service."
        case .airPurifier:
            return "An air purifier service."
        case .airQualitySensor:
            return "An air quality sensor service."
        case .carbonDioxideSensor:
            return "A carbon dioxide sensor service."
        case .carbonMonoxideSensor:
            return "A carbon monoxide sensor service."
        case .smokeSensor:
            return "A smoke sensor service."
        case .heaterCooler:
            return "A heater or cooler service."
        case .temperatureSensor:
            return "A temperature sensor service."
        case .thermostat:
            return "A thermostat service."
        case .fan:
            return "A fan service."
        case .filterMaintenance:
            return "A filter maintenance service."
        case .humidifierDehumidifier:
            return "A humidifier or dehumidifier service."
        case .humiditySensor:
            return "A humidity sensor service."
        case .ventilationFan:
            return "A ventilation fan service."
        case .window:
            return "A window service."
        case .windowCovering:
            return "A window covering service."
        case .slats:
            return "A slats service."
        case .faucet:
            return "A faucet service."
        case .valve:
            return "A valve service."
        case .irrigationSystem:
            return "An irrigation system service."
        case .leakSensor:
            return "A leak sensor service."
        case .door:
            return "A door service."
        case .doorbell:
            return "A doorbell service."
        case .garageDoorOpener:
            return "A garage door opener service."
        case .lockManagement:
            return "A lock management service."
        case .lockMechanism:
            return "A lock mechanism service."
        case .motionSensor:
            return "A motion sensor service."
        case .occupancySensor:
            return "An occupancy sensor service."
        case .securitySystem:
            return "A security system service."
        case .contactSensor:
            return "A contact sensor service."
        case .cameraControl:
            return "A camera control service."
        case .cameraRTPStreamManagement:
            return "A stream management service."
        case .microphone:
            return "A microphone service."
        case .speaker:
            return "An audio speaker service."
        case .label:
            return "A label namespace service used when an accessory supports multiple services of the same type."
        case .accessoryInformation:
            return "An accessory information service."
        case .unknown:
            return "Unknown"
        }
    }


#if !os(macOS)
    init(key: String) {
        switch key {
        case HMServiceTypeLightbulb:
            self = .lightbulb
        case HMServiceTypeLightSensor:
            self = .lightSensor
        case HMServiceTypeSwitch:
            self = .switch
        case HMServiceTypeBattery:
            self = .battery
        case HMServiceTypeOutlet:
            self = .outlet
        case HMServiceTypeStatefulProgrammableSwitch:
            self = .statefulProgrammableSwitch
        case HMServiceTypeStatelessProgrammableSwitch:
            self = .statelessProgrammableSwitch
        case HMServiceTypeAirPurifier:
            self = .airPurifier
        case HMServiceTypeAirQualitySensor:
            self = .airQualitySensor
        case HMServiceTypeCarbonDioxideSensor:
            self = .carbonDioxideSensor
        case HMServiceTypeCarbonMonoxideSensor:
            self = .carbonMonoxideSensor
        case HMServiceTypeSmokeSensor:
            self = .smokeSensor
        case HMServiceTypeHeaterCooler:
            self = .heaterCooler
        case HMServiceTypeTemperatureSensor:
            self = .temperatureSensor
        case HMServiceTypeThermostat:
            self = .thermostat
        case HMServiceTypeFan:
            self = .fan
        case HMServiceTypeFilterMaintenance:
            self = .filterMaintenance
        case HMServiceTypeHumidifierDehumidifier:
            self = .humidifierDehumidifier
        case HMServiceTypeHumiditySensor:
            self = .humiditySensor
        case HMServiceTypeVentilationFan:
            self = .ventilationFan
        case HMServiceTypeWindow:
            self = .window
        case HMServiceTypeWindowCovering:
            self = .windowCovering
        case HMServiceTypeSlats:
            self = .slats
        case HMServiceTypeFaucet:
            self = .faucet
        case HMServiceTypeValve:
            self = .valve
        case HMServiceTypeIrrigationSystem:
            self = .irrigationSystem
        case HMServiceTypeLeakSensor:
            self = .leakSensor
        case HMServiceTypeDoor:
            self = .door
        case HMServiceTypeDoorbell:
            self = .doorbell
        case HMServiceTypeGarageDoorOpener:
            self = .garageDoorOpener
        case HMServiceTypeLockManagement:
            self = .lockManagement
        case HMServiceTypeLockMechanism:
            self = .lockMechanism
        case HMServiceTypeMotionSensor:
            self = .motionSensor
        case HMServiceTypeOccupancySensor:
            self = .occupancySensor
        case HMServiceTypeSecuritySystem:
            self = .securitySystem
        case HMServiceTypeContactSensor:
            self = .contactSensor
        case HMServiceTypeCameraControl:
            self = .cameraControl
        case HMServiceTypeCameraRTPStreamManagement:
            self = .cameraRTPStreamManagement
        case HMServiceTypeMicrophone:
            self = .microphone
        case HMServiceTypeSpeaker:
            self = .speaker
        case HMServiceTypeLabel:
            self = .label
        case HMServiceTypeAccessoryInformation:
            self = .accessoryInformation
        default:
            self = .unknown
        }
    }
#endif
}
