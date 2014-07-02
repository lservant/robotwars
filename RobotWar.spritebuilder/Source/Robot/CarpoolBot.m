//
//  CarpoolBot.m
//  RobotWar
//
//  Created by Derek Tor on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CarpoolBot.h"

typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateDefault,
    RobotStateTurnaround,
    RobotStateFiring,
    RobotStateSearching
};
BOOL direction = YES;

@implementation CarpoolBot {
    RobotState _currentRobotState;
    
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
}

- (void)run {
    while (true) {
        if (_currentRobotState == RobotStateFiring) {
            
            if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f) {
                _currentRobotState = RobotStateSearching;
            } else {
                [self turnTurretToOpponent];
                [self shoot];
//                [self shoot];
//                if(direction == YES){
//                    [self moveAhead:100];
//                }
//                else{
//                    [self moveBack:50];
//                }
//                direction = !direction;
                
            }
        }
        
        if (_currentRobotState == RobotStateSearching) {
            if ((self.currentTimestamp-_lastKnownPositionTimestamp)<=1.f) {
                
                [self turnRobotToOpponent];
            }
            float distance = [self getDistanceFromCGPoint:_lastKnownPosition];
            [self moveAhead:distance];
        }
        
        if (_currentRobotState == RobotStateDefault) {
            [self moveAhead:100];
        }
    }
}

- (void)gotHit {
    [self moveAhead:100];
}

-(void)turnTurretToOpponent{
    CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
    if (angle >= 0) {
        [self turnGunRight:abs(angle)];
    } else {
        [self turnGunLeft:abs(angle)];
    }
}

-(void)turnRobotToOpponent{
    CGFloat angle = [self angleBetweenHeadingDirectionAndWorldPosition:_lastKnownPosition];
    if (angle < 0) {
        [self turnRobotLeft:abs(angle)];
    } else {
        [self turnRobotRight:abs(angle)];
    }
}

- (void)bulletHitEnemy:(Bullet *)bullet {
    if (!bullet) {
        [self shoot];
    }
    // There are a couple of neat things you could do in this handler
}

- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
    if (_currentRobotState != RobotStateFiring) {
        [self cancelActiveAction];
    }
    
    _lastKnownPosition = position;
    _lastKnownPositionTimestamp = self.currentTimestamp;
    _currentRobotState = RobotStateFiring;
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    if (_currentRobotState != RobotStateTurnaround) {
        [self cancelActiveAction];
        
        RobotState previousState = _currentRobotState;
        _currentRobotState = RobotStateTurnaround;
        
        // always turn to head straight away from the wall
//        if (angle >= 0) {
//            [self turnRobotLeft:abs(angle)];
//        } else {
//            [self turnRobotRight:abs(angle)];
//            
//        }
        [self turnRobotToOpponent];
        
        [self moveAhead:20];
//        [self turnInsideBoundaries];
        
        _currentRobotState = previousState;
    }
}

-(void)turnInsideBoundaries{

    float maxWidth=[self arenaDimensions].width,
    maxHeight=[self arenaDimensions].height,
    x=self.robotBoundingBox.origin.x,
    y=self.robotBoundingBox.origin.y;

    CGPoint bottom = CGPointMake(x, 0),
    top = CGPointMake(x, maxHeight),
    left = CGPointMake(0, y),
    right = CGPointMake(maxWidth, y);
    //(x,0),(x,max)
    //(0,y),(max,y)

    if (![self  checkDistanceFromTop:top Bottom:bottom Left:left AndRight:right Within:0]) {
        [self turnRobotLeft:45];
        [self moveAhead:25];
    }
}

-(BOOL)checkDistanceFromTop:(CGPoint)top Bottom:(CGPoint)bottom Left:(CGPoint)left AndRight:(CGPoint)right Within:(float)maxArea{
    if ([self getDistanceFromCGPoint:top]>maxArea &&
        [self getDistanceFromCGPoint:bottom]>maxArea &&
        [self getDistanceFromCGPoint:left]>maxArea &&
        [self getDistanceFromCGPoint:right]>maxArea) {
        return true;
    }
    return false;
}

-(float)getDistanceFromCGPoint:(CGPoint)position{
    float
    firstX=self.robotBoundingBox.origin.x,
    firstY=self.robotBoundingBox.origin.y,
    secondX=position.x,
    secondY=position.y,
    distance=sqrtf((firstX-secondX)*(firstX-secondX)+(firstY-secondY)*(firstY-secondY));
    //    NSLog(@"Distance is %f",distance);
    return distance;
}

@end
