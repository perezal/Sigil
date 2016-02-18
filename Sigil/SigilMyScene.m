//
//  SigilMyScene.m
//  Sigil
//
//  Created by Alex Perez on 4/22/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "SigilViewController.h"
#import "SigilMyScene.h"

@implementation SigilMyScene

@synthesize currentSpell;
@synthesize tulpa;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
        
        myLabel.text = @"Sigil";
        myLabel.fontSize = 40;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        }
    
    return self;
}

- (void) didMoveToView:(SKView *)view
{
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(tapHandler:)];
    tapRecognizer.delegate = self;
    //tapRecognizer.cancelsTouchesInView = NO;
    
    FireGestureRecognizer *fireRecognizer = [[FireGestureRecognizer alloc] initWithTarget: self action:@selector(fireHandler:)];
    fireRecognizer.delegate = self;
    fireRecognizer.delaysTouchesEnded = NO;
    fireRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer: fireRecognizer];
    
    [view addGestureRecognizer: tapRecognizer];
    
}

- (void) tapHandler:(UITapGestureRecognizer *)recognizer
{
    switch (currentSpell)
    {
        case FireSpell:
        {            
            SKEmitterNode *fireEmitter = [SKEmitterNode emitterNamed: @"FireSigil"];
            fireEmitter.position = [recognizer locationInView: self.view];
            
            [self addChild: fireEmitter];
            
            [fireEmitter runAction: [SKAction sequence:@[
                                                         [SKAction waitForDuration:3],
                                                         [SKAction runBlock:^{
                [fireEmitter removeFromParent];
            }]
                                                         ]]];
            
            break;
        }
        case WaterSpell:
            break;
        case ThunderSpell:
            break;
        case EarthSpell:
            break;
        default:
            break;
        
    }
    
    currentSpell = NoSpell;
    
    if (DEBUG)
        NSLog(@"Tap recognized");
}

- (void) fireHandler:(FireGestureRecognizer *) recognizer
{
    SKEmitterNode *fireEmitter = [SKEmitterNode emitterNamed: @"FireSigil"];
    fireEmitter.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
    //[recognizer locationInView: self.view];
    
    [self addChild: fireEmitter];
    
    [fireEmitter runAction: [SKAction sequence:@[
                                                 [SKAction waitForDuration:3],
                                                 [SKAction runBlock:^{
        [fireEmitter removeFromParent];
    }]
                                                 ]]];
    
    //currentSpell = FireSpell;
}

-(void)update:(CFTimeInterval)currentTime {
}

# pragma mark - Tulpa

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    tulpa = [SKEmitterNode emitterNamed: @"Tulpa"];
    tulpa.particleBirthRate = 0;
    tulpa.targetNode = self;
    tulpa.position = [touch locationInNode: self];
    
    [self addChild: tulpa];
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
    UITouch *touch = [touches anyObject];
    [tulpa runAction: [SKAction moveTo: [touch locationInNode: self] duration: 0.01]];
    //tulpa.position = [touch locationInNode: self];
    tulpa.particleBirthRate = 10000;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [tulpa runAction: [SKAction moveTo: [touch locationInNode: self] duration: 0.01]];
    tulpa.particleBirthRate = 0;
    
    /*CASTING ANIMATION ==========================*/
    SKEmitterNode *cast = [SKEmitterNode emitterNamed: @"Cast"];
    cast.position = [touch locationInNode: self];
    
    [self addChild: cast];
    [cast runAction: [SKAction waitForDuration: 1.2] completion:^{
        cast.particleBirthRate = 0;
    }];
    [cast runAction: [SKAction waitForDuration: 3] completion:^{
        [cast removeFromParent];
    }];
    //[tulpa removeFromParent];
    if (DEBUG)
        NSLog(@"Touch Ended");
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    tulpa.particleBirthRate = 0;
    
    /*CASTING ANIMATION ==========================*/
    SKEmitterNode *cast = [SKEmitterNode emitterNamed: @"Cast"];
    cast.position = [touch locationInNode: self];
    
    [self addChild: cast];
    [cast runAction: [SKAction waitForDuration: 1.2] completion:^{
        cast.particleBirthRate = 0;
    }];
    [cast runAction: [SKAction waitForDuration: 3] completion:^{
        [cast removeFromParent];
    }];
    //[tulpa removeFromParent];
    if (DEBUG)
        NSLog(@"Touch Cancelled");
}

@end

@implementation SKEmitterNode (fromFile)

+ (instancetype) emitterNamed: (NSString *) name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile: [[NSBundle mainBundle] pathForResource: name ofType: @"sks"]];
}

@end
