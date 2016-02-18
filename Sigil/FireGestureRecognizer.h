//
//  FireGestureRecognizer.h
//  Sigil
//
//  Created by Alex Perez on 5/4/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Downward = 0,
    DownwardComplete,
    UpLeft,
    UpLeftComplete,
    Right,
    RightComplete
} GestureStage;

@interface FireGestureRecognizer : UIGestureRecognizer

@property GestureStage gestureStage;
@property int gestureIndex;

@property CGPoint gestureStart;
@property NSTimeInterval gestureStartTime;

- (void) resetState;

@end
