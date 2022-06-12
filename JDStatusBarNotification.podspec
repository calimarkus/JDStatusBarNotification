Pod::Spec.new do |s|
  
  s.name         = 'JDStatusBarNotification'
  s.version      = '2.0'
  s.summary      = 'Highly customizable notifications displayed below the status bar for both notch and no-notch devices. Customizable colors, fonts & animations. Can show an activity indicator, a progress bar & custom views. iOS 13+. Swift ready!'
  s.description  = s.summary
  s.homepage     = 'https://github.com/calimarkus/JDStatusBarNotification'
  s.platform     = :ios, '13.0'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Markus Emrich' => 'markus.emrich@gmail.com' }  
  
  s.source               = { :git => 'https://github.com/calimarkus/JDStatusBarNotification.git', :tag => "#{s.version}" }
  s.source_files         = 'JDStatusBarNotification/**'
  s.private_header_files = 'JDStatusBarNotification/Private/*.{h}'
  
end
