class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://15.207.221.220:8082/v1/";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String login = "auth/login";
  static const String setuserdetails = "auth/register";
  static const String setuserprofilepicture = "upload/files";
  static const String contactus = "contact/create";
  static const String fetchcommunitypost = "community/incident/get/all";
  static const String createreportincident = "community/incident/create";
  static const String getRoutes = "navigation/direction/route";
  static const String saveRoutes = "route/save";
  static const String getsavedRoutes = "route/get/all";
  static const String getsavedPlace = "route/place/get/all";
  static const String postsavePlace = "route/place/save";
  static const String postsubscribe = "subscription/subscribe";
}
