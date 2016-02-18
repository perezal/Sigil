//
//  SigilStart.m
//  Sigil
//
//  Created by Alex Perez on 9/22/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "SigilStart.h"
#import "SigilMyScene.h"

@implementation SigilStart

@synthesize tulpa;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor darkGrayColor];
        
        SKLabelNode *sigilLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
        sigilLabel.text = @"Sigil";
        sigilLabel.fontSize = 40;
        sigilLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        sigilLabel.alpha = 0;
        
        SKLabelNode *swipeLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
        swipeLabel.text = @"Swipe to Continue";
        swipeLabel.fontSize = 26;
        swipeLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-20);
        swipeLabel.alpha = 0;
            
        

        
        
        [self addChild:sigilLabel];
        //[self addChild:swipeLabel];
        
        [sigilLabel runAction: [SKAction sequence:@[
                                                 [SKAction waitForDuration:1],
                                                 [SKAction fadeInWithDuration:2],
                                                 [SKAction waitForDuration:1.5],
                                                 [SKAction runBlock:^{
            [self addChild: swipeLabel];
        }],
                                                 [SKAction fadeOutWithDuration:2],
                                                 [SKAction runBlock:^{
            [sigilLabel removeFromParent];
        }]
                                                 ]]];
        [swipeLabel runAction: [SKAction fadeInWithDuration:2]];

        
    }
    
    return self;
}

- (void) didMoveToView:(SKView *)view {
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panRecognizer.delegate = self;
    panRecognizer.delaysTouchesEnded = NO;
    panRecognizer.cancelsTouchesInView = NO;
    //panRecognizer.canPanVertically = NO;
    
    [self.view addGestureRecognizer: panRecognizer];
    
}

- (void) panHandler:(UIPanGestureRecognizer *) recognizer {

    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        SigilMyScene *scene = [[SigilMyScene alloc] initWithSize: self.size];
        
        [self.view removeGestureRecognizer: recognizer];
        [self.view presentScene: scene transition: [SKTransition fadeWithDuration: 2]];
    }

}

# pragma mark - Tulpa methods

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
