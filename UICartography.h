//
//  UICartography.h
//  UICartography
//
//  Created by Filip Moberg on 2014-02-19.
//
//



struct CBoundaries { CLLocationCoordinate2D northeast, southwest; };
typedef struct CBoundaries CBoundaries;
CG_INLINE CBoundaries


CBoundariesMake(CLLocationCoordinate2D northeast, CLLocationCoordinate2D southwest) {
    
    CBoundaries vector;
    
    vector.northeast = northeast;
    vector.southwest = southwest;
    
    return vector;
}



@interface UICartography : UIImageView


- (void)setSource:(NSString *)projection;
- (void)setTarget:(NSString *)projection;
- (void)setBoundaries:(CBoundaries)boundaries;

- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)coordinate;

+ (void)setProjection:(NSString *)projection forKey:(NSString *)key;


@end
