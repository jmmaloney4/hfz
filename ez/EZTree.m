//
//  EZip, Awesome File Compression
//  Copyright (c) 2014 Jack Maloney. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "EZTree.h"
#import "EZNode.h"
#import "ez.h"
#import "ezutils.h"
#import "EZEncodeChar.h"

@interface EZTree()
@property (nonatomic, readwrite, strong) NSMutableArray* BaseNodes;
@property (nonatomic, readwrite, strong) NSMutableArray* Nodes;
@property (nonatomic, readwrite) BOOL modified;
@end

@implementation EZTree

-(instancetype) init {
    self = [super init];
    self.BaseNodes = [[NSMutableArray alloc] init];
    self.modified = NO;
    return self;
}

-(void) addNode:(EZNode*) node {
    if ([node isKindOfClass:[EZNode class]]) {
        [self.BaseNodes insertObject:node atIndex:0];
        self.modified = YES;
    }
}

-(void) constructTree {
    [self SortNodeArray];

    NSMutableArray* arr = [self.BaseNodes mutableCopy];

    while (arr.count > 1) {
        EZNode* node1 = arr[0];
        EZNode* node2 = arr[1];
        EZNode* node3 = [[EZNode alloc] init];

        node1.parent = node3;
        node2.parent = node3;
        node3.rightChild = node2;
        node3.leftChild = node1;

        node3.count = node2.count + node1.count;

        [arr removeObject:node1];
        [arr removeObject:node2];

        [arr addObject:node3];

        [EZTree sortEZNodeArray:arr];
    }
    self.Nodes = arr;
    self.modified = NO;
}

-(void) SortNodeArray {
    [EZTree sortEZNodeArray:self.BaseNodes];
}


-(void) GenerateCodes {
    if (self.modified) {
        [self constructTree];
    }

    


}



+(NSArray*) sortEZNodeArray:(NSArray*) arr {

    NSMutableArray* rv = [arr mutableCopy];

    while (true) {
        BOOL hasSorted = NO;
        for (int a = 0; a < rv.count - 1; a++) {
            if (![rv[a] isKindOfClass:[EZNode class]]) {
                printErr(@"Malformed Array");
                print(@"%@", [rv[a] class]);
                print(@"%@", rv[a]);
                exit(1);
            }

            if (((EZNode*)rv[a]).count > ((EZNode*)rv[a + 1]).count) {
                hasSorted = YES;
                EZNode* item1 = ((EZNode*)rv[a]);
                EZNode* item2 = ((EZNode*)rv[a + 1]);

                [rv replaceObjectAtIndex:a withObject:item2];
                [rv replaceObjectAtIndex:a + 1 withObject:item1];
            }
        }
        if (!hasSorted) {
            break;
        }
    }

    return rv;
}

@end