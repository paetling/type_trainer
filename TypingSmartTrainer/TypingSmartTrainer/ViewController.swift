//
//  ViewController.swift
//  Smart Typing Help
//
//  Created by Philip Alex Etling on 6/24/16.
//  Copyright © 2016 GC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet var typingView: TypingView!
  override func viewDidLoad() {
    super.viewDidLoad()
    typingView.typingString = "export class StateAccessor extends controller.EngineStateAccessor {\n      constructor(accessorType: controller.AccessorType,\n                  protected controller: Controller) {"
  }
  
  override var representedObject: AnyObject? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  
}

