class AppUrl {
  AppUrl._();
  //here 10.0.2.2 is equivalent to localhost as we are on emulator
  //we cant use localhost
  static const String baseurl = "http://10.0.2.2:8000";
  static const String login = "$baseurl/api/login";
  static const String register = "$baseurl/api/register";

//sends pswd reset otp
  static const String send_otp = "$baseurl/api/send-otp";

  //verify otp either pswd reset or registration
  static const String verify_otp = "$baseurl/api/verify-otp";
  static const String pswd_change = "$baseurl/api/password-change";
  static const String pswd_reset = "$baseurl/api/password-reset";

  //user routes
  static const String get_logged_user = "$baseurl/api/user";
  static const String update_user = "$baseurl/api/user";
  static const String retrive_all_user = "$baseurl/api/user/retrive-all-user";

//profile routes
  static const String update_profile = "$baseurl/api/profile";
  static const String get_profile = "$baseurl/api/profile";
  static const String retrive_profile_with_list =
      "$baseurl/api/profile/retrive-profile-with-list";
  static const String retrive_all_profile =
      "$baseurl/api/profile/retrive-all-profile";

  //space routes
  static const String space = "$baseurl/api/space";
  static const String get_all_space = "$baseurl/api/space/get-all-space";

  //chat
  static const String chat = "$baseurl/api/chat";
  static const String list_home_screen_chats =
      "$baseurl/api/chat/display-chat-associated-with-user";

  //notification
  static const String notifications = "$baseurl/notification";
}
