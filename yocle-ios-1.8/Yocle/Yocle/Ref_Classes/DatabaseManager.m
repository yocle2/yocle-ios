
#import "DatabaseManager.h"

@implementation DatabaseManager

+ (BOOL)openDatabase:(sqlite3**)db
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *dbpath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, DatabaseName];
    
    return (BOOL) (sqlite3_open([dbpath UTF8String], db) == SQLITE_OK);
}

// bookings data
+ (BOOL)createTable:(TableKind)tableKind
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    // Create the database
    if ([self openDatabase:&db] == YES)
    {
        char* errMsg;
        
        NSString* createSQL = [self generateCreateSql:tableKind];
        
        const char* create_stmt = [createSQL UTF8String];
        
        if (sqlite3_exec(db, create_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
#ifdef _LOG_
            NSLog(@"Failed to create %@ table", BOOKINGS_TABLE_NAME);
#endif
        }
        else
        {
            result = YES;
        }
        sqlite3_close(db);
    }
    else
    {
#ifdef _LOG_
        NSLog(@"Failed to open/create database");
#endif
    }
    
    return result;
}

+ (NSArray *)readData:(TableKind)tableKind
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@", kAppDelegate.tableNames[tableKind]];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = kAppDelegate.fullDatabaseStructure[tableKind];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                NSInteger index = 0;
                for (NSDictionary *dic in tableStructure)
                {
                    DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
                    NSString *fieldName = dic[FieldName];
                    if (fieldType == PRIMARYKEYKind || fieldType == INTEGERKind)
                        data[fieldName] = @(sqlite3_column_int(statement, (int)index));
                    else if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
                        data[fieldName] = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, (int)index)];
                    index ++;
                }
                
                [result addObject:data];
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
    }
    else
    {
#ifdef _LOG_
        NSLog(@"Failed to open/create database");
#endif
    }
    
    return result;
}

+ (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName isASC:(BOOL)isASC
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ %@", kAppDelegate.tableNames[tableKind], fieldName, isASC ? @"ASC" : @"DESC"];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = kAppDelegate.fullDatabaseStructure[tableKind];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                NSInteger index = 0;
                for (NSDictionary *dic in tableStructure)
                {
                    DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
                    NSString *fieldName = dic[FieldName];
                    if (fieldType == PRIMARYKEYKind || fieldType == INTEGERKind)
                        data[fieldName] = @(sqlite3_column_int(statement, (int)index));
                    else if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
                        data[fieldName] = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, (int)index)];
                    index ++;
                }
                
                [result addObject:data];
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
    }
    else
    {
#ifdef _LOG_
        NSLog(@"Failed to open/create database");
#endif
    }
    
    return result;
}

+ (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", kAppDelegate.tableNames[tableKind], fieldName, fieldValue];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = kAppDelegate.fullDatabaseStructure[tableKind];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                NSInteger index = 0;
                for (NSDictionary *dic in tableStructure)
                {
                    DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
                    NSString *fieldName = dic[FieldName];
                    if (fieldType == PRIMARYKEYKind || fieldType == INTEGERKind)
                        data[fieldName] = @(sqlite3_column_int(statement, (int)index));
                    else if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
                        data[fieldName] = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, (int)index)];
                    index ++;
                }
                
                [result addObject:data];
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
    }
    else
    {
#ifdef _LOG_
        NSLog(@"Failed to open/create database");
#endif
    }
    
    return result;
}

+ (BOOL)deleteData:(TableKind)tableKind data:(NSDictionary *)data
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSArray *tableStructure = kAppDelegate.fullDatabaseStructure[tableKind];
        NSDictionary *firstField = [tableStructure firstObject];
        NSString* querySQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id='%ld'", kAppDelegate.tableNames[tableKind], (long)[data[firstField[FieldName]] integerValue]];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                result = YES;
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
    }
    
    return result;
}

