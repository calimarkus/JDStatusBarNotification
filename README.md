# JDStatusBarNotification

Easy, customizable notifications displayed below the status bar for notch and no-notch devices.
Customizable colors, fonts and animations. Supports displaying a progress bar and/or an activity indicator.
Please open a [Github issue], if you think anything is missing or wrong.

![animation](https://user-images.githubusercontent.com/807039/170856043-6da8fcae-d453-47aa-9fdd-cd4f6ea982f5.gif)

![iphoneX](https://user-images.githubusercontent.com/807039/170856047-f63ebbf1-0aac-41ef-a620-07e73d5c0a76.png)

![screenshots](https://user-images.githubusercontent.com/807039/170856049-b7ca45a0-abbd-4e76-8bac-7c0c6adeb26a.png)

## Installation

#### CocoaPods:

`pod 'JDStatusBarNotification'`

(For infos on cocoapods, have a look at the [cocoapods website])

#### Manually:

1. Drag the `JDStatusBarNotification/JDStatusBarNotification` folder into your project.
2. Add `#include "JDStatusBarNotification.h"`, where you want to use it

#### Carthage:

`github "calimarkus/JDStatusBarNotification"`

(more infos on Carthage [here](https://github.com/Carthage/Carthage))

## Beware: App Rejections (pre iOS 13.0 I think)

Some people informed me, that their apps got rejected for using status bar overlays (for violating 10.1/10.3).
All cases I'm aware of are listed here:

- [@goelv](https://github.com/goelv) in [#15](https://github.com/calimarkus/JDStatusBarNotification/issues/15)
- [@dskyu](https://github.com/dskyu) in [#30](https://github.com/calimarkus/JDStatusBarNotification/issues/30)
- [@graceydb](https://github.com/graceydb) in [#49](https://github.com/calimarkus/JDStatusBarNotification/issues/49)
- [@hongdong](https://github.com/hongdong) in [#91](https://github.com/calimarkus/JDStatusBarNotification/issues/91)

## Usage

JDStatusBarNotification is a singleton. You don't need to initialize it anywhere.
Just use the following class methods:

### Showing a notification
    
```objc
+ (JDStatusBarView*)showWithStatus:(NSString *)status;
+ (JDStatusBarView*)showWithStatus:(NSString *)status
                      dismissAfter:(NSTimeInterval)timeInterval;
```

The return value will be the notification view. You can just ignore it, but if you need further customization, this is where you can access the view.

### Dismissing a notification

```objc
+ (void)dismiss;
+ (void)dismissAfter:(NSTimeInterval)delay;
```
    
### Showing progress

![progress](https://user-images.githubusercontent.com/807039/170856052-23feecb8-e692-4b64-a89c-7be504f4813a.gif)

```objc
+ (void)showProgress:(CGFloat)progress;  // Range: 0.0 - 1.0
```
    
### Showing activity

![activity](https://user-images.githubusercontent.com/807039/170856058-a38fb6ea-5d04-40af-9ede-d4984e288b66.gif)

```objc
+ (void)showActivityIndicator:(BOOL)show
               indicatorStyle:(UIActivityIndicatorViewStyle)style;
```
    
### Showing a notification with alternative styles

Included styles:

![styles](https://user-images.githubusercontent.com/807039/170856062-af9803ae-f740-4d8e-83dd-f2f3822ebc54.png)

Use them with the following methods:

```objc
+ (JDStatusBarView*)showWithStatus:(NSString *)status
                         styleName:(NSString*)styleName;

+ (JDStatusBarView*)showWithStatus:(NSString *)status
                      dismissAfter:(NSTimeInterval)timeInterval
                         styleName:(NSString*)styleName;
```
                 
To present a notification using a custom style, use the `identifier` you specified in `addStyleNamed:prepare:`. See Customization below.

## Customization

```objc
+ (void)setDefaultStyle:(JDPrepareStyleBlock)prepareBlock;

+ (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDPrepareStyleBlock)prepareBlock;
```


The `prepareBlock` gives you a copy of the default style, which can be modified as you like:

```objc
[JDStatusBarNotification addStyleNamed:<#identifier#> prepare:^JDStatusBarStyle*(JDStatusBarStyle *style) {
   // main properties
   style.barColor = <#color#>;
   style.textColor = <#color#>;
   style.font = <#font#>;
   
   // advanced properties
   style.animationType = <#type#>;
   style.textShadow = <#shadow#>;
   style.textVerticalPositionAdjustment = <#adjustment#>;

   // progress bar
   style.progressBarColor = <#color#>;
   style.progressBarHeight = <#height#>;
   style.progressBarPosition = <#position#>;

   return style;
}];
```

#### Animation Types

```objc
typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
  /// Notification won't animate
  JDStatusBarAnimationTypeNone,
  /// Notification will move in from the top, and move out again to the top
  JDStatusBarAnimationTypeMove,
  /// Notification will fall down from the top and bounce a little bit
  JDStatusBarAnimationTypeBounce,
  /// Notification will fade in and fade out
  JDStatusBarAnimationTypeFade,
};
```

## Twitter

I'm [@calimarkus](http://twitter.com/calimarkus) on Twitter. Feel free to [post a tweet](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus), if you like JDStatusBarNotification.  

[![tweetbutton](https://user-images.githubusercontent.com/807039/170856086-2c283e68-a44f-4a9f-b327-bd5a7c654455.png)](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus)

[Github issue]: https://github.com/calimarkus/JDStatusBarNotification/issues
[cocoapods website]: http://cocoapods.org
