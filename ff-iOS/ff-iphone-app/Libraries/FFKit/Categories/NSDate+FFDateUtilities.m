//
//  NSDate+FFDateUtilities.m
//  FFiPhoneApp
//
//  Created by lee on 7/23/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "NSDate+FFDateUtilities.h"

@implementation NSDate (FFDateUtilities)

typedef enum FFDateOffsetType : NSInteger FFDateOffsetType;
enum FFDateOffsetType : NSInteger {
    Year, Month, Week, Day, Hour, Minute, Second
};

- (NSDate *)dateWithOffsetFromNow:(NSInteger)offset type:(FFDateOffsetType)offsetType
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    switch (offsetType) {
        case Year:
            [comps setYear:offset];
            break;
        case Month:
            [comps setMonth:offset];
            break;
        case Week:
            [comps setWeek:offset];
            break;
        case Day:
            [comps setDay:offset];
            break;
        case Hour:
            [comps setHour:offset];
            break;
        case Minute:
            [comps setMinute:offset];
            break;
        case Second:
            [comps setSecond:offset];
            break;
        default:
            break;
    }

    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
    
    return newDate;
}

- (NSDate *)ff_dateByAddingYears:(NSInteger)years
{
    return [self dateWithOffsetFromNow:years type:Year];
}

- (NSDate *)ff_dateByAddingMonths:(NSInteger)months
{
    return [self dateWithOffsetFromNow:months type:Month];
}

- (NSDate *)ff_dateByAddingWeeks:(NSInteger)weeks
{
    return [self dateWithOffsetFromNow:weeks type:Week];
}

- (NSDate *)ff_dateByAddingDays:(NSInteger)days
{
    return [self dateWithOffsetFromNow:days type:Day];
}

- (NSDate *)ff_dateByAddingHours:(NSInteger)hours
{
    return [self dateWithOffsetFromNow:hours type:Hour];
}

- (NSDate *)ff_dateByAddingMinutes:(NSInteger)minutes
{
    return [self dateWithOffsetFromNow:minutes type:Minute];
}

- (NSDate *)ff_dateByAddingSeconds:(NSInteger)seconds
{
    return [self dateWithOffsetFromNow:seconds type:Second];
}

- (NSDate *)ff_dateMidnight
{
    return [self dateWithComponentsUpToOffsetType:Day];
}

- (NSDate *)dateWithComponentsUpToOffsetType:(FFDateOffsetType)offsetType
{
    NSString *dateFormat = @"";
    
    switch (offsetType) {
        case Year:
            dateFormat = @"yyyy";
            break;
        case Month:
            dateFormat = @"yyyy-MM";
            break;
        case Week:
            dateFormat = @"yyyy-w";
            break;
        case Day:
            dateFormat = @"yyyy-MM-dd";
            break;
        case Hour:
            dateFormat = @"yyyy-MM-dd HH";
            break;
        case Minute:
            dateFormat = @"yyyy-MM-dd HH:mm";
            break;
        case Second:
            dateFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];

    return [dateFormatter dateFromString:[dateFormatter stringFromDate:self]];
}

- (BOOL)isSameComponentOfYearAsDate:(NSDate *)date type:(FFDateOffsetType)offsetType
{
    return ([[self dateWithComponentsUpToOffsetType:offsetType] compare:[date dateWithComponentsUpToOffsetType:offsetType]] == NSOrderedSame);
}

- (BOOL)ff_isSameYearAsDate:(NSDate *)date
{
    return [self isSameComponentOfYearAsDate:date type:Year];
}

- (BOOL)ff_isSameMonthOfYearAsDate:(NSDate *)date
{
    return [self isSameComponentOfYearAsDate:date type:Month];
}

- (BOOL)ff_isSameWeekOfYearAsDate:(NSDate *)date
{
    return [self isSameComponentOfYearAsDate:date type:Week];
}

- (BOOL)ff_isSameDayOfYearAsDate:(NSDate *)date
{
    return [self isSameComponentOfYearAsDate:date type:Day];
}

- (BOOL)ff_isSameHourOfYearAsDate:(NSDate *)date
{
    return [self isSameComponentOfYearAsDate:date type:Hour];
}

- (BOOL)ff_isSameSecondOfYearAsDate:(NSDate *)date
{
    return [self isSameComponentOfYearAsDate:date type:Second];
}

- (BOOL)ff_isToday
{
    return [self ff_isSameDayOfYearAsDate:[NSDate date]];
}

- (BOOL)ff_isTomorrow
{
    return [self ff_isSameDayOfYearAsDate:[[NSDate date] ff_dateByAddingDays:1]];
}

- (BOOL)ff_isYesterday
{
    return [self ff_isSameDayOfYearAsDate:[[NSDate date] ff_dateByAddingDays:-1]];
}

- (NSInteger)ff_componentWithType:(FFDateOffsetType)offsetType
{
    NSString *dateFormat = @"";
    
    switch (offsetType) {
        case Year:
            dateFormat = @"yyyy";
            break;
        case Month:
            dateFormat = @"M";
            break;
        case Week:
            dateFormat = @"w";
            break;
        case Day:
            dateFormat = @"d";
            break;
        case Hour:
            dateFormat = @"H";
            break;
        case Minute:
            dateFormat = @"m";
            break;
        case Second:
            dateFormat = @"s";
            break;
        default:
            break;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    
    return [[dateFormatter stringFromDate:self] integerValue];
}

- (NSInteger)ff_year
{
    return [self ff_componentWithType:Year];
}

- (NSInteger)ff_month
{
    return [self ff_componentWithType:Month];
}

- (NSInteger)ff_week
{
    return [self ff_componentWithType:Week];
}

- (NSInteger)ff_day
{
    return [self ff_componentWithType:Day];
}

- (NSInteger)ff_hour
{
    return [self ff_componentWithType:Hour];
}

- (NSInteger)ff_minute
{
    return [self ff_componentWithType:Minute];
}

- (NSInteger)ff_second
{
    return [self ff_componentWithType:Second];
}

+ (NSDate *)ff_dateFromString:(NSString *)dateString withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];

    return [dateFormatter dateFromString:dateString];
}

- (NSString *)ff_stringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)ff_localTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dateFormatter dateFromString:[self ff_stringWithFormat:dateFormatter.dateFormat]];
}

@end
