//
//  TrigABSegue.m
//  StoryBoardTest
//
//  Created by James Brady on 26/05/2013.
//  Copyright (c) 2013 James Brady. All rights reserved.
//

#include <stdlib.h>
#import "TrigABSegue.h"

@implementation TrigABSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
	if (identifier == nil) {
		NSLog(@"Can't run A/B test: segue doesn't have an identifier");
		return nil;
	}
    UIStoryboard *storyBoard = [destination storyboard];	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* destinationID = [defaults stringForKey:[@"segues:" stringByAppendingString:identifier]];
	if (destinationID == nil) {
		NSLog(@"Can't run A/B test: don't know action to take for segues:%@", identifier);
		return nil;
	}
	
	UIViewController *newDestination = nil;
	newDestination = [storyBoard instantiateViewControllerWithIdentifier:destinationID];
    return [super initWithIdentifier:identifier source:source destination:newDestination];
}

- (void)perform {
	[self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
}

@end
