//
//  Constant.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import SWRevealViewController
import CocoaMQTT

//Singleton Class

class Singleton  {
    static var sharedInstance = Singleton()
    var resturantHomeModel : ResturantHome!
    var CustomerProfileModel : CustomerProfile!
    var RestaurantDetailsModel : Restaurant_Details!
    var ItemDetailModel : itemDetailModel!
    var MyCartModel : MyCartModel!
    var MyOrdersModel : MyOrderModel!
    
    
}

// common variables
var main_category_id = NSNumber()
var sub_category_id = NSNumber()
var sortByStr = String()
var tabBarSelectedIndex = Int()
let device_type = "ios"
var payingSubTotal = String()
var allcategoryItemsStr = String()
var veg_NonVegItemsStr = String()
var pagingIndex = Int()

var payingDesliveryFee = String()
var payingTotalAmt = String()
var payingPayPalTotalAmt = String()
var exactSubTotalAmt = Float()
var exactToatlAmt = Float()
var exactDeliveryAmt = Float()
var exactCouponAmt = Float()
var actAsBaseTabbar = UITabBarController()
var profilepageComesFrom = String()
var ActAsSelectedAddress = String()
var ActAsSelectedLatitude = String()
var ActAsSelectedLongitude = String()
var ActAsSelectedZipCode = String()
var MapLocationPageFrom = String()
var CommonOrderStatusUpdateStr = String()
var showWorkingHoursView = String()
var newOneOrderUpdated = String()
var isfromFavPage = Bool()
var isfromMyReviewPage = Bool()
var isfromShippingAddressPage = Bool()
var popUpToTrackingStatus = String()
var popUpToTrackingSelectedIndex = Int()
var AmountStringToShowForCustomer = String()
var getRestaurentID = String()
var isfromPaymentSucessPage = Bool()

var peakHourFee = String()
var peakHourFeeStatus = String()
var peakHour_Info = String()
var peakCurrency = String()
var globalCartCount = Int()
var customTabBar = UITabBar()
var localeIdendifier = NSLocale()
var localeIdendifierStr = String()

var LanguageDictonary = NSMutableDictionary()
var Appname = "Deliverees"

//let GOOGLE_CLIENT_ID = "551270170503-o6q10ubui6pid8mlu2vg3d436c6nor3t.apps.googleusercontent.com"
let GOOGLE_CLIENT_ID = "802377568198-ck0p6fn9irk8803na2c12f18aseh0tvm.apps.googleusercontent.com" //"802377568198-ar7r9g8aandpifga7k9ecar4dqbr7sa6.apps.googleusercontent.com"

//Base Color codes
let AppLightOrange = UIColor(red: 237/255.0, green: 27/255.0, blue: 36/255.0, alpha: 1.0)
let AppDarkOrange =  UIColor(red: 237/255.0, green: 27/255.0, blue: 36/255.0, alpha: 1.0)
let BlackTranspertantColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
let WhiteTranspertantColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.3)
let DarkWhiteTranspertantColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7)
let SuccessGreenColor = UIColor(red: 237/255.0, green: 27/255.0, blue: 36/255.0, alpha: 1.0)
// UIColor(red: 95/255.0, green: 186/255.0, blue: 79/255.0, alpha: 1.0)
let AppTranspertantOrange = UIColor(red: 254/255.0, green: 128/255.0, blue: 17/255.0, alpha: 0.5)
let OrangeTransperantColor = UIColor(red: 254/255.0, green: 128/255.0, blue: 17/255.0, alpha: 0.4)



//Adding Current User Details
let login_session = UserDefaults.standard

//  Base urlhttp

//let BASEURL = "http://mobileappshopurfood2.1.mytaxisoft.com/api/"
//let BASEURL_CUSTOMER = "http://mobileappshopurfood2.1.mytaxisoft.com/api/customer/"

//let BASEURL = "http://suf-app.pofi5.in/api/"
//let BASEURL_CUSTOMER = "http://suf-app.pofi5.in/api/customer/"



// V2.1 QA Testing URL

//let BASEURL = "http://192.168.0.76/victor_suf/api/"
//let BASEURL_CUSTOMER = "http://192.168.0.76/victor_suf/api/customer/"

