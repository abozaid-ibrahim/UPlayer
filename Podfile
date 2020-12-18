plugin 'cocoapods-binary'
platform :ios, '11.0'
debug = false
target 'MimiMusicPlayer' do
  use_frameworks!
  # all_binary!
  
  pod 'RxSwift', :binary => true
  pod 'RxCocoa', :binary => true
  pod 'SwiftLint', :binary => true
  pod 'Kingfisher', :binary => true
  if debug
    pod 'DevExtensions', :path => '../DevPods'
  else
    pod 'DevExtensions', :git => "https://github.com/abuzeid-ibrahim/DevPods.git"
  end
  target 'MimiMusicPlayerTests' do
    inherit! :search_paths
    pod 'RxTest'

  end

  target 'MimiMusicPlayerUITests' do
    # Pods for testing
  end

end
