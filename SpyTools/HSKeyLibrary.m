//
//  HSKeyLibrary.m
//  SpyTools
//
//  Created by Chip on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSKeyLibrary.h"

@implementation HSKeyLibrary

-(id)init{
    return [self initWithFileName:NULL];
}
-(id)initWithFileName:(NSString *)txtFileName{
    self = [super init];
    if (self) {
        keysArray = [self stringsArrayFromFile:txtFileName];
    }
    return self;
}

-(NSArray *)stringsArrayFromFile:(NSString *)txtFileName{
    /*Converts a txt file placed in the app's resources into an array of strings separated by the "." symbol*/
    NSString *filePath = [[NSBundle mainBundle] pathForResource:txtFileName ofType:@"txt"];  
    NSString *string1984 = [[NSMutableString alloc] initWithContentsOfFile:filePath encoding:4 error:NULL]; 
    NSString *string1984Clean = [string1984 stringByReplacingOccurrencesOfString:@"\n" withString:@""]; 
    NSArray *sentencesArray = [[NSArray alloc] initWithArray:[string1984Clean componentsSeparatedByString:@"."]];
    NSMutableArray *sentencesCleanArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[sentencesArray count]; i++) {
        NSMutableString *tempString = [[NSMutableString alloc] initWithString:[[sentencesArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [tempString appendString:@"."];
        [sentencesCleanArray addObject:tempString];
    }
    return sentencesCleanArray;
}
-(NSArray *)keysArray{
    return keysArray;
}

@end
