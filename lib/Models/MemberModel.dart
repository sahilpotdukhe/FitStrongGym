import 'package:arjunagym/Models/GymPlan.dart';
import 'package:intl/intl.dart';

class Member {
  final String id;
  final String name;
  final String mobileNumber;
  final DateTime dateOfBirth;
  final double height;
  final double weight;
  final String photoUrl;
  final String planId;
  final DateTime dateOfAdmission;
  final DateTime renewalDate;
  final DateTime expiryDate; // Add this field
  final String address;
  final String gender;

  Member({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.height,
    required this.weight,
    required this.photoUrl,
    required this.planId,
    required this.dateOfAdmission,
    required this.renewalDate,
    required this.expiryDate, // Add this field
    required this.address,
    required this.gender,
  });

  Member copyWith({String? id}) {
    return Member(
      id: id ?? this.id,
      name: name,
      mobileNumber: mobileNumber,
      dateOfBirth: dateOfBirth,
      height: height,
      weight: weight,
      photoUrl: photoUrl,
      planId: planId,
      dateOfAdmission: dateOfAdmission,
      renewalDate: renewalDate,
      expiryDate: expiryDate, // Add this field
      address: address,
      gender: gender,
    );
  }

  bool isExpired(List<GymPlan> plans) {
    return DateTime.now().isAfter(expiryDate);
  }
  Member renewMembership(GymPlan newPlan, DateTime newDateOfAdmission) {
    return Member(
      id: id,
      name: name,
      mobileNumber: mobileNumber,
      dateOfBirth: dateOfBirth,
      height: height,
      weight: weight,
      photoUrl: photoUrl,
      planId: newPlan.id,
      dateOfAdmission: dateOfAdmission,
      renewalDate: newDateOfAdmission,
      expiryDate: DateTime(newDateOfAdmission.year, newDateOfAdmission.month + newPlan.months, newDateOfAdmission.day),
      address: address,
      gender: gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'height': height,
      'weight': weight,
      'photoUrl': photoUrl,
      'planId': planId,
      'dateOfAdmission': dateOfAdmission,
      'renewalDate': renewalDate,
      'expiryDate': expiryDate,
      'address': address,
      'gender': gender,
    };
  }
}
