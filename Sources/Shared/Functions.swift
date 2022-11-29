//
//  Functions.swift
//
//  Created by Douglas Adams on 5/16/22.
//

import Foundation
// ----------------------------------------------------------------------------
// MARK: - Functions

/// Get the domain and App name
/// - Returns: a tuple
public func getBundleInfo() -> (domain: String, appName: String) {
  let bundleIdentifier = Bundle.main.bundleIdentifier!
  let separator = bundleIdentifier.lastIndex(of: ".")!
  let appName = String(bundleIdentifier.suffix(from: bundleIdentifier.index(separator, offsetBy: 1)))
  let domain = String(bundleIdentifier.prefix(upTo: separator))
  return (domain, appName)
}

/// Read a user default entry and transform it into a struct
/// - Parameters:
///    - key:         the name of the default
/// - Returns:        a struct or nil
public func getDefaultValue<T: Decodable>(_ key: String) -> T? {
  
  if let data = UserDefaults.standard.object(forKey: key) as? Data {
    let decoder = JSONDecoder()
    if let value = try? decoder.decode(T.self, from: data) {
      return value
    } else {
      return nil
    }
  }
  return nil
}

/// Write a user default entry for a struct
/// - Parameters:
///    - key:        the name of the default
///    - value:      a struct  to be encoded and written to user defaults
public func setDefaultValue<T: Encodable>(_ key: String, _ value: T?) {
  
  if value == nil {
    UserDefaults.standard.removeObject(forKey: key)
  } else {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(value) {
      UserDefaults.standard.set(encoded, forKey: key)
    } else {
      UserDefaults.standard.removeObject(forKey: key)
    }
  }
}
