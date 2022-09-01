//
//  InnerTexView+MultilineActions.swift
//  SavannaKit macOS
//
//  Created by Ivan on 1/8/22.
//  Copyright © 2022 Silver Fox. All rights reserved.
//

import Foundation

extension InnerTextView {
    // This class overrides default NSTextView actions to support multiline
    
    
    func insert(stringInRanges pairs: [(String, NSRange)]) -> [NSRange]? {
        
        guard
            shouldChangeText(inRanges: pairs.map { NSValue.init(range: $0.1) }, replacementStrings: pairs.map { $0.0 }),
            let textStorage = self.textStorage
        else {
            return nil
        }
        
        textStorage.beginEditing()
        
        var offset = 0
        
        let newPairs = pairs.sorted(by: { $0.1.location < $1.1.location  }).map {
            pair -> NSRange in
            let range = NSRange(location: pair.1.location + offset, length: pair.1.length)
            textStorage.replaceCharacters(in: range, with: pair.0)

            offset += pair.0.count - pair.1.length
            
            return NSRange(location: pair.1.location + offset + pair.1.length, length: 0)
        }
        
        textStorage.endEditing()
        
        self.didChangeText()
        
        return newPairs
    }
    
    // Delete
    
    override func delete(_ sender: Any?) {
        super.delete(sender)
    }
    
    override func deleteForward(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.deleteForward(sender)
        }
        
        self.insertionRanges = self.insert(stringInRanges: insertionRanges.compactMap({ range in
            guard range.location < self.text.count else {
                return nil
            }
            guard range.length == 0 else {
                return ("", range)
            }
            return ("", NSRange(location: range.location, length: 1))
        }))
    }
    
    override func deleteBackward(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.deleteBackward(sender)
        }
        
        self.insertionRanges = self.insert(stringInRanges: insertionRanges.flatMap({ range in
            guard range.location > 0 else {
                return nil
            }
            guard range.length == 0 else {
                return ("", range)
            }
            return ("", NSRange(location: range.location - 1, length: 1))
        }))
    }
    // Move
    
    override func moveUp(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveUp(sender)
        }
        self.moveInsertionPoints(.up)
    }
    
    override func moveDown(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveDown(sender)
        }
        self.moveInsertionPoints(.down)
    }
    
    override func moveLeft(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveLeft(sender)
        }
        self.moveInsertionPoints(.left)
    }
    override func moveRight(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveRight(sender)
        }
        self.moveInsertionPoints(.right)
    }
    
    override func moveForward(_ sender: Any?) {
        super.moveForward(sender)
        
        
        // Todo: handle both writing directions? not sure when this function is used.
    }
    
    // Select
    
    override func selectAll(_ sender: Any?) {
        self.insertionRanges = nil
        super.selectAll(sender)
    }
    
    
    override func moveLeftAndModifySelection(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.moveLeftAndModifySelection(sender)
        }
        
        self.insertionRanges = insertionRanges.map {
            range in
            
            guard
                let destination = self.move(range.lowerBound, .left, by: 1),
                destination != range.lowerBound
            else {
                return range // can't move
            }
            
            return NSRange(location: destination, length: range.length + 1)
        }
    }
    
    override func moveRightAndModifySelection(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.moveLeftAndModifySelection(sender)
        }
        
        self.insertionRanges = insertionRanges.flatMap {
            range in
            
            guard
                let destination = self.move(range.upperBound, .right, by: 1)
            else {
                if range.upperBound == self.textStorage?.length {
                    return range // Already a full selection, keep it
                }
                return nil // can't move cursor, delete like Xcode
            }
            
            return NSRange(location: range.lowerBound, length: destination - range.lowerBound)
        }
    }
    
    override func moveDownAndModifySelection(_ sender: Any?) {
        if
            let insertionRanges = self.insertionRanges?.sorted(
                by: { $0.lowerBound < $1.lowerBound }),
            let first = insertionRanges.first?.lowerBound,
            let last = insertionRanges.last?.upperBound
        {
            self.selectedRanges = [NSRange(location: first, length: last - first) as NSValue]
        }
        
        self.insertionRanges = nil
        
        super.moveDownAndModifySelection(sender)
    }
    
    override func moveUpAndModifySelection(_ sender: Any?) {
        if
            let insertionRanges = self.insertionRanges?.sorted(
                by: { $0.lowerBound < $1.lowerBound }),
            let first = insertionRanges.first?.lowerBound,
            let last = insertionRanges.last?.upperBound
        {
            self.selectedRanges = [NSRange(location: first, length: last - first) as NSValue]
        }
        
        self.insertionRanges = nil
        
        super.moveUpAndModifySelection(sender)
    }
}
