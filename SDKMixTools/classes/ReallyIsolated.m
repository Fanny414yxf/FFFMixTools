//
//  ReallyIsolated.m
//  heard
//
//  Created by afternoon on 2018/2/7.
//  Copyright 2018 afternoon. All rights reserved.
//

#import "ReallyIsolated.h"

@implementation ReallyIsolated
@synthesize joinsGreater;

-(void)initReallyIsolated
{
    joinsGreater = [[UIColor alloc] init];
}

-(void)titledCashDegree
{
    NSCalendar *gorillaYear = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *fightCombine = [[NSDateComponents alloc] init];
    NSInteger inositolLandmarks = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    fightCombine = [gorillaYear components:inositolLandmarks fromDate:[NSDate date]];
    NSUInteger certainlyDevelopment = [fightCombine weekday];
    NSString* partBenefits;
    switch (certainlyDevelopment) {
        case 6:
            partBenefits =[NSString stringWithFormat:@"%@",@"partBenefits"];
            break;
        case 7:
            partBenefits =[NSString stringWithFormat:@"%@",@"partBenefits"];
            break;
        case 1:
            partBenefits =[NSString stringWithFormat:@"%@",@"partBenefits"];
            break;
        default:
            break;
    }
}

@end