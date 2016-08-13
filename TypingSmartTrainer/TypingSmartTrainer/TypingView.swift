//
//  TypingTextView.swift
//  Smart Typing Help
//
//  Created by Philip Alex Etling on 6/24/16.
//  Copyright © 2016 GC. All rights reserved.
//

import Foundation
import Cocoa

class TypingView: NSView {
  var seconds = 0.0
  var currentTime: NSTimeInterval = 0.0
  var label: NSTextField = NSTextField()
  var timer: NSTextField = NSTextField()
  var seenFirstKeyStroke = false;
  private var typingLogic: TypingLogic = TypingLogic(typingGoal: "")
  var typingString: String {
    get {
      return self.typingLogic.typingGoal
    }
    set(newValue) {
      self.typingLogic = TypingLogic(typingGoal: newValue)
      label.attributedStringValue = createColoredAttributedString()
      self.timer.stringValue = "00:00"
    }
  }
  
  override var acceptsFirstResponder: Bool {
    get {
      return true
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.subviews = [self.label, self.timer]
    self.label.editable = false
    self.label.frame = self.frame
    self.timer.editable = false
    self.timer.font = NSFont(name: "Georgia", size: 30)
    self.timer.frame = NSRect(x: self.frame.size.width - 100, y: 0, width: 100, height: 100)
  }
  
  private func incrementTime() {
    let newTime: NSTimeInterval = NSDate().timeIntervalSince1970;
    seconds = seconds +  newTime - self.currentTime;
    self.currentTime = newTime
  }
  
  private func setupTimes() {
    self.seconds = 0.0
    self.currentTime = NSDate().timeIntervalSince1970
  }
  
  private func updateClock() {
    self.incrementTime()
    self.timer.stringValue = "\(Int(self.seconds/60.0)):\(Int(self.seconds) % 60)"
  }
  
  override func keyDown(theEvent: NSEvent) {
    if (!self.seenFirstKeyStroke) {
      self.setupTimes()
      self.seenFirstKeyStroke = true
    }
    
    self.updateClock()
    if theEvent.characters! == "\u{7F}"{
      self.typingLogic.deleteCharacter()
    } else {
      var character = theEvent.characters![theEvent.characters!.startIndex]
      character = character == "\r" ? "\n" : character
      self.typingLogic.processCharacter(character)
    }
    
    if self.typingLogic.isDone() {
      label.attributedStringValue = self.createEndColoredAttributedString()
    } else {
      label.attributedStringValue = self.createColoredAttributedString()
    }
  }
  
  private func createCoreColoredAttributedString(string: String) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:NSFont(name: "Georgia", size: 18.0)!])
  }
  
  private func getEndString() -> String {
    var endString = "\n\n\n\n"
    endString += "Words Per Minute = \(Double(self.typingLogic.wordsTyped) / (self.seconds * 1.0 / 60.0)) \n"
    let incorrectPercentage = (self.typingLogic.charactersTyped - self.typingLogic.totalCharactersToType) * 100 / self.typingLogic.totalCharactersToType
    endString += "You had an incorrect rate of \(incorrectPercentage)%\n"
    endString += "Mistyped Context Map: \(self.typingLogic.mistypedContextMap)\n"
    
    return endString
  }
  
  private func createEndColoredAttributedString() -> NSAttributedString {
    let attributedString = self.createCoreColoredAttributedString(self.typingLogic.typingGoal + self.getEndString())
    
    for index in self.typingLogic.mistypedIndices.sort() {
      attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.redColor(), range: NSRange(location: index, length: 1))
    }
    return attributedString
  }
  
  private func createColoredAttributedString() -> NSAttributedString {
    let attributedString = self.createCoreColoredAttributedString(self.typingLogic.typingGoal);
    let correctIndex = self.typingLogic.correctIndex;
    let incorrectIndex = self.typingLogic.index;
    
    attributedString.addAttribute(NSBackgroundColorAttributeName, value: NSColor.greenColor(), range: NSRange(location:0, length: correctIndex + 1))
    attributedString.addAttribute(NSBackgroundColorAttributeName, value: NSColor.redColor(), range: NSRange(location:correctIndex + 1, length: (incorrectIndex - correctIndex)))
    attributedString.addAttribute(NSBackgroundColorAttributeName, value: NSColor.orangeColor(), range: NSRange(location: incorrectIndex+1, length:1))
    return attributedString
  }
  
  override func mouseDown(theEvent: NSEvent) {
    let dog = theEvent.absoluteX
    return
  }
  
  override func mouseEntered(theEvent: NSEvent) {
    let dog = theEvent.absoluteX
    return
  }
}