#import "CategoriesViewController.h"
#import "CategorySelectionDelegate.h"

@implementation CategoriesViewController
@synthesize categories, categoriesTable;

- (void) viewDidLoad {
  self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @"Categories";
  
  self.categoriesTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.categoriesTable.dataSource = self;
  self.categoriesTable.delegate = self;

  [self.view addSubview:self.categoriesTable];
}

- (NSInteger)tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  return [[[categories objectAtIndex:section] objectForKey:@"sub_categories"] count];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView * ) tableView {
  return [categories count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [[categories objectAtIndex:section] objectForKey:@"name"];
}

- (UITableViewCell * )tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath * )indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  NSDictionary *parent = [categories objectAtIndex:indexPath.section];
  NSArray *sub = [parent objectForKey:@"sub_categories"];

  cell.textLabel.text = [[sub objectAtIndex:indexPath.row] objectForKey:@"name"];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSDictionary *parent = [categories objectAtIndex:indexPath.section];
  NSArray *sub = [parent objectForKey:@"sub_categories"];
  NSDictionary *category = [sub objectAtIndex:indexPath.row];
  NSString *catId = [category objectForKey:@"id"];
  NSString *catName = [category objectForKey:@"name"];
  
  [self.navigationController popViewControllerAnimated:YES];  
  if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCategory:withName:)]) {
    [self.delegate didSelectCategory:catId withName:catName];
  }
}

@end