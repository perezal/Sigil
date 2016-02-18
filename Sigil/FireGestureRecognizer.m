//
//  FireGestureRecognizer.m
//  Sigil
//
//  Created by Alex Perez on 5/4/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

// Prints the touch point vectors to the console during touchesMoved
#define DEBUG_TOUCH_POINT 0

// A vector quantity that determines how much a gesture may deviate from the intended direction
#define SENSITIVITY 3

#import "CGVectorMath.h"
#import "FireGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation FireGestureRecognizer

@synthesize gestureStage;
@synthesize gestureIndex;

@synthesize gestureStart;
@synthesize gestureStartTime;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.gestureStart = [touch locationInView: self.view];
    self.gestureStartTime = touch.timestamp;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView: self.view];
    CGPoint previousTouchPoint = [touch previousLocationInView: self.view];
    
    CGVector touchVector = VectorSubtract(currentTouchPoint, previousTouchPoint);
    
    /*
     touch origin in the upper left corner of the scene. Thus:
     
     rightward motion ....... touchVector.dx > 0
     leftward motion ........ touchVector.dx < 0
     downward motion ........ touchVector.dy > 0
     upward motion .......... touchVector.dy < 0
     */
    
    switch (gestureStage)
    {
        case Downward:
            /*
             The Downward stage checks for sufficient downward motion to complete that portion of the gesture.
            */
            
            // sufficient down motion achieved
            if (gestureIndex >= 40)
            {
                gestureStage = DownwardComplete;
                gestureIndex = 0;
                
                if (DEBUG)
                    NSLog(@"Downward Completed");
            }
            
            // check for sufficient down motion and lack of right or leftward motion
            else if (touchVector.dy > 0 && ABS(touchVector.dx) < SENSITIVITY * 2)
            {
                gestureIndex += touchVector.dy;
            }
            // allow any motion within sensitivity
            else if (ABS(touchVector.dx) < SENSITIVITY || ABS(touchVector.dy) < SENSITIVITY)
                break;
            
            else
                [self resetState];
            
            break;
            
        case DownwardComplete:
            /*
             After the Downward stage is recognized, the DownwardComplete stage allows downward motion while checking for UpLeft motion to progress to the UpLeft stage.
            */
            
            // check for UpLeft motion to indicate a transition to the UpLeft stage
            if (touchVector.dy < 0 && touchVector.dx < 0)
            {
                gestureStage = UpLeft;
                if (DEBUG)
                    NSLog(@"DownwardComplete Completed");
            }
            // allow downward motion within x-axis sensitivity
            else if (touchVector.dy > 0 && ABS(touchVector.dx) < SENSITIVITY * 2)
                break;
            
            // allow any motion within sensitivity
            else if (ABS(touchVector.dx) < SENSITIVITY || ABS(touchVector.dy) < SENSITIVITY)
                break;
            else
                [self resetState];
            
            break;
            
        case UpLeft:
            /*
             The UpLeft stage checks for sufficient upward and leftward motion to complete that portion of the gesture.
            */
            
            // sufficient up/left motion achieved
            if (gestureIndex >= 40)
            {
                gestureStage = UpLeftComplete;
                gestureIndex = 0;
                
                if (DEBUG)
                    NSLog(@"UpLeft Completed");
            }
            
            // check for sufficient up/left motion
            else if (touchVector.dy < 0 && touchVector.dx < 0)
            {
                gestureIndex += ABS(touchVector.dy);
                gestureIndex += ABS(touchVector.dx);
            }
            
            // allow any motion within sensitivity
            else if (ABS(touchVector.dx) < SENSITIVITY || ABS(touchVector.dy) < SENSITIVITY)
                break;
            
            else
                [self resetState];
            
            break;
            
        case UpLeftComplete:
            /*
             After the UpLeft stage is recognized, the UpLeftComplete stage allows UpLeft motion while checking for rightward motion to progress to the Right stage.
             */
            
            // check for rightward motion within y-axis sensitivity to indicate transition to the Right stage
            if (touchVector.dx > 0 && ABS(touchVector.dy) < SENSITIVITY * 2)
            {
                gestureStage = Right;
                if (DEBUG)
                    NSLog(@"UpLeftComplete Completed");
            }
            
            // allow up/left motion
            else if (touchVector.dx < 0 && touchVector.dy < 0)
                break;
            
            // allow any motion within sensitivity
            else if (ABS(touchVector.dx) < SENSITIVITY || ABS(touchVector.dy) < SENSITIVITY)
                break;
            
            else
                [self resetState];
            
            break;
        case Right:
            // sufficient right motion achieved
            if (gestureIndex >= 40)
            {
                // refer to touchesEnded for the completion of the gesture
                gestureStage = RightComplete;
                gestureIndex = 0;
                
                if (DEBUG)
                    NSLog(@"Right Completed");
            }
            
            // check for sufficient right motion within sensitivity
            else if (touchVector.dx > 0 && ABS(touchVector.dy) < SENSITIVITY * 2)
            {
                gestureIndex += touchVector.dx;
            }
            
            // allow any motion within sensitivity
            else if (ABS(touchVector.dx) < SENSITIVITY || ABS(touchVector.dy) < SENSITIVITY)
                break;
            
            else
                [self resetState];
            
            break;
        case RightComplete:
            
            // allow rightward motion within sensitivity
            if (touchVector.dx > 0 && ABS(touchVector.dy) < SENSITIVITY * 2)
                break;
            
            // allow any motion within sensitivity
            else if (ABS(touchVector.dx) < SENSITIVITY || ABS(touchVector.dy) < SENSITIVITY)
                break;
            else
                [self resetState];
            
            break;
            
        default:
            // fail the gesture
            [self resetState];
            break;
    };
    
    if (DEBUG_TOUCH_POINT == YES) {
        NSLog(@"Vector: %f, %f", touchVector.dx, touchVector.dy);
    }
    
    
    
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (gestureStage == RightComplete)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentTouchPoint = [touch locationInView: self.view];
        NSLog(@"currentTouchPoint: %f, %f", currentTouchPoint.x, currentTouchPoint.y);
        NSLog(@"gestureStart: %f, %f", gestureStart.x, gestureStart.y);
        
        if (currentTouchPoint.y > gestureStart.y && currentTouchPoint.x > gestureStart.x && self.state == UIGestureRecognizerStatePossible)
        {
            [self setState: UIGestureRecognizerStateEnded];
            
            NSLog(@"Fire Gesture Completed");
        }
    }
    
    [self resetState];
}

- (void) resetState
{
    gestureStage = 0;
    gestureIndex = 0;
    gestureStart = CGPointZero;
    if (self.state == UIGestureRecognizerStatePossible)
        [self setState: UIGestureRecognizerStateFailed];
    
    if (DEBUG && self.state == UIGestureRecognizerStateFailed)
        NSLog(@"Fire Gesture Failed");
}

@end
