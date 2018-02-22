//
//  HNConstants.h
//  Hanlin
//
//  Created by Selvam M on 1/25/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#ifndef HNConstants_h
#define HNConstants_h
//root url and action urls
#define HN_ROOTURL @"http://eventapp.platinumcode.net/"
#define HN_ROOTURL_APP @"http://eventapp.platinumcode.net/app/"
#define HN_REGISTER_USER @"app/userdetails.php"
#define HN_UPDATE_USER @"app/edit-userdetails.php"
#define HN_LOGIN_USER @"app/login.php"
#define HN_CHANGE_PASSWORD @"app/changePassword.php"
#define HN_UPDATE_PASSWORD @"app/resetPassword.php"
#define HN_DOCUMENT_DOWNLOAD @"app/Mobile/documentDownload.php"

#define HN_PUSH_NOTIFICATION @"app/tokens.php"
#define HN_CONTACTUS @"app/contact.php"
#define HN_GET_ALL_EVENTS @"app/events.php"
#define HN_JOIN_EVENT @"app/joinedusers.php"
#define HN_GET_ALL_NOTIFICATIONS @"/app/newsletter.php"
#define HN_GET_ALL_ATTACHMENTS @"app/event-file.php"

#define HN_GET_ALL_PROMOTIONS @"app/promotion.php"

//API Constants
#define HN_REQ_NAME @"name"
#define HN_REQ_PHONE @"phone"
#define HN_REQ_EMAIL @"email"
#define HN_REQ_PASSWORD @"password"
#define HN_REQ_USERFILE @"userfile"
#define HN_USERNAME @"username"
#define HN_REQ_USERID @"userid"
#define HN_REQ_MESSAGE @"message"
#define HN_REQ_COMPANY @"company"
#define HN_REQ_ADDRESS @"address"

//Login Response
#define HN_LOGIN_NAME @"name"
#define HN_LOGIN_USERNAME @"username"
#define HN_LOGIN_USERID @"userid"
#define HN_LOGIN_PHONE @"phone"
#define HN_LOGIN_JOINDATE @"joindate"
#define HN_LOGIN_PROFILE_IMG @"profileimage"

//events response
#define HN_APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#endif /* HNConstants_h */