//let BASEURL = "http://pofi5.com/victor_suf/api/"
//let BASEURL_CUSTOMER = "http://pofi5.com/victor_suf/api/customer/"

let BASEURL = "https://delivereesapp.com/api/"
let BASEURL_CUSTOMER = "https://delivereesapp.com/api/customer/"
//// V2.1 QA Dev URL
//let BASEURL = "http://suf-app.pofi5.in/api/"
//let BASEURL_CUSTOMER = "http://suf-app.pofi5.in/api/customer/"

//let BASEURL = "https://demo.shopurfood.com/api/"
//let BASEURL_CUSTOMER = "https://demo.shopurfood.com/api/customer/"


//Customer Login Api
let USER_LOGIN = "user_login"
let FB_LOGIN = "facebook_login"
let GOOGLE_LOGIN = "google_login"
let FORGET_PASSWORD = "customer_forgot_password"
let PROFILE = "customer_my_account"
let REGISTER = "registration"

//Home Page API
let RESTURANT_HOME = "restaurant_home_page"
let RESTAURANT_DETAILS_API = "restaurant_details"
let CATEGORY_BASE_ITEM = "category_based_items"
let ITEM_DETAILS = "item_details"
let SAVE_SHIPPING_ADDRESS = "save_shipping_address"
let ALL_RESTAURANT_LIST = "all_restaurant_list"
let ADD_TO_CART = "add_to_cart"
let MY_CART = "my_cart"
let REMOVE_FROM_CART = "remove_from_cart"
let CHOICE_REMOVE_FROM_CART = "remove_choice"
let HOME_SCREEN = "customer_home_page"
let HOME_SEARCH = "home-search"
let MY_ORDERS = "my_orders"
let MY_OFFERS = "my_offers"
let REMOVE_PREORDER_DATE = "remove_pre_order"
let ORDER_DETAILS = "my_order_details"
let CANCEL_ORDER = "cancel_order"
let CUSTOMER_INVOICE = "customer_invoice"
let CUSTOMER_PROFILE = "customer_my_account"
let MY_WISHLIST = "customer_wishlist"
let ADD_WISHLIST = "add_to_wishlist"
let QTY_UPDATE_CART = "qty_update_cart"
let MY_WALLET = "my_wallet"
let USE_WALLET = "use_wallet"
let USE_OFFER = "use_offer"
let CHECK_EXIST_CART = "check_exist_cart"
let COUNTRY_LIST = "country_list"
let USED_WALLET = "used_wallet_details"
let TOTAL_REWARDS_WALLET = "loyalty_history"
let ADD_PREORDER = "add_pre_order_date"
let CUSTOMER_ADDRESS = "customer_ship_address"
let PAYMENT_METHODS = "payment_methods"
let COD_CHECKOUT = "cod_checkout"
let STRIPE_CHECKOUT = "stripe_checkout"
let WALLET_CHECKOUT = "wallet_checkout"
let PAYPAL_CHECKOUT = "paypal_checkout"
let UPDATE_PROFILE = "customer_update_account"
let CUSTOMER_PAYMENT_DETAILS = "customer_payment_settings"
let UPDATE_CUSTOMER_PAYMENT_DETAILS = "customer_update_payment_settings"
let RESET_PASSWORD = "customer_reset_password"
let TERMS = "terms"
let HELP = "help"
let REFER_FRIENDS = "customer_refer_friend"
let UPDATE_USER_SHIPPING = "customer_update_shipadd"
let CATEGORY_BASE_SHOP = "category_based_restaurant"
let MY_REVIEW = "my_reviews"
let SEND_REFER_MAIL = "refer_friend_send_mail"
let REPEAT_ORDER = "repeat_order"
let ORDER_TRACKING = "order_tracking"
let ITEM_WRITE_REVIEW = "product_write_review"
let WIRTE_STORE_REVIEW = "store_write_review"
let REFUND_DETAILS = "refund_details"
let PROFILE_UPDATE_OTP = "customer_update_account_with_otp"
let ADD_CHOICE_TOCART = "add_choice_toCart"
let USER_LOGOUT = "customer_logout"



//MARK SIMONSON - PROXIMA NOVA REGULAR (1)
let TruenoBold14 = UIFont(name: "Trueno-Bold", size: 14.0)
var globalmqtt: CocoaMQTT!

