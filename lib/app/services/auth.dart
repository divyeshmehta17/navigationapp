import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../modules/OTPVERIFICATION/views/otpverification_view.dart';
import '../routes/app_pages.dart';
import 'dialog_helper.dart';
import 'storage.dart';

class Auth extends GetxService {
  final auth = FirebaseAuthenticationService();
  final _firebaseAuth = FirebaseAuth.instance;
  var user = '';
  var devicetoken = '';

  // Future<bool> facebook() async {
  //   DialogHelper.showLoading();
  //   bool status = false;
  //
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //
  //     if (result.status == LoginStatus.success) {
  //       final OAuthCredential facebookAuthCredential =
  //           FacebookAuthProvider.credential(result.accessToken!.tokenString);
  //
  //       await _firebaseAuth.signInWithCredential(facebookAuthCredential);
  //       await handleGetContact();
  //       final user = _firebaseAuth.currentUser;
  //       if (user != null) {
  //         print('User name: ${user.displayName}');
  //       }
  //       status = true;
  //     } else {
  //       showMySnackbar(msg: result.message ?? 'Facebook login failed');
  //     }
  //   } catch (e) {
  //     showMySnackbar(msg: 'Facebook login failed. Please try again.');
  //     print('Facebook login error: $e');
  //   }
  //
  //   DialogHelper.hideDialog();
  //   return status;
  // }

  Future<bool> google() async {
    DialogHelper.showLoading();
    bool status = false;
    await auth.signInWithGoogle().then((value) async {
      if (!value.hasError) {
        await handleGetContact();
        user = _firebaseAuth.currentUser!.displayName!;
        status = true;
      } else {
        showMySnackbar(msg: value.errorMessage!);
      }
    });
    DialogHelper.hideDialog();
    return status;
  }

  Future<void> checkLocationPermissionAndNavigate() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      Get.toNamed(Routes.CUSTOMNAVIGATIONBAR);
    } else {
      Get.to(const locationAccessSplashScreen());
    }
  }

  Future<bool> apple() async {
    DialogHelper.showLoading();
    bool status = false;
    await auth
        .signInWithApple(
            appleRedirectUri:
                'https://oui-7d6f3.firebaseapp.com/__/auth/handler',
            appleClientId: '')
        .then((value) async {
      if (!value.hasError) {
        status = true;
        await handleGetContact();
      } else {
        showMySnackbar(msg: value.errorMessage!);
      }
    });
    DialogHelper.hideDialog();
    return status;
  }

  Future<bool> loginEmailPass(
      {required String email, required String pass}) async {
    DialogHelper.showLoading();
    bool status = false;
    await auth.loginWithEmail(email: email, password: pass).then((value) async {
      if (!value.hasError) {
        await handleGetContact();
        status = true;
      } else {
        showMySnackbar(msg: value.errorMessage!);
      }
    });
    DialogHelper.hideDialog();
    return status;
  }

  Future<bool> createEmailPass(
      {required String email, required String pass}) async {
    DialogHelper.showLoading();
    bool status = false;
    await auth
        .createAccountWithEmail(email: email, password: pass)
        .then((value) async {
      if (!value.hasError) {
        await handleGetContact();
        status = true;
      } else {
        showMySnackbar(msg: value.errorMessage!);
      }
    });
    DialogHelper.hideDialog();
    return status;
  }

  // phone number with country code
  Future<void> mobileLoginOtp(
      {required String phoneno,
      required bool showLoading,
      required BuildContext context,
      dynamic arguments}) async {
    if (showLoading) {
      DialogHelper.showLoading();
    }
    print({'test ${auth.firebaseAuth.app.options.projectId}'});
    await auth.requestVerificationCode(
      phoneNumber: phoneno,
      timeout: const Duration(seconds: 0),
      onCodeSent: (authenticationResult) async {
        showLoading = false;
        DialogHelper.hideDialog();
        await Get.toNamed(Routes.OTPVERIFICATION, arguments: arguments);
      },
      onVerificationFailed: (exception) {
        debugPrint(exception.message);
        showMySnackbar(
            msg: exception.message ?? 'OTP request failed. Please try again.');
        showLoading = false;
        DialogHelper.hideDialog();

        // Show the failure popup dialog
        _showErrorDialog(context, exception.message!);
      },
    );
  }

  // Error dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Method to extract the error message from the API response
  String _getErrorMessage(dynamic error) {
    // Check if error is a DioError and contains response data
    if (error is DioException &&
        error.response != null &&
        error.response!.data != null) {
      // You can modify this based on how the API sends errors
      return error.response!.data['message'] ?? 'An unknown error occurred.';
    } else {
      return 'An error occurred while submitting your query.';
    }
  }

  Future<void> resendMobileOTP({required String phoneno}) async {
    DialogHelper.showLoading();
    await auth.requestVerificationCode(
      phoneNumber: phoneno,
      onCodeSent: (authenticationResult) {},
      onVerificationFailed: (exception) {
        debugPrint(exception.message);
        showMySnackbar(msg: exception.message ?? '');
      },
    );
    DialogHelper.hideDialog();
  }

  Future<bool> verifyMobileOtp({required String otp}) async {
    DialogHelper.showLoading();
    bool status = false;
    await auth.authenticateWithOtp(otp).then((value) async {
      if (!value.hasError) {
        await handleGetContact();
        status = true;
      }
    });

    DialogHelper.hideDialog();
    return status;
  }

  Future<void> handleGetContact() async {
    final mytoken = await _firebaseAuth.currentUser!.getIdToken(true);
    Get.find<GetStorageService>().setEncjwToken = mytoken!;
    log(Get.find<GetStorageService>().getEncjwToken);
  }

  Future<void> logOutUser() async {
    DialogHelper.showLoading();
    Get.find<GetStorageService>().logout();
    await auth.logout();
    await Get.offAllNamed(Routes.PHONELOGIN);
    DialogHelper.hideDialog();
  }
}
