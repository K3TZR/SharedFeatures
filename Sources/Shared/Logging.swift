//
//  Logging.swift
//
//  Created by Douglas Adams on 11/29/22.
//

import Foundation

// ----------------------------------------------------------------------------
// MARK: - Public properties

public var logEntries: AsyncStream<LogEntry> {
  AsyncStream { continuation in _logStream = { logEntry in continuation.yield(logEntry) }
    continuation.onTermination = { @Sendable _ in } }}

public var logAlerts: AsyncStream<LogEntry> {
  AsyncStream { continuation in _logAlertStream = { logEntry in continuation.yield(logEntry) }
    continuation.onTermination = { @Sendable _ in } }}

public struct LogEntry: Equatable {
  public static func == (lhs: LogEntry, rhs: LogEntry) -> Bool {
    guard lhs.msg == rhs.msg else { return false }
    guard lhs.level == rhs.level else { return false }
    guard lhs.level == rhs.level else { return false }
    guard lhs.function.description == rhs.function.description else { return false }
    guard lhs.file.description == rhs.file.description else { return false }
    guard lhs.line == rhs.line else { return false }
    return true
  }
  
  public var msg: String
  public var level: LogLevel
  public var function: StaticString
  public var file: StaticString
  public var line: Int
  
  public init(_ msg: String, _ level: LogLevel, _ function: StaticString, _ file: StaticString, _ line: Int ) {
    self.msg = msg
    self.level = level
    self.function = function
    self.file = file
    self.line = line
  }
}

public enum LogLevel: String, CaseIterable {
    case debug
    case info
    case warning
    case error
}

// ----------------------------------------------------------------------------
// MARK: - Private properties

private var _logStream: (LogEntry) -> Void = { _ in }
private var _logAlertStream: (LogEntry) -> Void = { _ in }

// ----------------------------------------------------------------------------
// MARK: - Public methods

/// Given the domain and App name, ensure that the Log folder exista
/// - Parameter info: a tuple of domain and app name
/// - Returns: the URL of the log folder
public func setupLogFolder(_ info: (domain: String, appName: String)) -> URL? {
  func createAsNeeded(_ folder: String) -> URL? {
    let fileManager = FileManager.default
    let folderUrl = URL.appSupport.appendingPathComponent( folder )
    // try to create it
    do {
      try fileManager.createDirectory( at: folderUrl, withIntermediateDirectories: true, attributes: nil)
    } catch {
      return nil
    }
    return folderUrl
  }
  return createAsNeeded(info.domain + "." + info.appName + "/Logs")
}

/// Place log messages into the Log stream
/// - Parameters:
///   - msg: a text message
///   - level: the message level
///   - function: the function originating the entry
///   - file: the file originating the entry
///   - line: the line originating the entry
public func log(_ msg: String, _ level: LogLevel, _ function: StaticString, _ file: StaticString, _ line: Int) {
  _logStream( LogEntry(msg, level, function, file, line) )
  if level == .warning || level == .error {
    _logAlertStream(LogEntry(msg, level, function, file, line) )
  }
}
