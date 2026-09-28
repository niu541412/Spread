//
//  Spread.h
//  Spread
//
//  Created by Kevin Wojniak on 3/12/10.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface Spread : NSObject
{
	CGSize boundsSize;
	NSMutableArray *branches;
	NSUInteger frameNum;
	CGLayerRef layer;
	CGFloat directionOffset;
	NSInteger newBranchFrames;
	CGColorSpaceRef colorSpace;
	uint64_t randomState;
}

- (id)initWithSize:(CGSize)size;
- (id)initWithSize:(CGSize)size seed:(uint64_t)seed;
- (void)drawInContext:(CGContextRef)ctx;
- (void)animateOneFrame;

@end
