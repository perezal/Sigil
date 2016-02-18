//
//  SigilViewController.m
//  Sigil
//
//  Created by Alex Perez on 4/22/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "SigilViewController.h"
#import "SigilStart.h"

@implementation SigilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *) self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [SigilStart sceneWithSize: skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


@end
