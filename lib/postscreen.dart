import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:hope/addposts.dart';
import 'package:hope/home.dart';
import 'package:hope/loginscreen.dart';
import 'package:hope/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hope/postdetailsscreen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Post');
  final TextEditingController _searchFilterController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final TextEditingController _editsController = TextEditingController();
  final TextEditingController _editssController = TextEditingController();
  final TextEditingController _editMagazinesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Current Registrations',
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
              query: _ref.orderByChild('payment status').equalTo('paid'),
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

                if (_searchFilterController.text.isEmpty) {
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
                } else if (name.toLowerCase().contains(
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
    String magazinesent,
    String subscriptionplan,
  ) {
    int totalAllowed = getAllowedBasedOnPlan(subscriptionplan);
    int sentCount = magazinesent
        .split(', ')
        .where((e) => e.trim().isNotEmpty)
        .length;
    int remaining = totalAllowed - sentCount;
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
            // 👈 NEW LINE
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

  int getAllowedBasedOnPlan(String plan) {
    switch (plan.trim().toLowerCase()) {
      case 'one year':
        return 3;
      case 'two year':
        return 6;
      case 'three year':
        return 9;
      default:
        return 0;
    }
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
    String NumberofMagazine,
    String subscriptionplan,
    String magazinesent,
    DataSnapshot snapshot,
  ) {
    Set<String> selectedEditions = magazinesent.split(', ').toSet();

    return SizedBox(
      width: 160,
      child: Row(
        children: [
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
                      selectedMagazineEditions: magazinesent
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
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
                    showMyDialog(snapshot);
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
                    _deleteItem(context, id);
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
          Utils().toastmessage(context,error.toString());
        });
  }

  Future<void> _deleteItem(BuildContext context, String id) async {
    DatabaseEvent event = await _ref.orderByChild('id').equalTo(id).once();

    if (event.snapshot.value != null) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<String, dynamic> values = Map.from(dataSnapshot.value as Map);

      if (values.isNotEmpty) {
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
  }

  Future<void> showMyDialog(DataSnapshot snapshot) async {
    final String name = snapshot.child('name').value?.toString() ?? '';
    final String mentor = snapshot.child('mentor').value?.toString() ?? '';
    final String id = snapshot.child('id').value?.toString() ?? '';
    final String numberOfMagazine =
        snapshot.child('Number of Magazine').value?.toString() ?? '';
    final String subscriptionPlan =
        snapshot.child('Subscription Plan').value?.toString() ?? '';
    _editController.text = name;
    _editsController.text = mentor;
    _editMagazinesController.text = numberOfMagazine;
    _editssController.text = subscriptionPlan;

    dynamic rawEditions = snapshot.child('Sent Editions').value;

    Set<String> selectedEditions = {};
    if (rawEditions is List) {
      selectedEditions = rawEditions.map((e) => e.toString()).toSet();
    } else if (rawEditions is String) {
      selectedEditions = rawEditions.split(', ').toSet();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Update',
                style: TextStyle(color: Color.fromARGB(255, 1, 31, 56)),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _editController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _editsController,
                      decoration: const InputDecoration(
                        labelText: 'Mentor',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _editssController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Subscription Plan',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Change Subscription Plan"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      [
                                        'One Year',
                                        'Two Year',
                                        'Three Year',
                                      ].map((plan) {
                                        return ListTile(
                                          title: Text(plan),
                                          onTap: () {
                                            setState(() {
                                              _editssController.text = plan;
                                              selectedEditions
                                                  .clear(); // clear existing
                                              _editMagazinesController.text =
                                                  getAllowedBasedOnPlan(
                                                    plan,
                                                  ).toString();
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      }).toList(),
                                ),
                              ),
                            );
                          },
                          child: const Text("Change"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    TextField(
                      controller: _editMagazinesController,
                      decoration: const InputDecoration(
                        labelText: 'Number of Magazines Entitled',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),

                    // NEW: Show current selected editions
                    if (selectedEditions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Currently Selected: ${selectedEditions.join(', ')}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                    const Text(
                      'Select Magazine Editions:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    CheckboxListTile(
                      title: const Text('Spring Edition 2025'),
                      value: selectedEditions.contains('Spring Edition 2025'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(
                            context,"You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Spring Edition 2025');
                          } else {
                            selectedEditions.remove('Spring Edition 2025');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Summer Edition 2025'),
                      value: selectedEditions.contains('Summer Edition 2025'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(
                            context,"You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Summer Edition 2025');
                          } else {
                            selectedEditions.remove('Summer Edition 2025');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Winter Edition 2025'),
                      value: selectedEditions.contains('Winter Edition 2025'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(context,
                            "You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Winter Edition 2025');
                          } else {
                            selectedEditions.remove('Winter Edition 2025');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Spring Edition 2026'),
                      value: selectedEditions.contains('Spring Edition 2026'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(context,
                            "You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Spring Edition 2026');
                          } else {
                            selectedEditions.remove('Spring Edition 2026');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Summer Edition 2026'),
                      value: selectedEditions.contains('Summer Edition 2026'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(context,
                            "You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Summer Edition 2026');
                          } else {
                            selectedEditions.remove('Summer Edition 2026');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Winter Edition 2026'),
                      value: selectedEditions.contains('Winter Edition 2026'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(context,
                            "You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Winter Edition 2026');
                          } else {
                            selectedEditions.remove('Winter Edition 2026');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Spring Edition 2027'),
                      value: selectedEditions.contains('Spring Edition 2027'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(context,
                            "You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Spring Edition 2027');
                          } else {
                            selectedEditions.remove('Spring Edition 2027');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Summer Edition 2027'),
                      value: selectedEditions.contains('Summer Edition 2027'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(context,
                            "You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Summer Edition 2027');
                          } else {
                            selectedEditions.remove('Summer Edition 2027');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Winter Edition 2027'),
                      value: selectedEditions.contains('Winter Edition 2027'),
                      onChanged: (value) {
                        int totalAllowed = getAllowedBasedOnPlan(
                          _editssController.text,
                        );

                        if (value == true &&
                            selectedEditions.length >= totalAllowed) {
                          Utils().toastmessage(context,
                            "You have reached the limit. Please change the subscription plan to select more editions.",
                          );
                          return; // prevent adding more
                        }

                        setState(() {
                          if (value == true) {
                            selectedEditions.add('Winter Edition 2027');
                          } else {
                            selectedEditions.remove('Winter Edition 2027');
                          }
                          _editMagazinesController.text =
                              (totalAllowed - selectedEditions.length)
                                  .toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    int totalAllowed = getAllowedBasedOnPlan(
                      _editssController.text,
                    );
                    int remaining = totalAllowed - selectedEditions.length;
                    String newStartDate = DateTime.now()
                        .toIso8601String()
                        .split('T')[0];
                    String editionsString = selectedEditions.join(', ');
                    await _updateData(id, selectedEditions)
                        .then(
                          (_) => _updateNumberOfMagazines(
                            id,
                            remaining.toString(),
                          ),
                        )
                        .then((_) {
                          Navigator.pop(context);
                          setState(() {}); // refresh FirebaseAnimatedList
                        })
                        .catchError((error) {
                          Utils().toastmessage(context,error.toString());
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateData(String id, Set<String> selectedEditions) async {
    DatabaseEvent event = await _ref.orderByChild('id').equalTo(id).once();

    if (event.snapshot.value != null) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<String, dynamic> values = Map<String, dynamic>.from(
        dataSnapshot.value as Map<dynamic, dynamic>,
      );

      if (values.isNotEmpty) {
        String itemKey = values.keys.first;

        // Convert Set<String> to a comma-separated string for Firebase
        String editionsString = selectedEditions.join(', ');

        await _ref
            .child(itemKey)
            .update({
              'name': _editController.text,
              'mentor': _editsController.text,
              'Sent Editions': editionsString,
            })
            .then((_) {
               if(!mounted) return;
              Utils().toastmessage(context,'Updated Successfully');
            })
            .catchError((error) {
               if(!mounted) return;
              Utils().toastmessage(context,error.toString());
            });
      }
    }
  }

  Future<void> _updateNumberOfMagazines(
    String id,
    String numberOfMagazines,
  ) async {
    DatabaseEvent event = await _ref.orderByChild('id').equalTo(id).once();

    if (event.snapshot.value != null) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<String, dynamic> values = Map<String, dynamic>.from(
        dataSnapshot.value as Map<dynamic, dynamic>,
      );

      if (values.isNotEmpty) {
        String itemKey = values.keys.first;

        await _ref
            .child(itemKey)
            .update({'Number of Magazine': numberOfMagazines})
            .then((_) {
               if(!mounted) return;
              Utils().toastmessage(context,'Number of Magazines Updated Successfully');
            })
            .catchError((error) {
               if(!mounted) return;
              Utils().toastmessage(context,error.toString());
            });
      }
    }
  }

  Future<void> _showMagazineEditDialog(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Number of Magazines'),
          content: TextField(
            controller: _editMagazinesController,
            decoration: const InputDecoration(labelText: 'Number of Magazines'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateNumberOfMagazines(id, _editMagazinesController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
