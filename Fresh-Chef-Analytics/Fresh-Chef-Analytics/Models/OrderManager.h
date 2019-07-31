//  OrderManager.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Dish.h"
#import "Waiter.h"
#import "OpenOrder.h"
#import "ClosedOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManager : NSObject
@property (strong, nonatomic) NSArray *allOpenOrders;
@property (strong, nonatomic) NSMutableDictionary *openOrdersByTable;
@property (strong, nonatomic) NSMutableDictionary *closedOrdersByDate;
@property (strong, nonatomic) NSMutableDictionary *profitByDate;
@property (strong, nonatomic) NSArray *closedOrders;
@property (strong, nonatomic) NSArray *ordersToDelete;
@property (strong, nonatomic) Dish * tempDish;
+ (instancetype)shared;
- (void) fetchOpenOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * openOrders, NSError * error))fetchedOpenOrders;
- (void) fetchClosedOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * closedOrders, NSError * error))fetchedClosedOrders;
- (void) deletingOrderswithTable : (NSNumber *) table forWaiter : (Waiter *) waiter withCustomerNum : (NSNumber *) customerNum withCompletion : (void (^)(NSError * error))completion;
- (void) postAllOpenOrders : (NSArray *) openOrders withCompletion : (void (^)(NSError * error))completion;
<<<<<<< HEAD
-(void)closeOpenOrdersArray:(NSArray <OpenOrder *>*)ordersToClose withDishArray:(NSArray <NSString *>*)dishNames withAmounts:(NSArray*)amounts withCompletion : (void (^)(NSError * error))completion;
=======
- (void)setProfitByDate;
>>>>>>> 2864d62130f871b4a603c8fd9d5358cf8139d580
@end

NS_ASSUME_NONNULL_END
