//
//  Smart_Typing_HelpTests.swift
//  Smart Typing HelpTests
//
//  Created by Philip Alex Etling on 6/24/16.
//  Copyright © 2016 GC. All rights reserved.
//

import XCTest
@testable import Smart_Typing_Help

class TestTypingLogic: TypingLogic {
  override func updateMap(key: String, inout map:[String: Int]){
    super.updateMap(key, map:&map)
  }
  override func updateMistypedContextMap(characters: [Character]){
    super.updateMistypedContextMap(characters)
  }
  override func updateMistypedCharacterMap(character: Character){
    super.updateMistypedCharacterMap(character)
  }
  override func incrementWordsTyped(character: Character) {
    super.incrementWordsTyped(character)
  }
  
  override func shiftPreceedingCharacters(character: Character) {
    super.shiftPreceedingCharacters(character)
  }
}

class TypingLogicTest: XCTestCase {
    
  func testUpdateMap() {
    var map: [String: Int] = [:]
    let typingLogic = TypingLogic(typingGoal: "Test String 1; Test String 2;")
    typingLogic.updateMap("a", map: &map)
    typingLogic.updateMap("asdfas", map: &map)
    typingLogic.updateMap("asdfas", map: &map)
    typingLogic.updateMap("dog", map: &map)
    
    XCTAssertEqual(map["a"], 1)
    XCTAssertEqual(map["asdfas"], 2)
    XCTAssertEqual(map["dog"], 1)
    XCTAssertEqual(map["b"], nil)
  }
  
  func testUpdateMistypedContextMap() {
    let typingLogic = TestTypingLogic(typingGoal: "Test String 1; Test String 2;")
    typingLogic.updateMistypedContextMap(["a"])
    typingLogic.updateMistypedContextMap(["a", "s", "d", "f", "a", "s"])
    typingLogic.updateMistypedContextMap(["a", "s", "d", "f", "a", "s"])
    typingLogic.updateMistypedContextMap(["d", "o", "g"])
    
    var map: [String: Int] = typingLogic.mistypedContextMap;
    
    XCTAssertEqual(map["a"], 1)
    XCTAssertEqual(map["asdfas"], 2)
    XCTAssertEqual(map["dog"], 1)
    XCTAssertEqual(map["b"], nil)
  }
  
  func testUpdateMistypedCharachterMap() {
    let typingLogic = TestTypingLogic(typingGoal: "Test String 1; Test String 2;")
    typingLogic.updateMistypedCharacterMap("a")
    typingLogic.updateMistypedCharacterMap("1")
    typingLogic.updateMistypedCharacterMap("b")
    typingLogic.updateMistypedCharacterMap("a")
    typingLogic.updateMistypedCharacterMap("2")
    typingLogic.updateMistypedCharacterMap("1")
    
    var map: [String: Int] = typingLogic.mistypedCharacterMap;
    
    XCTAssertEqual(map["a"], 2)
    XCTAssertEqual(map["1"], 2)
    XCTAssertEqual(map["b"], 1)
    XCTAssertEqual(map["2"], 1)
    XCTAssertEqual(map["c"], nil)
  }
  
  func testIncrementWordsTyped() {
    let typingLogic = TestTypingLogic(typingGoal: "The number of\nwords typedIs_seven!")

    for character in "The number of".characters {
      typingLogic.incrementWordsTyped(character)
      typingLogic.shiftPreceedingCharacters(character)
    }
    XCTAssertEqual(typingLogic.wordsTyped, 2)
    
    for character in "\nwords typedIs_seven".characters {
      typingLogic.incrementWordsTyped(character)
      typingLogic.shiftPreceedingCharacters(character)
    }
    XCTAssertEqual(typingLogic.wordsTyped, 6)
    typingLogic.correctIndex = 33
    typingLogic.index = 33
    typingLogic.incrementWordsTyped("!")
    XCTAssertEqual(typingLogic.wordsTyped, 7)
  }
  
  func testShiftProceedingCharacters() {
    let typingLogic = TestTypingLogic(typingGoal: "Test String 1; Test String 2;")
    
    typingLogic.shiftPreceedingCharacters("a")
    XCTAssertEqual(typingLogic.preceedingCharacters, [" ", " ", " ", "a"])
    typingLogic.shiftPreceedingCharacters("b")
    XCTAssertEqual(typingLogic.preceedingCharacters, [" ", " ", "a", "b"])
    typingLogic.shiftPreceedingCharacters("1")
    XCTAssertEqual(typingLogic.preceedingCharacters, [" ", "a", "b", "1"])
    typingLogic.shiftPreceedingCharacters("Z")
    XCTAssertEqual(typingLogic.preceedingCharacters, ["a", "b", "1", "Z"])
    typingLogic.shiftPreceedingCharacters("2")
    XCTAssertEqual(typingLogic.preceedingCharacters, ["b", "1", "Z", "2"])
    typingLogic.shiftPreceedingCharacters(" ")
    XCTAssertEqual(typingLogic.preceedingCharacters, ["1", "Z", "2", " "])
  }
  
