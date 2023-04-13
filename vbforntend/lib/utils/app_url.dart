class AppUrl {
  AppUrl._();
  //here 10.0.2.2 is equivalent to localhost as we are on emulator
  //we cant use localhost
  static const String baseurl = "http://10.0.2.2:8000";
  static const String login = "$baseurl/api/login";
  static const String register = "$baseurl/api/register";
  static const String update_profile =
      "$baseurl/api/profile/643568e8d0aed00bb41a4079";

//sends pswd reset otp
  static const String send_otp = "$baseurl/api/send-otp";

  //verify otp either pswd reset or registration
  static const String verify_otp = "$baseurl/api/verify-otp";
  static const String pswd_change = "$baseurl/api/password-change";
  static const String pswd_reset = "$baseurl/api/password-reset";
}
