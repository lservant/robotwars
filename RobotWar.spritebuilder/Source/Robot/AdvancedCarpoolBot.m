//
//  AdvancedCarpoolBot.m
//  RobotWar
//
//  Created by Derek Tor on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "AdvancedCarpoolBot.h"

typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateDefault,
    RobotStateTurnaround,
    RobotStateFiring,
    RobotStateTracking,
    RobotStateSearching
};

@implementation AdvancedCarpoolBot {
    RobotState _currentRobotState;
    
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
    CGPoint _oldLastKnownPosition;
    CGFloat _oldLastKnownPositionTimestamp;
}

//- (void)run {
//    [self firstTurn];
//    while (true) {
//        [self moveAhead:10];
//        [self turnInsideBoundaries];
//    }
//}

- (void)run {
    _lastKnownPosition = CGPointMake(0, 0);
    _lastKnownPositionTimestamp = self.currentTimestamp;
    while (true) {
        if (_currentRobotState == RobotStateFiring) {
            
            if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f) {
                _currentRobotState = RobotStateSearching;
            } else {
                [self shoot];
                [self moveAhead:100];
            }
        }
        
        if (_currentRobotState == RobotStateSearching) {
            [self moveAhead:10];
        }
        
        if (_currentRobotState == RobotStateTracking) {
            //CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
            //tracking function
            NSLog(@"Tracking...");
            
            CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
            if (angle >= 0) {
                [self turnGunRight:abs(angle)];
            } else {
                [self turnGunLeft:abs(angle)];
            }
            
            if ([self getAngleDifference]<10) {
                _currentRobotState = RobotStateFiring;
            }
        }
        
        if (_currentRobotState == RobotStateDefault) {
            [self firstTurn];
        }
    }
}

- (void)bulletHitEnemy:(Bullet *)bullet {
    // There are a couple of neat things you could do in this handler
}

- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
    if (_currentRobotState != RobotStateTracking) {
        [self cancelActiveAction];
    }
    if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 0.1) {
        // Save previous last known position to oldLastknownPosition
        _oldLastKnownPosition = _lastKnownPosition;
        _oldLastKnownPositionTimestamp = _lastKnownPositionTimestamp;
        
        _lastKnownPosition = position;
        _lastKnownPositionTimestamp = self.currentTimestamp;
        _currentRobotState = RobotStateTracking;
        
        NSLog(@"Old Last Known: %f,%f...New Last Known %f,%f",_oldLastKnownPosition.x,_oldLastKnownPosition.y,_lastKnownPosition.x,_lastKnownPosition.y);
    }

}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    if (_currentRobotState != RobotStateTurnaround) {
        [self cancelActiveAction];
        [self moveBack:50];
        [self turnRobotLeft:90];
        
        RobotState previousState = _currentRobotState;
        _currentRobotState = RobotStateTurnaround;
        
        // always turn to head straight away from the wall
        if (angle >= 0) {
            [self turnRobotLeft:abs(angle)];
        } else {
            [self turnRobotRight:abs(angle)];
            
        }
        
        [self moveAhead:20];
        
        _currentRobotState = previousState;
    }
}

//Custom Code

-(void)firstTurn{
    CGPoint origin = CGPointMake(0, 0);
    [self getDistanceFromCGPoint:origin];
    [self turnRobotRight:45];
    [self turnGunLeft:45];
    [self turnRobotRight:45];
    [self moveAhead:100];
    [self shoot];
    [self turnGunLeft:45];
    _currentRobotState = RobotStateSearching;
}


//if robot is less than 100 from boundary, turn left 90 and move forward 50

//-(void)turnInsideBoundaries{
//    
//    float maxWidth=[self arenaDimensions].width,
//    maxHeight=[self arenaDimensions].height,
//    x=self.robotBoundingBox.origin.x,
//    y=self.robotBoundingBox.origin.y;
//    
//    CGPoint bottom = CGPointMake(x, 0),
//    top = CGPointMake(x, maxHeight),
//    left = CGPointMake(0, y),
//    right = CGPointMake(maxWidth, y);
//    //(x,0),(x,max)
//    //(0,y),(max,y)
//    
//    if (![self  checkDistanceFromTop:top Bottom:bottom Left:left AndRight:right Within:10]) {
//        [self turnRobotLeft:45];
//        [self moveAhead:25];
//    }
//}

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

-(float)getAngleDifference{
    CGFloat angleFromLastKnownPosition = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
    CGFloat angleFromOldLastKnownPosition = [self angleBetweenGunHeadingDirectionAndWorldPosition:_oldLastKnownPosition];
    
    return abs(angleFromLastKnownPosition-angleFromOldLastKnownPosition);
    
}

- (void)gotHit {
    [self turnRobotLeft:60];
    [self moveAhead:100];
}


//Velocity Method Needed?
@end

