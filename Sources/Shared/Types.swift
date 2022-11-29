//
//  Types.swift
//
//  Created by Douglas Adams on 5/16/22.
//

import Foundation

// ----------------------------------------------------------------------------
// MARK: - Type Aliases

// ids
public typealias AmplifierId = UInt32
public typealias BandId = UInt32
public typealias DaxIqStreamId = UInt32
public typealias DaxMicAudioStreamId = UInt32
public typealias DaxRxAudioStreamId = UInt32
public typealias DaxTxAudioStreamId = UInt32
public typealias EqualizerId = String
public typealias GuiClientId = String
public typealias MemoryId = UInt32
public typealias MeterId = UInt32
public typealias PanadapterId = UInt32
public typealias ProfileId = String
public typealias RadioId = String
public typealias RemoteRxAudioStreamId = UInt32
public typealias RemoteTxAudioStreamId = UInt32
public typealias SliceId = UInt32
public typealias TnfId = UInt32
public typealias UsbCableId = String
public typealias WaterfallId = UInt32
public typealias XvtrId = UInt32

// other
public typealias AntennaPort = String
public typealias Handle = UInt32
public typealias Hz = Int
public typealias IdToken = String
public typealias KeyValuesArray = [(key:String, value:String)]
public typealias MHz = Double
public typealias MeterName  = String
public typealias MicrophonePort = String
//public typealias ObjectId = UInt16
//public typealias ObjectId = UInt32
public typealias ProfileName = String
public typealias ReplyHandler = (_ command: String, _ seqNumber: SequenceNumber, _ responseValue: String, _ reply: String) -> Void
public typealias ReplyTuple = (replyTo: ReplyHandler?, command: String, continuation: CheckedContinuation<String,Error>?)
public typealias RfGainValue = String
public typealias SequenceNumber = UInt
public typealias StreamId = UInt32
public typealias ValuesArray = [String]

public typealias Log = (_ msg: String, _ level: LogLevel, _ function: StaticString, _ file: StaticString, _ line: Int) -> Void
