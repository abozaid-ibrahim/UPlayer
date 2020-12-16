#plugin 'cocoapods-binary'
platform :ios, '11.0'

target 'MimiMusicPlayer' do
  use_frameworks!
  all_binary!
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint'
  pod 'Kingfisher'

  target 'MimiMusicPlayerTests' do
    inherit! :search_paths
    pod 'RxTest'

  end

  target 'MimiMusicPlayerUITests' do
    # Pods for testing
  end

end
