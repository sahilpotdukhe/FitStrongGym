import 'package:arjunagym/Screens/MemberCard.dart';
import 'package:arjunagym/Screens/MemberDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Member> memberList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.getAllMembers().then((list) {
      setState(() {
        memberList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          onChanged: (val) {
            setState(() {
              query = val;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => searchController.clear());
              setState(() {
                query = "";
              });
            },
          ),
        ],
      ),
      body: query.isEmpty
          ? Center(child: Text('No results found.'))
          : buildSuggestions(query),
    );
  }

  buildSuggestions(String query) {
    final List<Member> suggestionList = query.isEmpty
        ? []
        : memberList.where((Member member) {
      String getName = member.name.toLowerCase();
      String queryLower = query.toLowerCase();
      return getName.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Member searchedMember = suggestionList[index];
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDetailsPage(member: searchedMember)));
          },
          child: MemberCard(member: searchedMember)
          // ListTile(
          //   leading: CircleAvatar(
          //     backgroundImage: NetworkImage(
          //         searchedMember.photoUrl.isNotEmpty
          //             ? searchedMember.photoUrl
          //             : 'https://icons.veryicon.com/png/o/miscellaneous/administration/person-16.png'),
          //   ),
          //   title: Text(searchedMember.name),
          //   subtitle: Text('Plan: ${searchedMember.dateOfBirth}'),
          //
          // ),
        );
      },
    );
  }
}
