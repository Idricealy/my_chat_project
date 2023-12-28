import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_project/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  void _showEditProfileModal(BuildContext context, String currentUsername, String currentBio) {
    String newUsername = currentUsername;
    String newBio = currentBio;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit your profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  newUsername = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your new username',
                ),
                controller: TextEditingController(text: currentUsername),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  newBio = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your new bio',
                ),
                maxLines: 3,
                controller: TextEditingController(text: currentBio),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final currentUser = _auth.currentUser;
                  if (currentUser != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .update({
                      'displayName': newUsername,
                      'bio': newBio,
                    });
                  }
                  Navigator.pop(context); // Close the modal
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserID = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Users available'),
        actions: [
          if (currentUserID != null)
            GestureDetector(
              onTap: () async {
                final currentUser = await FirebaseFirestore.instance.collection('users').doc(currentUserID).get();
                final currentUsername = currentUser['displayName'];
                final currentBio = currentUser['bio'];
                _showEditProfileModal(context, currentUsername, currentBio);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://png.pngtree.com/png-vector/20220709/ourmid/pngtree-businessman-user-avatar-wearing-suit-with-red-tie-png-image_5809521.png',
                ),
              ),
            ),
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    final currentUserID = _auth.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading....');
        }

        final userList =
        snapshot.data!.docs.where((doc) => doc.id != currentUserID);

        return ListView(
          children: userList
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return ListTile(
      title: Text(data['displayName'] != null ? data['displayName'] : "No name"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserMail: data['displayName'],
              receiverUserID: data['id'],
            ),
          ),
        );
      },
    );
  }
}
