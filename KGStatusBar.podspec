Pod::Spec.new do |s|
  s.name         = "KGStatusBar"
  s.version      = "0.0.1"
  s.summary      = "A minimal status bar for iOS."
  s.description  = <<-DESC
                      Similar to the status bar seen in the MailBox app, it covers the top status bar and appears like the message is embedded within.
                     DESC
  s.homepage     = "https://github.com/kevingibbon/KGStatusBar"


  s.license      = { :type => 'MIT', :file => 'LICENSE.TXT' }
  s.author       = { "Kevin Gibbon" => "gibbon.kevin@gmail.com" }
  
  s.source       = { :git => "https://github.com/kevingibbon/KGStatusBar.git", :commit => "6af8533916b5da5f2aa951563bfae4dfa3f2c50b" }
  
  s.platform     = :ios
  s.source_files = 'KGStatusBar'
  s.requires_arc = true
end
