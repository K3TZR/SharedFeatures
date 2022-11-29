//
//  Protocols.swift
//
//  Created by Douglas Adams on 11/29/22.
//

import Foundation

/// UDP Stream handler protocol
public protocol StreamHandler: AnyObject {
  /// Process a frame of Stream data
  /// - Parameter frame:        a frame of data
  func streamHandler<T>(_ frame: T)
}

/// UDP AudioStream handler protocol
public protocol AudioStreamHandler: AnyObject {
  /// Process a frame of Audio data
  /// - Parameters:
  ///   - buffer: the data
  ///   - samples: sample count
  func sendAudio(buffer: [UInt8], samples: Int)
}
