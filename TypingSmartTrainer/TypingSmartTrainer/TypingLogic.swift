//
//  TypingLogic.swift
//  Smart Typing Help
//
//  Created by Philip Alex Etling on 6/24/16.
//  Copyright © 2016 GC. All rights reserved.
//

import Foundation

var lowercaseChars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
var uppercaseChars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

class TypingLogic {
  var originalGoal: String;
  var typingGoal: String
  var index: Int = -1
  var correctIndex: Int = -1
  var maxIndex: Int = -1
  var charactersTyped: Int = 0
  var wordsTyped: Int = 0
  var totalCharactersToType = 0
  var preceedingCharacters: [Character] = [" ", " ", " ", " "]
  var mistypedContextMap: [String: Int] = [String: Int]()
  var mistypedCharacterMap: [String: Int] = [String: Int]()
  var mistypedIndices: Set = Set<Int>()
  var mistypedState: Bool {
    get {
      return self.index != self.correctIndex
    }
  }
  
  init(typingGoal: String) {
    self.originalGoal = typingGoal;
    self.typingGoal = typingGoal
  }
    
  internal func shuffle() {
    var wordArray = self.originalGoal.stringByReplacingOccurrencesOfString("\n", withString: " ").characters.split(" ").map(String.init)
    var newGoal = ""
    var currentLine = ""
    while wordArray.count > 0 {
        if (currentLine.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 150) {
            newGoal += "\n"
            currentLine = ""
        }
        let randomIndex = Int(arc4random_uniform(UInt32(wordArray.count)))
        var wordToAdd = "\(wordArray.removeAtIndex(randomIndex))"
        if wordArray.count > 0 {
            wordToAdd += " "
        }
        newGoal += wordToAdd
        currentLine += wordToAdd
    }
    self.typingGoal = newGoal
  }
    
  internal func updateMap(key: String, inout map:[String: Int]){
    map[key] = map[key] == nil ? 1 : map[key]! + 1
  }
  
  internal func updateMistypedContextMap(characters: [Character]) {
    self.updateMap(String(characters), map: &self.mistypedContextMap)
  }
  
  internal func updateMistypedCharacterMap(character: Character) {
    self.updateMap(String(character), map: &self.mistypedCharacterMap)
  }
  
  internal func incrementWordsTyped(character: Character) {
    if (!self.mistypedState){
      let last = String(self.preceedingCharacters.last!)
      
      if !(lowercaseChars + uppercaseChars).contains(String(character)) &&
        (lowercaseChars + uppercaseChars).contains(last) {
        self.wordsTyped += 1
        return
      }
      
      if lowercaseChars.contains(last) &&
        uppercaseChars.contains(String(character)) {
        self.wordsTyped += 1
        return
      }
      
      if self.correctIndex == self.typingGoal.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - 1 {
        self.wordsTyped += 1
      }
    }
  }
  
  internal func shiftPreceedingCharacters(character: Character) {
    self.preceedingCharacters.append(character)
    self.preceedingCharacters.removeAtIndex(0)
  }
  
  internal func incrementIndices(incrementCorrect: Bool) {
    let newIndex = self.index + 1
    if (incrementCorrect) {
      self.correctIndex += 1
      if (newIndex > self.maxIndex) {
        self.maxIndex += 1
      }
    }
    self.index = newIndex
  }
  
  internal func decrementIndices(decrementCorrect: Bool) {
    if (decrementCorrect) {
      self.correctIndex = max(-1, self.correctIndex - 1)
    }
    self.index = max(-1, self.index - 1)
  }
  
  internal func fillWhiteSpace() {
    var currentIndex = self.index
    let character = self.typingGoal[self.typingGoal.startIndex.advancedBy(currentIndex)];
    if (character == "\n") {
      currentIndex += 1
      while(currentIndex < self.typingGoal.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) {
        let currentChar = self.typingGoal[self.typingGoal.startIndex.advancedBy(currentIndex)]
        if (currentChar == " " || currentChar == "\n") {
          self.incrementIndices(!self.mistypedState)
        } else {
          break
        }
        currentIndex += 1
      }
    }
  }
  
  internal func removeWhiteSpace() {
    var currentIndex = index
    if currentIndex < 0 { return }
    let character = self.typingGoal[self.typingGoal.startIndex.advancedBy(currentIndex)];
    if (character == " ") {
      let initialIndex = self.index
      let initialCorrect = self.correctIndex
      let initialMax = self.maxIndex
      
      while(currentIndex >= 0) {
        if (self.typingGoal[self.typingGoal.startIndex.advancedBy(currentIndex)] != " ") {
          if (self.typingGoal[self.typingGoal.startIndex.advancedBy(currentIndex)] != "\n"){
            self.index = initialIndex
            self.correctIndex = initialCorrect
            self.maxIndex = initialMax
          }
          break;
        }
        
        self.decrementIndices(!self.mistypedState)
        currentIndex -= 1
      }
    }
  }
  
  func isDone() -> Bool {
    return self.correctIndex == self.typingGoal.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - 1
  }
  
  func processCharacter(character: Character) -> Bool {
    let newIndex = self.index + 1
    if (isDone() || newIndex >= self.typingGoal.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) { return true}
    
    let expectedCharacter = self.typingGoal[self.typingGoal.startIndex.advancedBy(newIndex)];
    if (expectedCharacter != character) {
      if (!self.mistypedState) {
        self.updateMistypedContextMap(self.preceedingCharacters + [expectedCharacter])
      }
      self.updateMistypedCharacterMap(expectedCharacter)
      self.mistypedIndices.insert(newIndex)
    } else if (!self.mistypedState) {
      if (newIndex > self.maxIndex) {
        totalCharactersToType += 1
        self.incrementWordsTyped(character)
      }
    }
      
    self.incrementIndices(expectedCharacter == character && !self.mistypedState)
    self.shiftPreceedingCharacters(character)
    self.charactersTyped += 1;
      
    self.fillWhiteSpace()
    return expectedCharacter == character
 
  }
  
  func deleteCharacter() {
    self.shiftPreceedingCharacters("∂")
    self.decrementIndices(!self.mistypedState)
    self.removeWhiteSpace()
    self.charactersTyped += 1;
  }
}