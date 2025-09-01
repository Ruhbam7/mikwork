import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:hope/addposts.dart';
import 'package:hope/loginscreen.dart';
import 'package:hope/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hope/postsdetailsscreens.dart';
import 'package:hope/home.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Post');
  final TextEditingController _searchFilterController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final TextEditingController _editsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Registrations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 31, 56),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
          ),
          const SizedBox(width: 16),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ), // Replace 'HomePage' with the name of your home page widget
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _searchFilterController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: _ref.orderByChild('payment status').equalTo('pending'),
              defaultChild: const Center(child: CircularProgressIndicator()),
              itemBuilder: (context, snapshot, animation, index) {
                final String name =
                    snapshot.child('name').value?.toString() ?? '';
                final String mentor =
                    snapshot.child('mentor').value?.toString() ?? '';
                final String city =
                    snapshot.child('City').value?.toString() ?? '';
                final String club =
                    snapshot.child('Club').value?.toString() ?? '';
                final String pname =
                    snapshot.child('parent name').value?.toString() ?? '';
                final String ages =
                    snapshot.child('age').value?.toString() ?? '';
                final String dateS =
                    snapshot.child('DOS').value?.toString() ?? '';
                final String dateE =
                    snapshot.child('DOE').value?.toString() ?? '';
                final String pnumber =
                    snapshot.child('phone number').value?.toString() ?? '';
                final String address =
                    snapshot.child('Address').value?.toString() ?? '';
                final String id = snapshot.child('id').value?.toString() ?? '';
                final String dob =
                    snapshot.child('Dateofbirth').value?.toString() ?? '';
                final String paymentStatus =
                    snapshot.child('payment status').value?.toString() ?? '';
                final String subscriptionplan =
                    snapshot.child('Subscription Plan').value?.toString() ?? '';
                final String NumberofMagazine =
                    snapshot.child('Number of Magazine').value?.toString() ??
                    '';
                final String Magazinesent =
                    snapshot.child('Sent Editions').value?.toString() ?? '';

                if (_searchFilterController.text.isEmpty ||
                    name.toLowerCase().contains(
                      _searchFilterController.text.toLowerCase(),
                    ) ||
                    mentor.toLowerCase().contains(
                      _searchFilterController.text.toLowerCase(),
                    ) ||
                    city.toLowerCase().contains(
                      _searchFilterController.text.toLowerCase(),
                    ) ||
                    club.toLowerCase().contains(
                      _searchFilterController.text.toLowerCase(),
                    )) {
                  return _buildListTile(
                    context,
                    snapshot,
                    name,
                    mentor,
                    city,
                    club,
                    pname,
                    ages,
                    dateS,
                    dateE,
                    pnumber,
                    address,
                    id,
                    dob,
                    paymentStatus,
                    NumberofMagazine,
                    subscriptionplan,
                    Magazinesent,
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 1, 31, 56),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    DataSnapshot snapshot,
    String name,
    String mentor,
    String city,
    String club,
    String pname,
    String ages,
    String dateS,
    String dateE,
    String pnumber,
    String address,
    String id,
    String dob,
    String paymentStatus,
    String NumberofMagazine,
    String subscriptionplan,
    String magazinesent,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mentor: $mentor'),
            Text('City: $city'),
            Text('Club: $club'),
          ],
        ),
        trailing: _buildTrailingActions(
          context,
          name,
          mentor,
          city,
          club,
          pname,
          ages,
          dateS,
          dateE,
          pnumber,
          address,
          id,
          dob,
          paymentStatus,
          NumberofMagazine,
          subscriptionplan,
          magazinesent,
          snapshot,
        ),
      ),
    );
  }

  Widget _buildTrailingActions(
    BuildContext context,
    String name,
    String mentor,
    String city,
    String club,
    String pname,
    String ages,
    String dateS,
    String dateE,
    String pnumber,
    String address,
    String id,
    String dob,
    String paymentStatus,
    String subscriptionplan,
    String NumberofMagazine,
    String Magazinesent,
    DataSnapshot snapshot,
  ) {
    return SizedBox(
      width: 160,
      child: Row(
        children: [
          Switch(
            value: paymentStatus == 'paid',
            onChanged: (value) async {
              // Determine the new status based on the switch value
              String newStatus = value ? 'paid' : 'pending';
              // Update the payment status in the database
              await updatePaymentStatus(id, newStatus);
            },
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsScreen(
                      name: name,
                      mentor: mentor,
                      city: city,
                      club: club,
                      parentname: pname,
                      age: ages,
                      dateofStart: dateS,
                      dateofend: dateE,
                      phonenumber: pnumber,
                      address: address,
                      id: id,
                      dateofbirth: dob,
                      paymentStatus: paymentStatus,
                      subscriptionPlan: subscriptionplan,
                      numberOfMagazines: NumberofMagazine,
                      selectedMagazineEditions: [Magazinesent],
                    ),
                  ),
                );
              },
              child: const Text(
                'Full Detail',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.edit, color: Colors.black87),
                  title: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showmydialog(name, id, mentor);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    deleteRegistration(id);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    _auth
        .signOut()
        .then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const loginscreen()),
          );
        })
        .onError((error, stackTrace) {
          if(!mounted) return;
          Utils().toastmessage(context,error.toString());
        });
  }

  Future<void> updatePaymentStatus(String id, String status) async {
    try {
      DatabaseEvent event = await _ref.orderByChild('id').equalTo(id).once();
      if (event.snapshot.exists) {
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          // Convert the value to a Map<String, dynamic>
          Map<dynamic, dynamic> values =
              dataSnapshot.value as Map<dynamic, dynamic>;

          if (values.isNotEmpty) {
            String itemKey = values.keys.first.toString();
            await _ref
                .child(itemKey)
                .update({'payment status': status})
                .then((_) {
                  if(!mounted) return;
                  Utils().toastmessage(context,'Payment status updated successfully');
                })
                .onError((error, stackTrace) {
                  if(!mounted) return;
                  Utils().toastmessage(context,error.toString());
                });
          }
        }
      }
    } catch (e) {
      if(!mounted) return;
      Utils().toastmessage(context,'Error updating payment status: $e');
    }
  }

  Future<void> deleteRegistration(String id) async {
    try {
      DatabaseEvent event = await _ref.orderByChild('id').equalTo(id).once();
      if (event.snapshot.value != null) {
        DataSnapshot dataSnapshot = event.snapshot;
        Map<String, dynamic>? values =
            dataSnapshot.value as Map<String, dynamic>?;

        if (values != null && values.isNotEmpty) {
          String itemKey = values.keys.first;
          await _ref
              .child(itemKey)
              .remove()
              .then((_) {
                Utils().toastmessage(context,'Deleted Successfully');
              })
              .onError((error, stackTrace) {
                Utils().toastmessage(context,error.toString());
              });
        }
      }
    } catch (e) {
      Utils().toastmessage(context,'Error deleting registration: $e');
    }
  }

  Future<void> showmydialog(String name, String id, String mentor) async {
    _editController.text = name;
    _editsController.text = mentor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _editsController,
                decoration: const InputDecoration(labelText: 'Mentor'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 31, 56),
              ),
              child: const Text('Update'),
              onPressed: () async {
                Navigator.of(context).pop();
                DatabaseEvent event = await _ref
                    .orderByChild('id')
                    .equalTo(id)
                    .once();
                if (event.snapshot.value != null) {
                  DataSnapshot dataSnapshot = event.snapshot;
                  Map<String, dynamic>? values =
                      dataSnapshot.value as Map<String, dynamic>?;

                  if (values != null && values.isNotEmpty) {
                    String itemKey = values.keys.first;
                    await _ref
                        .child(itemKey)
                        .update({
                          'name': _editController.text.trim().toLowerCase(),
                          'mentor': _editsController.text.trim().toLowerCase(),
                        })
                        .then((_) {
                          Utils().toastmessage(context,'Updated Successfully');
                        })
                        .onError((error, stackTrace) {
                          Utils().toastmessage(context,error.toString());
                        });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
