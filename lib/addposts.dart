import 'package:flutter/material.dart';
import 'package:hope/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hope/utils.dart';
import 'package:intl/intl.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final mentorNameController = TextEditingController();
  final subscriberNameController = TextEditingController();
  final parentNameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final clubController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final dobController = TextEditingController();
  final numberOfMagazinesController = TextEditingController();

  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  DateTime? selectedDOB = DateTime.now();
  DateTime? selectedStartDate = DateTime.now();
  DateTime? selectedEndDate = DateTime.now();
  String selectedPaymentStatus = 'pending';
  String selectedSubscriptionPlan = 'One Year';
  Set<String> selectedMagazineEditions = {};
  int totalMagazinesAllowed = 3; // default for One Year

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Registration Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: mentorNameController,
                label: 'Mentor Name',
              ),
              _buildTextField(
                controller: subscriberNameController,
                label: 'Subscriber Name',
              ),
              _buildTextField(
                controller: parentNameController,
                label: 'Parent Name',
              ),
              _buildDateField(
                dobController,
                'Date of Birth',
                () => _selectDate(
                  context,
                  selectedDOB,
                  dobController,
                  isDOB: true,
                ),
              ),
              _buildTextField(controller: ageController, label: 'Age'),
              _buildTextField(
                controller: phoneNumberController,
                label: 'Phone Number',
              ),
              _buildTextField(controller: clubController, label: 'Club'),
              _buildTextField(controller: addressController, label: 'Address'),
              _buildTextField(controller: cityController, label: 'City'),
              _buildSubscriptionDropdown(),
              _buildTextField(
                controller: numberOfMagazinesController,
                label: 'Number of Magazines',
                readOnly: true,
              ),
              _buildMagazineCheckboxList(),
              _buildDateField(
                startDateController,
                'Subscription Start Date',
                () => _selectDate(
                  context,
                  selectedStartDate,
                  startDateController,
                ),
              ),
              _buildDateField(
                endDateController,
                'Subscription End Date',
                () => _selectDate(context, selectedEndDate, endDateController),
              ),
              _buildPaymentDropdown(),
              const SizedBox(height: 20),
              roundbutton(title: 'ADD', loading: loading, ontap: _submitForm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label,
    Function onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? selectedDate,
    TextEditingController controller, {
    bool isDOB = false,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
        if (isDOB) {
          ageController.text = (DateTime.now().year - picked.year).toString();
        }
      });
    }
  }

  Widget _buildSubscriptionDropdown() {
    return _buildDropdown(
      label: 'Subscription Plan',
      value: selectedSubscriptionPlan,
      items: [
        'One Year', 
        'Two Year', 
        'Three Year',
      ],
      onChanged: (String? newValue) {
        setState(() {
          selectedSubscriptionPlan = newValue!;
          _updateSubscriptionDetails();
        });
      },
    );
  }

  Widget _buildPaymentDropdown() {
    return _buildDropdown(
      label: 'Payment Status',
      value: selectedPaymentStatus,
      items: ['pending', 'paid', 'cancelled'],
      onChanged: (String? newValue) =>
          setState(() => selectedPaymentStatus = newValue!),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // Enhanced method for more flexible subscription plans
  Map<String, int> _getSubscriptionDetails(String plan) {
    switch (plan) {
      case 'One Year':
        return {'years': 1, 'magazines': 3};
      case 'Two Year':
        return {'years': 2, 'magazines': 6};
      case 'Three Year':
        return {'years': 3, 'magazines': 9};
      default:
        return {'years': 1, 'magazines': 3};
    }
  }

  List<String> _generateMagazineEditions() {
    final now = DateTime.now();
    final currentYear = now.year;
    final seasons = ['Spring', 'Summer', 'Winter'];
    final List<String> editions = [];
    
    final subscriptionDetails = _getSubscriptionDetails(selectedSubscriptionPlan);
    final yearsToGenerate = subscriptionDetails['years']!;
    
    // Handle special case for 6 months subscription
    // if (selectedSubscriptionPlan == 'Six Months') {
    //   final currentMonth = now.month;
    //   if (currentMonth <= 3) {
    //     editions.add('Spring Edition $currentYear');
    //     editions.add('Summer Edition $currentYear');
    //   } else if (currentMonth <= 6) {
    //     editions.add('Summer Edition $currentYear');
    //     editions.add('Winter Edition $currentYear');
    //   } else {
    //     editions.add('Winter Edition $currentYear');
    //     editions.add('Spring Edition ${currentYear + 1}');
    //   }
    //   return editions;
    // }
    
    // Generate editions for multi-year subscriptions
    for (int yearOffset = 0; yearOffset < yearsToGenerate; yearOffset++) {
      final year = currentYear + yearOffset;
      for (String season in seasons) {
        editions.add('$season Edition $year');
      }
    }
    
    return editions;
  }

  Widget _buildMagazineCheckboxList() {
    final magazineEditions = _generateMagazineEditions();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 8),
          child: Text(
            'Select Magazine Editions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: magazineEditions.map((edition) {
            return FilterChip(
              label: Text(edition),
              selected: selectedMagazineEditions.contains(edition),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (selectedMagazineEditions.length <
                        totalMagazinesAllowed) {
                      selectedMagazineEditions.add(edition);
                    } else {
                      Utils().toastmessage(context,
                        "You can only select $totalMagazinesAllowed editions.",
                      );
                    }
                  } else {
                    selectedMagazineEditions.remove(edition);
                  }
                  numberOfMagazinesController.text =
                      (totalMagazinesAllowed - selectedMagazineEditions.length)
                          .toString();
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _updateSubscriptionDetails() {
    final now = DateTime.now();
    selectedStartDate = now;
    
    final subscriptionDetails = _getSubscriptionDetails(selectedSubscriptionPlan);
    final years = subscriptionDetails['years']!;
    totalMagazinesAllowed = subscriptionDetails['magazines']!;

    // Calculate end date based on subscription plan
    if (selectedSubscriptionPlan == 'Six Months') {
      selectedEndDate = DateTime(now.year, now.month + 6, now.day);
    } else {
      selectedEndDate = DateTime(now.year + years, now.month, now.day);
    }

    selectedMagazineEditions.clear();
    numberOfMagazinesController.text = totalMagazinesAllowed.toString();
    startDateController.text = DateFormat(
      'dd-MM-yyyy',
    ).format(selectedStartDate!);
    endDateController.text = DateFormat('dd-MM-yyyy').format(selectedEndDate!);
  }

  void _submitForm() {
    setState(() => loading = true);
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    databaseRef
        .child(id)
        .set({
          'mentor': mentorNameController.text,
          'name': subscriberNameController.text,
          'parent name': parentNameController.text,
          'age': ageController.text,
          'phone number': phoneNumberController.text,
          'DOS': startDateController.text,
          'DOE': endDateController.text,
          'Club': clubController.text,
          'City': cityController.text,
          'Address': addressController.text,
          'Date of Birth': dobController.text,
          'id': id,
          'payment status': selectedPaymentStatus,
          'Subscription Plan': selectedSubscriptionPlan,
          'Number of Magazine': numberOfMagazinesController.text,
          'Sent Editions': selectedMagazineEditions.toList(),
        })
        .then((_) {
          if(!mounted) return;
          Utils().toastmessage(context,'REGISTRATION ADDED');
          setState(() => loading = false);
        })
        .catchError((error) {
          if(!mounted) return;
          Utils().toastmessage(context,error.toString());
          setState(() => loading = false);
        });
  }
}
