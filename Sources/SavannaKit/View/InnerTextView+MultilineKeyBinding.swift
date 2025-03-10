//
//  File.swift
//  
//
//  Created by Ivan Mathy on 8/22/22.
//

import Foundation

extension InnerTextView {
    
    
    override func moveBackward(_ sender: Any?) {
    }
    
//    override func moveWordForward(_ sender: Any?) { // ctrl + option + f
//        print("move word forward")
//    }
//
//    override func moveWordBackward(_ sender: Any?) { // ctrl + option + b
//        print("move word backwards")
//    }
    
    override func moveToBeginningOfLine(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.moveToBeginningOfLine(sender)
        }
        
        self.insertionRanges = insertionRanges.map {
            range in
            
            let newRange = self.getLineRange(for: range.lowerBound)
            
            return NSRange(location: newRange.lowerBound, length: 0)
        }
        self.shouldDrawInsertionPoints = true
        self.refreshInsertionRects()
    }
    
    override func moveToEndOfLine(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.moveToBeginningOfLine(sender)
        }
        
        self.insertionRanges = insertionRanges.map {
            range in
            
            let newRange = self.getLineRange(for: range.upperBound)
            
            let index = self.text.index(self.text.startIndex, offsetBy: newRange.upperBound - 1)
            
            let newLineOffset = (self.text[index].isNewline) ? 1 : 0
            
            return NSRange(location: newRange.upperBound - newLineOffset, length: 0)
        }
        
        self.shouldDrawInsertionPoints = true
        self.refreshInsertionRects()
    }
    
    override func moveToBeginningOfParagraph(_ sender: Any?) {
        print("moveToBeginningOfParagraph")
    }
    
    override func moveToEndOfParagraph(_ sender: Any?) {
        print("moveToEndOfParagraph")
    }
    
    override func moveToEndOfDocument(_ sender: Any?) {
        print("moveToEndOfDocument")
    }
    
    override func moveToBeginningOfDocument(_ sender: Any?) {
        print("moveToBeginningOfDocument")
    }
    
    override func pageDown(_ sender: Any?) {
    }
    
    override func pageUp(_ sender: Any?) {
    }
    
    override func centerSelectionInVisibleArea(_ sender: Any?) {
    }
    
    override func moveBackwardAndModifySelection(_ sender: Any?) {
    }
    
    override func moveForwardAndModifySelection(_ sender: Any?) {
    }
    
    override func moveWordForwardAndModifySelection(_ sender: Any?) {
    }

    override func moveWordBackwardAndModifySelection(_ sender: Any?) {
    }


    override func moveToBeginningOfLineAndModifySelection(_ sender: Any?) {
    }

    override func moveToEndOfLineAndModifySelection(_ sender: Any?) {
    }

    override func moveToBeginningOfParagraphAndModifySelection(_ sender: Any?) {
    }

    override func moveToEndOfParagraphAndModifySelection(_ sender: Any?) {
    }

    override func moveToEndOfDocumentAndModifySelection(_ sender: Any?) {
    }

    override func moveToBeginningOfDocumentAndModifySelection(_ sender: Any?) {
    }

    override func pageDownAndModifySelection(_ sender: Any?) {
    }

    override func pageUpAndModifySelection(_ sender: Any?) {
    }

    override func moveParagraphForwardAndModifySelection(_ sender: Any?) {
    }

    override func moveParagraphBackwardAndModifySelection(_ sender: Any?) {
        
    }
    
    override func moveWordRight(_ sender: Any?) {
    }

    override func moveWordLeft(_ sender: Any?) {
    }

    override func moveWordRightAndModifySelection(_ sender: Any?) {
    }

    override func moveWordLeftAndModifySelection(_ sender: Any?) {
    }

    // these call moveToBeginningOfLine and such
//    @available(macOS 10.6, *)
//    override func moveToLeftEndOfLine(_ sender: Any?) {
//        print("moveToLeftEndOfLine")
//    }
//
//    @available(macOS 10.6, *)
//    override func moveToRightEndOfLine(_ sender: Any?) {
//        print("moveToRightEndOfLine")
//    }

    @available(macOS 10.6, *)
    override func moveToLeftEndOfLineAndModifySelection(_ sender: Any?) {
    }

    @available(macOS 10.6, *)
    override func moveToRightEndOfLineAndModifySelection(_ sender: Any?) {
    }

    override func scrollPageUp(_ sender: Any?) {
    }

    override func scrollPageDown(_ sender: Any?) {
    }

    override func scrollLineUp(_ sender: Any?) {
    }

    override func scrollLineDown(_ sender: Any?) {
    }
    
    override func scrollToBeginningOfDocument(_ sender: Any?) {
    }

    override func scrollToEndOfDocument(_ sender: Any?) {
    }

    // Graphical Element transposition
    override func transpose(_ sender: Any?) { // ctrl + t
    }

    override func transposeWords(_ sender: Any?) {
    }

    override func selectParagraph(_ sender: Any?) {
    }

    override func selectLine(_ sender: Any?) {
    }

    override func selectWord(_ sender: Any?) {
        super.selectWord(sender);
        // https://developer.apple.com/documentation/appkit/nstextview/1449188-selectionrange
    }

    // Insertions and Indentations
    override func indent(_ sender: Any?) {
    }

//    override func insertNewline(_ sender: Any?) {
//    }

    override func insertParagraphSeparator(_ sender: Any?) {
    }

    override func insertNewlineIgnoringFieldEditor(_ sender: Any?) {
    }

    override func insertTabIgnoringFieldEditor(_ sender: Any?) {
    }

    override func insertLineBreak(_ sender: Any?) {
    }
    
    override func insertContainerBreak(_ sender: Any?) {
    }

    @available(macOS 10.5, *)
    override func insertSingleQuoteIgnoringSubstitution(_ sender: Any?) {
    }

    @available(macOS 10.5, *)
    override func insertDoubleQuoteIgnoringSubstitution(_ sender: Any?) {
    }

    // Case changes
    override func changeCaseOfLetter(_ sender: Any?) {
    }

    override func uppercaseWord(_ sender: Any?) {
    }

    override func lowercaseWord(_ sender: Any?) {
    }

    override func capitalizeWord(_ sender: Any?) {
    }

    // Deletions


    override func deleteBackwardByDecomposingPreviousCharacter(_ sender: Any?) {
    }

    override func deleteWordForward(_ sender: Any?) { // option + shift + delete
    }

    override func deleteWordBackward(_ sender: Any?) { // option + delete
    }

    override func deleteToBeginningOfLine(_ sender: Any?) {
    }

    override func deleteToEndOfLine(_ sender: Any?) {
    }

    override func deleteToBeginningOfParagraph(_ sender: Any?) {
    }
}

