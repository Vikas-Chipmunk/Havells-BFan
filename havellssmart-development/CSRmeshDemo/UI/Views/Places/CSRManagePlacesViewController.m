//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//

#import "CSRManagePlacesViewController.h"
#import "CSRPlacesSearchTableViewController.h"
#import "CSRPlaceDetailsViewController.h"
#import "CSRPlaceTableViewCell.h"
#import "CSRUtilities.h"
#import "CSRConstants.h"
#import "CSRmeshStyleKit.h"
#import "CSRMenuSlidingSegue.h"
#import "CSRDatabaseManager.h"
#import "CSRAppStateManager.h"
#import "NSManagedObject+DeleteEntities.h"
#import "CSRParseAndLoad.h"
#import "AppDelegate.h"

@interface CSRManagePlacesViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate, UISearchResultsUpdating, UIToolbarDelegate>
{
    
    NSUInteger selectedIndex;
    NSMutableArray *myPlacesArray;
    NSMutableArray *sharedPlacesArray;
    
}

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) CSRPlacesSearchTableViewController *placesSearchListTableViewController;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation CSRManagePlacesViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Manage Places";
    
    //Set navigation bar colour
    self.navigationController.navigationBar.barTintColor = [CSRUtilities colorFromHex:kColorBlueCSR];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = nil;
    
    //Add table delegates
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _placesArray = [NSMutableArray new];
    
    //Search controller details
    _placesSearchListTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CSRPlacesSearchTableViewController"];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_placesSearchListTableViewController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchBar.placeholder = @"Search for places";
    self.searchBar.isAccessibilityElement = YES;
    self.searchBar.accessibilityLabel = @"Places Search bar";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    //State control
    self.definesPresentationContext = YES;
    
    //need it for distinction between an import and normal place creation.
    _importedURL = ((AppDelegate*)[UIApplication sharedApplication].delegate).passingURL;
    
}

- (void)applicationBecameActive:(NSNotification*)notification
{
    [self showViewController:self sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Reload table data just in case anything changed
    [self refreshPlaces];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
    
    //Hide search bar
    [self hideSearchBarWithAnimation:YES];
}

-(void)relaodTable
{
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    //Reload table data just in case anything changed
}

- (void)dealloc
{
    self.view = nil;
}

- (void)refreshPlaces
{
    [_placesArray removeAllObjects];
    [myPlacesArray removeAllObjects];
    [sharedPlacesArray removeAllObjects];
    
    _placesArray = [[[[CSRDatabaseManager sharedInstance] fetchObjectsWithEntityName:@"CSRPlaceEntity" withPredicate:nil] allObjects] mutableCopy];
    
    
    //Sort devices alphabetically
    if (_placesArray != nil || [_placesArray count] != 0) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [_placesArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_placesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.isAccessibilityElement = YES;
    
    CSRPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CSRPlaceTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[CSRPlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSRPlaceTableViewCellIdentifier];
    }
    
    cell.isAccessibilityElement = YES;
    if (_placesArray && [_placesArray count] > 0) {
        
        CSRPlaceEntity *placeEntity = [_placesArray objectAtIndex:indexPath.row];
        
        if (placeEntity) {
            
            if (placeEntity.iconID) {
                
                NSArray *placeIcons = kPlaceIcons;
                
                [placeIcons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    NSDictionary *placeDictionary = (NSDictionary *)obj;
                    
                    if ([placeDictionary[@"id"] integerValue] > -1 && [placeDictionary[@"id"] integerValue] == [placeEntity.iconID integerValue]) {
                        
                        SEL imageSelector = NSSelectorFromString(placeDictionary[@"iconImage"]);
                        
                        if ([CSRmeshStyleKit respondsToSelector:imageSelector]) {
                            
                            cell.placeIcon.image = [CSRmeshStyleKit performSelector:imageSelector];
                            
                        }
                        
                        *stop = YES;
                    }
                }];
                
            }
            
            cell.placeIcon.image = [cell.placeIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.placeIcon.tintColor = [UIColor whiteColor];
            
            cell.placeIcon.backgroundColor = [CSRUtilities colorFromRGB:[placeEntity.color integerValue]];
            cell.placeIcon.layer.cornerRadius = 5;
            cell.placeIcon.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            cell.placeIcon.layer.borderWidth = .5;
            
            cell.placeNameLabel.text = placeEntity.name;
            cell.placeOwnerNameLabel.text = placeEntity.owner;
            
            //Added for automation
            cell.placeNameLabel.isAccessibilityElement = YES;
            cell.placeNameLabel.accessibilityTraits = UIAccessibilityTraitStaticText;
            
            cell.placeOwnerNameLabel.isAccessibilityElement = YES;
            cell.placeNameLabel.accessibilityTraits = UIAccessibilityTraitStaticText;
            
            if ([CSRAppStateManager sharedInstance].selectedPlace && [[placeEntity objectID] isEqual:[[CSRAppStateManager sharedInstance].selectedPlace objectID]]) {
                
                cell.currentPlaceIndicator.hidden = NO;
                cell.currentPlaceIndicator.image = [CSRmeshStyleKit imageOfThick_circle];
                
            }
            
        }
        
    }
    
    //Create accessory view for each cell
    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 30., 30.)];
    [accessoryButton setBackgroundImage:[CSRmeshStyleKit imageOfGear] forState:UIControlStateNormal];
    [accessoryButton addTarget:self action:(@selector(accessoryButtonTapped:)) forControlEvents:UIControlEventTouchUpInside];
    accessoryButton.tag = indexPath.row;
    
    accessoryButton.accessibilityLabel = [NSString stringWithFormat:@"%@ - configuration gear", cell.placeNameLabel.text];
    
    //Added for automation
    accessoryButton.isAccessibilityElement = YES;
    accessoryButton.accessibilityTraits = UIAccessibilityTraitButton;
    accessoryButton.accessibilityLabel = cell.placeNameLabel.text;
    
    cell.accessoryView = accessoryButton;
    
    return cell;
}

