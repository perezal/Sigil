#import <CoreGraphics/CGGeometry.h>


static inline CGVector VectorMultiply (CGVector vector, CGFloat m)
{
    return CGVectorMake(vector.dx * m, vector.dy * m);
}

//static inline CGVector VectorMultiply (CGVector vector, CGFloat m);

static inline CGVector VectorSubtract (CGPoint p1, CGPoint p2)
{
    return CGVectorMake(p1.x - p2.x, p1.y - p2.y);
}

static inline CGFloat VectorLength (CGVector vector)
{
    return sqrtf(vector.dx * vector.dx + vector.dy * vector.dy);
}

static inline CGVector VectorUnit (CGVector vector)
{
    CGFloat length = VectorLength (vector);
    return CGVectorMake (vector.dx / length, vector.dy / length);
}