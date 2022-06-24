//
//  JDStatusBarPrepareStyleBlock.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#ifndef JDStatusBarPrepareStyleBlock_h
#define JDStatusBarPrepareStyleBlock_h

@class JDStatusBarNotificationStyle;

/**
 *  A block that is used to define the appearance of a notification.
 *  A JDStatusBarNotificationStyle instance defines the notification appeareance.
 *
 *  @param style The current default JDStatusBarNotificationStyle instance.
 *
 *  @return The modified JDStatusBarNotificationStyle instance.
 */
typedef JDStatusBarNotificationStyle * _Nonnull(^JDStatusBarPrepareStyleBlock)(JDStatusBarNotificationStyle * _Nonnull style);

#endif /* JDStatusBarPrepareStyleBlock_h */
