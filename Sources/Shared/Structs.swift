//
//  Support.swift
//
//  Created by Douglas Adams on 10/23/21.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - Constants

public let kVersionSupported = Version("3.2.34")
public let kConnected = "connected"
public let kDisconnected = "disconnected"
public let kNoError = "0"
public let kNotInUse = "in_use=0"
public let kRemoved = "removed"

// ----------------------------------------------------------------------------
// MARK: - Structs & Enums

public struct DefaultValue: Equatable, Codable {
  public var serial: String
  public var source: String
  public var station: String?
  
  public init
  (
    _ selection: Pickable
  )
  {
    self.serial = selection.packet.serial
    self.source = selection.packet.source.rawValue
    self.station = selection.station
  }
}

public enum ConnectionError: String, Error {
  case instantiation = "Failed to create Radio object"
  case connection = "Failed to connect to Radio"
  case replyError = "Reply with error"
  case tcpConnect = "Tcp Failed to connect"
  case udpBind = "Udp Failed to bind"
  case wanConnect = "WanConnect Failed"
  case wanValidation = "WanValidation Failed"
}

public enum ConnectionType: String, Equatable {
  case gui = "Radio"
  case nonGui = "Station"
}

/// Struct to hold a Semantic Version number
///     with provision for a Build Number
///
public struct Version {
  var major: Int = 1
  var minor: Int = 0
  var patch: Int = 0
  var build: Int = 1
  
  public init(_ versionString: String = "1.0.0") {
    let components = versionString.components(separatedBy: ".")
    switch components.count {
    case 3:
      major = Int(components[0]) ?? 1
      minor = Int(components[1]) ?? 0
      patch = Int(components[2]) ?? 0
      build = 1
    case 4:
      major = Int(components[0]) ?? 1
      minor = Int(components[1]) ?? 0
      patch = Int(components[2]) ?? 0
      build = Int(components[3]) ?? 1
    default:
      major = 1
      minor = 0
      patch = 0
      build = 1
    }
  }
  
  public init() {
    // only useful for Apps & Frameworks (which have a Bundle), not Packages
    let versions = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "?"
    let build   = Bundle.main.infoDictionary![kCFBundleVersionKey as String] as? String ?? "?"
    self.init(versions + ".\(build)")
  }
  
  public var longString: String { "\(major).\(minor).\(patch) (\(build))" }
  public var string: String { "\(major).\(minor).\(patch)" }
  
  public static func == (lhs: Version, rhs: Version) -> Bool { lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch }
  
  public static func < (lhs: Version, rhs: Version) -> Bool {
    switch (lhs, rhs) {
      
    case (let lhs, let rhs) where lhs == rhs: return false
    case (let lhs, let rhs) where lhs.major < rhs.major: return true
    case (let lhs, let rhs) where lhs.major == rhs.major && lhs.minor < rhs.minor: return true
    case (let lhs, let rhs) where lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch < rhs.patch: return true
    default: return false
    }
  }
  public static func >= (lhs: Version, rhs: Version) -> Bool {
    switch (lhs, rhs) {
      
    case (let lhs, let rhs) where lhs == rhs: return true
    case (let lhs, let rhs) where lhs.major > rhs.major: return true
    case (let lhs, let rhs) where lhs.major == rhs.major && lhs.minor > rhs.minor: return true
    case (let lhs, let rhs) where lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch > rhs.patch: return true
    default: return false
    }
  }
}

public enum TcpMessageDirection {
  case received
  case sent
}

public struct TcpMessage: Identifiable, Equatable {
  public var id: UUID
  public var text: String
  public var direction: TcpMessageDirection
  public var timeStamp: Date
  public var interval: Double
  public var color: Color

  public static func == (lhs: TcpMessage, rhs: TcpMessage) -> Bool {
    lhs.id == rhs.id
  }
  
