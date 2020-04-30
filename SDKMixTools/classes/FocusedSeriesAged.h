//
//  FocusedSeriesAged.h
//  heard
//
//  Created by afternoon on 2018/12/2.
//  Copyright 2018 afternoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BrainAdultsMale.h"
#import "ComplexKindDebut.h"
#import "FeatureEpisode.h"
#import "LecturerImmediate.h"
#import "ResearchTotal.h"


@interface FocusedSeriesAged : FeatureEpisode

@property(nonatomic,retain) BrainAdultsMale* impactsKeynote;
@property(nonatomic,retain) ComplexKindDebut* healthilyFace;


/*
* @method initFocusedSeriesAged
*/
-(void)initFocusedSeriesAged;

/*
* @method poolScientistByEvent
* @param ResearchTotal* findingMice
* @param LecturerImmediate* communityChiefly
*/
-(void)poolScientistByEvent:(ResearchTotal*)findingMice communityChiefly:(LecturerImmediate*)communityChiefly ;

/*
* @method helpingPeak
* @param UITableView* environmentSystems
*/
+(void)helpingPeak:(UITableView*)environmentSystems ;

/*
* @method willPotentialFromGrants
* @param UITableViewCell* cellsRaising
*/
-(void)willPotentialFromGrants:(UITableViewCell*)cellsRaising ;

@end