plugin 'cocoapods-binary'
platform :ios, '11.0'
debug = true
target 'UPlayer' do
  use_frameworks!
  # all_binary! if debug
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint'
  pod 'Kingfisher'#, :binary => false
  if debug
    pod 'DevExtensions', :path => '../DevPods'
  else
    pod 'DevExtensions', :git => "https://github.com/abuzeid-ibrahim/DevPods.git"
  end
  target 'UPlayerTests' do
    inherit! :search_paths
    pod 'RxTest'

  end

  target 'UPlayerUITests' do
    # Pods for testing
  end

end
