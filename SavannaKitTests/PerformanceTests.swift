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

class PerformanceTests: XCTestCase {
    
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
    }

    func load(_ name: String, _ ext: String) -> String {
        
        let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext, subdirectory: nil)
        
        return try! String(contentsOf: url!)
    }
    
    func testPerfAlice() {
        
        let string = load("AliceInWonderland", "txt")
        
        // Baseline: 0.197s
        
        measure {
            view.text = string
        }
    }
    
    func testPerfGit() {
        
        let string = load("BoopGithub", "html")
        
        // Baseline: 0.22s
        
        measure {
            view.text = string
        }
    }
    
    
    
}
