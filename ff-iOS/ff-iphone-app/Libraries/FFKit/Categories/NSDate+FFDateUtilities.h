//
//  NSDate+FFDateUtilities.h
//  FFiPhoneApp
//
//  Created by lee on 7/23/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FFDateUtilities)

//
// Relative dates from the instance's date
//
- (NSDate *)ff_dateByAddingYears:(NSInteger)years;
- (NSDate *)ff_dateByAddingMonths:(NSInteger)months;
- (NSDate *)ff_dateByAddingWeeks:(NSInteger)weeks;
- (NSDate *)ff_dateByAddingDays:(NSInteger)days;
- (NSDate *)ff_dateByAddingHours:(NSInteger)hours;
- (NSDate *)ff_dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)ff_dateByAddingSeconds:(NSInteger)seconds;
- (NSDate *)ff_dateMidnight;

//
// Date comparisons
//
- (BOOL)ff_isSameYearAsDate:(NSDate *)date;
- (BOOL)ff_isSameMonthOfYearAsDate:(NSDate *)date;
- (BOOL)ff_isSameWeekOfYearAsDate:(NSDate *)date;
- (BOOL)ff_isSameDayOfYearAsDate:(NSDate *)date;
- (BOOL)ff_isSameHourOfYearAsDate:(NSDate *)date;
- (BOOL)ff_isSameSecondOfYearAsDate:(NSDate *)date;
- (BOOL)ff_isToday;
- (BOOL)ff_isTomorrow;
- (BOOL)ff_isYesterday;

//
// Date components
//
- (NSInteger)ff_year;
- (NSInteger)ff_month;
- (NSInteger)ff_week;
- (NSInteger)ff_day;
- (NSInteger)ff_hour;
- (NSInteger)ff_minute;
- (NSInteger)ff_second;

//
// Wrapper functions
//
+ (NSDate *)ff_dateFromString:(NSString *)dateString withFormat:(NSString *)format;
- (NSString *)ff_stringWithFormat:(NSString *)format;
- (NSDate *)ff_localTime;

@end
