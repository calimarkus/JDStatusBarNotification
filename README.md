# KGStatusBar

A minimal status bar for iOS. Similair to the status bar seen in the MailBox app. It covers the top status bar and appears like the message is embedded within.

![KGStatusBar](http://s10.postimage.org/doeo90sux/KGStatus_Bar.png)

## Installation

* Drag the `KGStatusBar/KGStatusBar` folder into your project.
* Add #include "KGStatusBar.h" to your .pch file

## Usage

KGStatusBar is a singleton. Make sure your view displays the default status bar for this to be effective. I defaulted the colors to match the default status bar. Change if needed.

### Showing the Status Bar

[KGStatusBar showWithStatus:@"Loading"];
[KGStatusBar showErrorWithStatus:@"Error Synching Files."];

### Dismissing Status Bar

[KGStatusBar dismiss];


Enjoy :)


Brought to you you by [Kevin Gibbon](https://twitter.com/kevingibbon). Currently raising hell at [Attachments.me](https://attachments.me)
