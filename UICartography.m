//
//  UICartography.m
//  UICartography
//
//  Created by Filip Moberg on 2014-02-19.
//
//

#import "UICartography.h"
#import "proj_api.h"



// DICTIONARY OF OPTIONALLY PRE STORED PROJECTIONS
static NSMutableDictionary *Projection = nil;



@implementation UICartography {
    
    projPJ *source;
    projPJ *target;
    
    double x;
    double y;
    
    double n;
    double e;
    
    double s;
    double w;
    
    double north;
    double east;
    
    double south;
    double west;
}



// INITIALIZER
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
    }
    
    return self;
}



// SET SOURCE PROJECTION (PROJ.4 STRING OR PRE SAVED PROJECTION NAME)
- (void)setSource:(NSString *)projection {

    NSString *p = [Projection objectForKey:projection];
    
    if (p) {
        
        projection = p;
    }

    source = pj_init_plus([p UTF8String]);
}



// SET TARGET PROJECTION (PROJ.4 STRING OR PRE SAVED PROJECTION NAME)
- (void)setTarget:(NSString *)projection {
    
    NSString *p = [Projection objectForKey:projection];
    
    if (p) {
        
        projection = p;
    }
    
    target = pj_init_plus([p UTF8String]);
}



// SET MAP BOUNDARIES (IN LAT/LONG)
- (void)setBoundaries:(CBoundaries)boundaries {
    
    north = boundaries.northeast.latitude;
    east = boundaries.northeast.longitude;
    
    south = boundaries.southwest.latitude;
    west = boundaries.southwest.longitude;
}



// CONVERT LAT/LONG TO PIXELS ON A MAP
- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)coordinate {
    
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    
    x = coordinate.longitude;
    y = coordinate.latitude;
    
    
    n = north;
    e = east;
    
    
    s = south;
    w = west;

    
    // CHECK IF SOURCE EXIST
    if (!source) {
        
        return CGPointMake(0, 0);
    }
    
    
    // CHECK IF TARGET EXIST
    if (!target) {
        
        return CGPointMake(0, 0);
    }
    
    
    // CONVERT LAT/LONG DECIMALS TO RADIANS (AS NEEDED BY PROJ4)
    x *= DEG_TO_RAD;
    y *= DEG_TO_RAD;
    w *= DEG_TO_RAD;
    s *= DEG_TO_RAD;
    n *= DEG_TO_RAD;
    e *= DEG_TO_RAD;
    
    
    // TRANSFORM COORDINATE TO PIXELS
    pj_transform(source, target, 1, 1, &x, &y, NULL);
    pj_datum_transform(source, target, 1, 1, &x, &y, NULL);
    
    pj_transform(source, target, 1, 1, &w, &s, NULL);
    pj_datum_transform(source, target, 1, 1, &w, &s, NULL);
    
    pj_transform(source, target, 1, 1, &e, &n, NULL);
    pj_datum_transform(source, target, 1, 1, &e, &n, NULL);

    
    // USE SOUTH/WEST AS OFFSET
    x -= w;
    y -= s;
    
    
    // CALCULATE WIDTH/HEIGHT IN RELATION TO OFFSET (WHICH WILL GIVE US THE PIXEL POSITIONS IN RELATION TO THE MAP SIZE)
    x *= width / (e - w);
    y *= height / (n - s);
    
    
    // REVERSE Y-COORDINATE (ANCHOR IT TO TOP INSTEAD OF BOTTOM)
    y = abs(height - y);
    
    
    // RETURN CONVERTED VALUES
    return CGPointMake(round(x), round(y));
}



// STORE PROJECTIONS
+ (void)setProjection:(NSString *)projection forKey:(NSString *)key {
    
    if (!Projection) {
        
        Projection = [[NSMutableDictionary alloc] init];
    }

    [Projection setObject:projection forKey:key];
}



@end
