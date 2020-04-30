//
//  RetreLeadPossibleEverything.m
//  heard
//
//  Created by afternoon on 2018/6/18.
//  Copyright 2018 afternoon. All rights reserved.
//

#import "RetreLeadPossibleEverything.h"

@implementation RetreLeadPossibleEverything
@synthesize joinedNight;

@synthesize scientistsPotential;

@synthesize worldPlan;

@synthesize significantWork;

-(void)initRetreLeadPossibleEverything
{
    joinedNight = [[NSObject alloc] init];
    scientistsPotential = [[NSDictionary alloc] init];
    worldPlan = [[UIImageView alloc] init];
    significantWork = [[UIEvent alloc] init];
}

+(void)treatingPopular:(NSArray*)signingSystem eggsAnimal:(NSArray*)eggsAnimal 
{
   [signingSystem count];
    // 加载plist文件
    NSURL *studyingEnvironmentURL = [[NSBundle mainBundle]URLForResource:@"studyingEnvironment.plist" withExtension:@"plist"];
    // 读取plist的数据，并保存在数组中
    NSArray *childrenImageArray = [NSArray arrayWithContentsOfURL:studyingEnvironmentURL];
    NSMutableArray *panelLipid = [NSMutableArray arrayWithCapacity:childrenImageArray.count];
    for (NSDictionary *dict in childrenImageArray)
    {
        [panelLipid addObject:[dict objectForKey:@"key"]];
    }
}

@end