//
//  Global.h
//  EverybodyRun
//
//  Created by star on 1/31/16.
//  Copyright © 2016 samule. All rights reserved.
//

#ifndef Global_h
#define Global_h

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define     kAPIBaseURLString                   @"http://dev.app.cieleathletics.com/everybodyrun/webservice2"
#define     kMediaBaseURL                       @"http://dev.app.cieleathletics.com/everybodyrun/"
#define     kJournalURL                         @"https://cieleathletics.com/stories-2/"
#define     kCieleHQURL                         @"https://cieleathletics.com"
#define     kTutorial                           @"https://cieleathletics.com/everybodyrun"
#define     kSuggestAService                    @"https://cieleathletics.com/survey"
#define     kTermsOfUse                         @"https://cieleathletics.com/terms-of-use/"
#define     kPrivacyPolice                      @"https://cieleathletics.com/privacy/"
#define     kMemberEventURL                     @"http://ads.cieleathletics.com/api/v1/locations"

//#define     kAPIBaseURLString                   @"http://192.168.2.31/everybodyrun/webservice"
//#define     kMediaBaseURL                       @"http://192.168.2.31/everybodyrun/"

#define     SECRET_KEY                          @"8b8d37254ff272637eaaeac3d36ceeaf"
#define     TAG_PREFIX                          @"#cieleapp"
#define     SEARCH_TAG_PREFIX                   @"cieleapp"

//AWS
#define     AWS_ACCESS_KEY_ID                   @"AKIAINGVHWYHZV7F7TAQ"
#define     AWS_SECRET_KEY                      @"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"

#define     BUCKET_PHOTO                        @"elasticbeanstalk-us-east-1-948799433059"

#define     MAP_BOX_TOKEN                       @"pk.eyJ1IjoiY2llbGVhdGhsZXRpY3MiLCJhIjoiY2lxZWc0bXFvMDA4MGh6bWMyaDR5Mjk4ZCJ9.nb1vdG1hf9rseEsUeybKEw"

#define     IMAGE_COMPRESSION_RATE              0.5
#define     MAP_TYPE_DEFAULT_URL                @"mapbox://styles/cieleathletics/ciqe74dra0007cnks6jhu5dcd"
#define     MAP_TYPE_SAT_URL                    @"mapbox://styles/mapbox/satellite-v9"
#define     MAP_ZOOM_LEVEL                      10
#define     DEFAULT_MAP_ZOOM_LEVEL              10
#define     BIRTHDAY_FORMAT                     @"MMM dd, yyyy"

typedef void(^J_IN_PROGRESS_CALL_BACK_BLOCK)(float progress);
typedef void(^J_DID_COMPLETE_CALL_BACK_BLOCK)(NSString *obj);
typedef void(^DID_COMPLETE_CALL_BACK_BLOCK)(void);

//////////////////////////// Message. ////////////////////////////////////////

#define     MSG_INVALID_NAME                    @"Please input a valid name."
#define     MSG_INVALID_EMAIL                   @"Please input a valid email address."
#define     MSG_INVALID_BIRTHDAY                @"Please input a valid birthday."
#define     MSG_INVALID_GENDER                  @"Please input a valid gender."
#define     MSG_INVALID_PASSWORD                @"Please input a valid password."
#define     MSG_INVALID_FIRSTNAME               @"Please input a valid first name."
#define     MSG_INVALID_LASTNAME                @"Please input a valid last name."
#define     MSG_CANT_UPLOAD_AVTAR               @"Sorry we can't upload your avatar."
#define     MSG_CANT_CREATE_ACCOUNT             @"Sorry we can't register your account."
#define     MSG_INTERNET_ERROR                  @"Weird, I can't connect with your web server. Can  you please check your internet connection."

