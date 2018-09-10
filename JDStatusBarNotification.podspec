Pod::Spec.new do |s|
  
  s.name         = 'JDStatusBarNotification'
  s.version      = '1.6.0'
  s.summary      = 'Easy, customizable notifications displayed on top of the statusbar. With progress and activity. iPhone X ready.'

  s.description  = 'Show messages on top of the status bar. Customizable colors, font and animation. Supports progress display and can show an activity indicator. Supports iOS 6+ and iPhone X.'
  
  s.homepage     = 'https://github.com/calimarkus/JDStatusBarNotification'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Markus Emrich' => 'markus.emrich@gmail.com' }  
  
  s.source       = { :git => 'https://github.com/calimarkus/JDStatusBarNotification.git', :tag => "#{s.version}" }
  s.source_files = 'JDStatusBarNotification/**'
  s.frameworks   = 'QuartzCore'
  
  s.platform     = :ios, '6.0'
  s.requires_arc = true

end
