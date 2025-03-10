//
//  InnerTextView+MultilineEditing.swift
//  SavannaKit macOS
//
//  Created by Ivan on 12/29/21.
//  Copyright © 2021 OKatBest. All rights reserved.
//

import Foundation
import AppKit

enum MoveDirection {
    case up
    case down
    case left
    case right
}

extension InnerTextView {
    
    func characterIndex(for event: NSEvent) -> Int? {
        
        let point = self.convert(event.locationInWindow, from: nil)
        
        return self.characterIndex(at: point)
    }
    
    func characterIndex(at point: CGPoint) -> Int? {
        
        guard
            let layoutManager = layoutManager,
            let textStorage   = textStorage,
            let textContainer = textContainer
        else {
            return nil
        }
        
        var fraction: CGFloat = 0

        var index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: &fraction)

        if (fraction > 0.5 && index < textStorage.length &&
            (textStorage.string as NSString).character(at: index) != 10)
        {
          index += 1;
        }

        return index
    }
    
    override func mouseDown(with event: NSEvent) {
        guard event.modifierFlags.contains(.option) else {
            
            if insertionRanges != nil {
                self.cursorBlinkTimer?.invalidate()
                self.cursorBlinkTimer = nil
                
                self.shouldDrawInsertionPoints = false
                self.refreshInsertionRects()
                self.insertionRanges = nil
            }
            
            return super.mouseDown(with: event)
            
            // Check and sync new ranges here
            
        }
        
        if insertionRanges != nil {
            self.shouldDrawInsertionPoints = false
            self.refreshInsertionRects()
        }
        
        startPoint = self.convert(event.locationInWindow, from: nil)
        
        insertionRanges = []
        self.setSelectedRange(NSRange())
        
        
        
        self.shouldDrawInsertionPoints = true
        self.refreshInsertionRects()
        
        
        
    }
    
    override func mouseDragged(with event: NSEvent) {
//        let index = characterIndex(for: event)!
//        let glyphIndex = (layoutManager?.glyphIndexForCharacter(at: index))!
//
        //(string as NSString).lineRange(for: <#T##NSRange#>)
        
        //layoutManager?.enumerateLineFragments(forGlyphRange: <#T##NSRange#>, using: <#T##(NSRect, NSRect, NSTextContainer, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void#>)
        
        // 1 find first char in line by setting X to 0
        // 2 save rect of char (maybe)
        // 3 if mouse moves out of rect, find 1st char of new line
        // 4 offset first char by original offset
        
        
        // if move more than 1/2 char on x, switch to box selection
        //layoutManager!.glyphRange(forBoundingRect: <#T##NSRect#>, in: <#T##NSTextContainer#>)
        // find smallest range
        
//        layoutManager!.enumerateLineFragments(forGlyphRange: NSRange(location: glyphIndex, length: 100)) { (rect, usedRect, textContainer, glyphRange, stop) in
//
//            print(rect, usedRect, textContainer, glyphRange, stop)
//        }
//
        
        
        self.autoscroll(with: event)
        
        
        
        self.updateinsertionRanges(with: self.convert(event.locationInWindow, from: nil))
        
        
        //self.insertionRanges?.append(NSRange(location: index, length: 0))
        
        self.cursorBlinkTimer?.invalidate()
        self.cursorBlinkTimer = nil
        self.shouldDrawInsertionPoints = true
        self.refreshInsertionRects()
        self.cursorBlinkTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateInsertionPoints), userInfo: nil, repeats: true)
        
        
        
        
        //print(layoutManager!.truncatedGlyphRange(inLineFragmentForGlyphAt: glyphIndex!))
    }

    
    @objc func updateInsertionPoints() {
        self.refreshInsertionRects()
        self.shouldDrawInsertionPoints.toggle()
    }
    
    func updateinsertionRanges(with currentPoint: CGPoint?) {
        guard let startPoint = startPoint else {
            return
        }
        
        guard let currentPoint = currentPoint else {
            if let index = self.characterIndex(at: startPoint) {
                self.insertionRanges = [NSRange(location: index, length: 0)]
            }
            return
        }
        
        guard let startIndex = self.characterIndex(at: startPoint) else {
            return
        }
        
        guard let currentIndex = self.characterIndex(at: currentPoint) else {
            return
        }
        
        // Here we pretend the selection started perfectly in the right spot
        let normalizedStartPoint = self.getCharacterRect(at: startIndex).origin
        
        
        let min = min(currentIndex, startIndex)
        let max = max(currentIndex, startIndex)
            
        var cursor = min
        let info = self.getLineInfo(for: cursor)
        var range = info.0
        
        let positionInLine = startIndex - range.lowerBound
        var infos = [info]
        
        while
            !range.contains(max),
            range.upperBound != self.textStorage?.length
        {
            cursor = range.upperBound + 1
            let info = self.getLineInfo(for: cursor)
            range = info.0
            infos.append(info)
        }
        
        let startRange = self.getLineRange(for: startIndex)
        
        let firstLinePoint = CGPoint(x: currentPoint.x + normalizedStartPoint.x - startPoint.x, y: startPoint.y)
        
        guard let offsetIndex = self.characterIndex(at: firstLinePoint) else {
            return
        }
        
        //todo: handle last charcter in line
        
        let delta = offsetIndex - startIndex
        
      
        
        self.insertionRanges = infos.compactMap({ info in
            
            let range = info.0
            var upper = range.upperBound
            
            if range.upperBound != self.textStorage?.length {
                upper -= 1
            }
            let startIndex = Swift.min(range.lowerBound + positionInLine, upper)
            
            guard delta != 0 else {
                // No need for a range
                return NSRange(location: startIndex, length: 0)
            }
            
            // Box search
            
            let y = info.1.origin.y + info.1.height / 2
            
            guard
                let start = characterIndex(at: CGPoint(x: normalizedStartPoint.x, y: y)),
                let end = characterIndex(at: CGPoint(x: firstLinePoint.x, y: y)),
                start != end // end of line
            else  {
                return nil
            }
            
            print(start, end, info)
            
            return NSRange(location: Swift.min(start, end), length: abs(start - end))
        })
         //   self.insertionRanges?.append(NSRange(location: index, length: 0))
       
        
        //self.layoutManager.rect
    }
    
    func getCursorRects() -> [NSRect] {
        guard let selectionRanges = insertionRanges else {
            return []
        }
        
        return selectionRanges.compactMap({ range in
            guard range.length == 0 else {
                return nil
            }
            
            // use previous character rect for cursor position
            var location = range.location
            var isLastChar = false
            
            if location >= textStorage!.length {
                location -= 1
                isLastChar = true
            }
            
            var rect = getCharacterRect(at: location)
            var origin = rect.origin
            
            if(isLastChar) {
                origin = NSPoint(x: origin.x + rect.width, y: origin.y)
            }
            
            // Round for a crisp line. I'm getting flashback to when I
            // thought saying I cared about "Pixel perfection" was cool.
            // I mean caring is cool, but saying it is very much  not.
            origin = NSPoint(x: round(origin.x) - 1, y: origin.y)
            
            
            return NSRect(origin: origin, size: NSSize(width: 1, height: rect.height))
        })
    }
        
    func refreshInsertionRects() {
        getCursorRects().forEach {
            super.setNeedsDisplay($0)
        }
    }
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
        guard self.insertionRanges == nil else {
            // No thanks I make my own
            return
        }
        super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
    }
    
    
