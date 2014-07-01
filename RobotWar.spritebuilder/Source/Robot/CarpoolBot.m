////
////  CarpoolBot.m
////  RobotWar
////
////  Created by Derek Tor on 7/1/14.
////  Copyright (c) 2014 Apportable. All rights reserved.
////
//
//#import "CarpoolBot.h"
//
//@implementation CarpoolBot{
//
////RobotState _currentRobotState;
//
//CGPoint _lastKnownPosition;
//CGFloat _lastKnownPositionTimestamp;
//}
//- (void)run {
//    [self firstTurn];
//    while (true) {
//        [self moveAhead:10];
//        [self turnInsideBoundaries];
//    }
//}
//
//-(void)firstTurn{
//    CGPoint origin = CGPointMake(0, 0);
//    [self getDistanceFromCGPoint:origin];
//    //if current timestamp == 0 then turn
//    if (self.currentTimestamp == 0) {
//        [self turnRobotRight:45];
//        [self turnGunLeft:45];
//        [self turnRobotRight:45];
//        [self moveAhead:100];
//        [self shoot];
//        [self turnGunLeft:45];
//    }
//    if (_currentRobotState == RobotStateFiring) {
//        
//        if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f) {
//            _currentRobotState = RobotStateSearching;
//        } else {
//            CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
//            if (angle >= 0) {
//                [self turnGunRight:abs(angle)];
//            } else {
//                [self turnGunLeft:abs(angle)];
//            }
//            [self shoot];
//        }
//    }
//    
//    if (_currentRobotState == RobotStateSearching) {
//        [self moveAhead:50];
//        [self turnRobotLeft:20];
//        [self moveAhead:50];
//        [self turnRobotRight:20];
//    }
//    
//    if (_currentRobotState == RobotStateDefault) {
//        [self moveAhead:100];
//    }
//}
//
//-(void)wallPresent{
//    
//}
////if robot is less than 100 from boundary, turn left 90 and move forward 50
//
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
//    if (![self  checkDistanceFromTop:top Bottom:bottom Left:left AndRight:right Within:50]) {
//        [self turnRobotLeft:45];
//        [self moveAhead:25];
//    }
//}
//
//-(BOOL)checkDistanceFromTop:(CGPoint)top Bottom:(CGPoint)bottom Left:(CGPoint)left AndRight:(CGPoint)right Within:(float)maxArea{
//    if ([self getDistanceFromCGPoint:top]>maxArea &&
//        [self getDistanceFromCGPoint:bottom]>maxArea &&
//        [self getDistanceFromCGPoint:left]>maxArea &&
//        [self getDistanceFromCGPoint:right]>maxArea) {
//        return true;
//    }
//    return false;
//}
//
//-(float)getDistanceFromCGPoint:(CGPoint)position{
//    float
//    firstX=self.robotBoundingBox.origin.x,
//    firstY=self.robotBoundingBox.origin.y,
//    secondX=position.x,
//    secondY=position.y,
//    distance=sqrtf((firstX-secondX)*(firstX-secondX)+(firstY-secondY)*(firstY-secondY));
////    NSLog(@"Distance is %f",distance);
//    return distance;
//}
//
//- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
////    if (_currentRobotState != RobotStateFiring) {
////        [self cancelActiveAction];
////    }
//    float distance = [self getDistanceFromCGPoint:position];
////    _lastKnownPositionTimestamp = self.currentTimestamp;
////    _currentRobotState = RobotStateFiring;
//    NSLog(@"Distance from enemy %f",distance);
//}
//
//@end