//TODO: define action when table cell was touched
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([CSRAppStateManager sharedInstance].isImportMode == YES) {
        CSRPlaceEntity *placeEntity = [_placesArray objectAtIndex:indexPath.row];
        [[CSRAppStateManager sharedInstance] setSelectedPlace:placeEntity];

        [self importDatabaseFromOpenURL];
    } else {
        
    }
}

- (void) importDatabaseFromOpenURL
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Place"
                                                    message:@"Your current place devices and areas will be updated."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else {
        [[CSRAppStateManager sharedInstance].selectedPlace setAreas:nil];
        [[CSRAppStateManager sharedInstance].selectedPlace setDevices:nil];
        
        [NSManagedObject deleteAllObjects:@"CSRDeviceEntity"];
        [NSManagedObject deleteAllObjects:@"CSRAreaEntity"];
        
        NSData *jsonDataImported = [NSData dataWithContentsOfURL:_importedURL];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonDataImported options:NSJSONReadingMutableLeaves error:&error];
        CSRParseAndLoad *parseLoad = [[CSRParseAndLoad alloc] init];
        
        NSArray *groupsArray = jsonDictionary[@"areas_list"];
        [parseLoad parseAndLoadGroups:groupsArray];
        
        NSArray *devicesArray = jsonDictionary[@"devices_list"];
        [parseLoad parseAndLoadDevices:devicesArray];

        [[CSRAppStateManager sharedInstance] setIsImportMode:NO];
        [self dismissViewControllerAnimated:NO completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPlaces" object:self userInfo:nil];

    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hideSearchBarWithAnimation:YES];
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = _placesArray;
    
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // name field matching
        NSExpression *seachFieldName = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *searchStringName = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *nameSearchPredicate = [NSComparisonPredicate
                                            predicateWithLeftExpression:seachFieldName
                                            rightExpression:searchStringName
                                            modifier:NSDirectPredicateModifier
                                            type:NSContainsPredicateOperatorType
                                            options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:nameSearchPredicate];
        
        NSExpression *seachFieldType = [NSExpression expressionForKeyPath:@"type"];
        NSExpression *searchStringType = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *typeSearchPredicate = [NSComparisonPredicate
                                            predicateWithLeftExpression:seachFieldType
                                            rightExpression:searchStringType
                                            modifier:NSDirectPredicateModifier
                                            type:NSContainsPredicateOperatorType
                                            options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:typeSearchPredicate];
        
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    
    CSRPlacesSearchTableViewController *tableController = (CSRPlacesSearchTableViewController *)self.searchController.searchResultsController;
    tableController.filteredPlacesArray = searchResults;
    [tableController.tableView reloadData];
}

#pragma mark - UIStateRestoration

//  we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ManagePlacesViewControllerTitleKey = @"ManagePlacesViewControllerTitleKey";
NSString *const PlacesSearchControllerIsActiveKey = @"PlacesSearchControllerIsActiveKey";
NSString *const ManagePlacesSearchBarTextKey = @"ManagePlacesSearchBarTextKey";
NSString *const PlacesSearchBarIsFirstResponderKey = @"PlacesSearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.title forKey:ManagePlacesViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:PlacesSearchControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:PlacesSearchBarIsFirstResponderKey];
    }
    
    [coder encodeObject:searchController.searchBar.text forKey:ManagePlacesSearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    self.title = [coder decodeObjectForKey:ManagePlacesViewControllerTitleKey];
    _searchControllerWasActive = [coder decodeBoolForKey:PlacesSearchControllerIsActiveKey];
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:PlacesSearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:ManagePlacesSearchBarTextKey];
}

#pragma mark - Hide SearchBar

- (void)hideSearchBarWithAnimation:(BOOL)animated
{
    if ([_placesArray count] > 0 || ([myPlacesArray count] > 0 || [sharedPlacesArray count] > 0)) {
        [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[CSRMenuSlidingSegue class]]) {
        [super showCoverView];
    }
    
    if ([segue.identifier isEqualToString:@"placeDetailsSegue"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        CSRPlaceDetailsViewController *vc = (CSRPlaceDetailsViewController*)[navController topViewController];
        
        if ((int)selectedIndex > -1) {
            vc.placeEntity = [_placesArray objectAtIndex:selectedIndex];
            
        } else {
            
            vc.title = @"Create a new place";
            
        }
        
    }
    
}

#pragma mark - Accessory type action

- (void)accessoryButtonTapped:(id)sender
{
    UIButton *accessoryButton = (UIButton *)sender;
    selectedIndex = accessoryButton.tag;
    [self performSegueWithIdentifier:@"placeDetailsSegue" sender:self];
}

#pragma mark - Navigation Bar item menthods

- (IBAction)showSearch:(id)sender
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.searchController setActive:YES];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)addNewPlace:(id)sender
{
    selectedIndex = -1;
    [self performSegueWithIdentifier:@"placeDetailsSegue" sender:self];
}


@end
