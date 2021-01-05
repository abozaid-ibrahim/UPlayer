plugin 'cocoapods-binary'
platform :ios, '11.0'
debug = true
target 'UPlayer' do
  use_frameworks!
  # all_binary! if debug
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint'
  pod 'Kingfisher'
  if debug
    pod 'DevExtensions', :path => '../DevPods'
    pod 'DevPlayer', :path => '../DevPods'
  else
    pod 'DevExtensions', :git => "https://github.com/abuzeid-ibrahim/DevPods.git"
    pod 'DevPlayer', :git => "https://github.com/abuzeid-ibrahim/DevPods.git"
  end
  target 'UPlayerTests' do
    inherit! :search_paths
    pod 'RxTest'

  end

  target 'UPlayerUITests' do
    # Pods for testing
  end

end
