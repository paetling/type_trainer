//
//  Smart_Typing_HelpTests.swift
//  Smart Typing HelpTests
//
//  Created by Philip Alex Etling on 6/24/16.
//  Copyright © 2016 GC. All rights reserved.
//

import XCTest
@testable import TypingSmartTrainer

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
    override func incrementIndices(incrementCorrect: Bool) {
        super.incrementIndices(incrementCorrect)
    }
    override func decrementIndices(decrementCorrect: Bool) {
        super.decrementIndices(decrementCorrect)
    }
    override func fillWhiteSpace() {
        super.fillWhiteSpace()
    }
    override func removeWhiteSpace() {
        super.removeWhiteSpace()
    }
    override func shuffle() {
        super.shuffle()
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
    
    func testShuffle1() {
        let originalGoal = "word1 word2 word3 word4 word5"
        let typingLogic = TypingLogic(typingGoal: originalGoal)
        XCTAssertEqual(typingLogic.typingGoal, originalGoal);
        
        typingLogic.shuffle()
        let newTypingGoal1 = typingLogic.typingGoal;
        typingLogic.shuffle()
        let newTypingGoal2 = typingLogic.typingGoal;
        typingLogic.shuffle()
        let newTypingGoal3 = typingLogic.typingGoal;
        
        XCTAssertEqual(newTypingGoal1.characters.split(" ").map(String.init).count, 5);
        XCTAssertEqual(newTypingGoal2.characters.split(" ").map(String.init).count, 5);
        XCTAssertEqual(newTypingGoal3.characters.split(" ").map(String.init).count, 5);
        for newTypingGoal in [newTypingGoal1, newTypingGoal2, newTypingGoal3] {
            var typingGoalArray = newTypingGoal.characters.split(" ").map(String.init);
            while (typingGoalArray.count > 0) {
                XCTAssert(originalGoal.containsString(typingGoalArray.popLast()!))
            }
        }
        XCTAssert(!typingLogic.typingGoal.containsString("\n"))
    }
    
    func testShuffle2() {
        let originalGoal = "word1\nword2\nword3\nword4\nword5"
        let typingLogic = TypingLogic(typingGoal: originalGoal)
        XCTAssertEqual(typingLogic.typingGoal, originalGoal);
        
        typingLogic.shuffle()
        let newTypingGoal1 = typingLogic.typingGoal;
        typingLogic.shuffle()
        let newTypingGoal2 = typingLogic.typingGoal;
        typingLogic.shuffle()
        let newTypingGoal3 = typingLogic.typingGoal;
        
        XCTAssertEqual(newTypingGoal1.characters.split(" ").map(String.init).count, 5);
        XCTAssertEqual(newTypingGoal2.characters.split(" ").map(String.init).count, 5);
        XCTAssertEqual(newTypingGoal3.characters.split(" ").map(String.init).count, 5);
        for newTypingGoal in [newTypingGoal1, newTypingGoal2, newTypingGoal3] {
            var typingGoalArray = newTypingGoal.characters.split(" ").map(String.init);
            while (typingGoalArray.count > 0) {
                XCTAssert(originalGoal.containsString(typingGoalArray.popLast()!))
            }
        }
        XCTAssert(!typingLogic.typingGoal.containsString("\n"))
    }
    
    func testShuffleNewLine() {
        var originalGoal = ""
        for _ in 1...50 {
            originalGoal += "a"
        }
        originalGoal = "\(originalGoal) \(originalGoal) \(originalGoal) \(originalGoal) \(originalGoal)"
        let typingLogic = TypingLogic(typingGoal: originalGoal)
        typingLogic.shuffle()
        XCTAssert(typingLogic.typingGoal.containsString("\n"))
        XCTAssertEqual(typingLogic.typingGoal.characters.split("\n").count, 2)
    }
    
    func testIncrementIndices1() {
        let typingLogic = TypingLogic(typingGoal: "Test String 1; Test String 2;")
        typingLogic.incrementIndices(true)
        XCTAssertEqual(typingLogic.index, 0);
        XCTAssertEqual(typingLogic.correctIndex, 0);
        XCTAssertEqual(typingLogic.maxIndex, 0);
    }
    
    func testIncrementIndices2() {
        let typingLogic = TypingLogic(typingGoal: "Test String 1; Test String 2;")
        typingLogic.incrementIndices(false)
        XCTAssertEqual(typingLogic.index, 0);
        XCTAssertEqual(typingLogic.correctIndex, -1);
        XCTAssertEqual(typingLogic.maxIndex, -1);
    }
    
    func testIncrementIndices3() {
        let typingLogic = TypingLogic(typingGoal: "Test String 1; Test String 2;")
        typingLogic.maxIndex = 5
        typingLogic.incrementIndices(true)
        XCTAssertEqual(typingLogic.index, 0);
        XCTAssertEqual(typingLogic.correctIndex, 0);
        XCTAssertEqual(typingLogic.maxIndex, 5);
    }
    
    func testDecrementIndices1() {
        let typingLogic = TypingLogic(typingGoal: "Test String 1; Test String 2;")
        typingLogic.maxIndex = 0
        typingLogic.correctIndex = 0
        typingLogic.index = 0;
        
        typingLogic.decrementIndices(true)
        XCTAssertEqual(typingLogic.index, -1);
        XCTAssertEqual(typingLogic.correctIndex, -1);
        XCTAssertEqual(typingLogic.maxIndex, 0);
        
        typingLogic.decrementIndices(true)
        XCTAssertEqual(typingLogic.index, -1);
        XCTAssertEqual(typingLogic.correctIndex, -1);
        XCTAssertEqual(typingLogic.maxIndex, 0);
    }
    
    func testDecrementIndices2() {
        let typingLogic = TypingLogic(typingGoal: "Test String 1; Test String 2;")
        typingLogic.maxIndex = 0
        typingLogic.correctIndex = 0
        typingLogic.index = 0;
        
        typingLogic.decrementIndices(false)
        XCTAssertEqual(typingLogic.index, -1);
        XCTAssertEqual(typingLogic.correctIndex, 0);
        XCTAssertEqual(typingLogic.maxIndex, 0);
    }
    
    func testFillWhiteSpace1() {
        let typingLogic = TypingLogic(typingGoal: "\n          Hello")
        typingLogic.processCharacter("\n")
        XCTAssertEqual(typingLogic.index, 10)
        XCTAssertEqual(typingLogic.correctIndex, 10)
        XCTAssertEqual(typingLogic.maxIndex, 10)
    }
    
    func testFillWhiteSpace2() {
        let typingLogic = TypingLogic(typingGoal: "\n          Hello")
        typingLogic.processCharacter("s")
        XCTAssertEqual(typingLogic.index, 10)
        XCTAssertEqual(typingLogic.correctIndex, -1)
        XCTAssertEqual(typingLogic.maxIndex, -1)
    }
    
    func testFillWhiteSpaceDoesNotCrash() {
        let typingLogic = TypingLogic(typingGoal: "\n          ")
        typingLogic.processCharacter("\n")
        XCTAssertEqual(typingLogic.index, 10)
        XCTAssertEqual(typingLogic.correctIndex, 10)
        XCTAssertEqual(typingLogic.maxIndex, 10)
    }
    
    func testRemoveWhiteSpace1() {
        let typingLogic = TypingLogic(typingGoal: "\n          Hello")
        typingLogic.processCharacter("\n")
        typingLogic.deleteCharacter()
        XCTAssertEqual(typingLogic.index, 0)
        XCTAssertEqual(typingLogic.correctIndex, 0)
        XCTAssertEqual(typingLogic.maxIndex, 10)
    }
    
    func testRemoveWhiteSpace2() {
        let typingLogic = TypingLogic(typingGoal: "a    asdf Hello")
        typingLogic.index = 4
        typingLogic.correctIndex = 4
        typingLogic.maxIndex = 4
        
        typingLogic.deleteCharacter()
        XCTAssertEqual(typingLogic.index, 3)
        XCTAssertEqual(typingLogic.correctIndex, 3)
        XCTAssertEqual(typingLogic.maxIndex, 4)
    }
    
    func testRemoveWhiteSpaceDoesNotCrash() {
        let typingLogic = TypingLogic(typingGoal: "          Hello")
        typingLogic.index = 9
        typingLogic.correctIndex = 9
        typingLogic.maxIndex = 9
        
        typingLogic.deleteCharacter()
        XCTAssertEqual(typingLogic.index, -1)
        XCTAssertEqual(typingLogic.correctIndex, -1)
        XCTAssertEqual(typingLogic.maxIndex, 9)
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
        
        XCTAssertEqual(typingLogic.processCharacter("T"), true)
        XCTAssertEqual(typingLogic.index, 0)
        XCTAssertEqual(typingLogic.correctIndex, 0)
        XCTAssertEqual(typingLogic.maxIndex, 0)
        
        XCTAssertEqual(typingLogic.processCharacter("e"), true)
        XCTAssertEqual(typingLogic.processCharacter("s"), true)
        XCTAssertEqual(typingLogic.processCharacter("t"), true)
        XCTAssertEqual(typingLogic.index, 3)
        XCTAssertEqual(typingLogic.correctIndex, 3)
        XCTAssertEqual(typingLogic.maxIndex, 3)
        
        XCTAssertEqual(typingLogic.processCharacter("s"), false)
        XCTAssertEqual(typingLogic.index, 4)
        XCTAssertEqual(typingLogic.correctIndex, 3)
        XCTAssertEqual(typingLogic.maxIndex, 3)
        
        XCTAssertEqual(typingLogic.processCharacter("S"), true)
        XCTAssertEqual(typingLogic.processCharacter("t"), true)
        XCTAssertEqual(typingLogic.processCharacter("r"), true)
        XCTAssertEqual(typingLogic.index, 7)
        XCTAssertEqual(typingLogic.correctIndex, 3)
        XCTAssertEqual(typingLogic.maxIndex, 3)
    }
    
    func testMistypedIndices() {
        let typingLogic = TestTypingLogic(typingGoal: "Test String 1;")
        
        typingLogic.processCharacter("T")
        typingLogic.processCharacter("e")
        typingLogic.processCharacter("d")
        typingLogic.processCharacter("d")
        typingLogic.deleteCharacter()
        typingLogic.deleteCharacter()
        typingLogic.processCharacter("s")
        typingLogic.processCharacter("t")
        typingLogic.processCharacter(" ")
        typingLogic.processCharacter("S")
        typingLogic.processCharacter("r")
        typingLogic.processCharacter("i")
        typingLogic.deleteCharacter()
        typingLogic.deleteCharacter()
        typingLogic.processCharacter("t")
        typingLogic.processCharacter("r")
        typingLogic.processCharacter("i")
        typingLogic.processCharacter("n")
        typingLogic.processCharacter("g")
        typingLogic.processCharacter(" ")
        typingLogic.processCharacter("1")
        typingLogic.processCharacter(" ")
        typingLogic.deleteCharacter()
        typingLogic.processCharacter(";")
        
        XCTAssertEqual(typingLogic.mistypedIndices.count, 5)
        XCTAssertEqual(typingLogic.mistypedIndices.sort(), [2, 3, 6, 7, 13])
    }
    
    func testDeleteCharacter1() {
        let typingLogic = TestTypingLogic(typingGoal: "Test String 1; Test String 2;")
        
        XCTAssertEqual(typingLogic.processCharacter("T"), true)
        XCTAssertEqual(typingLogic.index, 0)
        XCTAssertEqual(typingLogic.correctIndex, 0)
        XCTAssertEqual(typingLogic.maxIndex, 0)
        
        XCTAssertEqual(typingLogic.processCharacter("e"), true)
        XCTAssertEqual(typingLogic.processCharacter("s"), true)
        XCTAssertEqual(typingLogic.processCharacter("t"), true)
        XCTAssertEqual(typingLogic.index, 3)
        XCTAssertEqual(typingLogic.correctIndex, 3)
        XCTAssertEqual(typingLogic.maxIndex, 3)
        
        XCTAssertEqual(typingLogic.processCharacter("s"), false)
        XCTAssertEqual(typingLogic.index, 4)
        XCTAssertEqual(typingLogic.correctIndex, 3)
        XCTAssertEqual(typingLogic.maxIndex, 3)
        
        typingLogic.deleteCharacter()
        XCTAssertEqual(typingLogic.index, 3)
        XCTAssertEqual(typingLogic.correctIndex, 3)
        XCTAssertEqual(typingLogic.maxIndex, 3)
        
        XCTAssertEqual(typingLogic.processCharacter(" "), true)
        XCTAssertEqual(typingLogic.processCharacter("S"), true)
        XCTAssertEqual(typingLogic.processCharacter("r"), false)
        XCTAssertEqual(typingLogic.processCharacter("i"), false)
        XCTAssertEqual(typingLogic.index, 7)
        XCTAssertEqual(typingLogic.correctIndex, 5)
        XCTAssertEqual(typingLogic.maxIndex, 5)
        
        typingLogic.deleteCharacter()
        typingLogic.deleteCharacter()
        XCTAssertEqual(typingLogic.index, 5)
        XCTAssertEqual(typingLogic.correctIndex, 5)
        XCTAssertEqual(typingLogic.maxIndex, 5)
        
        XCTAssertEqual(typingLogic.processCharacter("t"), true)
        XCTAssertEqual(typingLogic.processCharacter("r"), true)
        XCTAssertEqual(typingLogic.index, 7)
        XCTAssertEqual(typingLogic.correctIndex, 7)
        XCTAssertEqual(typingLogic.maxIndex, 7)
        
        XCTAssertEqual(typingLogic.mistypedContextMap, ["Test ": 1, "s∂ St": 1])
    }
    
    func testIsDone() {
        let typingLogic = TestTypingLogic(typingGoal: "Test String 1")
        
        XCTAssertEqual(typingLogic.processCharacter("T"), true)
        XCTAssertEqual(typingLogic.isDone(), false)
        
        XCTAssertEqual(typingLogic.processCharacter("e"), true)
        XCTAssertEqual(typingLogic.processCharacter("s"), true)
        XCTAssertEqual(typingLogic.processCharacter("t"), true)
        XCTAssertEqual(typingLogic.isDone(), false)
        
        XCTAssertEqual(typingLogic.processCharacter("s"), false)
        XCTAssertEqual(typingLogic.isDone(), false)
        
        typingLogic.deleteCharacter()
        XCTAssertEqual(typingLogic.isDone(), false)
        
        XCTAssertEqual(typingLogic.processCharacter(" "), true)
        XCTAssertEqual(typingLogic.processCharacter("S"), true)
        XCTAssertEqual(typingLogic.processCharacter("t"), true)
        XCTAssertEqual(typingLogic.processCharacter("r"), true)
        XCTAssertEqual(typingLogic.processCharacter("i"), true)
        XCTAssertEqual(typingLogic.processCharacter("n"), true)
        XCTAssertEqual(typingLogic.processCharacter("g"), true)
        XCTAssertEqual(typingLogic.processCharacter(" "), true)
        XCTAssertEqual(typingLogic.isDone(), false)
        
        XCTAssertEqual(typingLogic.processCharacter(" "), false)
        XCTAssertEqual(typingLogic.isDone(), false)
        typingLogic.deleteCharacter()
        XCTAssertEqual(typingLogic.processCharacter("1"), true)
        XCTAssertEqual(typingLogic.isDone(), true)
    }
    
}
