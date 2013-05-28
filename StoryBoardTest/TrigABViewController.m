//
//  TrigABViewController.m
//  StoryBoardTest
//
//  Created by James Brady on 27/05/2013.
//  Copyright (c) 2013 James Brady. All rights reserved.
//

#import "TrigABViewController.h"

@interface TrigABViewController ()

@end

@implementation TrigABViewController

- (void)viewWillAppear:(BOOL)animated {
	if ([self.view restorationIdentifier] == nil) {
		NSLog(@"Can't run A/B test for %@: no restoration ID", self);
		return;
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	id abParams = [defaults valueForKey:[@"views:" stringByAppendingString:[self.view restorationIdentifier]]];
	
	if (abParams == nil) {
		NSLog(@"No A/B parameters found for %@", [@"views:" stringByAppendingString:[self.view restorationIdentifier]]);
	} else {
		[abParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			if ([@"views" isEqualToString:key]) {
				[self.view.subviews enumerateObjectsUsingBlock:^(id subview, NSUInteger idx, BOOL *stop) {
					id subViewParams = [obj valueForKey:[subview restorationIdentifier]];
					if (subViewParams != nil) {
						[subViewParams enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
							[subview setValue:value forKey:key];
						}];
					}
				}];
			} else {
				[self setValue:obj forKey:key];
			}
		}];
	}
}

@end
