//
//  ReceiptViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ReceiptTableViewCell.h"
#import "Parse/Parse.h"
#import "MenuManager.h"
#import "OrderManager.h"
#import "BEMCheckbox.h"

@interface ReceiptViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *topIm;
@property (strong, nonatomic) IBOutlet UILabel *receiptLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundIm;
@property (strong, nonatomic) IBOutlet BEMCheckBox *checkBox;

@property (weak, nonatomic) IBOutlet UITableView *receiptTable;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *allLabels;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (assign, nonatomic) float priceTracker;
@property (weak, nonatomic) IBOutlet UITextField *tip;
@property (weak, nonatomic) IBOutlet UILabel *finalPrice;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) NSMutableArray<NSString *>* mutableDishes;
@property (strong, nonatomic) NSMutableArray* mutableAmounts;



@end

@implementation ReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *category = [PFUser currentUser][@"theme"];
    NSString *category_top = [NSString stringWithFormat:@"%@_top", category];
    [self.backgroundIm setImage:[UIImage imageNamed:category]];
    [self.topIm setImage:[UIImage imageNamed:category_top]];
    if ([category isEqualToString:@"Elegant"]){
        self.receiptLabel.textColor = [UIColor blackColor];
    } else {
        self.receiptLabel.textColor = [UIColor whiteColor];
    }
    UIColor *desired = [UIColor whiteColor];
    if ([category isEqualToString:@"Comfortable"]){
        self.checkBox.onTintColor = [UIColor whiteColor];
        self.checkBox.onCheckColor = [UIColor whiteColor];
        self.checkBox.tintColor = [UIColor whiteColor];
        
    } else {
       
        desired = [UIColor blackColor];
        self.checkBox.onTintColor = [UIColor blackColor];
        self.checkBox.onCheckColor = [UIColor blackColor];
        self.checkBox.tintColor = [UIColor blackColor];
    }
    for (UILabel *aLabel in self.allLabels) {
        // Set all label in the outlet collection to have center aligned text.
        aLabel.textColor = desired;
    }
    self.mutableAmounts = [[NSMutableArray alloc] init];
    self.mutableDishes = [[NSMutableArray alloc] init];
    self.receiptTable.dataSource = self;
    self.receiptTable.delegate = self;
    PFUser *currentUser = [PFUser currentUser];
    self.restaurantName.text = currentUser.username;
    self.restaurantAddress.text = currentUser[@"address"];
    self.date.text = self.waiter[@"updatedAt"];
    
    //NSString *test = @"XuLMO3Jh3r";
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *category = [PFUser currentUser][@"theme"];
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"receiptCell"];
    Dish *dish = self.dishesArray[indexPath.row];
    NSNumber *amount = self.openOrders[indexPath.row].amount;
    cell.dishName.text = dish.name;
    cell.dishAmount.text = [NSString stringWithFormat:@"%.0@", amount];
    cell.calculatedPrice.text = [NSString stringWithFormat:@"%.2f", ([dish.price floatValue] * [amount floatValue])];
    if ([category isEqualToString:@"Comfortable"]){
        cell.dishName.textColor = [UIColor whiteColor];
        cell.dishAmount.textColor = [UIColor whiteColor];
        cell.calculatedPrice.textColor = [UIColor whiteColor];
    }
        
    self.priceTracker += [cell.calculatedPrice.text floatValue];
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f", self.priceTracker];
    return cell;
}
- (IBAction)editingChange:(id)sender {
    self.finalPrice.text = [NSString stringWithFormat:@"%.2f", ([self.tip.text floatValue] + self.priceTracker)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didSubmit:(id)sender {
    float pastTotalTips = [self.waiter.tipsMade floatValue];
    self.waiter.tipsMade = [NSNumber numberWithFloat: ([self.tip.text floatValue] + pastTotalTips)];
    [self fillCellArrays:self.openOrders];
    NSArray *dishNameStrings = [self.mutableDishes copy];
    NSArray *amounts = [self.mutableAmounts copy];
    [[OrderManager shared] closeOpenOrdersArray:self.openOrders withDishArray:dishNameStrings withAmounts:amounts withCompletion:^(NSError * _Nonnull error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            [self performSegueWithIdentifier:@"toThankYou" sender:self];
        }
            
    }];
    
}

-(void)fillCellArrays:(NSArray<OpenOrder *>*)openOrders {
    NSArray<Dish*>*dishArray = [[NSArray alloc] init];
    dishArray = [[MenuManager shared] dishes];
    NSLog(@"%@", dishArray);
    for (int i = 0; i < openOrders.count; i++){
        for (int j = 0; j < dishArray.count; j++)
        {
            NSLog(@"%@", openOrders[i]);
            NSLog(@"%@", ((Dish*)openOrders[i].dish).objectId);
            if ([((Dish *)dishArray[j]).objectId isEqualToString:((Dish*)openOrders[i].dish).objectId]){
                 [self.mutableDishes addObject:((Dish *)dishArray[j]).name];
                 [self.mutableAmounts addObject:openOrders[i].amount];
            }
        }
    }
}

@end
