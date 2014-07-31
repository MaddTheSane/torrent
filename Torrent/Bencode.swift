//
//  Bencode.swift
//  Torrent
//
//  Copyright (c) 2014 Bryant Luk. All rights reserved.
//

import Foundation

func decideToBencode(item : AnyObject) -> NSData? {
  if let bencodableData = item as? String {
    return bencode(bencodableData)
  } else if let bencodableData = item as? Int {
    return bencode(bencodableData)
  } else if let bencodableData = item as? Array<AnyObject> {
    return bencode(bencodableData)
  } else if let bencodableData = item as? Dictionary<String, AnyObject> {
    return bencode(bencodableData)
  }
  return nil
}

public func bencode(s : String) -> NSData {
  let data = NSMutableData()
  let str = "\(s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)):"
  data.appendData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  data.appendData(s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  return data
}

public func bencode(i : Int) -> NSData {
  let data = NSMutableData()
  let str = "i\(String(i))e"
  data.appendData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  return data
}

public func bencode(arr : [AnyObject]) -> NSData {
  let data = NSMutableData()
  let s : Array<AnyObject> = []
  data.appendData("l".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  for item in arr {
    if let bencodedData = decideToBencode(item) {
      data.appendData(bencodedData)
    }
  }
  data.appendData("e".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
  return data
}

public func bencode(dict : [String:AnyObject]) -> NSData {
    let data = NSMutableData()
    data.appendData("d".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))

    let sortedKeys = sorted(Array(dict.keys))
    for key in sortedKeys {
      data.appendData(bencode(key))
      if let value: AnyObject = dict[key] {
        if let bencodedData = decideToBencode(value) {
          data.appendData(bencodedData)
        }
      }
    }

    data.appendData("e".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
    return data
}
