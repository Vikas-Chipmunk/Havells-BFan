//
//  PlacesViewController.m
//  CSRmeshDemo
//
//  Created by SudheerPalchuri on 06/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "PlacesViewController.h"
#import "CSRMenuSlidingSegue.h"
#import "Places.h"
#import "AppDelegate.h"
#import "CSRDatabaseManager.h"
#import "DevicesViewController.h"
#import "ViewController.h"
#import "CSRmeshStyleKit.h"
#import "CSRMenuSlidingSegue.h"
#import "CSRDevicesManager.h"
#import "CSRmeshDevice.h"
#import "HomePresetCollectionViewCell.h"
#import <CSRmesh/LightModelApi.h>

@interface PlacesViewController ()
{
    AppDelegate *appDelegate;
    CSRDatabaseManager *dataBaseMng;
    NSInteger intSelectedPlace;
    NSMutableArray *homePresets;
}
@property(nonatomic,strong)NSMutableArray *arrPlaces;
@property (weak, nonatomic) IBOutlet UITableView *tblViewPlaces;
- (IBAction)btnAddPlace:(id)sender;
- (IBAction)btnDummyRoom:(id)sender;
@end

@implementation PlacesViewController
@synthesize arrPlaces;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showNavMenuButton = YES;
    arrPlaces = [[NSMutableArray alloc]init];
    
    self.tblViewPlaces.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    
    
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"isLoggedin"] boolValue])
    {
//        NSArray *arrPlacesDummy = [NSArray arrayWithObjects:@"Kitchen",@"Bathroom",@"Bedroom",@"Living Room", nil];
//        for (int i=0; i<4;i++) {
//            
//            [self savePlaceWithName:[arrPlacesDummy objectAtIndex:i]];
//        }
//        
//        dataBaseMng = [CSRDatabaseManager sharedInstance];
//        [self refreshPlaces];

        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(insertDummyAreas) userInfo:nil repeats:NO];
        
        NSArray *xibContents = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil];
        UIView *feebackView = [xibContents lastObject];
        feebackView.translatesAutoresizingMaskIntoConstraints = NO;
        feebackView.tag = 143225;
        [appDelegate.window addSubview:feebackView];
        
        NSDictionary *viewsDict = [NSDictionary dictionaryWithObjectsAndKeys:feebackView,@"viewFeedback", nil];
        
        NSArray *widhtConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewFeedback]|" options:0 metrics:nil views:viewsDict];
        NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewFeedback]|" options:0 metrics:nil views:viewsDict];
        
        [appDelegate.window addConstraints:widhtConstraints];
        [appDelegate.window addConstraints:heightConstraints];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        UINavigationController *vc = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginNav"];
        vc.view.tag = 112233;
        [self.navigationController presentViewController:vc animated:NO completion:nil];
        //[appDelegate.window addSubview:vc.view];
        
        //        NSDictionary *viewsDict = [NSDictionary dictionaryWithObjectsAndKeys:vc.view,@"viewFeedback", nil];
        //
        //        NSArray *widhtConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewFeedback(600)]|" options:0 metrics:nil views:viewsDict];
        //        NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewFeedback(600)]|" options:0 metrics:nil views:viewsDict];
        //
        //        [appDelegate.window addConstraints:widhtConstraints];
        //        [appDelegate.window addConstraints:heightConstraints];
        
        
    }

    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc]initWithTitle:@"Add New Device" style:UIBarButtonItemStylePlain target:self action:@selector(btnDetectDevice)];
    self.navigationItem.rightBarButtonItem = barBtnSearch;
    
    dataBaseMng = [CSRDatabaseManager sharedInstance];
    [self refreshPlaces];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    //home presets
    
    homePresets=[NSMutableArray arrayWithObjects:@"icn_warm",@"icn_cool",@"icn_powersaver",@"icn_party", nil];
    
    [self.collectionViewHomePresets registerNib:[UINib nibWithNibName:@"HomePresetCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"homePresetCell"];
    
    
    [self.collectionViewHomePresets setDataSource:self];
    [self.collectionViewHomePresets setDelegate:self];
}

-(void)btnDetectDevice
{
    [[MeshServiceApi sharedInstance] setContinuousLeScanEnabled:YES];
    [[CSRDevicesManager sharedInstance] setDeviceDiscoveryFilter:self mode:YES];
    [self performSegueWithIdentifier:@"PlacesToDetectDevice" sender:nil];
}

-(void)insertDummyAreas
{
    NSArray *arrPlacesDummy = [NSArray arrayWithObjects:@"Kitchen",@"Bathroom",@"Bedroom",@"Living Room", nil];
    for (int i=0; i<4;i++) {
        
        [self savePlaceWithName:[arrPlacesDummy objectAtIndex:i]];
    }
    
    dataBaseMng = [CSRDatabaseManager sharedInstance];
    [self refreshPlaces];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];

    dataBaseMng = [CSRDatabaseManager sharedInstance];
    [self refreshPlaces];
    self.title = @"HOME";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if([arrPlaces count]>4)
//    {
//        return @"Other Places";
//    }
//    else
//        return @"";
//}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([arrPlaces count]>0)
    {
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 40)];

        UILabel *lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 768, 40)];
        lblHeader.text = @"PLACES";
        lblHeader.textAlignment = NSTextAlignmentCenter;
        lblHeader.textColor = [UIColor whiteColor];
        lblHeader.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
        [viewHeader addSubview:lblHeader];
        
        return viewHeader;
    }
    else
    {
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 40)];
        return viewHeader;
    }
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrPlaces count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    int index = indexPath.row;
    Places *obj = [arrPlaces objectAtIndex:index];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(index==0)
        cell.imageView.image = [UIImage imageNamed:@"ic_kitchenette-512.png"];
    else if (index==1)
        cell.imageView.image = [UIImage imageNamed:@"icon_bath.png"];
    else if (index==2)
        cell.imageView.image = [UIImage imageNamed:@"Bed-1.png"];
    else if (index==3)
        cell.imageView.image = [UIImage imageNamed:@"living_room-512.png"];
    else
        cell.imageView.image = [UIImage imageNamed:@"homeicon.png"];
    cell.textLabel.text = obj.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    intSelectedPlace =  indexPath.row;
    [self performSegueWithIdentifier:@"placesListToDevices" sender:nil];
}

