//
//  InnerTextView+MultiLineEditing.swift
//  SavannaKit macOS
//
//  Created by Ivan on 12/29/21.
//  Copyright © 2021 Silver Fox. All rights reserved.
//

import AppKit
import Foundation


extension InnerTextView {
    
    
    
//    override func mouseDown(with event: NSEvent) {
//
//        guard
//            let textStorage = textStorage,
//            let textContainer = textContainer,
//            let layoutManager = layoutManager
//        else {
//            return
//        }
//
//        var fraction: CGFloat = 0
//
//        var _characterIndexForPoint: CGFloat?
//
//        let point = self.convert(event.locationInWindow, from: nil)
//
//        var index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: &fraction)
//
//        print(fraction)
//
//        if (fraction > 0.5 && index < textStorage.length &&
//            (textStorage.string as NSString).character(at: index) != 0)
//            {
//              index += 1;
//            }
//
//
//        //string.insert("😀", at: string.index(string.startIndex, offsetBy: (index ?? 0) - 1))
//
//        self.setSelectedRange(NSRange(location: index, length: 0))
//    }
//    
//    func characterIndex(for event: NSEvent) -> Int {
//        let point = self.convert(event.locationInWindow, from: nil)
//        var fraction: CGFloat = 0
//        
//        var index = layoutManager!.characterIndex(for: point, in: textContainer!, fractionOfDistanceBetweenInsertionPoints: &fraction)
//        
//        if (fraction > 0.5 && index < textStorage!.length &&
//            (textStorage!.string as NSString).character(at: index) != 0)
//        {
//          index += 1;
//        }
//        
//        return index
//    }
//    
//    func getNextEvent(block: Bool) {
//        var block = block
//        
//        if let nextEvent = self.window?.nextEvent(matching: [.leftMouseUp], until: nil, inMode: .eventTracking, dequeue: false) {
//            // we got a left mouse up, we don't want to block it so that NSTextView gets it
//            RunLoop.main.perform(inModes: [RunLoop.Mode.eventTracking, RunLoop.Mode.default]) {
//                self.setSelectedRange(NSRange(location: 0, length: 1))
//            }
//            return
//        }
//        
//        if let nextEvent = self.window?.nextEvent(matching: [.leftMouseDragged, ], until: nil, inMode: .eventTracking, dequeue: block) {
//            block = nextEvent.modifierFlags.contains(.option)
//            print(nextEvent)
//            
////            if(nextEvent.type == .leftMouseUp) {
////                self.window?.sendEvent(NSEvent.mouseEvent(with: .leftMouseUp, location: nextEvent.locationInWindow, modifierFlags: nextEvent.modifierFlags, timestamp: nextEvent.timestamp, windowNumber: nextEvent.windowNumber, context: nil, eventNumber: nextEvent.eventNumber, clickCount: nextEvent.clickCount, pressure: nextEvent.pressure)!)
////                return
////            }
//        }
//        
//        
//        RunLoop.main.perform(inModes: [RunLoop.Mode.eventTracking, RunLoop.Mode.default]) {
//            self.getNextEvent(block: block)
//        }
//    }
//    
//    override func mouseDown(with event: NSEvent) {
////        startIndex = characterIndex(for: event)
////        if(event.clickCount == 1) {
////            let range = NSRange(location: characterIndex(for: event), length: 0)
////            self.setSelectedRange(range)
////        } else {
////            super.mouseDown(with: event)
////        }
//        RunLoop.main.perform(inModes: [RunLoop.Mode.eventTracking, RunLoop.Mode.default]) {
//            self.getNextEvent(block: event.modifierFlags.contains(.option))
//        }
//        super.mouseDown(with: event)
//    }
//    
    override func mouseDragged(with event: NSEvent) {
//        let endIndex = characterIndex(for: event)
//        let range = NSRange(location: min(startIndex, endIndex), length: max(startIndex, endIndex) - min(startIndex, endIndex))
//        self.setSelectedRange(range)
    }
    
//    override func mouseDown(with event: NSEvent) {
//
//        self.autoscroll(with: <#T##NSEvent#>)
//
//        RunLoop.main.perform(inModes: [RunLoop.Mode.eventTracking, RunLoop.Mode.default]) {
//                    self.displayToggle.state = self.df.bool(forKey: "CaffeinateDisplay") ? .on : .off
//                    self.advancedProcToggle.state = self.df.bool(forKey: "AdvancedProcessSelector") ? .on : .off
//                }
//
//
//        //super.mouseDown(with: event)
//
//        while true {
//                guard let nextEvent = self.window?.nextEvent(matching: [.leftMouseUp, .leftMouseDragged]) else { continue }
//                let mouseLocation = self.convert(nextEvent.locationInWindow, from: nil)
//
//                switch nextEvent.type {
//                case .leftMouseDragged:
//                    print("dragged")
//
//                case .leftMouseUp:
//
//                        print("up")
//                    return
//
//                default: break
//                }
//            }
//
//    }
    
//    override func mouseMoved(with event: NSEvent) {
//        if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)) {
//            let point = self.convert(event.locationInWindow, from: nil)
//            //let index = characterIndex(for: point)
//            var fraction: CGFloat = 0
//            var index = layoutManager!.characterIndex(for: point, in: textContainer!, fractionOfDistanceBetweenInsertionPoints: &fraction)
//
//
//            print(fraction)
//
//            if (fraction > 0.5 && index < textStorage!.length &&
//                (textStorage!.string as NSString).character(at: index) != 0)
//                {
//                  index += 1;
//                }
//            self.setSelectedRange(NSRange(location: index, length: 0))
//        }
//    }
//
//    override func mouseDragged(with event: NSEvent) {
//
////        monitor = NSEvent.addLocalMonitorForEvents(matching: mode) { (event) -> NSEvent? in
////                    DispatchQueue.global(qos: .userInteractive).async {
////                        self.dataSend(event: event, mode)
////                    }
////
////                    return event
////                }
//
////        var a = 0
////        repeat {
////
////
////            var nextevent: NSEvent?
////            nextevent = window?.nextEvent(matching: NSEvent.EventTypeMask.leftMouseDown.union(.leftMouseUp).union(.mouseMoved).union(.leftMouseDragged))
////
////            if nextevent?.type == .leftMouseUp {
////                break
////            }
////
////            a += 1;
////            print(a)
////        } while true
//
//
//    }
    
}
