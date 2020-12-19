plugin 'cocoapods-binary'
platform :ios, '11.0'
debug = false
target 'MimiMusicPlayer' do
  use_frameworks!
  all_binary! if debug
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint'
  pod 'Kingfisher'#, :binary => false
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
