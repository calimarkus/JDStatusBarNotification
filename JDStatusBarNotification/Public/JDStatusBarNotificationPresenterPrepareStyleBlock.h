//
//  JDStatusBarNotificationPresenterPrepareStyleBlock.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#ifndef JDStatusBarNotificationPresenterPrepareStyleBlock_h
#define JDStatusBarNotificationPresenterPrepareStyleBlock_h

@class JDStatusBarNotificationStyle;

/**
 *  A block that is used to define the appearance of a notification.
 *  A JDStatusBarNotificationStyle instance defines the notification appeareance.
 *
 *  @param style The current default JDStatusBarNotificationStyle instance.
 *
 *  @return The modified JDStatusBarNotificationStyle instance.
 */
typedef JDStatusBarNotificationStyle * _Nonnull(^JDStatusBarNotificationPresenterPrepareStyleBlock)(JDStatusBarNotificationStyle * _Nonnull style) NS_SWIFT_NAME(NotificationPresenterPrepareStyleClosure);

#endif /* JDStatusBarNotificationPresenterPrepareStyleBlock_h */
