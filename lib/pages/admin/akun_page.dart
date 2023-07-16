import 'package:finance_flutter/pages/admin/create_users_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'users')
        .get();
    setState(() {
      _users = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index].data();
          final name = user['nama'];
          final email = user['email'];
          return Dismissible(
            key: Key(_users[index].id), // Assuming each user document has an 'id' field
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16),
            ),
            // background: Container(
            //   color: Colors.blue,
            //   child: Icon(Icons.edit),
            //   alignment: Alignment.centerLeft,
            //   padding: EdgeInsets.only(left: 16),
            // ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // Show confirmation dialog for delete
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete User'),
                      content: Text('Are you sure you want to delete this user?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false); // Cancel dismiss
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(context).pop(true); // Confirm dismiss
                          },
                        ),
                      ],
                    );
                  },
                );
              } 
              return false; // Do not dismiss by default
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // Delete the user
                final userId = _users[index].id;
                _deleteUser(userId);
              }
            },
            child: Card(
              child: ListTile(
                title: Text(name),
                subtitle: Text(email),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add code to navigate to create user page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateUserPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteUser(String userId) async {
  try {
    await _firestore.collection('users').doc(userId).delete();
    setState(() {
      // Remove the deleted user from the list
      _users.removeWhere((user) => user.id == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User deleted successfully'),
      ),
    );
    _fetchUsers();

  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting user'),
      ),
    );
  }
}
}