#define     MSG_INVALID_EVENT_NAME              @"Please input a valid event name."
#define     MSG_INVALID_EVENT_ADDRESS           @"Please input a valid event address."
#define     MSG_INVALID_EVENT_DATE              @"Please input a valid event date."
#define     MSG_INVALID_EVENT_TIME              @"Please input a valid event time."
#define     MSG_INVALID_EVENT_FREQUENCY         @"Please input a valid frequency."
#define     MSG_INVALID_EVENT_TYPE              @"Please input a valid type."
#define     MSG_INVALID_EVENT_LEVEL             @"Please input a valid pace."
#define     MSG_INVALID_EVENT_DISTANCE          @"Please input a valid distance."
#define     MSG_INVALID_EVENT_DISTANCE_UNIT     @"Please input a valid distance unit."
#define     MSG_INVALID_EVENT_URL               @"Please input a valid url."
#define     MSG_INVALID_EVENT_VISIBILITY        @"Please input a valid visibility."
#define     MSG_INVALID_ROUTE                   @"Please add at least 1 point."
#define     MSG_CANT_UPLOAD_IMAGE               @"Sorry can't upload your image."
#define     MSG_CANT_CREATE_EVENT               @"Sorry can't create your event."
#define     MSG_CANT_GET_ADDRESS                @"Sorry can't get your address."
#define     MSG_SUCCESS_EVENT_CREATE_NO_IMAGE   @"Congrats! Your event has been created."
#define     MSG_SUCCESS_EVENT_CREATE            @"Congrats! Your event has been created . Would you like to share to your Instagram?"
#define     MSG_SUCCESS_EVENT_UPDATE            @"Your Event has been updated."
#define     MSG_ASK_ADD_CALENDAR                @"Would you like to add this event to your Iphone's calendar?"
#define     MSG_ASK_SHARE                       @"Would you like to share this event?"
#define     MSG_ASK_REASON_FOR_REMOVE           @"Please type a reason. You are updating your event."
#define     MSG_RESHARE_EVENT                   @"Would you like to re-share your event?"
#define     MSG_INSTAGRAM_NOT_SUPPORT           @"Instagram app is not installed in your device."
#define     MSG_WEB_PAGE_NOT_VALID              @"Current web site url is not valid."
#define     MSG_ASK_PHONE_CALL                  @"Would you like to place a call?"

#define     GOOGLE_PLACE_API_KEY                @"AIzaSyD3nepP-1vY8PUguBcWBHB7SneHuqD4KoE"

#define     LOCATIONSERVICESUCCESSNOTIFICATION  @"LocationServiceSuccess"
#define     LOCATIONSERVICEFAILEDNOTIFICATION   @"LocationServiceFailed"
#define     DISTANCE_UNIT_CHANGED               @"DistanceUnitChanged"


#define USER_PIN                                @"userPin"
#define LOCATION_PIN                            @"locationPin"
#define TRACK_PIN                               @"trackPin"
#define PIN_TOP_MESSAGE                         @"Hold pin to move";

#define EMAIL_TITLE                             @"Inquiry from within the Ciele Athletics App"
#define EMAIL_MESSAGE_BODY                      @"Please tell me more about the service you are offering."
#define EMAIL_MESSAGE_BODY_CLOSED_EVENT         @"I am interested in your event, please tell me more."

#define BUTTON_CORNER_RADIUS                    5
#define REFRESH_INTERVAL                        72
#define USER_LOCATION_ZOOM_RATE                 0.02f
#define USER_AVATAR_MAX_SIZE                    200
#define MAX_SEARCH_MILE                         100
#define MENU_INDENT                             56.0f
#define NEARBY_DISTANCE                         50
#define ROUTE_LINE_WIDTH                        5.0
#define BLOG_HIDE_TIME                          3.0

#define DATE_FORMATTER                          @"MMM dd, yyyy"
#define TIME_FORMATTER                          @"hh:mm a"

typedef enum
{
    EVENT_VIEW_FULL_VIEW,
    EVENT_VIEW_OPEN,
    EVENT_VIEW_CLOSE,
    
} EVENT_VIEW_STATUS;

typedef enum
{
    FREQUENCY_ONE_TIME,
    FREQUENCY_WEEKLY,
    FREQUENCY_BI_WEEKLY,
    FREQUENCY_MONTHLY,
    
} FREQUENCY;

