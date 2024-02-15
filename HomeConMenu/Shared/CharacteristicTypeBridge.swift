//
//  CharacteristicTypeBridge.swift
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

@objc(CharacteristicTypeBridge)
public enum CharacteristicType: Int, CustomStringConvertible {
    case currentLightLevel    // The current light level.
    case hue    // The hue of the color used by a light.
    case brightness    // The brightness of a light.
    case saturation    // The saturation of the color used by a light.
    case colorTemperature    // The color temperature of a light.
    case batteryLevel    // The battery level of the accessory.
    case chargingState    // The charging state of a battery.
    case contactState    // The state of a contact sensor.
    case outletInUse    // The state of an outlet.
    case powerState    // The power state of the accessory.
    case statusLowBattery    // A low battery indicator.
    case outputState    // The output state of a programmable switch.
    case inputEvent    // The input event of a programmable switch.
    case currentTemperature    // The current temperature measured by the accessory.
    case targetTemperature    // The target temperature for the accessory to achieve.
    case temperatureUnits    // The units of temperature currently active on the accessory.
    case targetHeatingCooling    // The target heating or cooling mode for a thermostat.
    case currentHeatingCooling    // The current heating or cooling mode for a thermostat.
    case targetHeaterCoolerState    // The target state for a device that heats or cools, like an oven or a refrigerator.
    case currentHeaterCoolerState    // The current state for a device that heats or cools, like an oven or a refrigerator.
    case coolingThreshold    // The temperature above which cooling will be active.
    case heatingThreshold    // The temperature below which heating will be active.
    case currentRelativeHumidity    // The current relative humidity measured by the accessory.
    case targetRelativeHumidity    // The target relative humidity for the accessory to achieve.
    case currentHumidifierDehumidifierState    // The current state of a humidifier or dehumidifier accessory.
    case targetHumidifierDehumidifierState    // The state that a humidifier or dehumidifier accessory should try to achieve.
    case humidifierThreshold    // The humidity below which a humidifier should begin to work.
    case dehumidifierThreshold    // The humidity above which a dehumidifier should begin to work.
    case airQuality    // The air quality.
    case airParticulateDensity    // The density of air-particulate matter.
    case airParticulateSize    // The size of the air-particulate matter.
    case smokeDetected    // A smoke detection indicator.
    case carbonDioxideDetected    // An indicator of abnormally high levels of carbon dioxide.
    case carbonDioxideLevel    // The measured carbon dioxide level.
    case carbonDioxidePeakLevel    // The highest recorded level of carbon dioxide.
    case carbonMonoxideDetected    // An indicator of abnormally high levels of carbon monoxide.
    case carbonMonoxideLevel    // The measured carbon monoxide level.
    case carbonMonoxidePeakLevel    // The highest recorded level of carbon monoxide.
    case nitrogenDioxideDensity    // The measured density of nitrogen dioxide.
    case ozoneDensity    // The measured density of ozone.
    case pM10Density    // The measured density of air-particulate matter of size 10 micrograms.
    case pM2_5Density    // The measured density of air-particulate matter of size 2.5 micrograms.
    case sulphurDioxideDensity    // The measured density of sulphur dioxide.
    case volatileOrganicCompoundDensity    // The measured density of volatile organic compounds.
    case currentFanState    // The current state of a fan.
    case targetFanState    // The target state of a fan.
    case rotationDirection    // The rotation direction of an accessory like a fan.
    case rotationSpeed    // The rotation speed of an accessory like a fan.
    case swingMode    // An indicator of whether a fan swings back and forth during operation.
    case currentAirPurifierState    // The current air purifier state.
    case targetAirPurifierState    // The target air purifier state.
    case filterLifeLevel    // The amount of useful life remaining in a filter.
    case filterChangeIndication    // A filter’s change indicator.
    case filterResetChangeIndication    // A reset control for a filter change notification.
    case waterLevel    // The water level measured by an accessory.
    case valveType    // The type of automated valve that controls fluid flow.
    case leakDetected    // A leak detection indicator.
    case currentDoorState    // The current door state.
    case targetDoorState    // The target door state.
    case currentPosition    // The current position of a door, window, awning, or window covering.
    case targetPosition    // The target position of a door, window, awning, or window covering.
    case positionState    // The position of an accessory like a door, window, awning, or window covering.
    case statusJammed    // An indicator of whether an accessory is jammed.
    case holdPosition    // A control for holding the position of an accessory like a door or window.
    case slatType    // The type of slat on an accessory like a window or a fan.
    case currentSlatState    // The current state of slats on an accessory like a window or a fan.
    case currentHorizontalTilt    // The current tilt angle of a horizontal slat for an accessory like a window or a fan.
    case targetHorizontalTilt    // The target tilt angle of a horizontal slat for an accessory like a window or a fan.
    case currentVerticalTilt    // The current tilt angle of a vertical slat for an accessory like a window or a fan.
    case targetVerticalTilt    // The target tilt angle of a vertical slat for an accessory like a window or a fan.
    case currentTilt    // The current tilt angle of a slat for an accessory like a window or a fan.
    case targetTilt    // The target tilt angle of a slat for an accessory like a window or a fan.
    case lockManagementAutoSecureTimeout    // The automatic timeout for a lockable accessory that supports automatic lockout.
    case lockManagementControlPoint    // A control that accepts vendor-specific actions for lock management.
    case lockMechanismLastKnownAction    // The last known action of the locking mechanism.
    case lockPhysicalControls    // The lock’s physical control state.
    case motionDetected    // An indicator of whether the accessory has detected motion.
    case currentLockMechanismState    // The current state of the locking mechanism.
    case targetLockMechanismState    // The target state for the locking mechanism.
    case currentSecuritySystemState    // The current security system state.
    case targetSecuritySystemState    // The target security system state.
    case obstructionDetected    // An indicator of whether an obstruction is detected, as when something prevents a garage door from closing.
    case occupancyDetected    // An indicator of whether the home is occupied.
    case securitySystemAlarmType    // The alarm trigger state.
    case supportedRTPConfiguration    // The supported Real-time Transport Protocol (RTP) configuration.
    case digitalZoom    // The digital zoom of a video Real-time Transport Protocol (RTP) service.
    case opticalZoom    // The optical zoom setting of the camera sourcing a video Real-time Transport Protocol (RTP) service.
    case imageMirroring    // An indicator of whether the image should be flipped about the vertical axis.
    case imageRotation    // The angle of rotation for an image.
    case nightVision    // An indicator of whether night vision is enabled on a video Real-time Transport Protocol (RTP) service.
    case streamingStatus    // A description of the status of the Real-time Transport Protocol (RTP) stream management service.
    case supportedVideoStreamConfiguration    // The video stream’s configuration.
    case supportedAudioStreamConfiguration    // The audio stream’s configuration.
    case selectedStreamConfiguration    // The selected stream’s configuration.
    case setupStreamEndpoint    // The stream's endpoint configuration.
    case audioFeedback    // An indicator of whether audio feedback, like a beep or other external sound mechanism, is enabled.
    case volume    // The input or output volume of an audio device.
    case mute    // A control for muting audio.
    case active    // The current status of an accessory.
    case statusTampered    // An indicator of whether an accessory has been tampered with.
    case statusFault    // An indicator of whether the accessory has experienced a fault.
    case statusActive    // An indicator of whether the service is working.
    case inUse    // The current usage state of an accessory.
    case isConfigured    // The configuration state of an accessory.
    case remainingDuration    // The number of seconds remaining for the activity being carried out by the accessory.
    case setDuration    // The duration of the activity being carried out by the accessory.
    case programMode    // The current mode of the accessory’s scheduled programs.
    case name    // The name of the accessory.
    case identify    // A control you can use to ask the accessory to identify itself.
    case version    // The version of the accessory.
    case logs    // Log data for the accessory.
    case adminOnlyAccess    // An indicator of whether the accessory accepts only administrator access.
    case hardwareVersion    // The hardware version of the accessory.
    case softwareVersion    // The software version of the accessory.
    case labelIndex    // The index of the label for the service on an accessory with multiple instances of the same service.
    case labelNamespace    // The naming schema used to label the services on an accessory with multiple services of the same type.
    case manufacturer    // The manufacturer of the accessory.
    case model    // The model of the accessory.
    case firmwareVersion    // The firmware version of the accessory.
    case serialNumber    // The serial number of the accessory.
    case unknown
    
