//
//  BaseTestCase.h
//  Amplitude
//
//  Created by Allan on 3/11/15.
//  Copyright (c) 2015 Amplitude. All rights reserved.
//

#import <XCTest/XCTest.h>

extern NSString *const apiKey;
extern NSString *const userId;

@interface BaseTestCase : XCTestCase

@property (nonatomic, retain) Amplitude *amplitude;

- (BOOL) archive:(id)rootObject toFile:(NSString *)path;
- (id) unarchive:(NSString *)path;

@end