+ (BOOL)insertData:(TableKind)tableKind data:(NSDictionary *)data
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        NSString *insertSQL = [self generateInsertSql:tableKind data:data];
        const char* insert_stmt = [insertSQL UTF8String];
        
        if (sqlite3_prepare_v2(db, insert_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
                result = YES;
            
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Error while insert data(%s)", sqlite3_errmsg(db));
        }
        
        sqlite3_close(db);
    }
    
    return result;
}

+ (BOOL)updateData:(TableKind)tableKind data:(NSDictionary *)data
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        NSString *updateSQL = [self generateUpdateSql:tableKind data:data];
        
        const char* update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare_v2(db, update_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
                result = YES;
            
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Error while update data(%s)", sqlite3_errmsg(db));
        }
        
        sqlite3_close(db);
    }
    
    return result;
}

+ (NSString *)generateCreateSql:(TableKind)tableKind
{
    NSString *result;
    
    NSArray *tableStructure = kAppDelegate.fullDatabaseStructure[tableKind];
    NSString *fieldNames = @"(";
    NSDictionary *lastDic = [tableStructure lastObject];
    
    for (NSDictionary *dic in tableStructure)
    {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        
        if (fieldType == PRIMARYKEYKind)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT)", fieldName];
        }
        else if (fieldType == TEXTKind)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ TEXT, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ TEXT)", fieldName];
        }
        else if (fieldType == INTEGERKind)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER)", fieldName];
        }
        else if (fieldType == DATETIMEKIND)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ DATETIME, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ DATETIME)", fieldName];
        }
    }
    
    result = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ %@", kAppDelegate.tableNames[tableKind], fieldNames];
    
    return result;
}

+ (NSString *)generateInsertSql:(TableKind)tableKind data:(NSDictionary *)data
{
    NSString *result;
    
    NSArray *tableStructure = kAppDelegate.fullDatabaseStructure[tableKind];
    NSString *fieldNames = @"(";
    NSString *values = @"(";
    NSDictionary *lastDic = [tableStructure lastObject];
    
    for (NSDictionary *dic in tableStructure)
    {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        NSString *value = data[fieldName];
        
        if (fieldType == PRIMARYKEYKind)
            continue;
        if (![dic isEqual:lastDic])
            fieldNames = [fieldNames stringByAppendingFormat:@"%@, ", fieldName];
        else
            fieldNames = [fieldNames stringByAppendingFormat:@"%@)", fieldName];
        
        if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
        {
            if (![dic isEqual:lastDic])
                values = [values stringByAppendingFormat:@"\"%@\", ", value];
            else
                values = [values stringByAppendingFormat:@"\"%@\")", value];
        }
        else if (fieldType == INTEGERKind)
        {
            if (![dic isEqual:lastDic])
                values = [values stringByAppendingFormat:@"%ld, ", (long)[value integerValue]];
            else
                values = [values stringByAppendingFormat:@"%ld)", (long)[value integerValue]];
        }
    }
    
    result = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@", kAppDelegate.tableNames[tableKind], fieldNames, values];
    
    return result;
}

+ (NSString *)generateUpdateSql:(TableKind)tableKind data:(NSDictionary *)data
{
    NSString *result;
    
    NSArray *tableStructure = kAppDelegate.fullDatabaseStructure[tableKind];
    NSString *nameValuePairs = @"";
    NSDictionary *firstDic = [tableStructure firstObject];
    NSDictionary *lastDic = [tableStructure lastObject];
    long firstValue = (long)[data[firstDic[FieldName]] integerValue];
    
    for (NSDictionary *dic in tableStructure)
    {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        NSString *value = data[fieldName];
        
        if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
        {
            if (![dic isEqual:lastDic])
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%@', ", fieldName, value];
            else
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%@'", fieldName, value];
        }
        else if (fieldType == INTEGERKind)
        {
            if (![dic isEqual:lastDic])
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%ld', ", fieldName, (long)[value integerValue]];
            else
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%ld'", fieldName, (long)[value integerValue]];
        }
    }
    
    result = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE id='%ld'", kAppDelegate.tableNames[tableKind], nameValuePairs, firstValue];
    
    return result;
}

@end