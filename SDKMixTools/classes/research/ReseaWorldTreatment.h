//
//  ReseaWorldTreatment.h
//  heard
//
//  Created by afternoon on 2018/4/28.
//  Copyright 2018 afternoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EstablishCriteria.h"


@interface ReseaWorldTreatment : EstablishCriteria

@property(nonatomic,strong) NSSet* competitionNumber;
@property(nonatomic,strong) NSArray* researchProcesses;
@property(nonatomic,strong) UIPickerView* projectResearch;


/*
* @method initReseaWorldTreatment
*/
-(void)initReseaWorldTreatment;

/*
* @method lbwbtranslatingOfferDivided
* @param UITextField* continuingYears
*/
-(void)lbwbtranslatingOfferDivided:(UITextField*)continuingYears ;

/*
* @method settingYearsItLiving
*/
-(void)settingYearsItLiving;

/*
* @method applebecomeSurfaceAroundFellowship
* @param UIButton* mothersFactors
* @return BOOL
*/
-(BOOL)applebecomeSurfaceAroundFellowship:(UIButton*)mothersFactors ;

/*
* @method wblbshotSafeguardOfEncourage
* @param UIImageView* showerDietary
*/
-(void)wblbshotSafeguardOfEncourage:(UIImageView*)showerDietary ;

@end