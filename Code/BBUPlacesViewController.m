//
//  BBUPlacesViewController.m
//  Places
//
//  Created by Boris Bügling on 27.03.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <moves-ios-sdk/MovesAPI.h>

#import "BBUPlace.h"
#import "BBUPlacesViewController.h"

@interface BBUPlacesViewController () <MKMapViewDelegate>

@property (nonatomic) MKMapView* mapView;

@end

#pragma mark -

@implementation BBUPlacesViewController

-(void)adjustMapRectToOverlays {
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id<MKOverlay> overlay in self.mapView.overlays) {
        MKMapPoint overlayPoint = MKMapPointForCoordinate(overlay.coordinate);
        MKMapRect pointRect = MKMapRectMake(overlayPoint.x, overlayPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

-(id)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Places", nil);
    }
    return self;
}

-(void)refresh {
    [[MovesAPI sharedInstance] getDailyPlacesByPastDays:7 success:^(NSArray *dailyPlaces) {
        NSMutableDictionary* places = [@{} mutableCopy];
        
        for (MVDailyPlace* place in dailyPlaces) {
            for (MVSegment* segment in place.segments) {
                if (segment.type != MVSegmentTypePlace) {
                    continue;
                }
                
                BBUPlace* currentPlace = places[segment.place.placeId];
                if (!currentPlace) {
                    currentPlace = [[BBUPlace alloc] initWithPlace:segment.place];
                    places[segment.place.placeId] = currentPlace;
                }
                
                currentPlace.duration += [segment.endTime timeIntervalSinceDate:segment.startTime];
            }
        }
        
        for (BBUPlace* place in places.allValues) {
            [self.mapView addAnnotation:place];
            [self.mapView addOverlay:place.circle];
        }
        
        NSArray* placesByDuration = [places.allValues sortedArrayUsingComparator:^NSComparisonResult(BBUPlace* place1,
                                                                                                     BBUPlace* place2) {
            return [@(place1.duration) compare:@(place2.duration)];
        }];
        
        [self.mapView setCenterCoordinate:[[placesByDuration firstObject] coordinate] animated:YES];
        [self adjustMapRectToOverlays];
    } failure:^(NSError *error) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

#pragma mark -

-(MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

@end
