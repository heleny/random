//
//  CollapsableTableView.m
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/03/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CollapsableTableView.h"
#import "CollapsableTableViewHeaderViewController.h"


@implementation CollapsableTableView

#pragma mark -
#pragma mark Properties

- (void) setDelegate:(id <UITableViewDelegate>) newDelegate
{
    [super setDelegate:self];
    realDelegate = newDelegate;
}

- (void) setDataSource:(id <UITableViewDataSource>) newDataSource
{
    [super setDataSource:self];
    realDataSource = newDataSource;
}


#pragma mark -
#pragma mark Initialization

- (void) postInit
{
    toggleHeaderIdx = -1;
    headerTitleToIsCollapsedMap = [[NSMutableDictionary alloc] init];
    headerTitleToSectionIdxMap = [[NSMutableDictionary alloc] init];
    sectionIdxToHeaderTitleMap = [[NSMutableDictionary alloc] init];
    heightOfShortestCellSeen = 35;
    temporaryRowCountOverrideSectionIdx = -1;
}

- (id) init
{
    if ((self = [super init]))
        [self postInit];
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
        [self postInit];
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ((self = [super initWithFrame:frame style:style]))
        [self postInit];
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    return self = [super initWithFrame:frame];
}


#pragma mark -
#pragma mark Miscellaneous methods

- (void)reinitializeSectionIndexReferences
{
    [headerHeightArray removeAllObjects];
    [sectionIdxToHeaderTitleMap removeAllObjects];
    [headerTitleToSectionIdxMap removeAllObjects];
    for (NSInteger sectionIdx=0; sectionIdx<[self numberOfSectionsInTableView:self]; sectionIdx++)
    {
        NSString* headerTitle = [realDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)] ? [realDataSource tableView:self titleForHeaderInSection:sectionIdx] : nil;
        if (! headerTitle)
        {
            if (! [realDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
                continue;
            int tag =  [realDelegate tableView:self viewForHeaderInSection:sectionIdx].tag;
            if ((! tag) && (sectionIdx))
                tag = sectionIdx;
            headerTitle = [NSString stringWithFormat:@"Tag %i",tag];
        }
        NSNumber* sectionIdxNumber = [[NSNumber alloc] initWithInt:sectionIdx];
        [sectionIdxToHeaderTitleMap setObject:headerTitle forKey:sectionIdxNumber];
        [headerTitleToSectionIdxMap setObject:sectionIdxNumber forKey:headerTitle];
    }
}

- (void) toggleSectionCollapsedForTitle:(NSString*) headerTitle headerView:(UIView*) view withRowAnimation:(UITableViewRowAnimation) rowAnimation
{
    BOOL isCollapsed = ! [[headerTitleToIsCollapsedMap objectForKey:headerTitle] boolValue];
    int sectionIdx = [[headerTitleToSectionIdxMap objectForKey:headerTitle] intValue];
    
    if (view)
    {
        UILabel* collapsedIndicatorLabel = (UILabel*) [view viewWithTag:COLLAPSED_INDICATOR_LABEL_TAG];
        if (collapsedIndicatorLabel)
            collapsedIndicatorLabel.text = isCollapsed ? @"+" : @"–";
    }
    else
    {
        toggleHeaderIdx = sectionIdx;
        [self reloadSections:[NSIndexSet indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationNone];
        toggleHeaderIdx = -1;
    }
    
    [headerTitleToIsCollapsedMap setObject:[NSNumber numberWithBool:isCollapsed] forKey:headerTitle];
    
    int rowCount = [realDataSource tableView:self numberOfRowsInSection:sectionIdx];
    
    // For insert-rows optimization.
    int rowsLeftOut = 0;
    if (! isCollapsed)
    {
        int maximumVisibleRowEstimate = (int) ceil(self.frame.size.height / heightOfShortestCellSeen);
        if (rowCount>maximumVisibleRowEstimate)
        {
            rowsLeftOut = rowCount - maximumVisibleRowEstimate;
            temporaryRowCountOverride = rowCount = maximumVisibleRowEstimate;
            temporaryRowCountOverrideSectionIdx = sectionIdx;
        }
    }
    
    NSMutableArray* indexPaths = [[NSMutableArray alloc] initWithCapacity:rowCount];
    for (int i=0; i<rowCount; i++)
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIdx]];
    if (isCollapsed)
        [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    else
    {
        [super insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        if (sectionIdx==[realDataSource numberOfSectionsInTableView:self] - 1)
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:MIN(rowCount - 1,4) inSection:sectionIdx] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        if (rowsLeftOut!=0)
            [self performSelector:@selector(insertRemainingRows) withObject:nil afterDelay:0.3];
    }
}

// Insert-rows optimization (see http://stackoverflow.com/questions/6077885/insertrowsatindexpaths-calling-cellforrowatindexpath-for-every-row 
// for more info; specifically, the topmost answer to the question).
- (void) insertRemainingRows
{
    int rowCount = [realDataSource tableView:self numberOfRowsInSection:temporaryRowCountOverrideSectionIdx];
    NSMutableArray* indexPaths = [[NSMutableArray alloc] initWithCapacity:rowCount - temporaryRowCountOverride];
    for (int i=temporaryRowCountOverride; i<rowCount; i++)
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:temporaryRowCountOverrideSectionIdx]];
    temporaryRowCountOverrideSectionIdx = -1;
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void) toggleSectionCollapsedForTitle:(NSString*) headerTitle headerView:(UIView*) view
{
    [self toggleSectionCollapsedForTitle:headerTitle headerView:view withRowAnimation:UITableViewRowAnimationFade];
}

