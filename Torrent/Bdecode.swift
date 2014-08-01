//
//  Bdecode.swift
//  Torrent
//
//  Copyright (c) 2014 Bryant Luk. All rights reserved.
//

import Foundation

let eData = "e".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
let colonData = ":".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)

public func bdecode(data : NSData, offset : Int = 0) -> (value: AnyObject?, offset: Int) {
  if (data.length < offset) {
    return (nil, 0)
  }

  let type = nextCharacter(data, offset)
  
  if type == "i" {
    let val = decodeInt(data, offset: offset)
    return (val.value, val.offset)
  } else if (type >= "0" && type <= "9") {
    let val = decodeString(data, offset: offset)
    return (val.value, val.offset)
  } else if (type == "l") {
    let val = decodeArray(data, offset: offset)
    return (val.value, val.offset)
  } else if (type == "d") {
    let val = decodeDict(data, offset: offset)
    return (val.value, val.offset)
  }

  return (nil, offset)
}

func decodeInt(data : NSData, offset : Int = 0) -> (value: Int?, offset: Int) {
  let rangeAfterOffset = NSRange(location: offset, length: data.length - offset)
  let endRange = data.rangeOfData(eData, options: NSDataSearchOptions.fromRaw(0)!, range: rangeAfterOffset)
  let numData = data.subdataWithRange(NSRange(location: offset + 1, length:(endRange.location - offset)))
  let numStr = NSString(data: numData, encoding:NSUTF8StringEncoding)
  let scanner = NSScanner(string: numStr)
  var value = 0
  let scanned = scanner.scanInteger(&value)
  if scanned {
    if nextCharacter(data, endRange.location) != "e" {
      return (nil, offset)
    }
    return (value, endRange.location + 1)
  }
  return (nil, offset)
}

func decodeString(data : NSData, offset : Int = 0) -> (value: NSData?, offset: Int)  {
  let rangeAfterOffset = NSRange(location: offset, length: data.length - offset)
  let endRange = data.rangeOfData(colonData, options: NSDataSearchOptions.fromRaw(0)!, range: rangeAfterOffset)
  let numData = data.subdataWithRange(NSRange(location: offset, length:(endRange.location - offset)))
  let numStr = NSString(data: numData, encoding:NSUTF8StringEncoding)
  let scanner = NSScanner(string: numStr)
  var value = 0
  let scanned = scanner.scanInteger(&value)
  
  if scanned {
    return (data.subdataWithRange(NSRange(location: endRange.location + 1, length: value)), endRange.location + 1 + value)
  }
  
  return (nil, offset)
}

func decodeArray(data : NSData, offset : Int = 0) -> (value: [AnyObject]?, offset: Int)  {
  var arr : [AnyObject] = []
  
  if nextCharacter(data, offset + 1) == "e" {
    return (arr, offset + 2)
  }
  
  var (decodedObj : AnyObject?, newOffset: Int) = bdecode(data, offset: offset + 1)
  while let actualObj: AnyObject = decodedObj {
    arr += actualObj
    
    if nextCharacter(data, newOffset) == "e" {
      break
    }
    
    (decodedObj, newOffset) = bdecode(data, offset: newOffset)
  }
  
  if nextCharacter(data, newOffset) != "e" {
    return (nil, offset)
  }
  
  return (arr, newOffset + 1)
}

func decodeDict(data : NSData, offset : Int = 0) -> (value: [String:AnyObject]?, offset: Int)  {
  var dict : [String:AnyObject] = [String:AnyObject]()

  if nextCharacter(data, offset + 1) == "e" {
    return (dict, offset + 2)
  }
  
  var (decodedObj : AnyObject?, newOffset: Int) = bdecode(data, offset: offset + 1)
  while let actualObj : AnyObject = decodedObj {
    if let key = actualObj as? NSData {
      (decodedObj, newOffset) = bdecode(data, offset: newOffset)
      if let value : AnyObject = decodedObj {
        let keyStr = String(NSString(data: key, encoding: NSUTF8StringEncoding))
        dict[keyStr] = value
        
        if nextCharacter(data, newOffset) == "e" {
          break
        }
        
        (decodedObj, newOffset) = bdecode(data, offset: newOffset)
      } else {
        return (nil, offset)
      }
    } else {
      return (nil, offset)
    }
  }
  
  if nextCharacter(data, newOffset) != "e" {
    return (nil, offset)
  }
  
  return (dict, newOffset + 1)
}

func nextCharacter(data: NSData, offset: Int) -> String? {
  if (data.length < offset + 1) {
    return nil
  }
  
  let nextSubdata = data.subdataWithRange(NSRange(location: offset, length: 1))
  return String(NSString(data: nextSubdata, encoding:NSUTF8StringEncoding))
}
