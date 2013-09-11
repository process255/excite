//
//  ExciteMyScene.m
//  ExciteBike
//
//  Created by Sean Dougherty on 9/10/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "ExciteMyScene.h"

#define kRowHeight 40
#define kRows 4

typedef enum {
	ExcitePadDirectionLeft,
	ExcitePadDirectionRight,
	ExcitePadDirectionUp,
    ExcitePadDirectionDown
} ExcitePadDirection;


@interface ExciteMyScene()
@property (nonatomic, strong) SKSpriteNode *bike;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, copy) NSArray *rows;
@property (nonatomic, assign) ExcitePadDirection padDirection;
@end

@implementation ExciteMyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.61 green:0.875 blue:0.05 alpha:1.0];
        SKSpriteNode *bottomBarrier = [SKSpriteNode spriteNodeWithImageNamed:@"bottom-barrier"];
        [self addRows];
        [self addChild:self.bike];
        [self addChild:bottomBarrier];
        bottomBarrier.position = CGPointMake(50, 50);
    }
    return self;
}

- (void)didChangeSize:(CGSize)oldSize
{
    [super didChangeSize:oldSize];
    [self resizeAndReposition];
}

- (void)addRows
{
    SKSpriteNode *row0 = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(self.frame.size.width, kRowHeight)];
    SKSpriteNode *row1 = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(self.frame.size.width, kRowHeight)];
    SKSpriteNode *row2 = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(self.frame.size.width, kRowHeight)];
    SKSpriteNode *row3 = [[SKSpriteNode alloc] initWithColor:[SKColor purpleColor] size:CGSizeMake(self.frame.size.width, kRowHeight)];
    
    self.rows = @[row0, row1, row2, row3];
    
    [self addChild:row0];
    [self addChild:row1];
    [self addChild:row2];
    [self addChild:row3];
    
    [self resizeAndReposition];
}

- (void)resizeAndReposition
{
    [self positionRows];
    self.bike.position = CGPointMake(CGRectGetMidX(self.frame) / 2, 0);
    [self moveBike:0];
}

- (void)positionRows
{
    for (SKSpriteNode *row in self.rows)
    {
        NSUInteger index = [self.rows indexOfObject:row];
        row.position = CGPointMake(CGRectGetMidX(self.frame), kRowHeight * (index + 1));
        row.size = CGSizeMake(self.frame.size.width, kRowHeight);
    }
}

- (SKSpriteNode *)bike
{
    if (_bike == nil)
    {
        _bike = [SKSpriteNode spriteNodeWithImageNamed:@"excitebike_2"];
    }
    
    return _bike;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1)
    {
        self.padDirection = [self directionFromTouch:[touches anyObject]];
        
        switch (self.padDirection)
        {
            case ExcitePadDirectionUp:
                [self moveUp];
                break;
                
            case ExcitePadDirectionDown:
                [self moveDown];
                break;
                
            case ExcitePadDirectionLeft:
                NSLog(@"left");
                break;
                
            case ExcitePadDirectionRight:
                NSLog(@"right");
                break;
        }
    }
}

- (void)moveDown
{
    if (self.row > 0)
    {
        self.row--;
        [self moveBike:0.2];
    }
}

- (void)moveUp
{
    if (self.row < 3)
    {
        self.row++;
        [self moveBike:0.2];
    }
}

- (void)moveBike:(CGFloat)duration
{
    [self.bike runAction: [SKAction moveToY:(self.row + 1) * kRowHeight + 20  duration:duration]];
}

- (ExcitePadDirection)directionFromTouch:(UITouch*)touch
{
    CGPoint location = [touch locationInNode:self];

    if (location.y < self.frame.size.height / 3)
    {
        return ExcitePadDirectionDown;
    }
    else if (location.y > self.frame.size.height * 2/3)
    {
        return ExcitePadDirectionUp;
    }
    else if (location.x < self.frame.size.width / 3)
    {
        return ExcitePadDirectionLeft;
    }
    else
    {
        return ExcitePadDirectionRight;
    }

}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
