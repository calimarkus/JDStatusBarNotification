//
//  JDStatusBarNotificationPresenterPrepareStyleBlock.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#ifndef JDStatusBarNotificationPresenterPrepareStyleBlock_h
#define JDStatusBarNotificationPresenterPrepareStyleBlock_h

@class JDStatusBarNotificationStyle;

/// Creates a modified copy of an existing ``JDStatusBarNotificationStyle`` instance.
///
/// - Parameter style: The current default ``JDStatusBarNotificationStyle`` instance.
///
/// - Returns: The modified ``JDStatusBarNotificationStyle`` instance.
///
typedef JDStatusBarNotificationStyle * _Nonnull(^JDStatusBarNotificationPresenterPrepareStyleBlock)(JDStatusBarNotificationStyle * _Nonnull style) NS_SWIFT_NAME(NotificationPresenterPrepareStyleClosure);

#endif /* JDStatusBarNotificationPresenterPrepareStyleBlock_h */
