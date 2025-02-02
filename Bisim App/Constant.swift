//
//  Constant.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

// TYPEALIAS
typealias COMPLETION_HANDLER = (_ status: Alert) -> Void
typealias FORMDATA_PARAMETERS = [String:String]
typealias JSON_PARAMETERS = [String:Any]

// USERDEFAULTS
let TOKEN_KEY = "tokenKey"
let IS_LOGGED_IN_KEY = "isLoggedInKey"
let PRESENT_REGISTER_VC_KEY = "presentRegisterVCKey"
let SHOW_ADDRESS_VC_KEY = "showAddressVCKey"
let PRESENT_PAGE_VIEW_CONTROLLER_KEY = "presentPageViewControllerKey"


// FONT
let IRAN_SANS_MOBILE_FONT = "IRANSansMobile(FaNum)"
let IRAN_SANS_BOLD_MOBILE_FONT = "IRANSansMobileFaNum-Bold"

// URL
var BASE_URL = "https://api.bisimapp.com/"

// HEADER
let JSON_HEADER = ["Authorization":Authentication.auth.token]

// CELLS
let SEARCH_CELL = "searchCell"
let ADDRESS_CELL = "addressCell"
let CITY_CELL = "cityCell"
let TRAVEL_CELL = "travelCell"
let PAY_CELL = "payCell"

// STOARYBOARD ID
let REGISTRATION_VIEW_CONTROLLER_ID = "RegistrerationViewControllerID"
let ORDER_MENU_VIEW_CONTROLLER_ID = "OrderMenuViewControllerID"
let OPTION_DRIVE_VIEW_CONTROLLER_ID = "OptionDriveViewControllerID"
let REQUST_VIEW_CONTROLLER_ID = "RequestViewControllerID"
let SEARCH_NAV_ID = "searchNavID"
let MAP_SEARCH_VIEW_CONTROLLER_ID = "MapSearchViewControllerID"
let ADDRESS_TABLE_VC_ID = "addressTableVCID"
let CITY_VIEW_CONTROLLER_ID = "CityViewControllerID"
let DRIVER_VIEW_CONTROLLER_ID = "DriverViewControllerID"
let DISS_ROUTE_VIEW_CONTROLLER_ID = "DissRouteViewControllerID"
let FEEDBACK_VIEW_CONTROLLER_ID = "FeedbackViewControllerID"
let CARIO_CONTENT_PAGE_VIEW_CONTROLLER_ID = "carioContentPageViewControllerID"
let CARIO_PAGE_VIEW_VIEW_CONTROLLER_ID = "carioPageViewControllerID"

// SEGUES
let REGISTRATION_TO_CONFIRM_SEGUE = "registerationToConfirmSegue"
let TO_MAIN_VIEW_CONTROLLER_SEGUE = "toMainViewControllerSegue"
let UNWIND_VERIFICATION_TO_LOADER_SEGUE = "unwindVerificationToLoaderSegue"
let OPEN_SIDE_MENU_SEGUE = "openSideMenuSegue"
let ORDER_TO_MAIN_SEGUE = "orderToMainSegue"
let TO_OPTION_ORDER_SEGUE = "toOptionDriverSegue"
let UNWIND_OPTION_TO_MAIN_SEGUE = "unwindOptionToMainSegue"
let UNWIND_PASSENGER_TO_MAIN_SEGUE = "passengerToMainSegue"
let UNWIND_SEND_ORDER_TO_MAIN_SEGUE = "unwindSendOrderToMainSegue"
let UNWIND_DISCOUNT_VC_TO_MAIN_VC_SEGUE = "unwindDiscountVCToMainVC"
let ADDRESS_TO_SEARCH_SEGUE = "addressToSearchSegue"
let ADDRESS_TABLE_VC_TO_ADDRESS_MAP_VC_SEGUE = "addressTableVCToMapAddressVCSegue"
let UNWIND_TO_ADDRESS_TABLE_VC_SEGUE = "unwindToAddressTableViewController"
let UNWIND_DRIVER_VC_TO_MAIN_VC_SEGUE = "unwindDriverToMain"
let UNWIND_FEEDBACK_VC_TO_MAIN_VC_SEGUE = "unwindFeedbackToMainSegue"
let UNWIND_SIDE_TO_LOADER_SEGUE = "unwindSideToLoaderSegue"
let APP_SUPOORT_SEGUE = "appSupport"
let OTHER_SUPPORT_SEGUE = "otherSupport"
let TRAVEL_SUPPORT_SEGUE = "travelSupport"
let UNWIND_SEND_ORDER_TO_MAIN_NORMAL_SEGUE = "UNWIND_SEND_ORDER_TO_MAIN_NORMAL_SEGUE"

// GOOGLE API KEY
let GOOGLE_API_KEY = "AIzaSyBeFj7zZmb3OfxyMqfBkq8Ps-ZnfR8kSc0"

// NOTIFICATION CENTER
let DISMISS_INDICATOR_VC_NOTIFY = Notification.Name("dismissedIndicatorViewController")
let CHANGE_SERVICE_TYPE_NOTIFY = Notification.Name("changedServiceTypeNotify")
let REMOVE_ORDER_MENU_NOTIFY = Notification.Name("removeOrderMenuNotify")
let ADD_SECEND_PLACE_NOTIFY = Notification.Name("addSecendPlaceNotify")
let OPEN_SETTING_BUTTON_NOTIFY = Notification.Name("openSettingButtonNotify")
let RESET_CUSTOMER_AND_MAP_DATA = Notification.Name("resetCustomerAndMapData")
let SEARCH_DRIVER_REQUEST_NOTIFY = Notification.Name("searchForDriverNotify")
let CHANGE_OPTION_DRIVE_VC_UI_NOTIFY = Notification.Name("searchForDriverNotify")
let DISMISS_REQUEST_VIEW_CONTROLLER = Notification.Name("dismissedRequestViewController")
let GO_MARKER_FOR_ADDRESS_NOTIFY = Notification.Name("goMarkerForAddressNotify")
let DRIVER_ACCEPT_NOTIFT = Notification.Name("driverAcceptedNotify")
let TRAVEL_INFO_RECIEVED_NOTIFY = Notification.Name("travelInfoRecievedNotify")
let DRIVER_IN_LOCATION_NOTIFIY = Notification.Name("driverInLocationNotify")
let START_TRAVEL_NOTIFY = Notification.Name("startTravelNotify")
let FINISHED_TRAVEL_NOTIFIY = Notification.Name("finishedTravelNotify")
let CANCEL_TRAVEL_NOTIFY = Notification.Name("cancelTravelNotify")
let GO_TO_MAIN_FROM_LOADER_NOTIFY = Notification.Name("goToMainNotify")
let SECEND_PLACE_NAME_CHANGED_NOTIFY = Notification.Name("secendPlaceNameChangedNotify")

// UNIQUE NAME
let FROM_LABEL = "آدرس مبداء ..."
let TO_LABEL = "آدرس مقصد ..."
let SECEND_LABEL = "انتخاب مسیر دوم"
let TELEGRAM_URL = "https://telegram.me/bisimapp"
let INSTAGRAM_URL = "http://instagram.com/_u/bisimapp"
let WEBSITE_URL = "http://www.bisimapp.com/"

// STORYBOARD
let driveModeStroyboard = UIStoryboard.init(name: "DriveMode", bundle: nil)
