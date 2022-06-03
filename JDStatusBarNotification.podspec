Pod::Spec.new do |s|
  
  s.name         = 'JDStatusBarNotification'
  s.version      = '2.0'
  s.summary      = 'Easy, customizable notifications displayed below the status bar. Notch and no-notch devices. Customizable colors, fonts, animations. Can show an activity indicicator & a progress bar. iOS 13+'
  s.description  = 'Easy, customizable notifications displayed below the status bar. Notch and no-notch devices. Customizable colors, fonts, animations. Can show an activity indicicator & a progress bar. iOS 13+'
  s.homepage     = 'https://github.com/calimarkus/JDStatusBarNotification'
  s.platform     = :ios, '13.0'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Markus Emrich' => 'markus.emrich@gmail.com' }  
  
  s.source               = { :git => 'https://github.com/calimarkus/JDStatusBarNotification.git', :tag => "#{s.version}" }
  s.source_files         = 'JDStatusBarNotification/**'
  s.private_header_files = 'JDStatusBarNotification/Private/*.{h}'
  
end
