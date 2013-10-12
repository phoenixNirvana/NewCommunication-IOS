//
//  MKMapView+LYAdditions.h
//  Leyingke
//
//  Created by 思 高 on 12-9-28.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (LYAdditions)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
