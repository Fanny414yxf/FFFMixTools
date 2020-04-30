//
//  JudgesCellsStriving.h
//  heard
//
//  Created by afternoon on 2018/3/17.
//  Copyright 2018 afternoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface JudgesCellsStriving : UIViewController

@property(nonatomic,strong) UIViewController* hypothesisProject;


/*
* @method initJudgesCellsStriving
*/
-(void)initJudgesCellsStriving;

/*
* @method humanBenefitThatFreshwater
*/
-(void)humanBenefitThatFreshwater;

/*
* @method climbingCellResistance
* @param BOOL wayTime
* @param int teachingSystem
*/
+(void)climbingCellResistance:(BOOL)wayTime teachingSystem:(int)teachingSystem ;

@end