  func testProcessCharacter1() {
    let typingLogic = TestTypingLogic(typingGoal: "Test String 1; Test String 2;")
    
    XCTAssertEqual(typingLogic.processCharachter("T"), true)
    XCTAssertEqual(typingLogic.index, 0)
    XCTAssertEqual(typingLogic.correctIndex, 0)
    XCTAssertEqual(typingLogic.maxIndex, 0)
    
    XCTAssertEqual(typingLogic.processCharachter("e"), true)
    XCTAssertEqual(typingLogic.processCharachter("s"), true)
    XCTAssertEqual(typingLogic.processCharachter("t"), true)
    XCTAssertEqual(typingLogic.index, 3)
    XCTAssertEqual(typingLogic.correctIndex, 3)
    XCTAssertEqual(typingLogic.maxIndex, 3)
    
    XCTAssertEqual(typingLogic.processCharachter("s"), false)
    XCTAssertEqual(typingLogic.index, 4)
    XCTAssertEqual(typingLogic.correctIndex, 3)
    XCTAssertEqual(typingLogic.maxIndex, 3)
    
    XCTAssertEqual(typingLogic.processCharachter("S"), true)
    XCTAssertEqual(typingLogic.processCharachter("t"), true)
    XCTAssertEqual(typingLogic.processCharachter("r"), true)
    XCTAssertEqual(typingLogic.index, 7)
    XCTAssertEqual(typingLogic.correctIndex, 3)
    XCTAssertEqual(typingLogic.maxIndex, 3)
  }
  
  func testDeleteCharacter1() {
    let typingLogic = TestTypingLogic(typingGoal: "Test String 1; Test String 2;")
    
    XCTAssertEqual(typingLogic.processCharachter("T"), true)
    XCTAssertEqual(typingLogic.index, 0)
    XCTAssertEqual(typingLogic.correctIndex, 0)
    XCTAssertEqual(typingLogic.maxIndex, 0)
    
    XCTAssertEqual(typingLogic.processCharachter("e"), true)
    XCTAssertEqual(typingLogic.processCharachter("s"), true)
    XCTAssertEqual(typingLogic.processCharachter("t"), true)
    XCTAssertEqual(typingLogic.index, 3)
    XCTAssertEqual(typingLogic.correctIndex, 3)
    XCTAssertEqual(typingLogic.maxIndex, 3)
    
    XCTAssertEqual(typingLogic.processCharachter("s"), false)
    XCTAssertEqual(typingLogic.index, 4)
    XCTAssertEqual(typingLogic.correctIndex, 3)
    XCTAssertEqual(typingLogic.maxIndex, 3)
    
    typingLogic.deleteCharacter()
    XCTAssertEqual(typingLogic.index, 3)
    XCTAssertEqual(typingLogic.correctIndex, 3)
    XCTAssertEqual(typingLogic.maxIndex, 3)
    
    XCTAssertEqual(typingLogic.processCharachter(" "), true)
    XCTAssertEqual(typingLogic.processCharachter("S"), true)
    XCTAssertEqual(typingLogic.processCharachter("t"), true)
    XCTAssertEqual(typingLogic.processCharachter("r"), true)
    XCTAssertEqual(typingLogic.index, 7)
    XCTAssertEqual(typingLogic.correctIndex, 7)
    XCTAssertEqual(typingLogic.maxIndex, 7)
  }
  
  func testIsDone() {
    let typingLogic = TestTypingLogic(typingGoal: "Test String 1")
    
    XCTAssertEqual(typingLogic.processCharachter("T"), true)
    XCTAssertEqual(typingLogic.isDone(), false)
    
    XCTAssertEqual(typingLogic.processCharachter("e"), true)
    XCTAssertEqual(typingLogic.processCharachter("s"), true)
    XCTAssertEqual(typingLogic.processCharachter("t"), true)
    XCTAssertEqual(typingLogic.isDone(), false)
    
    XCTAssertEqual(typingLogic.processCharachter("s"), false)
    XCTAssertEqual(typingLogic.isDone(), false)
    
    typingLogic.deleteCharacter()
    XCTAssertEqual(typingLogic.isDone(), false)
    
    XCTAssertEqual(typingLogic.processCharachter(" "), true)
    XCTAssertEqual(typingLogic.processCharachter("S"), true)
    XCTAssertEqual(typingLogic.processCharachter("t"), true)
    XCTAssertEqual(typingLogic.processCharachter("r"), true)
    XCTAssertEqual(typingLogic.processCharachter("i"), true)
    XCTAssertEqual(typingLogic.processCharachter("n"), true)
    XCTAssertEqual(typingLogic.processCharachter("g"), true)
    XCTAssertEqual(typingLogic.processCharachter(" "), true)
    XCTAssertEqual(typingLogic.isDone(), false)
    
    XCTAssertEqual(typingLogic.processCharachter(" "), false)
    XCTAssertEqual(typingLogic.isDone(), false)
    typingLogic.deleteCharacter()
    XCTAssertEqual(typingLogic.processCharachter("1"), true)
    XCTAssertEqual(typingLogic.isDone(), true)
  }
  
}
