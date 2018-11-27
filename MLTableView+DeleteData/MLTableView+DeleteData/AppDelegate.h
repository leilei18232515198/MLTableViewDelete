//
//  AppDelegate.h
//  MLTableView+DeleteData
//
//  Created by 268Edu on 2018/11/21.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

