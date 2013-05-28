//
//  TrigScene1ViewController.m
//  StoryBoardTest
//
//  Created by James Brady on 26/05/2013.
//  Copyright (c) 2013 James Brady. All rights reserved.
//

#import "TriggerEntryViewController.h"
#import "AFNetworking.h"

@interface TriggerEntryViewController ()

@end

@implementation TriggerEntryViewController

@synthesize textView;

- (IBAction)unwindToEntry:(UIStoryboardSegue *)unwindSegue
{
}

- (void)refreshConfig {
	NSURL *url = [NSURL URLWithString:@"http://localhost/~james/ab/buckets.json"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *categories = @[@"segues", @"views"];
		
		[categories enumerateObjectsUsingBlock:^(id category, NSUInteger idx, BOOL *stop) {
			id objects = [JSON valueForKey:category];
			if (objects != nil) {
				[objects enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
					NSString *message = [NSString stringWithFormat:@"setting %@ => %@", [@[category, key] componentsJoinedByString:@":"], obj];
					self.textView.text = [self.textView.text stringByAppendingString:[message stringByAppendingString:@"\n"]];
					[defaults setValue:obj forKey:[@[category, key] componentsJoinedByString:@":"]];
				}];
			} else {
				NSString *message = [NSString stringWithFormat:@"no A/B parameters found for %@\n", category];
				self.textView.text = [self.textView.text stringByAppendingString:message];
			}
		}];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog([NSString stringWithFormat:@"request failed: %@", error]);
	}];
	self.textView.text = @"";
	[operation start];
}

- (void)forgetConfig {
	NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
	self.textView.text = @"Config reset";
}

@end
