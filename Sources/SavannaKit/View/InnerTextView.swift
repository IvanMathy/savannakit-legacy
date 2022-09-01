//
//  InnerTextView.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 09/07/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit
import Carbon.HIToolbox

protocol InnerTextViewDelegate: class {
	func didUpdateCursorFloatingState()
}

final class InnerTextView: NSTextView {

	weak var innerDelegate: InnerTextViewDelegate?
	var theme: SyntaxColorTheme?
	var cachedParagraphs: [Paragraph]?
    
    // Multiline Editing
    
    var startIndex: Int?
    var startPoint: CGPoint?
    
    var insertionRanges: [NSRange]? {
        didSet {
            didSetInsertionRanges()
        }
    }
    var cursorBlinkTimer: Timer?
    var shouldDrawInsertionPoints = false
    
    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = super.menu(for: event)
        
        let bannedItems = [
            "changeLayoutOrientation:",
            "replaceQuotesInSelection:",
            "toggleAutomaticQuoteSubstitution:",
            "orderFrontFontPanel:"
        ]
        
        // This is a mess.
        menu?.items = menu?.items.filter { menuItem in
            return !(menuItem.submenu?.items.contains { item in
                    return bannedItems.contains(item.action?.description ?? "")
                } ?? false)
        } ?? []
        
        return menu
    }
    
	func invalidateCachedParagraphs() {
		cachedParagraphs = nil
	}
    
    // Automatic closing
    
    override func insertBacktab(_ sender: Any?) {
        // TODO: Handle this
    }
    
    
    override func insertText(_ string: Any, replacementRange: NSRange) {
        switch string as? String {
           case "[":
               insertAfter(string, "]")
           case "{":
               insertAfter(string, "}")
           case "(":
               insertAfter(string, ")")
           case "\"":
               insertQuotes(string, "\"")
           case "'":
               insertQuotes(string, "'")
           default:
               super.insertText(string, replacementRange: replacementRange)
           }
    }
    
    private func insertAfter(_ before: Any, _ after: String) {
        
        // Skip the second char to avoid duplicates
        var skipAfter = false
        
        if self.text.startIndex != self.text.endIndex {
            let end = self.text.index(self.text.startIndex, offsetBy: selectedRange().upperBound, limitedBy: self.text.index(before: self.text.endIndex))
            
            if let end = end, String(self.text[end]) == after {
                skipAfter = true
            }
        }
        
        
        super.insertText(before, replacementRange: self.selectedRange)
        
        guard !skipAfter else {
            return
        }
        
        super.insertText(after, replacementRange: self.selectedRange)
        self.moveBackward(self)
    }
    
    private func insertQuotes(_ before: Any, _ after: String) {
        
        guard self.selectedRange.length > 0 else {
            insertAfter(before, after)
            return
        }
        
        var originalRange = self.selectedRange
        var targetRange = originalRange
        targetRange.length = 0
        
        super.insertText(before, replacementRange: targetRange)
        
        targetRange.location = originalRange.upperBound + 1
        
        super.insertText(after, replacementRange: targetRange)
        
        originalRange.location += 1
        
        self.setSelectedRange(originalRange)
    }
	
    override func insertTab(_ sender: Any?) {
        
        self.undoManager?.beginUndoGrouping()
        
        var range = self.selectedRange
        
        let spaces = String(repeating: " ", count: theme?.tabWidth ?? 4)
        
        super.insertText(spaces, replacementRange: range)
        
        self.undoManager?.endUndoGrouping()
        
        // TODO: Add selection tabbing support
    }
    
    // Overscroll
    // Inspired by https://christiantietze.de
    
    public func scrollViewDidResize(_ scrollView: NSScrollView) {
        let offset = scrollView.bounds.height / 4
        textContainerInset = NSSize(width: 0, height: offset)
        overscrollY = offset
    }

    var overscrollY: CGFloat = 0

    override var textContainerOrigin: NSPoint {
        return super
            .textContainerOrigin
            .applying(.init(translationX: 0, y: -overscrollY))
    }
    
    override var readablePasteboardTypes: [NSPasteboard.PasteboardType] {
        return [.string]
    }
}