    public var description: String {
        switch self {
        case .currentLightLevel:
            return "HMCharacteristicTypeCurrentLightLevel"
        case .hue:
            return "HMCharacteristicTypeHue"
        case .brightness:
            return "HMCharacteristicTypeBrightness"
        case .saturation:
            return "HMCharacteristicTypeSaturation"
        case .colorTemperature:
            return "HMCharacteristicTypeColorTemperature"
        case .batteryLevel:
            return "HMCharacteristicTypeBatteryLevel"
        case .chargingState:
            return "HMCharacteristicTypeChargingState"
        case .contactState:
            return "HMCharacteristicTypeContactState"
        case .outletInUse:
            return "HMCharacteristicTypeOutletInUse"
        case .powerState:
            return "HMCharacteristicTypePowerState"
        case .statusLowBattery:
            return "HMCharacteristicTypeStatusLowBattery"
        case .outputState:
            return "HMCharacteristicTypeOutputState"
        case .inputEvent:
            return "HMCharacteristicTypeInputEvent"
        case .currentTemperature:
            return "HMCharacteristicTypeCurrentTemperature"
        case .targetTemperature:
            return "HMCharacteristicTypeTargetTemperature"
        case .temperatureUnits:
            return "HMCharacteristicTypeTemperatureUnits"
        case .targetHeatingCooling:
            return "HMCharacteristicTypeTargetHeatingCooling"
        case .currentHeatingCooling:
            return "HMCharacteristicTypeCurrentHeatingCooling"
        case .targetHeaterCoolerState:
            return "HMCharacteristicTypeTargetHeaterCoolerState"
        case .currentHeaterCoolerState:
            return "HMCharacteristicTypeCurrentHeaterCoolerState"
        case .coolingThreshold:
            return "HMCharacteristicTypeCoolingThreshold"
        case .heatingThreshold:
            return "HMCharacteristicTypeHeatingThreshold"
        case .currentRelativeHumidity:
            return "HMCharacteristicTypeCurrentRelativeHumidity"
        case .targetRelativeHumidity:
            return "HMCharacteristicTypeTargetRelativeHumidity"
        case .currentHumidifierDehumidifierState:
            return "HMCharacteristicTypeCurrentHumidifierDehumidifierState"
        case .targetHumidifierDehumidifierState:
            return "HMCharacteristicTypeTargetHumidifierDehumidifierState"
        case .humidifierThreshold:
            return "HMCharacteristicTypeHumidifierThreshold"
        case .dehumidifierThreshold:
            return "HMCharacteristicTypeDehumidifierThreshold"
        case .airQuality:
            return "HMCharacteristicTypeAirQuality"
        case .airParticulateDensity:
            return "HMCharacteristicTypeAirParticulateDensity"
        case .airParticulateSize:
            return "HMCharacteristicTypeAirParticulateSize"
        case .smokeDetected:
            return "HMCharacteristicTypeSmokeDetected"
        case .carbonDioxideDetected:
            return "HMCharacteristicTypeCarbonDioxideDetected"
        case .carbonDioxideLevel:
            return "HMCharacteristicTypeCarbonDioxideLevel"
        case .carbonDioxidePeakLevel:
            return "HMCharacteristicTypeCarbonDioxidePeakLevel"
        case .carbonMonoxideDetected:
            return "HMCharacteristicTypeCarbonMonoxideDetected"
        case .carbonMonoxideLevel:
            return "HMCharacteristicTypeCarbonMonoxideLevel"
        case .carbonMonoxidePeakLevel:
            return "HMCharacteristicTypeCarbonMonoxidePeakLevel"
        case .nitrogenDioxideDensity:
            return "HMCharacteristicTypeNitrogenDioxideDensity"
        case .ozoneDensity:
            return "HMCharacteristicTypeOzoneDensity"
        case .pM10Density:
            return "HMCharacteristicTypePM10Density"
        case .pM2_5Density:
            return "HMCharacteristicTypePM2_5Density"
        case .sulphurDioxideDensity:
            return "HMCharacteristicTypeSulphurDioxideDensity"
        case .volatileOrganicCompoundDensity:
            return "HMCharacteristicTypeVolatileOrganicCompoundDensity"
        case .currentFanState:
            return "HMCharacteristicTypeCurrentFanState"
        case .targetFanState:
            return "HMCharacteristicTypeTargetFanState"
        case .rotationDirection:
            return "HMCharacteristicTypeRotationDirection"
        case .rotationSpeed:
            return "HMCharacteristicTypeRotationSpeed"
        case .swingMode:
            return "HMCharacteristicTypeSwingMode"
        case .currentAirPurifierState:
            return "HMCharacteristicTypeCurrentAirPurifierState"
        case .targetAirPurifierState:
            return "HMCharacteristicTypeTargetAirPurifierState"
        case .filterLifeLevel:
            return "HMCharacteristicTypeFilterLifeLevel"
        case .filterChangeIndication:
            return "HMCharacteristicTypeFilterChangeIndication"
        case .filterResetChangeIndication:
            return "HMCharacteristicTypeFilterResetChangeIndication"
        case .waterLevel:
            return "HMCharacteristicTypeWaterLevel"
        case .valveType:
            return "HMCharacteristicTypeValveType"
        case .leakDetected:
            return "HMCharacteristicTypeLeakDetected"
        case .currentDoorState:
            return "HMCharacteristicTypeCurrentDoorState"
        case .targetDoorState:
            return "HMCharacteristicTypeTargetDoorState"
        case .currentPosition:
            return "HMCharacteristicTypeCurrentPosition"
        case .targetPosition:
            return "HMCharacteristicTypeTargetPosition"
        case .positionState:
            return "HMCharacteristicTypePositionState"
        case .statusJammed:
            return "HMCharacteristicTypeStatusJammed"
        case .holdPosition:
            return "HMCharacteristicTypeHoldPosition"
        case .slatType:
            return "HMCharacteristicTypeSlatType"
        case .currentSlatState:
            return "HMCharacteristicTypeCurrentSlatState"
        case .currentHorizontalTilt:
            return "HMCharacteristicTypeCurrentHorizontalTilt"
        case .targetHorizontalTilt:
            return "HMCharacteristicTypeTargetHorizontalTilt"
        case .currentVerticalTilt:
            return "HMCharacteristicTypeCurrentVerticalTilt"
        case .targetVerticalTilt:
            return "HMCharacteristicTypeTargetVerticalTilt"
        case .currentTilt:
            return "HMCharacteristicTypeCurrentTilt"
        case .targetTilt:
            return "HMCharacteristicTypeTargetTilt"
        case .lockManagementAutoSecureTimeout:
            return "HMCharacteristicTypeLockManagementAutoSecureTimeout"
        case .lockManagementControlPoint:
            return "HMCharacteristicTypeLockManagementControlPoint"
        case .lockMechanismLastKnownAction:
            return "HMCharacteristicTypeLockMechanismLastKnownAction"
        case .lockPhysicalControls:
            return "HMCharacteristicTypeLockPhysicalControls"
        case .motionDetected:
            return "HMCharacteristicTypeMotionDetected"
        case .currentLockMechanismState:
            return "HMCharacteristicTypeCurrentLockMechanismState"
        case .targetLockMechanismState:
            return "HMCharacteristicTypeTargetLockMechanismState"
        case .currentSecuritySystemState:
            return "HMCharacteristicTypeCurrentSecuritySystemState"
        case .targetSecuritySystemState:
            return "HMCharacteristicTypeTargetSecuritySystemState"
        case .obstructionDetected:
            return "HMCharacteristicTypeObstructionDetected"
        case .occupancyDetected:
            return "HMCharacteristicTypeOccupancyDetected"
        case .securitySystemAlarmType:
            return "HMCharacteristicTypeSecuritySystemAlarmType"
        case .supportedRTPConfiguration:
            return "HMCharacteristicTypeSupportedRTPConfiguration"
        case .digitalZoom:
            return "HMCharacteristicTypeDigitalZoom"
        case .opticalZoom:
            return "HMCharacteristicTypeOpticalZoom"
        case .imageMirroring:
            return "HMCharacteristicTypeImageMirroring"
        case .imageRotation:
            return "HMCharacteristicTypeImageRotation"
        case .nightVision:
            return "HMCharacteristicTypeNightVision"
        case .streamingStatus:
            return "HMCharacteristicTypeStreamingStatus"
        case .supportedVideoStreamConfiguration:
            return "HMCharacteristicTypeSupportedVideoStreamConfiguration"
        case .supportedAudioStreamConfiguration:
            return "HMCharacteristicTypeSupportedAudioStreamConfiguration"
        case .selectedStreamConfiguration:
            return "HMCharacteristicTypeSelectedStreamConfiguration"
        case .setupStreamEndpoint:
            return "HMCharacteristicTypeSetupStreamEndpoint"
        case .audioFeedback:
            return "HMCharacteristicTypeAudioFeedback"
        case .volume:
            return "HMCharacteristicTypeVolume"
        case .mute:
            return "HMCharacteristicTypeMute"
        case .active:
            return "HMCharacteristicTypeActive"
        case .statusTampered:
            return "HMCharacteristicTypeStatusTampered"
        case .statusFault:
            return "HMCharacteristicTypeStatusFault"
        case .statusActive:
            return "HMCharacteristicTypeStatusActive"
        case .inUse:
            return "HMCharacteristicTypeInUse"
        case .isConfigured:
            return "HMCharacteristicTypeIsConfigured"
        case .remainingDuration:
            return "HMCharacteristicTypeRemainingDuration"
        case .setDuration:
            return "HMCharacteristicTypeSetDuration"
        case .programMode:
            return "HMCharacteristicTypeProgramMode"
        case .name:
            return "HMCharacteristicTypeName"
        case .identify:
            return "HMCharacteristicTypeIdentify"
        case .version:
            return "HMCharacteristicTypeVersion"
        case .logs:
            return "HMCharacteristicTypeLogs"
        case .adminOnlyAccess:
            return "HMCharacteristicTypeAdminOnlyAccess"
        case .hardwareVersion:
            return "HMCharacteristicTypeHardwareVersion"
        case .softwareVersion:
            return "HMCharacteristicTypeSoftwareVersion"
        case .labelIndex:
            return "HMCharacteristicTypeLabelIndex"
        case .labelNamespace:
            return "HMCharacteristicTypeLabelNamespace"
        case .manufacturer:
            return "HMCharacteristicTypeManufacturer"
        case .model:
            return "HMCharacteristicTypeModel"
        case .firmwareVersion:
            return "HMCharacteristicTypeFirmwareVersion"
        case .serialNumber:
            return "HMCharacteristicTypeSerialNumber"
        default:
            return "Unknown"
        }
    }

