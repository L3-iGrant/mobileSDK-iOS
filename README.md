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

iGrantioSDK.shared.modalPresentationStyle = .fullScreen
iGrantioSDK.shared.show(organisationId: <ORGANISATION ID>, apiKey: <API KEY>, userId: <USERID>)
```

## Get iGrant user id

If you need to login anonymously, You can use the below function to create new iGrant user id.

```swift
iGrantioSDK.shared.createIGrantUser(orgId: <ORGANISATION ID>,apiKey: <APIKEY>) {(success, userId) in
 print("UserID \(userId)")
}
```

## Author

iGrant.io

## License

iGrantioSDK is available under the custom license. See the LICENSE file for more info.
