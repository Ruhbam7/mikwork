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

  // Add these new methods for dynamic year generation
  Map<String, int> _getSubscriptionDetails(String plan) {
    switch (plan.trim().toLowerCase()) {
      case 'one year':
        return {'years': 1, 'magazines': 3};
      case 'two year':
        return {'years': 2, 'magazines': 6};
      case 'three year':
        return {'years': 3, 'magazines': 9};
      default:
        return {'years': 1, 'magazines': 3};
    }
  }

  List<String> _generateMagazineEditions(String subscriptionPlan) {
    final now = DateTime.now();
    final currentYear = now.year;
    final seasons = ['Spring', 'Summer', 'Winter'];
    final List<String> editions = [];

    final subscriptionDetails = _getSubscriptionDetails(subscriptionPlan);
    final yearsToGenerate = subscriptionDetails['years']!;

    // Handle special case for 6 months subscription
    if (subscriptionPlan.toLowerCase() == 'six months') {
      final currentMonth = now.month;
      if (currentMonth <= 3) {
        editions.add('Spring Edition $currentYear');
        editions.add('Summer Edition $currentYear');
      } else if (currentMonth <= 6) {
        editions.add('Summer Edition $currentYear');
        editions.add('Winter Edition $currentYear');
      } else {
        editions.add('Winter Edition $currentYear');
        editions.add('Spring Edition ${currentYear + 1}');
      }
      return editions;
    }

    // Generate editions for multi-year subscriptions
    for (int yearOffset = 0; yearOffset < yearsToGenerate; yearOffset++) {
      final year = currentYear + yearOffset;
      for (String season in seasons) {
        editions.add('$season Edition $year');
      }
    }

    return editions;
  }

  // Updated method to handle subscription plan changes intelligently
  List<String> _getAvailableEditionsForUpgrade(
      String currentPlan,
      String newPlan,
      Set<String> alreadySelected
      ) {
    final currentDetails = _getSubscriptionDetails(currentPlan);
    final newDetails = _getSubscriptionDetails(newPlan);

    // If upgrading to more years, only show additional years
    if (newDetails['years']! > currentDetails['years']!) {
      final now = DateTime.now();
      final currentYear = now.year;
      final seasons = ['Spring', 'Summer', 'Winter'];
      final List<String> additionalEditions = [];

      // Generate only the additional years
      for (int yearOffset = currentDetails['years']!; yearOffset < newDetails['years']!; yearOffset++) {
        final year = currentYear + yearOffset;
        for (String season in seasons) {
          additionalEditions.add('$season Edition $year');
        }
      }

      return additionalEditions;
    }

    // If downgrading or same, show all editions for the new plan
    return _generateMagazineEditions(newPlan);
  }

  int getAllowedBasedOnPlan(String plan) {
    return _getSubscriptionDetails(plan)['magazines']!;
  }

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

    // Store the original subscription plan
    String originalSubscriptionPlan = subscriptionPlan;

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
                                  children: [
                                    'One Year',
                                    'Two Year',
                                    'Three Year',
                                  ].map((plan) {
                                    return ListTile(
                                      title: Text(plan),
                                      onTap: () {
                                        setState(() {
                                          _editssController.text = plan;

                                          // Calculate total magazines for extension
                                          final originalDetails = _getSubscriptionDetails(originalSubscriptionPlan);
                                          final newDetails = _getSubscriptionDetails(plan);
                                          final totalMagazines = originalDetails['magazines']! + newDetails['magazines']!;

                                          _editMagazinesController.text = totalMagazines.toString();
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

                    const Text(
                      'Select Magazine Editions:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // CORRECTED: Pass correct parameters
                    _buildMagazineFilterChips(
                      selectedEditions,
                      _editssController.text,    // extension plan
                      originalSubscriptionPlan,  // original plan
                      setState,
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
                    final originalDetails = _getSubscriptionDetails(originalSubscriptionPlan);
                    final newDetails = _getSubscriptionDetails(_editssController.text);
                    final totalAllowed = originalDetails['magazines']! + newDetails['magazines']!;
                    int remaining = totalAllowed - selectedEditions.length;
                    String editionsString = selectedEditions.join(', ');

                    await _updateData(id, selectedEditions)
                        .then((_) => _updateNumberOfMagazines(id, remaining.toString()))
                        .then((_) {
                      // Navigator.pop(context);   // <-- closes AlertDialog
                      // setState(() {});          // <-- rebuild after Navigator.pop (dangerous)
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
// CORRECTED: Fixed helper method to generate ONLY extension years (not consecutive from highest)
  List<String> _generateAdditionalEditions(
      String originalSubscriptionPlan,
      String extensionSubscriptionPlan,
      Set<String> alreadySelectedEditions
      ) {
    final seasons = ['Spring', 'Summer', 'Winter'];
    final additionalEditions = <String>[];

    // Get the years covered by original subscription
    final originalYears = _getYearsCoveredByPlan(originalSubscriptionPlan);

    // Calculate the extension years based on original plan's end year
    final extensionYears = _calculateExtensionYears(originalSubscriptionPlan, extensionSubscriptionPlan);

    // Generate editions ONLY for the calculated extension years
    for (int year in extensionYears) {
      for (String season in seasons) {
        final edition = '$season Edition $year';
        // Only add if not already selected
        if (!alreadySelectedEditions.contains(edition)) {
          additionalEditions.add(edition);
        }
      }
    }

    return additionalEditions;
  }

// NEW: Helper method to get years covered by original subscription plan
  List<int> _getYearsCoveredByPlan(String subscriptionPlan) {
    final now = DateTime.now();
    final currentYear = now.year;
    final details = _getSubscriptionDetails(subscriptionPlan);
    final years = <int>[];

    for (int i = 0; i < details['years']!; i++) {
      years.add(currentYear + i);
    }

    return years;
  }

// NEW: Helper method to calculate extension years based on original plan
  List<int> _calculateExtensionYears(String originalPlan, String extensionPlan) {
    final originalYears = _getYearsCoveredByPlan(originalPlan);
    final extensionDetails = _getSubscriptionDetails(extensionPlan);
    final extensionYears = <int>[];

    // Extension years start from the year after original plan ends
    final originalEndYear = originalYears.last;

    for (int i = 1; i <= extensionDetails['years']!; i++) {
      extensionYears.add(originalEndYear + i);
    }

    return extensionYears;
  }

  // REPLACE your existing _buildMagazineFilterChips with this one
  Widget _buildMagazineFilterChips(
      Set<String> selectedEditions,
      String newSubscriptionPlan,        // extension plan (from _editssController.text)
      String originalSubscriptionPlan,   // original plan
      StateSetter setState,
      ) {
    // Plan details
    final originalDetails = _getSubscriptionDetails(originalSubscriptionPlan);
    final newDetails = _getSubscriptionDetails(newSubscriptionPlan);
    final int totalAllowed = originalDetails['magazines']! + newDetails['magazines']!;

    // Years covered by original plan and by extension
    final originalYears = _getYearsCoveredByPlan(originalSubscriptionPlan);
    final extensionYears = _calculateExtensionYears(originalSubscriptionPlan, newSubscriptionPlan);

    // Helper: seasons per year
    const seasons = ['Spring', 'Summer', 'Winter'];

    // Build ALL editions that belong to the original plan years
    final allOriginalEditions = <String>{
      for (final y in originalYears) ...seasons.map((s) => '$s Edition $y'),
    };

    // Split currently selected into original vs extension (for display)
    final originalSelectedEditions = selectedEditions.where((edition) {
      final year = _extractYearFromEdition(edition);
      return originalYears.contains(year);
    }).toSet();

    final extensionSelectedEditions = selectedEditions.where((edition) {
      final year = _extractYearFromEdition(edition);
      return extensionYears.contains(year);
    }).toSet();

    // Pending = original plan editions the user did NOT choose during Add
    final pendingOriginalEditions =
    allOriginalEditions.difference(originalSelectedEditions);

    // Generate ONLY extension-year editions still available (not already chosen)
    final availableExtensionEditions = _generateAdditionalEditions(
      originalSubscriptionPlan,
      newSubscriptionPlan,
      selectedEditions,
    );

    // Utility to update remaining count after a toggle
    void _refreshRemaining() {
      final remaining = totalAllowed - selectedEditions.length;
      _editMagazinesController.text = remaining.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Info summary ---
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Original Plan: $originalSubscriptionPlan (${originalYears.join(', ')})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                'Extension: +$newSubscriptionPlan (${extensionYears.join(', ')})',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Total Magazines: $totalAllowed | Selected: ${selectedEditions.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // --- Original (already selected; read-only) ---
        if (originalSelectedEditions.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Original Subscription (Already Selected):',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: originalSelectedEditions.map((edition) {
              return FilterChip(
                label: Text(edition),
                selected: true,
                onSelected: null, // read-only
                selectedColor: Colors.grey[300],
                checkmarkColor: Colors.grey[600],
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],

        // --- Pending (from original plan; can select now) ---
        if (pendingOriginalEditions.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Pending Editions (Original Plan):',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: pendingOriginalEditions.map((edition) {
              final isSelected = selectedEditions.contains(edition);
              return FilterChip(
                label: Text(edition),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected && selectedEditions.length >= totalAllowed) {
                    Utils().toastmessage(
                      context,
                      "You have reached the limit of $totalAllowed magazines for this plan.",
                    );
                    return;
                  }
                  setState(() {
                    if (selected) {
                      selectedEditions.add(edition);
                    } else {
                      selectedEditions.remove(edition);
                    }
                    _refreshRemaining();
                  });
                },
                selectedColor:
                const Color.fromARGB(255, 255, 205, 210).withValues(alpha: 0.6),
                checkmarkColor: Colors.red,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],

        // --- Extension (already selected from extension years; read-only) ---
        if (extensionSelectedEditions.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Extension - Already Selected:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: extensionSelectedEditions.map((edition) {
              return FilterChip(
                label: Text(edition),
                selected: true,
                onSelected: null, // read-only
                selectedColor: Colors.grey[300],
                checkmarkColor: Colors.grey[600],
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],

        // --- Extension (available to select) ---
        if (availableExtensionEditions.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Available Extension Editions (${extensionYears.join(', ')}):',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: availableExtensionEditions.map((edition) {
              return FilterChip(
                label: Text(edition),
                selected: false,
                onSelected: (selected) {
                  if (selected && selectedEditions.length >= totalAllowed) {
                    Utils().toastmessage(
                      context,
                      "You have reached the limit of $totalAllowed magazines for this plan.",
                    );
                    return;
                  }
                  setState(() {
                    if (selected) {
                      selectedEditions.add(edition);
                      _refreshRemaining();
                    }
                  });
                },
                selectedColor:
                const Color.fromARGB(255, 1, 31, 56).withOpacity(0.2),
                checkmarkColor: const Color.fromARGB(255, 1, 31, 56),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: const Color.fromARGB(255, 1, 31, 56).withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],

        // Completion message when limit hit and nothing else to pick
        if (availableExtensionEditions.isEmpty &&
            selectedEditions.length >= totalAllowed)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All magazines selected!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Progress
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Extension Progress: ${extensionSelectedEditions.length}/${newDetails['magazines']!} selected',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Progress: ${selectedEditions.length}/$totalAllowed magazines',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }



// NEW: Helper method to extract year from edition string
  int _extractYearFromEdition(String edition) {
    final yearMatch = RegExp(r'\b(20\d{2})\b').firstMatch(edition);
    return yearMatch != null ? int.parse(yearMatch.group(0)!) : 0;
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
