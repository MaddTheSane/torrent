//
//  Bencode.swift
//  Torrent
//
//  Copyright (c) 2014 Bryant Luk. All rights reserved.
//

import Foundation

public protocol Bencodable {
  func bencode() -> NSData
}

extension String : Bencodable {
  public func bencode() -> NSData {
    let data = NSMutableData()
    let str = "\(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)):"
    data.appendData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
    data.appendData(self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
    return data
  }
}

extension Int : Bencodable {
  public func bencode() -> NSData {
    let data = NSMutableData()
    let str = "i\(String(self))e"
    data.appendData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
    return data
  }
}

public func bencode(arr : Array<Bencodable>) -> NSData {
  let data = NSMutableData()
  data.appendData("l".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  for item in arr {
    data.appendData(item.bencode())
  }
  data.appendData("e".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  return data
}

public func bencode(dict : Dictionary<String, Bencodable>) -> NSData {
  let data = NSMutableData()
  data.appendData("d".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))

  let sortedKeys = sorted(Array(dict.keys))
  for key in sortedKeys {
    data.appendData(key.bencode())
    let item = dict[key]
    data.appendData(item!.bencode())
  }

  data.appendData("e".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  return data
}