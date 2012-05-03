//
//  HSKeyLibrary.h
//  SpyTools
//
//  Created by Chip on 4/19/12.
//  Copyright (c) 2012 __Héctor Sánchez__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSKeyLibrary : NSObject{
    NSArray *keysArray;
}
-(id)init;
-(id)initWithFileName:(NSString *)txtFileName;
-(NSArray *)stringsArrayFromFile:(NSString *)txtFileName;
-(NSArray *)keysArray;

@end
