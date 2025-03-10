//
//  PerformanceTests.swift
//  SavannaKitTests
//
//  Created by Ivan on 7/21/20.
//  Copyright © 2020 OKatBest. All rights reserved.
//

import XCTest
@testable import SavannaKit
import Foundation

let sampleText = """
Hello world!
This is a sample of a longer text.

Here's another paragraph. Cheerio!
"""

class MultiCursorEditingTests: XCTestCase {
    
    func range(_ location: Int, _ length: Int) -> NSRange {
        return NSRange(location: location, length: length)
    }
    
    
    
    var view: SyntaxTextView!
    
    let delegate = Delegate()
    
    struct MyTheme: SyntaxColorTheme {
        var lineNumbersStyle: LineNumbersStyle?
        
        var gutterStyle: GutterStyle = .init(backgroundColor: .red, minimumWidth: 0)
        
        var font = NSFont.systemFont(ofSize: 2)
        
        var backgroundColor = NSColor.red
        
        func globalAttributes() -> [NSAttributedString.Key : Any] {
            return [:]
        }
        
        func attributes(for token: Token) -> [NSAttributedString.Key : Any] {
            return [:]
        }
        
        var tabWidth = 0
    }
    
    class Delegate: SyntaxTextViewDelegate {
        func lexerForSource(_ source: String) -> Lexer {
            return BoopLexer()
        }
        
        func theme(for appearance: NSAppearance) -> SyntaxColorTheme {
            return MyTheme()
        }
        
        
    }
    
    override func setUp() {
        super.setUp()
        
        view = SyntaxTextView()
        
        view.delegate = delegate
        view.text = sampleText
    }

    func testDeleteBackward() {
        
        view.textView.insertionRanges = [range(12, 0), range(34, 0), range(57, 6), range(0, 0), range(83, 0)]
        view.textView.deleteBackward(nil)
        
        
        XCTAssertEqual(view.text, """
Hello world
This is a sample of  longer text.

Here's a paragraph. Cheerio
""")
    }
    
    func testDeleteForward() {
        
        view.textView.insertionRanges = [ range(0, 0),range(11, 0), range(34, 0), range(57, 6), range(83, 0)]
        view.textView.deleteForward(nil)
        
        
        XCTAssertEqual(view.text, """
ello world
This is a sample of alonger text.

Here's a paragraph. Cheerio!
""")
    }
    
    func testMoveLeftAndModifySelection() {
        
        view.textView.insertionRanges = [range(0, 0), range(1, 0),range(11, 0), range(34, 0), range(57, 6), range(83, 0)]
        view.textView.moveLeftAndModifySelection(nil)
        
        
        XCTAssertEqual(view.textView.insertionRanges, [range(0, 0), range(0, 1),range(10, 1), range(33, 1), range(56, 7), range(82, 1)])
    }
    
    func testMoveRightAndModifySelection() {
        
        view.textView.insertionRanges = [range(0, 0), range(1, 0),range(11, 0), range(34, 0), range(57, 6), range(83, 0)]
        view.textView.moveRightAndModifySelection(nil)
        
        
        XCTAssertEqual(view.textView.insertionRanges,[range(0, 1), range(1, 1),range(11, 1), range(34, 1), range(57, 7), range(83, 0)])
    }
    
    func testMoveDownAndModifySelection() {
        view.textView.insertionRanges = [range(11, 0), range(34, 6)]
        view.textView.moveDownAndModifySelection(nil)
        
        XCTAssertNil(view.textView.insertionRanges)
        
        XCTAssertEqual(view.textView.selectedRanges, [range(11, 37) as NSValue])
    }
    
    func testMoveUpAndModifySelection() {
        view.textView.insertionRanges = [range(34, 0), range(70, 6)]
        view.textView.moveUpAndModifySelection(nil)
        
        XCTAssertNil(view.textView.insertionRanges)
        
        XCTAssertEqual(view.textView.selectedRanges, [range(12, 64) as NSValue])
    }
    
    
}
