//
//  SigilStart.h
//  Sigil
//
//  Created by Alex Perez on 9/22/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SigilStart : SKScene <UIGestureRecognizerDelegate>

@property SKEmitterNode *tulpa;

- (void) panHandler: (UIPanGestureRecognizer *) recognizer;

@end
