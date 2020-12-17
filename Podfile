plugin 'cocoapods-binary'
source 'https://github.com/abuzeid-ibrahim/DevPods.git'
platform :ios, '11.0'

target 'MimiMusicPlayer' do
  use_frameworks!
  # all_binary!
  
  pod 'RxSwift', :binary => true
  pod 'RxCocoa', :binary => true
  pod 'SwiftLint', :binary => true
  pod 'Kingfisher', :binary => true
  pod 'DevExtensions', :path => '../DevPods'
  target 'MimiMusicPlayerTests' do
    inherit! :search_paths
    pod 'RxTest'

  end

  target 'MimiMusicPlayerUITests' do
    # Pods for testing
  end

end
