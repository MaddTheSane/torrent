//
//  BdecodeTests.swift
//  Torrent
//
//  Copyright (c) 2014 Bryant Luk. All rights reserved.
//

import Cocoa
import XCTest

import Torrent

class BdecodeTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testBdecodeInt() {
    let x = 1234
    let bencodedData = bencode(x)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    XCTAssertEqual(x, decodedData as Int)
  }

  func testBdecodeNegativeInt() {
    let x = -1234
    let bencodedData = bencode(x)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    XCTAssertEqual(x, decodedData as Int)
  }
  
  func testBdecodeZeroInt() {
    let x = 0
    let bencodedData = bencode(x)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    XCTAssertEqual(x, decodedData as Int)
  }

  func testBdecodeString() {
    let x = "abcd"
    let bencodedData = bencode(x)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    let decodedString : NSString = NSString(data: decodedData as NSData, encoding: NSUTF8StringEncoding)
    XCTAssertEqual(x, decodedString as String)
  }
  
  func testBdecodeEmptyString() {
    let x = ""
    let bencodedData = bencode(x)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    let decodedString : NSString = NSString(data: decodedData as NSData, encoding: NSUTF8StringEncoding)
    XCTAssertEqual(x, decodedString as String)
  }

  func testBdecodeArray() {
    let arr: [String] = ["spam", "eggs"]
    let bencodedData = bencode(arr)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    var decodedArray : [String] = []
    for item in (decodedData as [NSData]) {
      decodedArray += String(NSString(data: item, encoding: NSUTF8StringEncoding))
    }
    XCTAssertTrue(["spam", "eggs"] == decodedArray)
  }

  func testBdecodeMixedArray() {
    let arr : [AnyObject] = ["spam", "eggs", 1234]
    let bencodedData = bencode(arr)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    var decodedArray = decodedData as [AnyObject]
    
    XCTAssertEqual(arr[0] as String, String(NSString(data: decodedArray[0] as? NSData, encoding: NSUTF8StringEncoding)))
    XCTAssertEqual(arr[1] as String, String(NSString(data: decodedArray[1] as? NSData, encoding: NSUTF8StringEncoding)))
    XCTAssertEqual(arr[2] as Int, decodedArray[2] as Int)
    XCTAssertEqual(arr.count, decodedArray.count)
  }
  
  func testBdecodeEmptyArray() {
    let arr: [AnyObject] = []
    let bencodedData = bencode(arr)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    var decodedArray = decodedData as [AnyObject]
    XCTAssertEqual(arr.count, decodedArray.count)
  }

  func testBdecodeMixedDictionary() {
    let dict : [String:AnyObject] = ["spam" : "eggs", "num" : 1234]
    let bencodedData = bencode(dict)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    var decodedDict = decodedData as [String:AnyObject]
    
    var str = dict["spam"]! as String
    var decodedStr = String(NSString(data: decodedDict["spam"] as? NSData, encoding: NSUTF8StringEncoding))
    XCTAssertEqual(str, decodedStr)
    
    var int = dict["num"]! as Int
    var decodedInt = decodedDict["num"]! as Int
    XCTAssertEqual(int, decodedInt)
    
    XCTAssertEqual(dict.count, decodedDict.count)
  }

  func testBdecodeEmptyDictionary() {
    let dict : [String:AnyObject] = Dictionary<String, AnyObject>()
    let bencodedData = bencode(dict)
    let (decodedData: AnyObject?, offset: Int) = bdecode(bencodedData)
    var decodedDict = decodedData as [String:AnyObject]
    XCTAssertEqual(dict.count, decodedDict.count)
  }
}
