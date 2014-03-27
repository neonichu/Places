//
//  BBUPlace.h
//  Places
//
//  Created by Boris Bügling on 27.03.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MVPlace;

@interface BBUPlace : NSObject <MKAnnotation>

@property (nonatomic, readonly) MKCircle* circle;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, readonly) MVPlace* place;

-(id)initWithPlace:(MVPlace*)place;

@end