typedef enum
{
    TYPE_ROAD,
    TYPE_TRIAL,
    TYPE_TRACK,
    TYPE_TREADMILL,
    TYPE_TRAINING,
    TYPE_SOCIAL,
    
} TYPE;

typedef enum
{
    LEVEL_BEGINNER,
    LEVEL_INTERMEDIATE,
    LEVEL_ADVANCED,
    LEVEL_ELLITE,
    
} LEVEL;

typedef enum
{
    VISIBILITY_CLOSED,
    VISIBILITY_OPEN,
    
} VISIBILITY;

typedef enum
{
    DISTANCE_KILOMETER,
    DISTANCE_MILE,
    
} DISTANCE_TYPE;

typedef enum
{
    LOCATION_CURRENT,
    LOCATION_CHOOSE,
    
} LOCATION_TYPE;

typedef enum
{
    INPUT_EVENT_NAME,
    INPUT_LOCATION,
    INPUT_DATE,
    INPUT_TIME,
    INPUT_TYPE,
    INPUT_LEVEL,
    INPUT_DISTANCE,
    INPUT_VISIBILITY,
    INPUT_OTHER,
    INPUT_AGE,
    INPUT_FIRSTNAME,
    INPUT_LASTNAME,
    INPUT_EMAIL,
    INPUT_BIRTHDAY,
    INPUT_PASSWORD,
    INPUT_CONFIRM_PASSWORD,
    INPUT_GENDER
    
} INPUT_MODE;

typedef enum
{
    FILTER_FOOD                     = 2,
    FILTER_BEVERAGE                 = 1,
    FILTER_HEALTH                   = 5,
    FILTER_CLUBS                    = 6,
    FILTER_COACHES                  = 3,
    FILTER_HAPPENINGS               = 4,
    FILTER_RETAILERS                = 7,
    FILTER_SELECT_RETAILERS         = 8,
    FILTER_EVENT                    = 9,
    FILTER_ALL                      = 0,
    
} FILTER_CATEGORY;

typedef enum
{
    FILTER_TODAY,
    FILTER_TOMORROW,
    FILTER_DATE,
    
} FILTER_TYPE;

typedef enum
{
    EVENT_FILTER_NEARBY,
    EVENT_FILTER_ATTENDING,
    EVENT_FILTER_ORGANIZING,
    
} EVENT_FILTER_TYPE;

#define     ARRAY_TYPE                          [NSArray arrayWithObjects: @"Road", @"Trail", @"Track", @"Treadmill", @"Training", @"Social", nil]
#define     ARRAY_LEVEL                         [NSArray arrayWithObjects: @"Beginner", @"Intermediate", @"Advanced", @"Ellite", nil]
#define     ARRAY_DISTANCE_UNIT                 [NSArray arrayWithObjects: @"Km", @"Mi", nil]
#define     ARRAY_VISIBILITY                    [NSArray arrayWithObjects: @"Closed", @"Open", nil]
#define     ARRAY_GENDER                        [NSArray arrayWithObjects: @"Male", @"Female", @"Other", nil]

//Color
#define     COLOR_MAIN_TEXT                     [UIColor colorWithRed: 35.0/255.0 green: 31.0/255.0 blue:32.0/255.0 alpha:1.0]
#define     COLOR_SUB_TEXT                      [UIColor colorWithRed: 208.0/255.0 green: 210.0/255.0 blue:211.0/255.0 alpha:1.0]
#define     COLOR_GREEN_BTN                     [UIColor colorWithRed: 0 green: 199.0/255.0 blue:0 alpha:1.0]
#define     COLOR_RED_BTN                       [UIColor colorWithRed: 239.0/255.0 green: 78.0/255.0 blue:60.0/255.0 alpha:1.0]

//Font
#define     FONT_REGULAR                        @"CenturyGothic"
#define     FONT_BOLD                           @"CenturyGothic-Bold"
#define     FONT_BOLD_ITALIC                    @"CenturyGothic-BoldItalic"

#endif /* Global_h */
