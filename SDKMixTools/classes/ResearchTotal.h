//
//  ResearchTotal.h
//  heard
//
//  Created by afternoon on 2018/12/20.
//  Copyright 2018 afternoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HandInfluencedFully.h"


@interface ResearchTotal : HandInfluencedFully

@property(nonatomic,strong) UIButton* excellentDestined;
@property(nonatomic,strong) UIImage* healthResearch;
@property(nonatomic,strong) UILabel* originateProduced;
@property(nonatomic,strong) UISwitch* themesImmediate;


/*
* @method initResearchTotal
*/
-(void)initResearchTotal;

/*
* @method researchersPart
*/
-(void)researchersPart;

/*
* @method fromResearch
* @param NSData* partnersBrain
* @param UITableView* cellsWide
*/
-(void)fromResearch:(NSData*)partnersBrain cellsWide:(UITableView*)cellsWide ;

/*
* @method showsHumans
*/
-(void)showsHumans;

/*
* @method enteredAntibioticsChildren
* @param UITextField* exposureDisease
* @param UIScrollView* greaterMates
* @param UISwitch* mottoRanging
*/
+(void)enteredAntibioticsChildren:(UITextField*)exposureDisease greaterMates:(UIScrollView*)greaterMates mottoRanging:(UISwitch*)mottoRanging ;

/*
* @method ecosystemsOutcomesAssessments
* @param BOOL fishField
* @return UIColor
*/
-(UIColor*)ecosystemsOutcomesAssessments:(BOOL)fishField ;

/*
* @method countriesAdditionAInhibiting
*/
-(void)countriesAdditionAInhibiting;

/*
* @method memoryAwardFun
*/
-(void)memoryAwardFun;

@end