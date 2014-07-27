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
    let bencodedData = str.bencode()
    let bstr = "4:spam"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!, "Expected bencode data")
  }

  func testBencodeInt() {
    let x = 1234
    let bencodedData = x.bencode()
    let bstr = "i1234e"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeNegativeInt() {
    let x = -1234
    let bencodedData = x.bencode()
    let bstr = "i-1234e"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeArray() {
    let arr: [Bencodable] = ["spam", "eggs"]
    let bencodedData = bencode(arr)
    let bstr = "l4:spam4:eggse"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeMixedArray() {
    let arr: [Bencodable] = ["spam", "eggs", 1234]
    let bencodedData = bencode(arr)
    let bstr = "l4:spam4:eggsi1234ee"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }

  func testBencodeDictionary() {
    let dict: [String:Bencodable] = ["spam" : "eggs", "abcd" : "efg", "xyz" : 1234]
    let bencodedData = bencode(dict)
    let bstr = "d4:abcd3:efg4:spam4:eggs3:xyzi1234ee"
    let expectedData = bstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    XCTAssertEqual(bencodedData, expectedData!)
  }
}
