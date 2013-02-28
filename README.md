# KGStatusBar

A minimal status bar for iOS. Similair to the status bar seen in the MailBox app. It covers the top status bar and appears like the message is embedded within.

![KGStatusBar](http://s10.postimage.org/doeo90sux/KGStatus_Bar.png)

## Installation

* Drag the `KGStatusBar/KGStatusBar` folder into your project.
* Add #include "KGStatusBar.h" in your .pch file

## Usage

KGStatusBar is a singleton and can be ran from anywhere. Make sure your layout shows the default status bar. I defaulted the colors to match it. Change if needed.

### Showing the Status Bar

[KGStatusBar showWithStatus:@"Loading"];
[KGStatusBar showErrorWithStatus:@"Error Synching Files."];

### Dismissing Status Bar

[KGStatusBar dismiss];


Enjoy :)


Brought to you you by [Kevin Gibbon](https://twitter.com/kevingibbon). Currently raising hell at [Attachments.me](https://attachments.me)