- (NSDictionary*) headerTitleToIsCollapsedMap
{
    return [NSDictionary dictionaryWithDictionary:headerTitleToIsCollapsedMap];
}

+ (void) setTextOnCollapsableTableViewHeaderViewController:(CollapsableTableViewHeaderViewController*) headerViewController forHeaderTitle:(NSString*) headerTitle
{
    headerViewController.fullTitle = headerTitle;
    NSRange barRange = [headerTitle rangeOfString:@"|"];
    if (barRange.location==NSNotFound)
        headerViewController.titleText = headerTitle;
    else
    {
        headerViewController.titleText = [headerTitle substringToIndex:barRange.location];
        headerViewController.detailText = [headerTitle substringFromIndex:barRange.location + barRange.length];
    }
}

- (NSString*) getHeaderViewNibName
{
    return self.style==UITableViewStylePlain ? @"CollapsableTableViewHeaderViewPlain" : @"CollapsableTableViewHeaderViewGrouped";
}

- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle andView:(UIView*) headerView withRowAnimation:(UITableViewRowAnimation) rowAnimation;
{
    NSNumber* isCollapsedNumber = [headerTitleToIsCollapsedMap objectForKey:headerTitle];
    if (isCollapsedNumber)
    {
        if (isCollapsed!=[isCollapsedNumber boolValue])
            [self toggleSectionCollapsedForTitle:headerTitle headerView:headerView withRowAnimation:rowAnimation];
    }
    else
    {
        [headerTitleToIsCollapsedMap setObject:[NSNumber numberWithBool:isCollapsed] forKey:headerTitle];
        if ([headerTitleToSectionIdxMap objectForKey:headerTitle])
        {
            [self reinitializeSectionIndexReferences];
            [self reloadSections:[NSIndexSet indexSetWithIndex:[[headerTitleToSectionIdxMap objectForKey:headerTitle] intValue]] withRowAnimation:rowAnimation];
        }
    }
}

- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle withRowAnimation:(UITableViewRowAnimation) rowAnimation
{
    [self setIsCollapsed:isCollapsed forHeaderWithTitle:headerTitle andView:nil withRowAnimation:rowAnimation];
}

- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle andView:(UIView*) headerView
{
    [self setIsCollapsed:isCollapsed forHeaderWithTitle:headerTitle andView:headerView withRowAnimation:UITableViewRowAnimationFade];
}

- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle
{
    [self setIsCollapsed:isCollapsed forHeaderWithTitle:headerTitle andView:nil];
}


- (void)endUpdates
{
    [self reinitializeSectionIndexReferences];
    [super endUpdates];
}


- (void)reloadData
{
    [self reinitializeSectionIndexReferences];
    [super reloadData];
}


- (NSMutableArray*) extractValidIndexPaths:(NSArray*) indexPaths
{
    NSMutableArray* newIndexPaths = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath* nextIndexPath in indexPaths)
        if (! [[headerTitleToIsCollapsedMap objectForKey:[sectionIdxToHeaderTitleMap objectForKey:[NSNumber numberWithInt:nextIndexPath.section]]] boolValue])
            [newIndexPaths addObject:nextIndexPath];
    return newIndexPaths;
}

- (void) deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSArray* newIndexPaths = [self extractValidIndexPaths:indexPaths];
    if (newIndexPaths.count)
        [super deleteRowsAtIndexPaths:newIndexPaths withRowAnimation:animation];
}

- (void) insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSArray* newIndexPaths = [self extractValidIndexPaths:indexPaths];
    if (newIndexPaths.count)
        [super insertRowsAtIndexPaths:newIndexPaths withRowAnimation:animation];
}

- (void) reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSArray* newIndexPaths = [self extractValidIndexPaths:indexPaths];
    if (newIndexPaths.count)
        [super reloadRowsAtIndexPaths:newIndexPaths withRowAnimation:animation];
}