- (IBAction)btnAddPlace:(id)sender
{
    NSString *strMsg = [NSString stringWithFormat:@"Add a new place."];
    if ([UIAlertController class])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:strMsg];
        [title addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:14]
                      range:NSMakeRange(0, [strMsg length])];
        [alertController setValue:title forKey:@"attributedTitle"];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *K2TextField)
         {
             K2TextField.placeholder = @"Place";
             K2TextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
         }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancel];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSString *text = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            if([text length])
            {
                [self savePlaceWithName:text];
            }
            else
                [self.view makeToast:@"Place should not be empty" duration:3 position:CSToastPositionTop title:nil];
            
        }];
        [alertController addAction:ok];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag=1122;
        [alert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textfield =  [alert textFieldAtIndex:0];
        textfield.placeholder = @"Email id or mobile number";
        [alert show];
        
    }
    
    
}

- (IBAction)btnDummyRoom:(UIButton*)sender
{
    intSelectedPlace =  sender.tag;
    [self performSegueWithIdentifier:@"placesListToDevices" sender:nil];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1122&&buttonIndex==1)
    {
        UITextField *textfield =  [alertView textFieldAtIndex:0];
        if([textfield.text length])
        {
            [self savePlaceWithName:textfield.text];
        }
        else
        {
            [self.view makeToast:@"Place should not be empty" duration:3 position:CSToastPositionTop title:nil];
        }
        
    }
}

-(void)savePlaceWithName:(NSString*)strName
{
    
    Places *placeObj = [NSEntityDescription insertNewObjectForEntityForName:@"Places" inManagedObjectContext:dataBaseMng.managedObjectContext];
    placeObj.name = strName;

    NSError *error = nil;
    [dataBaseMng.managedObjectContext save:&error];
    
    if(error!=nil)
    {
        NSLog(@"Error is %@",[error description]);
    }
    
    [self refreshPlaces];
}

-(void)refreshPlaces
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Places"];
    
    [arrPlaces removeAllObjects];
    [arrPlaces addObjectsFromArray:[dataBaseMng.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    [self.tblViewPlaces reloadData];
    
    for (int i=0 ; i<[arrPlaces count]; i++) {
        
        if(i>3)
        {
            Places *obj = [arrPlaces objectAtIndex:i];

            UIView *viewOthers = (UIView*)[self.view viewWithTag:(i+1)*100];
            viewOthers.hidden = NO;
            
            UILabel *lblPlaceName = (UILabel*)[self.view viewWithTag:i*11];
            lblPlaceName.text = obj.name;
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue isKindOfClass:[CSRMenuSlidingSegue class]]) {
        [super showCoverView];
    }
    else if ([segue.identifier isEqualToString:@"placesListToDevices"])
    {
        DevicesViewController *obj = [segue destinationViewController];
        obj.placeSelected = [arrPlaces objectAtIndex:intSelectedPlace];
    }
}



#pragma mark-uicollectionview delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:      (NSInteger)section
{
    return homePresets.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(165.0, 55.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePresetCollectionViewCell *cell = (HomePresetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"homePresetCell" forIndexPath:indexPath];
    
    
    [[cell imgViewPreset] setImage:[UIImage imageNamed:[homePresets objectAtIndex:indexPath.row]]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        //call warm preset
        
        [self setWarmPreset];
        
    }
    else if (indexPath.row==1){
        //call cool preset
        
        [self setCoolPresets];
        
    }
    else if (indexPath.row==2){
        //call powersaver preset
        
        [self setPowerSaverPresets];
        
    }
    else if (indexPath.row==3){
        //call party preset
        
        [self setPartyPresets];
    }
    
}

#pragma mark- home preset functions

-(void)setWarmPreset{
    [[LightModelApi sharedInstance] setRgb:0 red:[NSNumber numberWithFloat:0] green:[NSNumber numberWithFloat:0] blue:[NSNumber numberWithFloat:0] level:[NSNumber numberWithFloat:0] duration:0 acknowledged:0];
}

-(void)setCoolPresets{
    [[LightModelApi sharedInstance] setRgb:0 red:[NSNumber numberWithFloat:255] green:[NSNumber numberWithFloat:255] blue:[NSNumber numberWithFloat:255] level:[NSNumber numberWithFloat:255] duration:0 acknowledged:0];
}

-(void)setPowerSaverPresets{
    [[LightModelApi sharedInstance] setLevel:0 level:[NSNumber numberWithFloat:127] acknowledged:NO];
}

-(void)setPartyPresets{
    UIColor *pixel = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    CGFloat red, green, blue, alpha;
    if ([pixel getRed:&red green:&green blue:&blue alpha:&alpha]) {
        
            [[[CSRDevicesManager sharedInstance] selectedDevice] setColorWithRed:red green:green blue:blue];
    }
}
@end
