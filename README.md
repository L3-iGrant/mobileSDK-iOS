# iGrantioSDK

[![CI Status](https://img.shields.io/travis/rebinkpmna@gmail.com/iGrantioSDK.svg?style=flat)](https://travis-ci.org/rebinkpmna@gmail.com/iGrantioSDK)
[![Version](https://img.shields.io/cocoapods/v/iGrantioSDK.svg?style=flat)](https://cocoapods.org/pods/iGrantioSDK)
[![License](https://img.shields.io/cocoapods/l/iGrantioSDK.svg?style=flat)](https://cocoapods.org/pods/iGrantioSDK)
[![Platform](https://img.shields.io/cocoapods/p/iGrantioSDK.svg?style=flat)](https://cocoapods.org/pods/iGrantioSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Environment
iOS 10.0+,
macOS 10.10+,

Swift 4.2 and Xcode 10.

## Installation

iGrantioSDK is available through [CocoaPods](https://cocoapods.org). To install
it, add the following line to your Podfile:

```ruby
pod 'iGrantioSDK'
```

## Usage

You can easily present the iGrantViewController by single line code shown below:

```swift
#import iGrantioSDK

iGrantViewController.shared.show(organisationToken: <Your iGrant.io Organisation Token> , userToken: <iGrant.io Token of User>)
```

## Author

iGrant.io

## License

iGrantioSDK is available under the custom license. See the LICENSE file for more info.
