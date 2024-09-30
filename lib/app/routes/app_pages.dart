import 'package:get/get.dart';

import '../modules/CUSTOMNAVIGATIONBAR/bindings/customnavigationbar_binding.dart';
import '../modules/CUSTOMNAVIGATIONBAR/views/customnavigationbar_view.dart';
import '../modules/OTPVERIFICATION/bindings/otpverification_binding.dart';
import '../modules/OTPVERIFICATION/views/otpverification_view.dart';
import '../modules/addaplace/bindings/addaplace_binding.dart';
import '../modules/addaplace/views/addaplace_view.dart';
import '../modules/community/bindings/community_binding.dart';
import '../modules/community/views/community_view.dart';
import '../modules/contactus/bindings/contactus_binding.dart';
import '../modules/contactus/views/contactus_view.dart';
import '../modules/directioncard/bindings/directioncard_binding.dart';
import '../modules/directioncard/views/directioncard_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/views/faq_view.dart';
import '../modules/feedback/bindings/feedback_binding.dart';
import '../modules/feedback/views/feedback_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/offlineroutes/bindings/offlineroutes_binding.dart';
import '../modules/offlineroutes/views/offlineroutes_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/phonelogin/bindings/phonelogin_binding.dart';
import '../modules/phonelogin/views/phonelogin_view.dart';
import '../modules/privacypolicy/bindings/privacypolicy_binding.dart';
import '../modules/privacypolicy/views/privacypolicy_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/realtimenavigation/bindings/realtimenavigation_binding.dart';
import '../modules/realtimenavigation/views/realtimenavigation_view.dart';
import '../modules/reportincident/bindings/reportincident_binding.dart';
import '../modules/reportincident/views/reportincident_view.dart';
import '../modules/resetpassword/bindings/resetpassword_binding.dart';
import '../modules/resetpassword/views/resetpassword_view.dart';
import '../modules/saved/bindings/saved_binding.dart';
import '../modules/saved/views/saved_view.dart';
import '../modules/searchview/bindings/searchview_binding.dart';
import '../modules/searchview/views/searchview_view.dart';
import '../modules/setprofiledetails/bindings/setprofiledetails_binding.dart';
import '../modules/setprofiledetails/views/setprofiledetails_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscribescreen/bindings/subscribescreen_binding.dart';
import '../modules/subscribescreen/views/subscribescreen_view.dart';
import '../modules/termsandcondition/bindings/termsandcondition_binding.dart';
import '../modules/termsandcondition/views/termsandcondition_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.PHONELOGIN,
      page: () => const PhoneloginView(),
      binding: PhoneloginBinding(),
    ),
    GetPage(
      name: _Paths.OTPVERIFICATION,
      page: () => const OtpverificationView(),
      binding: OtpverificationBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMNAVIGATIONBAR,
      page: () => const CustomnavigationbarView(),
      binding: CustomnavigationbarBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: _Paths.SAVED,
      page: () => SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: _Paths.COMMUNITY,
      page: () => const CommunityView(),
      binding: CommunityBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SEARCHVIEW,
      page: () => const SearchviewView(),
      binding: SearchviewBinding(),
    ),
    GetPage(
      name: _Paths.DIRECTIONCARD,
      page: () => DirectioncardView(),
      binding: DirectioncardBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIBESCREEN,
      page: () => const SubscribescreenView(),
      binding: SubscribescreenBinding(),
    ),
    GetPage(
      name: _Paths.OFFLINEROUTES,
      page: () => const OfflineroutesView(),
      binding: OfflineroutesBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.RESETPASSWORD,
      page: () => const ResetpasswordView(),
      binding: ResetpasswordBinding(),
    ),
    GetPage(
      name: _Paths.CONTACTUS,
      page: () => const ContactusView(),
      binding: ContactusBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: _Paths.TERMSANDCONDITION,
      page: () => const TermsandconditionView(),
      binding: TermsandconditionBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACYPOLICY,
      page: () => const PrivacypolicyView(),
      binding: PrivacypolicyBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.REPORTINCIDENT,
      page: () => const ReportincidentView(),
      binding: ReportincidentBinding(),
    ),
    GetPage(
      name: _Paths.SETPROFILEDETAILS,
      page: () => const SetprofiledetailsView(),
      binding: SetprofiledetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADDAPLACE,
      page: () => const AddaplaceView(),
      binding: AddaplaceBinding(),
    ),
    GetPage(
      name: _Paths.REALTIMENAVIGATION,
      page: () => RealtimenavigationView(),
      binding: RealtimenavigationBinding(),
    ),
  ];
}
