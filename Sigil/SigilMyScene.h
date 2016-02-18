//
//  SigilMyScene.h
//  Sigil
//

//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FireGestureRecognizer.h"

typedef enum {
    NoSpell = 0,
    FireSpell,
    WaterSpell,
    ThunderSpell,
    EarthSpell
} SpellType;

@interface SigilMyScene : SKScene <UIGestureRecognizerDelegate>

@property SpellType currentSpell;
@property SKEmitterNode *tulpa;

- (void) tapHandler: (UITapGestureRecognizer *) recognizer;

- (void) fireHandler: (FireGestureRecognizer *) recognizer;

@end

@interface SKEmitterNode (fromFile)
+ (instancetype) emitterNamed: (NSString *) name;
@end
