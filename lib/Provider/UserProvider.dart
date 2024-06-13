import 'package:arjunagym/Resources/FirebaseResources.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arjunagym/Models/UserModel.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  bool _isLoading = false;
  AuthMethods authMethods = AuthMethods();

  // UserModel? get user => _user;
  bool get isLoading => _isLoading;

  UserModel? get getUser => _userModel;

  Future<void> refreshUser() async {
    UserModel user = await authMethods.getUserDetails();
    _userModel = user;
    print(_userModel);
    notifyListeners();
  }
}
