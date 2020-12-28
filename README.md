# UPlayer
</p>
 <p align="center">
<img src="https://img.shields.io/github/workflow/status/abozaid-ibrahim/UPlayer/iOS%20starter%20workflow/master">
<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift"/></a>
<img src="https://img.shields.io/badge/Platform-iOS%2011.0+-lightgrey.svg" alt="Platform: iOS">
<img src="https://img.shields.io/badge/XCode-11.5%2B-lightgrey">
<img src="https://img.shields.io/badge/Code%20Coverage-71%25-brightgreen">
</p>

MVP music player consumes HearThisAt API to show the popular tracks
 
 <p align="center">
 <img src="https://github.com/abozaid-ibrahim/UPlayer/blob/master/demo.gif" width="50%">
 </p>

## Getting Started
- If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to set up XCode and Swift on your Mac.
- To set up cocoa pods for dependency management, make use of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)

## Setup Configs
- Checkout master branch to run the latest version
- Open the terminal and navigate to the project root directory.
- Make sure you have cocoa pods set up, then run: pod install
- Open the project by double-clicking the `UPlayer.xcworkspace` file
- Select the build scheme which can be found right after the stop button on the top left of the IDE
- [Command(cmd)] + R - Run app
```
// App Settings
APP_NAME = UPlayer
PRODUCT_BUNDLE_IDENTIFIER = abozaid.UPlayer

#targets:
* UPlayer
* UPlayerTests
* UPlayerUITests

```

## Build
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (referred to as MVVM) UI architecture.

## Folders Structure
* SupportingFiles: Group app shared files, like app delegate, assets, info.plist, ...etc
* Modules: Include separate modules, components, extensions, ...etc.
* Scenes: Group of app scenes.

## Dependencies
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [RxCocoa](https://github.com/ReactiveX/RxSwift)
* [SwiftLint](https://github.com/realm/SwiftLint)
* [Kingfisher](https://github.com/onevcat/Kingfisher)

## TODOs
- [x] Set-up dependencies
- [x] Add swiftlint yml, gitignore.
- [x] Implement artists list, songs list
- [x] Paginate the artists API
- [x] Implement audio player
- [x] Check different device size and different orientation
- [x] Check dark mode
- [x] Add unittests
- [x] Add ui-tests
- [x] Render waveform to audio player
- [x] Enable audio player full screen page by swipe up.
- [x] Add CD pipelines using github actions.
- [x] Create app test plan
- [x] Integerate with danger.
- [ ] Add search feature.
- [ ] Cach the audio and json response
- [ ] Auto play next audio file in the list.
- [ ] Reach 100% code coverage.
- [ ] Add split controller for iPad
- [ ] Play music in background
- [ ] Add xcconfig
- [ ] Move modules into framework.

## Useful links
- [How to build a sound wave](https://deda9.medium.com/lets-learn-how-to-play-a-song-on-ios-like-soundcloud-do-77643a90d449)
- [CocoaPods binary](https://github.com/leavez/cocoapods-binary)
- [ Danger](https://danger.systems/swift/)
