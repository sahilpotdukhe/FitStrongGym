import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:arjunagym/Models/GymPlan.dart';

class GymPlanProvider with ChangeNotifier {
  List<GymPlan> _plans = [];

  List<GymPlan> get plans => _plans;

  Future<void> fetchPlans() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('gymPlans')
          .get();
      _plans = querySnapshot.docs.map((doc) => GymPlan(
        id: doc.id,
        name: doc['name'],
        months: doc['months'],
        fee: doc['fee'],
        personalTraining: doc['personalTraining'],
      )).toList();
      notifyListeners();
    }
  }

  Future<void> addPlan(GymPlan plan) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final docRef = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('gymPlans')
          .add({
        'name': plan.name,
        'months': plan.months,
        'fee': plan.fee,
        'personalTraining': plan.personalTraining,
      });

      _plans.add(GymPlan(
        id: docRef.id,
        name: plan.name,
        months: plan.months,
        fee: plan.fee,
        personalTraining: plan.personalTraining,
      ));
      notifyListeners();
    }
  }
}
