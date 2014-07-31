//
//  TorrentTests.swift
//  TorrentTests
//
//  Copyright (c) 2014 Bryant Luk. All rights reserved.
//

import Cocoa
import XCTest

import Torrent

class TorrentTests: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }

  func testBencodeString() {
    let str = "spam"
    let bencodedData = bencode(str)
    let bstr = "4:spam"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!, "Expected bencode data")
  }

  func testBencodeInt() {
    let x = 1234
    let bencodedData = bencode(x)
    let bstr = "i1234e"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeNegativeInt() {
    let x = -1234
    let bencodedData = bencode(x)
    let bstr = "i-1234e"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeStringArray() {
    let arr: [String] = ["spam", "eggs"]
    let bencodedData = bencode(arr)
    let bstr = "l4:spam4:eggse"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeIntArray() {
    let arr: [Int] = [1234, 5678]
    let bencodedData = bencode(arr)
    let bstr = "li1234ei5678ee"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeMixedArray() {
    let arr = [1234, 5678, "spam"]
    let bencodedData = bencode(arr)
    let bstr = "li1234ei5678e4:spame"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeDictionary() {
    let dict: [String:AnyObject] = ["spam" : "eggs", "abcd" : "efg", "xyz" : 1234]
    let bencodedData = bencode(dict)
    let bstr = "d4:abcd3:efg4:spam4:eggs3:xyzi1234ee"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeStringDictionary() {
    let dict: [String:String] = ["spam" : "eggs", "abcd" : "efg"]
    let bencodedData = bencode(dict)
    let bstr = "d4:abcd3:efg4:spam4:eggse"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeInnerDictionary() {
    let dict: [String:AnyObject] = ["spam" : "eggs", "abcd" : "efg", "inner" : ["a" : [1, 2, 3]]]
    let bencodedData = bencode(dict)
    let bstr = "d4:abcd3:efg5:innerd1:ali1ei2ei3eee4:spam4:eggse"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

}
