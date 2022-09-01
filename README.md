This repository is deprecated. Work on this library now happens in https://github.com/IvanMathy/savannakit





This repository is a fork of louisdh's SavannaKit. It is built to be the editor within <a href="https://github.com/ivanmathy/Boop">Boop</a>. This repository is not intended to be a successor or replacement to the original; simply a fork that fits Boop's needs.

Overall, this fork has the following changes:

- Replaced the line numbering with a ruler view
- Added search/replace support
- Fixed Undo/Redo
- Added tabs to spaces replacement
- Added automatic brackets/parenthesis/quotes closing
- Added overscroll support
- Added light/dark mode switching

This fork also removes the following features for compatibility reasons:

- iOS support
- Code placeholders
- Some delegate functions


The original repo is not maintained anymore, but here's the original readme for reference:


<p align="center">
  <a href="https://github.com/louisdh/lioness">Lioness</a> &bull;
  <a href="https://github.com/louisdh/cub">Cub</a> &bull;
  <b> SavannaKit </b>
</p>

<p align="center">
<img src="readme-resources/hero@2x.png" alt="SavannaKit">
</p>

<p align="center">
<a href="https://travis-ci.org/louisdh/savannakit"><img src="https://travis-ci.org/louisdh/savannakit.svg?branch=master" style="max-height: 300px;" alt="Build Status"/></a>
<a href="https://codecov.io/gh/louisdh/savannakit"><img src="https://codecov.io/gh/louisdh/savannakit/branch/master/graph/badge.svg" alt="Codecov"/></a>
<br>
<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat" style="max-height: 300px;" alt="Swift"/></a>
<a href="https://cocoapods.org/pods/SavannaKit"><img src="https://img.shields.io/cocoapods/v/SavannaKit.svg" style="max-height: 300px;" alt="PodVersion"/></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4bc51d.svg?style=flat" style="max-height: 300px;" alt="Carthage Compatible"/></a>
<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-lightgrey.svg" style="max-height: 300px;" alt="Platform: iOS macOS">
<br>
<a href="http://twitter.com/LouisDhauwe"><img src="https://img.shields.io/badge/Twitter-@LouisDhauwe-blue.svg?style=flat" style="max-height: 300px;" alt="Twitter"/></a>
<a href="https://paypal.me/louisdhauwe"><img src="https://img.shields.io/badge/Donate-PayPal-green.svg?style=flat" alt="Donate via PayPal"/></a>
</p>

## About
SavannaKit is a high-performance, protocol oriented, framework for creating native IDEs for iOS and macOS, written in Swift. 

This project includes `SyntaxTextView`, a cross-platform Text View with syntax highlighting and line numbers.

## Example
The following examples show syntax highlighting for [the Lioness programming language](https://github.com/louisdh/lioness).

### iOS
<img src="readme-resources/example_ios.png" alt="iOS Example"/>

### macOS
<img src="readme-resources/example_mac.png" alt="macOS Example"/>

## License

This project is available under the MIT license. See the LICENSE file for more info.
