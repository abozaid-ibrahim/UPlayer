# MimiMusicPlayer

## Building And Running The Project (Requirements)
* Swift 5.0+
* Xcode 11.5+
* iOS 13.0+

# Getting Started
- If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac.
- To setup cocoapods for dependency management, make use of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)

## Setup Configs
- Checkout master branch to run latest version
- Open the terminal and navigate to the project root directory.
- Make sure you have cocoapods setup, then run: pod install
- Open the project by double clicking the `MimiMusicPlayer.xcworkspace` file
- Select the build scheme which can be found right after the stop button on the top left of the IDE
- [Command(cmd)] + R - Run app
```
// App Settings
APP_NAME = MimiMusicPlayer
PRODUCT_BUNDLE_IDENTIFIER = abozaid.MimiMusicPlayer

#targets:
* MimiMusicPlayer
* MimiMusicPlayerTests
* MimiMusicPlayerUITests

```

# Build and or run application by doing:
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) UI architecture,

## Folders Structure
### SupportingFiles
- Group app shared fils, like app delegate, assets, info.plist, ...etc
### Modules
- Include seperate modules, components, extensions, ...etc.
### Scenes
- Group of app scenes.

### Dependencies
* RxSwift
* RxCocoa
* SwiftLint
* Kingfisher


### TODOs
- [x] Set-up dependencies
- [x] Add Swiftlint yml, gitignore.
- [x] Implement Artists List, Songs List
- [x] Paginate the artists API
- [x] Implement Audio player
- [x] Check different device size and different orientation
- [x] Check dark mode
- [x] Add unittests
- [x] Add UITests
- [x] Render waveform to audio player
- [x] Enable audio player full screen page by swipe up.
- [ ] Cach the audio and json response
- [ ] Auto play next audio file in the list.
- [ ] Reach 100% code coverage.
- [ ] Add split controller for iPad
- [ ] Play music in bg.


### UX
- Swipe the audio player full screen down to show up the mini player bar
- Click on mini player view to show the full screen player

