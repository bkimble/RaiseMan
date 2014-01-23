//
//  RMDocument.m
//  RaiseMan
//
//  Created by Billy Kimble on 1/16/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import "RMDocument.h"
#import "Person.h"
#import "PreferenceController.h"


@implementation RMDocument

static void *RMDocumentKVOContext;

- (void) startObservingPerson:(Person *)person {
    [person addObserver:self forKeyPath:@"personName" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    [person addObserver:self forKeyPath:@"expectedRaise" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
}

- (void) stopObservingPerson:(Person *)person {
    [person removeObserver:self forKeyPath:@"personName" context:&RMDocumentKVOContext];
    [person removeObserver:self forKeyPath:@"expectedRaise" context:&RMDocumentKVOContext];    
}


- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        employees = [[NSMutableArray alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(handleColorChange:) name:BNRColorChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleColorChange:(NSNotification *)note {
    NSColor *color = [[note userInfo] objectForKey:@"color"];
    [tableView setBackgroundColor:color];
}

- (void)insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index {
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Add Person"];
    }
    [self startObservingPerson:p];
    [employees insertObject:p atIndex:index];
    
}

- (void) removeObjectFromEmployeesAtIndex:(NSUInteger)index {
    Person *p = [employees objectAtIndex:index];
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:p inEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Remove Person"];
    }
    [self stopObservingPerson:p];
    [employees removeObjectAtIndex:index];
}


- (void)setEmployees:(NSMutableArray *)a {
    if (a == employees) {
        return;
    }

    for(Person *p in employees) {
       [self stopObservingPerson:p];
    }
    
    employees = a;

    for(Person *p in employees) {
        [self startObservingPerson:p];
    }
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"RMDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [tableView setBackgroundColor:[PreferenceController preferenceTableBgColor]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue {
    [obj setValue:newValue forKeyPath:keyPath];
}


- (IBAction)createEmployee:(id)sender {
    NSWindow *w = [tableView window];
    BOOL editingEnded = [w makeFirstResponder:w];
    if (!editingEnded) {
        NSLog(@"unable to end editing");
        return;
    }
    NSUndoManager *undo = [self undoManager];
    
    if([undo groupingLevel] > 0) {
        [undo endUndoGrouping];
        [undo beginUndoGrouping];
    }
    
    Person *p = [employeeController newObject];
    // add it to the content array of emp control
    [employeeController addObject:p];
    
    // re sort
    [employeeController rearrangeObjects];
    
    // get sorted array via proxy?
    NSArray *a = [employeeController arrangedObjects];
    
    // find object jst added
    NSUInteger row = [a indexOfObjectIdenticalTo:p];
    NSLog(@"Start edit?");
    
    // begin edit in the first column
    [tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    [undo setActionName:@"Edit"];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    // end editing
    [[tableView window] endEditingFor:nil];
    return [NSKeyedArchiver archivedDataWithRootObject:employees];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSMutableArray  *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e) {
        NSLog(@"exception = %@", e);
        if (outError ) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"the data is corrupted" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
        }
        return NO;
    }
    [self setEmployees:newArray];
    return YES;
}

@end
