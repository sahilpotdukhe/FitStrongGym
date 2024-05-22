import 'package:arjunagym/Models/MemberModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MemberProvider with ChangeNotifier {
  List<Member> _members = [];
  List<Member> _recycleBinMembers = [];

  List<Member> get members => _members;
  List<Member> get recycleBinMembers => _recycleBinMembers;

  MemberProvider() {
    // Fetch members when the provider is initialized
    getAllMembers();
  }

  Future<List<Member>> getAllMembers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('members').get();
      _members = querySnapshot.docs.map((doc) => _memberFromSnapshot(doc)).toList();
      notifyListeners();
      return _members;
    } catch (error) {
      print('Error fetching members: $error');
      return [];
    }
  }

  Future<void> fetchRecycleBinMembers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('recyclebin').get();
      _recycleBinMembers = querySnapshot.docs.map((doc) => _memberFromSnapshot(doc)).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching recycle bin members: $error');
    }
  }

  Future<void> restoreMember(Member member) async {
    try {
      await FirebaseFirestore.instance.collection('recyclebin').doc(member.id).delete();
      await FirebaseFirestore.instance.collection('members').doc(member.id).set(member.toMap());
      await fetchRecycleBinMembers();
      await getAllMembers();
      notifyListeners();
    } catch (error) {
      print('Error restoring member: $error');
    }
  }
  Member _memberFromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Member(
      id: doc.id,
      name: data['name'],
      mobileNumber: data['mobileNumber'],
      dateOfBirth: (data['dateOfBirth'] as Timestamp)?.toDate() ?? DateTime.now(),
      height: data['height'],
      weight: data['weight'],
      photoUrl: data['photoUrl'],
      planId: data['planId'],
      dateOfAdmission: (data['dateOfAdmission'] as Timestamp)?.toDate() ?? DateTime.now(),
      expiryDate: (data['expiryDate'] as Timestamp)?.toDate() ?? DateTime.now(),
      address: data['address'],
      gender: data['gender'],
    );
  }

  Future<void> addMember(Member member, XFile photo) async {
    final storageRef = FirebaseStorage.instance.ref().child('member_photos/${member.name}.jpg');
    final uploadTask = storageRef.putFile(File(photo.path));
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();

    final memberData = {
      'name': member.name,
      'mobileNumber': member.mobileNumber,
      'dateOfBirth': member.dateOfBirth,
      'height': member.height,
      'weight': member.weight,
      'photoUrl': downloadUrl,
      'planId': member.planId,
      'dateOfAdmission': member.dateOfAdmission,
      'expiryDate': member.expiryDate,
      'address': member.address,
      'gender': member.gender,
    };

    final docRef = await FirebaseFirestore.instance.collection('members').add(memberData);
    final newMember = member.copyWith(id: docRef.id);
    _members.add(newMember);
    notifyListeners();
  }

  Future<void> fetchActiveMembers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('expiryDate', isGreaterThan: Timestamp.now())
          .get();
      _members = querySnapshot.docs.map((doc) => _memberFromSnapshot(doc)).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching active members: $error');
    }
  }

  Future<void> fetchExpiredMembers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('expiryDate', isLessThanOrEqualTo: Timestamp.now())
          .get();
      _members = querySnapshot.docs.map((doc) => _memberFromSnapshot(doc)).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching expired members: $error');
    }
  }
  // Future<List<Member>> fetchExpiredMembers() async {
  //   try {
  //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('members')
  //         .where('expiryDate', isLessThanOrEqualTo: Timestamp.now())
  //         .get();
  //     return querySnapshot.docs.map((doc) => _memberFromSnapshot(doc)).toList();
  //   } catch (error) {
  //     print('Error fetching expired members: $error');
  //     return [];
  //   }
  // }
  //
  // Future<List<Member>> fetchActiveMembers() async {
  //   try {
  //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('members')
  //         .where('expiryDate', isGreaterThan: Timestamp.now())
  //         .get();
  //     return querySnapshot.docs.map((doc) => _memberFromSnapshot(doc)).toList();
  //   } catch (error) {
  //     print('Error fetching active members: $error');
  //     return [];
  //   }
  // }
  Future<void> updateMember(Member member) async {
    try {
      await FirebaseFirestore.instance.collection('members').doc(member.id).update({
        'name': member.name,
        'mobileNumber': member.mobileNumber,
        'dateOfBirth': member.dateOfBirth,
        'height': member.height,
        'weight': member.weight,
        'photoUrl': member.photoUrl,
        'planId': member.planId,
        'dateOfAdmission': member.dateOfAdmission,
        'expiryDate': member.expiryDate,
        'address': member.address,
        'gender': member.gender,
      });
      int index = _members.indexWhere((m) => m.id == member.id);
      if (index != -1) {
        _members[index] = member;
        notifyListeners();
      }
    } catch (error) {
      print('Error updating member: $error');
      throw error;
    }
  }

  Future<void> deleteMember(Member member) async {
    try {
      await FirebaseFirestore.instance.collection('recyclebin').doc(member.id).set(member.toMap());
      await FirebaseFirestore.instance.collection('members').doc(member.id).delete();

      _members.removeWhere((m) => m.id == member.id);
      notifyListeners();
    } catch (error) {
      print('Error deleting member: $error');
    }
  }

  // Future<void> restoreMember(Member member) async {
  //   try {
  //     // Delete the member from the recycle bin collection
  //     await FirebaseFirestore.instance.collection('recyclebin').doc(member.id).delete();
  //
  //     // Add the member back to the members collection
  //     await FirebaseFirestore.instance.collection('members').doc(member.id).set(member.toMap());
  //
  //     _members.add(member); // Add the member back to the local list
  //     notifyListeners();
  //   } catch (error) {
  //     print('Error restoring member: $error');
  //   }
  // }
  // Future<List<Member>> fetchAllMembers() async {
  //   try {
  //     // Fetch active members
  //     final Future<List<Member>> activeMembersFuture = fetchActiveMembers();
  //
  //     // Fetch expired members
  //     final Future<List<Member>> expiredMembersFuture = fetchExpiredMembers();
  //
  //     // Wait for both futures to complete
  //     final List<List<Member>> results = await Future.wait([activeMembersFuture, expiredMembersFuture]);
  //
  //     // Combine active and expired members into a single list
  //     final List<Member> allMembers = [];
  //     for (final membersList in results) {
  //       allMembers.addAll(membersList);
  //     }
  //
  //     print('Fetched all members: $allMembers');
  //     return allMembers;
  //   } catch (error) {
  //     print('Error fetching all members: $error');
  //     return [];
  //   }
  // }
  // Fetch recycle bin members
  // Future<List<Member>> fetchRecycleBinMembers() async {
  //   try {
  //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('recyclebin').get();
  //     return querySnapshot.docs.map((doc) => _memberFromSnapshot(doc)).toList();
  //   } catch (error) {
  //     print('Error fetching recycle bin members: $error');
  //     return [];
  //   }
  // }

}
