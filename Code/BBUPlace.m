//
//  BBUPlace.m
//  Places
//
//  Created by Boris Bügling on 27.03.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <moves-ios-sdk/MovesAPI.h>

#import "BBUPlace.h"

@interface BBUPlace ()

@property (nonatomic) MVPlace* place;

@end

#pragma mark -

@implementation BBUPlace

-(MKCircle *)circle {
    return [MKCircle circleWithCenterCoordinate:self.coordinate radius:MIN(self.duration / 100.0, 300.0)];
}

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.place.location.lat, self.place.location.lon);
}

-(NSString *)description {
    return [NSString stringWithFormat:@"BBUPlace: %@ for %f seconds", self.place.name, self.duration];
}

-(id)initWithPlace:(MVPlace*)place {
    self = [super init];
    if (self) {
        self.duration = 0.0f;
        self.place = place;
    }
    return self;
}

-(NSString *)subtitle {
    return [NSString stringWithFormat:@"%.1f hours", self.duration / 60.0 / 60.0];
}

-(NSString *)title {
    return self.place.name;
}

@end
