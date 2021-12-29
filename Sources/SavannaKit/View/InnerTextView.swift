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
    
    func didChangeFont(_ font: Font)
}

final class InnerTextView: NSTextView {
	
	weak var innerDelegate: InnerTextViewDelegate?
	
	var theme: SyntaxColorTheme?
	
	var cachedParagraphs: [Paragraph]?
    
<<<<<<< Updated upstream
    var autocompleteWords: [String]?
	
=======
    // Multiline Select
    var startIndex = 0
    
    // /
    
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
    
>>>>>>> Stashed changes
	func invalidateCachedParagraphs() {
		cachedParagraphs = nil
	}
	
	func hideGutter() {
		gutterWidth = theme?.gutterStyle.minimumWidth ?? 0.0
	}
	
	func updateGutterWidth(for numberOfCharacters: Int) {
		
		let leftInset: CGFloat = 4.0
		let rightInset: CGFloat = 4.0
		
		let charWidth: CGFloat = 10.0
		
		gutterWidth = max(theme?.gutterStyle.minimumWidth ?? 0.0, CGFloat(numberOfCharacters) * charWidth + leftInset + rightInset)
		
	}
	
	var gutterWidth: CGFloat {
		set {
            textContainerInset = NSSize(width: newValue, height: 0)
		}
		get {
            return textContainerInset.width
		}
	}
    
    override func didChangeText() {
        
        super.didChangeText()
        
        if let event = self.window?.currentEvent,
            event.type == .keyDown,
            (event.keyCode == UInt16(kVK_Escape) || event.keyCode == UInt16(kVK_Delete) || event.keyCode == UInt16(kVK_UpArrow) || event.keyCode == UInt16(kVK_DownArrow) || event.keyCode == UInt16(kVK_LeftArrow) || event.keyCode == UInt16(kVK_RightArrow)) {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            return
        }

        // Invoke lint after delay
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(complete(_:)), with: nil, afterDelay: 0.7)
    }
    
    /// Autocomplete
    override func completions(forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String]? {
        
        guard charRange.length > 0, let range = Range(charRange, in: text) else { return nil }
        
        var wordList = [String]()
        let partialWord = String(text[range])

        // Add words in the document
        let documentWords: [String] = {
            // do nothing if the particle word is a symbol
            guard charRange.length > 1 || CharacterSet.alphanumerics.contains(partialWord.unicodeScalars.first!) else { return [] }
            
            let pattern = "(?:^|\\b|(?<=\\W))" + NSRegularExpression.escapedPattern(for: partialWord) + "\\w+?(?:$|\\b)"
            let regex = try! NSRegularExpression(pattern: pattern)
            
            return regex.matches(in: self.string, range: NSRange(..<self.string.endIndex, in: self.string)).map { (self.string as NSString).substring(with: $0.range) }
        }()
        wordList.append(contentsOf: documentWords)

        // Add words defined in lexer
        if let autocompleteWords = self.autocompleteWords {
            
            let syntaxWords = autocompleteWords.filter { $0.range(of: partialWord, options: [.caseInsensitive, .anchored]) != nil }
            
            wordList.append(contentsOf: syntaxWords)
        }
            
        // if word matches full word in list, e.g. "fi", don't suggest "field"
        if wordList.contains(partialWord) { return nil }
        
        // Remove double words
        let set:Set<String> = Set(wordList)
        
        return Array(set)
        
    }
    
    override func changeFont(_ sender: Any?) {
        
        guard let oldFont = self.font, let fontManager = sender as? NSFontManager else { return }
        let newFont = fontManager.convert(oldFont)
        innerDelegate?.didChangeFont(newFont)
        super.changeFont(sender)
    }
}
