# JDStatusBarNotification

Show messages on top of the status bar. Customizable colors, font and animation. iOS 7 ready.

![Animation](gfx/animation.gif "Animation")

![Screenshots](gfx/screenshots.png "Screenshots")

## Installation

**Install via pods:**  
`pod 'JDStatusBarNotification'`

**Manually:**  

1. Drag the `JDStatusBarNotification/JDStatusBarNotification` folder into your project.
2. Add `#include "JDStatusBarNotification.h"`, where you want to use it

## Usage

JDStatusBarNotification is a singleton. You don't need to initialize it anywhere.
Just use the following class methods:

### Showing a notification

    + (void)showWithStatus:(NSString *)status;
    + (void)showWithStatus:(NSString *)status
              dismissAfter:(NSTimeInterval)timeInterval;

### Dismissing a notification

    + (void)dismiss;
    + (void)dismissAfter:(NSTimeInterval)delay;
    
### Showing a notification with alternative styles

Available styles: `JDStatusBarStyleDefault`, `JDStatusBarStyleDark`, `JDStatusBarStyleError`, `JDStatusBarStyleWarning` or `JDStatusBarStyleSuccess`;
               
    + (void)showWithStatus:(NSString *)status
                 styleName:(NSString*)styleName;
                 
    + (void)showWithStatus:(NSString *)status
              dismissAfter:(NSTimeInterval)timeInterval
                 styleName:(NSString*)styleName;
                 
To present a notification using a custom style, use the `identifier` you specified in `addStyleNamed:prepare:`. See Customization below.

## Customization

    + (void)setDefaultStyle:(JDPrepareStyleBlock)prepareBlock;
    
    + (NSString*)addStyleNamed:(NSString*)identifier
                       prepare:(JDPrepareStyleBlock)prepareBlock;


The `prepareBlock` gives you a copy of the default style, which can be modified as you like:

	[JDStatusBarNotification addStyleNamed:<#identifier#>
	                               prepare:^JDStatusBarStyle*(JDStatusBarStyle *style) {
	                                   style.barColor = <#color#>;
	                                   style.textColor = <#color#>;
	                                   style.textShadow = <#textShadow#>;
	                                   style.animationType = <#type#>;
	                                   style.font = <#font#>;
	                                   return style;
	                               }];


## Twitter

I'm [@jaydee3](http://twitter.com/jaydee3) on Twitter. Feel free to [post a tweet](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/jaydee3/JDStatusBarNotification&via=jaydee3), if you like JDStatusBarNotification.  

[![TweetButton](gfx/tweetbutton.png "Tweet")](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/jaydee3/JDStatusBarNotification&via=jaydee3)
