Pod::Spec.new do |s|
  
  # basics
  s.name      = 'JDStatusBarNotification'
  s.version   = '2.0.7'
  s.platform  = :ios, '13.0'
  s.license   = { :type => 'MIT' }
  s.author    = { 'Markus Emrich' => 'markus.emrich@gmail.com' }  
  s.source    = { :git => 'https://github.com/calimarkus/JDStatusBarNotification.git', :tag => "#{s.version}" }
  
  # description
  s.summary      = 'Highly customizable & feature rich notifications displayed below the status bar. Swift ready!'
  s.description  = 'Highly customizable & feature rich notifications displayed below the status bar. Customizable colors, fonts & animations. Supports notch and no-notch devices, landscape & portrait layouts and Drag-to-Dismiss. Can display a subtitle, an activity indicator, a progress bar & custom views out of the box. iOS 13+. Swift ready!'
  
  # links
  s.homepage          = 'https://github.com/calimarkus/JDStatusBarNotification'
  s.documentation_url = 'http://calimarkus.github.io/JDStatusBarNotification/documentation/jdstatusbarnotification/'
  s.screenshot        = 'https://user-images.githubusercontent.com/807039/173831886-d7c8cca9-9274-429d-b924-78f21a4f6092.jpg'
  
  # sources
  s.source_files         = 'JDStatusBarNotification/**/*.{h,m}'
  s.private_header_files = 'JDStatusBarNotification/Private/*.h'
  
end