//    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
//        guard let selectionRanges = selectionRanges else {
//            return super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
//        }
//
//        var selections = [NSRange]()
//
//        for range in selectionRanges {
//            guard range.length == 0 else {
//                selections.append(range)
//                continue
//            }
//            var rect = layoutManager!.boundingRect(forGlyphRange: NSRange(location: range.location, length: 1), in: textContainer!)
//            rect = NSRect(origin: rect.origin, size: NSSize(width: 1, height: rect.height))
//            super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
//
//        }
//
//        if !selections.isEmpty {
//            self.setSelectionRanges(selections)
//        }
//
//
//
//    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard shouldDrawInsertionPoints else {
            return
        }
        
        getCursorRects().forEach {
            super.drawInsertionPoint(in: $0, color: .textColor, turnedOn: true)
        }
    }
    
//    override func insertText(_ insertString: Any) {
//        guard let insertionPoints = insertionPoints else {
//            return super.insertText(insertString)
//        }
//
//        insertionPoints.forEach { point in
//            self.setSelectedRange(NSRange(location: point, length: 0))
//            super.insertText(insertString)
//        }
//    }
    
    override func mouseUp(with event: NSEvent) {
        
        startIndex = nil
    }
    
//    override func keyDown(with event: NSEvent) {
//        guard let insertionPoints = insertionPoints else {
//            return super.keyDown(with: event)
//        }
//
//        insertionPoints.forEach { point in
//            self.setSelectedRange(NSRange(location: point, length: 0))
//            super.keyDown(with: event)
//        }
//    }
    
    override func insertText(_ insertString: Any) {

        guard let insertionRanges = insertionRanges, let insertString = insertString as? String else {
            return super.insertText(insertString)
        }
        
        self.insertionRanges = self.insert(stringInRanges: insertionRanges.map { (insertString, $0)})
        
    }
    
    
    func setSelectionRanges(_ ranges: [NSRange]) {
        self.insertionRanges = ranges
        
        self.selectedRanges = ranges.filter { $0.length > 0 } as [NSValue]
    }
    
    func moveInsertionPoints(_ direction: MoveDirection) {
        self.setSelectedRange(NSRange())
        self.shouldDrawInsertionPoints = false
        self.refreshInsertionRects()
        insertionRanges = insertionRanges?.compactMap {
            let position = (direction == .right) ? $0.upperBound : $0.lowerBound
            if $0.length > 0, [.left, .right].contains(direction) {
                // If we have a selection, stay at the bounds when moving left/right
                return position
            }
            return self.move(position, direction, by: 1)
        }.map { NSRange(location: $0, length: 0) }
        
        self.shouldDrawInsertionPoints = true
        self.refreshInsertionRects()
    }
    
    // this is peak function signature fight me
    // move(index, .up, by: 1)
    func move(_ index: Int, _ direction: MoveDirection, by: Int) -> Int? {
        guard
            let textStorage = self.textStorage
        else {
            return nil
        }
        
        let lineRange = self.getLineRange(for: index)
        let characterPosition = index - lineRange.location
        
        
        switch direction {
        case .up:
            let previousLine = lineRange.location - 1
            guard previousLine >= 0 else {
                // out of bounds, let's return 0 like Xcode does
                return 0
            }
            
            let previousLineRange = self.getLineRange(for: previousLine)
            
            return previousLineRange.lowerBound + min(previousLineRange.length, characterPosition)
            
        case .down:
            let nextLine = lineRange.upperBound + 1
            guard nextLine < textStorage.length else {
                // out of bounds
                return nil
            }
            
            let nextLineRange = self.getLineRange(for: nextLine)
            
            return nextLineRange.lowerBound + min(nextLineRange.length, characterPosition)
            
        case .left:
            guard index - 1 >= 0 else {
                // out of bounds, let's return 0 like Xcode does
                return 0
            }
            return index - 1
        case .right:
            guard index + 1 <= textStorage.length else {
                // out of bounds
                return nil
            }
            return index + 1
        }
    }
    
    func getCharacterRect(at location: Int) -> CGRect {
        return layoutManager!.boundingRect(forGlyphRange: NSRange(location: location, length: 1), in: textContainer!)
    }
    
    func getLineRange(for glyphIndex: Int) -> NSRange {
        return self.getLineInfo(for: glyphIndex).0
    }
    
    func getLineInfo(for glyphIndex: Int) -> (NSRange, NSRect) {
        
        guard let layoutManager = layoutManager else {
            fatalError("Missing Layout Manager. How did we get so far without it??")
        }
        
        var lineRange = NSRange()
        var lineRect = NSRect.zero
        
        layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: glyphIndex, length: 1)) { (rect, usedRect, textContainer, glyphRange, stop) in
            lineRange = glyphRange
            lineRect = rect
        }
        
        return (lineRange, lineRect)
    }
    
    func didSetInsertionRanges() {
        guard let selection = (self.insertionRanges?.filter({
            $0.length > 0
        }) as [NSValue]?) else {
        
            return
        }
        guard selection.count > 0 else {
            return self.selectedRanges = [NSValue()]
        }
        self.selectedRanges = selection
        
    }
    
}