- (void) scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSString* headerTitle = [sectionIdxToHeaderTitleMap objectForKey:[NSNumber numberWithInt:indexPath.section]];
    if ([[headerTitleToIsCollapsedMap objectForKey:headerTitle] boolValue])
        [self toggleSectionCollapsedForTitle:headerTitle headerView:nil];
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void) selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    NSString* headerTitle = [sectionIdxToHeaderTitleMap objectForKey:[NSNumber numberWithInt:indexPath.section]];
    if ([[headerTitleToIsCollapsedMap objectForKey:headerTitle] boolValue])
        [self toggleSectionCollapsedForTitle:headerTitle headerView:nil];
    [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void) deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    NSString* headerTitle = [sectionIdxToHeaderTitleMap objectForKey:[NSNumber numberWithInt:indexPath.section]];
    if ([[headerTitleToIsCollapsedMap objectForKey:headerTitle] boolValue])
        [self toggleSectionCollapsedForTitle:headerTitle headerView:nil];
    [super deselectRowAtIndexPath:indexPath animated:animated];
}

#pragma mark -
#pragma mark TapDelegate methods

- (void) view:(UIView*) view tappedWithIdentifier:(NSString*) identifier;
{
    [self toggleSectionCollapsedForTitle:identifier headerView:view];
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
        [realDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        return [realDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([realDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [realDelegate tableView:tableView heightForHeaderInSection:section];
    if (! headerHeightArray)
        headerHeightArray = [[NSMutableArray alloc] initWithCapacity:[self numberOfSectionsInTableView:tableView] + 5];
    while (headerHeightArray.count<=section)
        [self tableView:tableView viewForHeaderInSection:headerHeightArray.count];
    return [[headerHeightArray objectAtIndex:section] intValue];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* headerTitle = [realDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)] ? [realDataSource tableView:tableView titleForHeaderInSection:section] : nil;
    CollapsableTableViewHeaderViewController* headerViewController = [[CollapsableTableViewHeaderViewController alloc] initWithNibName:[self getHeaderViewNibName] bundle:nil];
    headerViewController.tapDelegate = self;
    if (headerTitle)
    {
        [headerViewController loadView];
        CGRect frame = headerViewController.view.frame;
        frame.size.width = tableView.frame.size.width;
        headerViewController.view.frame = frame;
        [CollapsableTableView setTextOnCollapsableTableViewHeaderViewController:headerViewController forHeaderTitle:headerTitle];
    }
    else
    {
        UIView* theView = [realDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)] ? [realDelegate tableView:tableView viewForHeaderInSection:section] : nil;
        if (! theView)
            return nil;
        if ((! theView.tag) && (section))
            theView.tag = section;
        headerViewController.fullTitle = headerTitle = [NSString stringWithFormat:@"Tag %i",theView.tag];
        headerViewController.view = theView;
    }
    
    NSNumber* isCollapsedNumber = [headerTitleToIsCollapsedMap objectForKey:headerTitle];
    if (isCollapsedNumber)
        headerViewController.isCollapsed = toggleHeaderIdx==section ? ! [isCollapsedNumber boolValue] : [isCollapsedNumber boolValue]; 
    else
        [headerTitleToIsCollapsedMap setObject:[NSNumber numberWithBool:NO] forKey:headerTitle];
    
    NSNumber* sectionNumber = [[NSNumber alloc] initWithInt:section];
    [sectionIdxToHeaderTitleMap setObject:headerTitle forKey:sectionNumber];
    [headerTitleToSectionIdxMap setObject:sectionNumber forKey:headerTitle];
    
    NSNumber* heightNumber = [[NSNumber alloc] initWithInt:(int) headerViewController.view.frame.size.height];
    while (headerHeightArray.count<section)
        [headerHeightArray addObject:heightNumber];
    if (headerHeightArray.count==section)
        [headerHeightArray addObject:heightNumber];
    else
        [headerHeightArray replaceObjectAtIndex:section withObject:heightNumber];
    
    return headerViewController.view;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures). 

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [realDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
        return [realDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    return indexPath;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [realDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
        return [realDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    return UITableViewCellEditingStyleDelete;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [realDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    return YES;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
        [realDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
        [realDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
        return [realDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
        return [realDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    return 0;
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (temporaryRowCountOverrideSectionIdx==section)
        return temporaryRowCountOverride;
    return [[headerTitleToIsCollapsedMap objectForKey:[sectionIdxToHeaderTitleMap objectForKey:[NSNumber numberWithInt:section]]] boolValue] ? 0 : [realDataSource tableView:tableView numberOfRowsInSection:section];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [realDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell.frame.size.height<heightOfShortestCellSeen)
        heightOfShortestCellSeen = (int) cell.frame.size.height;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sectionCount = [realDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] ? [realDataSource numberOfSectionsInTableView:tableView] : 1;
    if (headerHeightArray)
    {
        while (headerHeightArray.count>sectionCount)
            [headerHeightArray removeLastObject];
    }
    return sectionCount;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
        return [realDataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    return YES;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
        return [realDataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    return [realDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:)];
}

// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([realDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
        return [realDataSource sectionIndexTitlesForTableView:tableView];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [realDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([realDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        [realDataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([realDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
        [realDataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}


@end
