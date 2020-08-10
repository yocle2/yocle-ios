
#import <Foundation/Foundation.h>

#define FieldName                               @"FieldName"
#define FieldType                               @"FieldType"
#define InvalidNumber                           -1
#define ValidNumber                             0

// snoring table
#define SnoringId                               @"id"
#define SnoringName                             @"name"
#define SnoringStarted                          @"started"
#define SnoringStoped                           @"stoped"

// database
#define DatabaseName                            @"Snoring.db"
#define SnoringTableName                        @"SnoringTable"

typedef enum DatabaseDataTypeKind
{
    PRIMARYKEYKind = 0,
    TEXTKind = 1,
    INTEGERKind = 2,
    DATETIMEKIND = 3
} DatabaseDataTypeKind;

typedef enum TableKind
{
    SnoringTable = 0
}TableKind;

@interface DatabaseManager : NSObject

+ (BOOL)createTable:(TableKind)tableKind;
+ (NSArray *)readData:(TableKind)tableKind;
+ (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName isASC:(BOOL)isASC;
+ (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue;
+ (BOOL)deleteData:(TableKind)tableKind data:(NSDictionary *)data;
+ (BOOL)insertData:(TableKind)tableKind data:(NSDictionary *)data;
+ (BOOL)updateData:(TableKind)tableKind data:(NSDictionary *)data;

@end