    public var detail: String {
        switch self {
        case .currentLightLevel:
            return "The current light level."
        case .hue:
            return "The hue of the color used by a light."
        case .brightness:
            return "The brightness of a light."
        case .saturation:
            return "The saturation of the color used by a light."
        case .colorTemperature:
            return "The color temperature of a light."
        case .batteryLevel:
            return "The battery level of the accessory."
        case .chargingState:
            return "The charging state of a battery."
        case .contactState:
            return "The state of a contact sensor."
        case .outletInUse:
            return "The state of an outlet."
        case .powerState:
            return "The power state of the accessory."
        case .statusLowBattery:
            return "A low battery indicator."
        case .outputState:
            return "The output state of a programmable switch."
        case .inputEvent:
            return "The input event of a programmable switch."
        case .currentTemperature:
            return "The current temperature measured by the accessory."
        case .targetTemperature:
            return "The target temperature for the accessory to achieve."
        case .temperatureUnits:
            return "The units of temperature currently active on the accessory."
        case .targetHeatingCooling:
            return "The target heating or cooling mode for a thermostat."
        case .currentHeatingCooling:
            return "The current heating or cooling mode for a thermostat."
        case .targetHeaterCoolerState:
            return "The target state for a device that heats or cools, like an oven or a refrigerator."
        case .currentHeaterCoolerState:
            return "The current state for a device that heats or cools, like an oven or a refrigerator."
        case .coolingThreshold:
            return "The temperature above which cooling will be active."
        case .heatingThreshold:
            return "The temperature below which heating will be active."
        case .currentRelativeHumidity:
            return "The current relative humidity measured by the accessory."
        case .targetRelativeHumidity:
            return "The target relative humidity for the accessory to achieve."
        case .currentHumidifierDehumidifierState:
            return "The current state of a humidifier or dehumidifier accessory."
        case .targetHumidifierDehumidifierState:
            return "The state that a humidifier or dehumidifier accessory should try to achieve."
        case .humidifierThreshold:
            return "The humidity below which a humidifier should begin to work."
        case .dehumidifierThreshold:
            return "The humidity above which a dehumidifier should begin to work."
        case .airQuality:
            return "The air quality."
        case .airParticulateDensity:
            return "The density of air-particulate matter."
        case .airParticulateSize:
            return "The size of the air-particulate matter."
        case .smokeDetected:
            return "A smoke detection indicator."
        case .carbonDioxideDetected:
            return "An indicator of abnormally high levels of carbon dioxide."
        case .carbonDioxideLevel:
            return "The measured carbon dioxide level."
        case .carbonDioxidePeakLevel:
            return "The highest recorded level of carbon dioxide."
        case .carbonMonoxideDetected:
            return "An indicator of abnormally high levels of carbon monoxide."
        case .carbonMonoxideLevel:
            return "The measured carbon monoxide level."
        case .carbonMonoxidePeakLevel:
            return "The highest recorded level of carbon monoxide."
        case .nitrogenDioxideDensity:
            return "The measured density of nitrogen dioxide."
        case .ozoneDensity:
            return "The measured density of ozone."
        case .pM10Density:
            return "The measured density of air-particulate matter of size 10 micrograms."
        case .pM2_5Density:
            return "The measured density of air-particulate matter of size 2.5 micrograms."
        case .sulphurDioxideDensity:
            return "The measured density of sulphur dioxide."
        case .volatileOrganicCompoundDensity:
            return "The measured density of volatile organic compounds."
        case .currentFanState:
            return "The current state of a fan."
        case .targetFanState:
            return "The target state of a fan."
        case .rotationDirection:
            return "The rotation direction of an accessory like a fan."
        case .rotationSpeed:
            return "The rotation speed of an accessory like a fan."
        case .swingMode:
            return "An indicator of whether a fan swings back and forth during operation."
        case .currentAirPurifierState:
            return "The current air purifier state."
        case .targetAirPurifierState:
            return "The target air purifier state."
        case .filterLifeLevel:
            return "The amount of useful life remaining in a filter."
        case .filterChangeIndication:
            return "A filter’s change indicator."
        case .filterResetChangeIndication:
            return "A reset control for a filter change notification."
        case .waterLevel:
            return "The water level measured by an accessory."
        case .valveType:
            return "The type of automated valve that controls fluid flow."
        case .leakDetected:
            return "A leak detection indicator."
        case .currentDoorState:
            return "The current door state."
        case .targetDoorState:
            return "The target door state."
        case .currentPosition:
            return "The current position of a door, window, awning, or window covering."
        case .targetPosition:
            return "The target position of a door, window, awning, or window covering."
        case .positionState:
            return "The position of an accessory like a door, window, awning, or window covering."
        case .statusJammed:
            return "An indicator of whether an accessory is jammed."
        case .holdPosition:
            return "A control for holding the position of an accessory like a door or window."
        case .slatType:
            return "The type of slat on an accessory like a window or a fan."
        case .currentSlatState:
            return "The current state of slats on an accessory like a window or a fan."
        case .currentHorizontalTilt:
            return "The current tilt angle of a horizontal slat for an accessory like a window or a fan."
        case .targetHorizontalTilt:
            return "The target tilt angle of a horizontal slat for an accessory like a window or a fan."
        case .currentVerticalTilt:
            return "The current tilt angle of a vertical slat for an accessory like a window or a fan."
        case .targetVerticalTilt:
            return "The target tilt angle of a vertical slat for an accessory like a window or a fan."
        case .currentTilt:
            return "The current tilt angle of a slat for an accessory like a window or a fan."
        case .targetTilt:
            return "The target tilt angle of a slat for an accessory like a window or a fan."
        case .lockManagementAutoSecureTimeout:
            return "The automatic timeout for a lockable accessory that supports automatic lockout."
        case .lockManagementControlPoint:
            return "A control that accepts vendor-specific actions for lock management."
        case .lockMechanismLastKnownAction:
            return "The last known action of the locking mechanism."
        case .lockPhysicalControls:
            return "The lock’s physical control state."
        case .motionDetected:
            return "An indicator of whether the accessory has detected motion."
        case .currentLockMechanismState:
            return "The current state of the locking mechanism."
        case .targetLockMechanismState:
            return "The target state for the locking mechanism."
        case .currentSecuritySystemState:
            return "The current security system state."
        case .targetSecuritySystemState:
            return "The target security system state."
        case .obstructionDetected:
            return "An indicator of whether an obstruction is detected, as when something prevents a garage door from closing."
        case .occupancyDetected:
            return "An indicator of whether the home is occupied."
        case .securitySystemAlarmType:
            return "The alarm trigger state."
        case .supportedRTPConfiguration:
            return "The supported Real-time Transport Protocol (RTP) configuration."
        case .digitalZoom:
            return "The digital zoom of a video Real-time Transport Protocol (RTP) service."
        case .opticalZoom:
            return "The optical zoom setting of the camera sourcing a video Real-time Transport Protocol (RTP) service."
        case .imageMirroring:
            return "An indicator of whether the image should be flipped about the vertical axis."
        case .imageRotation:
            return "The angle of rotation for an image."
        case .nightVision:
            return "An indicator of whether night vision is enabled on a video Real-time Transport Protocol (RTP) service."
        case .streamingStatus:
            return "A description of the status of the Real-time Transport Protocol (RTP) stream management service."
        case .supportedVideoStreamConfiguration:
            return "The video stream’s configuration."
        case .supportedAudioStreamConfiguration:
            return "The audio stream’s configuration."
        case .selectedStreamConfiguration:
            return "The selected stream’s configuration."
        case .setupStreamEndpoint:
            return "The stream's endpoint configuration."
        case .audioFeedback:
            return "An indicator of whether audio feedback, like a beep or other external sound mechanism, is enabled."
        case .volume:
            return "The input or output volume of an audio device."
        case .mute:
            return "A control for muting audio."
        case .active:
            return "The current status of an accessory."
        case .statusTampered:
            return "An indicator of whether an accessory has been tampered with."
        case .statusFault:
            return "An indicator of whether the accessory has experienced a fault."
        case .statusActive:
            return "An indicator of whether the service is working."
        case .inUse:
            return "The current usage state of an accessory."
        case .isConfigured:
            return "The configuration state of an accessory."
        case .remainingDuration:
            return "The number of seconds remaining for the activity being carried out by the accessory."
        case .setDuration:
            return "The duration of the activity being carried out by the accessory."
        case .programMode:
            return "The current mode of the accessory’s scheduled programs."
        case .name:
            return "The name of the accessory."
        case .identify:
            return "A control you can use to ask the accessory to identify itself."
        case .version:
            return "The version of the accessory."
        case .logs:
            return "Log data for the accessory."
        case .adminOnlyAccess:
            return "An indicator of whether the accessory accepts only administrator access."
        case .hardwareVersion:
            return "The hardware version of the accessory."
        case .softwareVersion:
            return "The software version of the accessory."
        case .labelIndex:
            return "The index of the label for the service on an accessory with multiple instances of the same service."
        case .labelNamespace:
            return "The naming schema used to label the services on an accessory with multiple services of the same type."
        case .manufacturer:
            return "The manufacturer of the accessory."
        case .model:
            return "The model of the accessory."
        case .firmwareVersion:
            return "The firmware version of the accessory."
        case .serialNumber:
            return "The serial number of the accessory."
        case .unknown:
            return "Unknown"
        }
    }

#if !os(macOS)
    init(key: String) {
        switch key {
        case HMCharacteristicTypeCurrentLightLevel:
            self = .currentLightLevel
        case HMCharacteristicTypeHue:
            self = .hue
        case HMCharacteristicTypeBrightness:
            self = .brightness
        case HMCharacteristicTypeSaturation:
            self = .saturation
        case HMCharacteristicTypeColorTemperature:
            self = .colorTemperature
        case HMCharacteristicTypeBatteryLevel:
            self = .batteryLevel
        case HMCharacteristicTypeChargingState:
            self = .chargingState
        case HMCharacteristicTypeContactState:
            self = .contactState
        case HMCharacteristicTypeOutletInUse:
            self = .outletInUse
        case HMCharacteristicTypePowerState:
            self = .powerState
        case HMCharacteristicTypeStatusLowBattery:
            self = .statusLowBattery
        case HMCharacteristicTypeOutputState:
            self = .outputState
        case HMCharacteristicTypeInputEvent:
            self = .inputEvent
        case HMCharacteristicTypeCurrentTemperature:
            self = .currentTemperature
        case HMCharacteristicTypeTargetTemperature:
            self = .targetTemperature
        case HMCharacteristicTypeTemperatureUnits:
            self = .temperatureUnits
        case HMCharacteristicTypeTargetHeatingCooling:
            self = .targetHeatingCooling
        case HMCharacteristicTypeCurrentHeatingCooling:
            self = .currentHeatingCooling
        case HMCharacteristicTypeTargetHeaterCoolerState:
            self = .targetHeaterCoolerState
        case HMCharacteristicTypeCurrentHeaterCoolerState:
            self = .currentHeaterCoolerState
        case HMCharacteristicTypeCoolingThreshold:
            self = .coolingThreshold
        case HMCharacteristicTypeHeatingThreshold:
            self = .heatingThreshold
        case HMCharacteristicTypeCurrentRelativeHumidity:
            self = .currentRelativeHumidity
        case HMCharacteristicTypeTargetRelativeHumidity:
            self = .targetRelativeHumidity
        case HMCharacteristicTypeCurrentHumidifierDehumidifierState:
            self = .currentHumidifierDehumidifierState
        case HMCharacteristicTypeTargetHumidifierDehumidifierState:
            self = .targetHumidifierDehumidifierState
        case HMCharacteristicTypeHumidifierThreshold:
            self = .humidifierThreshold
        case HMCharacteristicTypeDehumidifierThreshold:
            self = .dehumidifierThreshold
        case HMCharacteristicTypeAirQuality:
            self = .airQuality
        case HMCharacteristicTypeAirParticulateDensity:
            self = .airParticulateDensity
        case HMCharacteristicTypeAirParticulateSize:
            self = .airParticulateSize
        case HMCharacteristicTypeSmokeDetected:
            self = .smokeDetected
        case HMCharacteristicTypeCarbonDioxideDetected:
            self = .carbonDioxideDetected
        case HMCharacteristicTypeCarbonDioxideLevel:
            self = .carbonDioxideLevel
        case HMCharacteristicTypeCarbonDioxidePeakLevel:
            self = .carbonDioxidePeakLevel
        case HMCharacteristicTypeCarbonMonoxideDetected:
            self = .carbonMonoxideDetected
        case HMCharacteristicTypeCarbonMonoxideLevel:
            self = .carbonMonoxideLevel
        case HMCharacteristicTypeCarbonMonoxidePeakLevel:
            self = .carbonMonoxidePeakLevel
        case HMCharacteristicTypeNitrogenDioxideDensity:
            self = .nitrogenDioxideDensity
        case HMCharacteristicTypeOzoneDensity:
            self = .ozoneDensity
        case HMCharacteristicTypePM10Density:
            self = .pM10Density
        case HMCharacteristicTypePM2_5Density:
            self = .pM2_5Density
        case HMCharacteristicTypeSulphurDioxideDensity:
            self = .sulphurDioxideDensity
        case HMCharacteristicTypeVolatileOrganicCompoundDensity:
            self = .volatileOrganicCompoundDensity
        case HMCharacteristicTypeCurrentFanState:
            self = .currentFanState
        case HMCharacteristicTypeTargetFanState:
            self = .targetFanState
        case HMCharacteristicTypeRotationDirection:
            self = .rotationDirection
        case HMCharacteristicTypeRotationSpeed:
            self = .rotationSpeed
        case HMCharacteristicTypeSwingMode:
            self = .swingMode
        case HMCharacteristicTypeCurrentAirPurifierState:
            self = .currentAirPurifierState
        case HMCharacteristicTypeTargetAirPurifierState:
            self = .targetAirPurifierState
        case HMCharacteristicTypeFilterLifeLevel:
            self = .filterLifeLevel
        case HMCharacteristicTypeFilterChangeIndication:
            self = .filterChangeIndication
        case HMCharacteristicTypeFilterResetChangeIndication:
            self = .filterResetChangeIndication
        case HMCharacteristicTypeWaterLevel:
            self = .waterLevel
        case HMCharacteristicTypeValveType:
            self = .valveType
        case HMCharacteristicTypeLeakDetected:
            self = .leakDetected
        case HMCharacteristicTypeCurrentDoorState:
            self = .currentDoorState
        case HMCharacteristicTypeTargetDoorState:
            self = .targetDoorState
        case HMCharacteristicTypeCurrentPosition:
            self = .currentPosition
        case HMCharacteristicTypeTargetPosition:
            self = .targetPosition
        case HMCharacteristicTypePositionState:
            self = .positionState
        case HMCharacteristicTypeStatusJammed:
            self = .statusJammed
        case HMCharacteristicTypeHoldPosition:
            self = .holdPosition
        case HMCharacteristicTypeSlatType:
            self = .slatType
        case HMCharacteristicTypeCurrentSlatState:
            self = .currentSlatState
        case HMCharacteristicTypeCurrentHorizontalTilt:
            self = .currentHorizontalTilt
        case HMCharacteristicTypeTargetHorizontalTilt:
            self = .targetHorizontalTilt
        case HMCharacteristicTypeCurrentVerticalTilt:
            self = .currentVerticalTilt
        case HMCharacteristicTypeTargetVerticalTilt:
            self = .targetVerticalTilt
        case HMCharacteristicTypeCurrentTilt:
            self = .currentTilt
        case HMCharacteristicTypeTargetTilt:
            self = .targetTilt
        case HMCharacteristicTypeLockManagementAutoSecureTimeout:
            self = .lockManagementAutoSecureTimeout
        case HMCharacteristicTypeLockManagementControlPoint:
            self = .lockManagementControlPoint
        case HMCharacteristicTypeLockMechanismLastKnownAction:
            self = .lockMechanismLastKnownAction
        case HMCharacteristicTypeLockPhysicalControls:
            self = .lockPhysicalControls
        case HMCharacteristicTypeMotionDetected:
            self = .motionDetected
        case HMCharacteristicTypeCurrentLockMechanismState:
            self = .currentLockMechanismState
        case HMCharacteristicTypeTargetLockMechanismState:
            self = .targetLockMechanismState
        case HMCharacteristicTypeCurrentSecuritySystemState:
            self = .currentSecuritySystemState
        case HMCharacteristicTypeTargetSecuritySystemState:
            self = .targetSecuritySystemState
        case HMCharacteristicTypeObstructionDetected:
            self = .obstructionDetected
        case HMCharacteristicTypeOccupancyDetected:
            self = .occupancyDetected
        case HMCharacteristicTypeSecuritySystemAlarmType:
            self = .securitySystemAlarmType
        case HMCharacteristicTypeSupportedRTPConfiguration:
            self = .supportedRTPConfiguration
        case HMCharacteristicTypeDigitalZoom:
            self = .digitalZoom
        case HMCharacteristicTypeOpticalZoom:
            self = .opticalZoom
        case HMCharacteristicTypeImageMirroring:
            self = .imageMirroring
        case HMCharacteristicTypeImageRotation:
            self = .imageRotation
        case HMCharacteristicTypeNightVision:
            self = .nightVision
        case HMCharacteristicTypeStreamingStatus:
            self = .streamingStatus
        case HMCharacteristicTypeSupportedVideoStreamConfiguration:
            self = .supportedVideoStreamConfiguration
        case HMCharacteristicTypeSupportedAudioStreamConfiguration:
            self = .supportedAudioStreamConfiguration
        case HMCharacteristicTypeSelectedStreamConfiguration:
            self = .selectedStreamConfiguration
        case HMCharacteristicTypeSetupStreamEndpoint:
            self = .setupStreamEndpoint
        case HMCharacteristicTypeAudioFeedback:
            self = .audioFeedback
        case HMCharacteristicTypeVolume:
            self = .volume
        case HMCharacteristicTypeMute:
            self = .mute
        case HMCharacteristicTypeActive:
            self = .active
        case HMCharacteristicTypeStatusTampered:
            self = .statusTampered
        case HMCharacteristicTypeStatusFault:
            self = .statusFault
        case HMCharacteristicTypeStatusActive:
            self = .statusActive
        case HMCharacteristicTypeInUse:
            self = .inUse
        case HMCharacteristicTypeIsConfigured:
            self = .isConfigured
        case HMCharacteristicTypeRemainingDuration:
            self = .remainingDuration
        case HMCharacteristicTypeSetDuration:
            self = .setDuration
        case HMCharacteristicTypeProgramMode:
            self = .programMode
        case HMCharacteristicTypeName:
            self = .name
        case HMCharacteristicTypeIdentify:
            self = .identify
        case HMCharacteristicTypeVersion:
            self = .version
        case HMCharacteristicTypeLogs:
            self = .logs
        case HMCharacteristicTypeAdminOnlyAccess:
            self = .adminOnlyAccess
        case HMCharacteristicTypeHardwareVersion:
            self = .hardwareVersion
        case HMCharacteristicTypeSoftwareVersion:
            self = .softwareVersion
        case HMCharacteristicTypeLabelIndex:
            self = .labelIndex
        case HMCharacteristicTypeLabelNamespace:
            self = .labelNamespace
//        case HMCharacteristicTypeManufacturer:
//            self = .manufacturer
//        case HMCharacteristicTypeModel:
//            self = .model
//        case HMCharacteristicTypeFirmwareVersion:
//            self = .firmwareVersion
//        case HMCharacteristicTypeSerialNumber:
//            self = .serialNumber
        default:
            self = .unknown
        }
    }
#endif
}