  public init
  (
    text: String,
    direction: TcpMessageDirection = .received,
    timeStamp: Date = Date(),
    interval: Double,
    color: Color = .primary
  )
  {
    self.id = UUID()
    self.text = text
    self.direction = direction
    self.timeStamp = timeStamp
    self.interval = interval
    self.color = color
  }
  
}

public enum ConnectionMode: String, Identifiable, CaseIterable {
  case both
  case local
  case none
  case smartlink
  
  public var id: String { rawValue }
}

public enum WanStatusType {
  case connect
  case publicIp
  case settings
}

public struct WanStatus: Equatable {
  public var type: WanStatusType
  public var name: String?
  public var callsign: String?
  public var serial: String?
  public var wanHandle: String?
  public var publicIp: String?

  public init(
    _ type: WanStatusType,
    _ name: String?,
    _ callsign: String?,
    _ serial: String?,
    _ wanHandle: String?,
    _ publicIp: String?
  )
  {
    self.type = type
    self.name = name
    self.callsign = callsign
    self.serial = serial
    self.wanHandle = wanHandle
    self.publicIp = publicIp
  }
}

public enum WanListenerError: Error {
  case kFailedToObtainIdToken
  case kFailedToConnect
}

public struct TestResult: Equatable {
  public var upnpTcpPortWorking = false
  public var upnpUdpPortWorking = false
  public var forwardTcpPortWorking = false
  public var forwardUdpPortWorking = false
  public var natSupportsHolePunch = false
  public var radioSerial = ""
  
  public init() {}
  
  // format the result as a String
  public var description: String {
        """
        Forward Tcp Port:\t\t\(forwardTcpPortWorking)
        Forward Udp Port:\t\t\(forwardUdpPortWorking)
        UPNP Tcp Port:\t\t\(upnpTcpPortWorking)
        UPNP Udp Port:\t\t\(upnpUdpPortWorking)
        Nat Hole Punch:\t\t\(natSupportsHolePunch)
        """
  }
  
  // result was Success / Failure
  public var success: Bool {
    (
      forwardTcpPortWorking == true &&
      forwardUdpPortWorking == true &&
      upnpTcpPortWorking == false &&
      upnpUdpPortWorking == false &&
      natSupportsHolePunch  == false) ||
    (
      forwardTcpPortWorking == false &&
      forwardUdpPortWorking == false &&
      upnpTcpPortWorking == true &&
      upnpUdpPortWorking == true &&
      natSupportsHolePunch  == false)
  }
}

/// Struct containing RemoteRxAudio (Opus) Stream data
public struct RemoteRxAudioFrame {
  
  // ----------------------------------------------------------------------------
  // MARK: - Public properties
  
  public var samples: [UInt8]                     // array of samples
  public var numberOfSamples: Int                 // number of samples
  //  public var duration: Float                     // frame duration (ms)
  //  public var channels: Int                       // number of channels (1 or 2)
  
  // ----------------------------------------------------------------------------
  // MARK: - Initialization
  
  /// Initialize a RemoteRxAudioFrame
  /// - Parameters:
  ///   - payload:            pointer to the Vita packet payload
  ///   - numberOfSamples:    number of Samples in the payload
  public init(payload: [UInt8], sampleCount: Int) {
    // allocate the samples array
    samples = [UInt8](repeating: 0, count: sampleCount)
    
    // save the count and copy the data
    numberOfSamples = sampleCount
    memcpy(&samples, payload, sampleCount)
    
    // Flex 6000 series always uses:
    //     duration = 10 ms
    //     channels = 2 (stereo)
    
    //    // determine the frame duration
    //    let durationCode = (samples[0] & 0xF8)
    //    switch durationCode {
    //    case 0xC0:
    //      duration = 2.5
    //    case 0xC8:
    //      duration = 5.0
    //    case 0xD0:
    //      duration = 10.0
    //    case 0xD8:
    //      duration = 20.0
    //    default:
    //      duration = 0
    //    }
    //    // determine the number of channels (mono = 1, stereo = 2)
    //    channels = (samples[0] & 0x04) == 0x04 ? 2 : 1
  }
}
