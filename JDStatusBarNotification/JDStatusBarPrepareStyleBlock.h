//
//  JDStatusBarPrepareStyleBlock.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#ifndef JDPrepareStyleBlock_h
#define JDPrepareStyleBlock_h

@class JDStatusBarStyle;

/**
 *  A block that is used to define the appearance of a notification.
 *  A JDStatusBarStyle instance defines the notification appeareance.
 *
 *  @param style The current default JDStatusBarStyle instance.
 *
 *  @return The modified JDStatusBarStyle instance.
 */
typedef JDStatusBarStyle * _Nonnull(^JDPrepareStyleBlock)(JDStatusBarStyle * _Nonnull style);

#endif /* JDPrepareStyleBlock_h */
