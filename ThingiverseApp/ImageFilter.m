//
//  ImageFilter.m
//  ThingiverseApp
//
//  Created by Danny on 6/14/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "ImageFilter.h"

@implementation ImageFilter

-(UIImage *) filterImage:(UIImage*)image{
    //Filter
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *resultImage = [filter valueForKey:kCIOutputImageKey];
    
    //CIgaussianBlur
    CGImageRef finalImage = [context createCGImage:resultImage fromRect:[inputImage extent]];
    return image = [UIImage imageWithCGImage:finalImage];
}

@end
