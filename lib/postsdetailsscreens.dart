import 'package:flutter/material.dart';
import 'package:hope/pendingscreen.dart';

class PostDetailsScreen extends StatefulWidget {
  final String name;
  final String mentor;
  final String city;
  final String club;
  final String address;
  final String parentname;
  final String dateofStart;
  final String dateofend;
  final String age;
  final String phonenumber;
  final String id;
  final String dateofbirth;
  final String paymentStatus;
  final String subscriptionPlan;
  final String numberOfMagazines;
  final List<String> selectedMagazineEditions;

  const PostDetailsScreen({
    super.key,
    required this.name,
    required this.mentor,
    required this.city,
    required this.club,
    required this.address,
    required this.parentname,
    required this.dateofStart,
    required this.dateofend,
    required this.age,
    required this.phonenumber,
    required this.id,
    required this.dateofbirth,
    required this.paymentStatus,
    required this.subscriptionPlan,
    required this.numberOfMagazines,
    required this.selectedMagazineEditions,
  });

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late DateTime _selectedDateOfBirth;
  late DateTime _selectedDateOfStart;
  late DateTime _selectedDateOfEnd;

  @override
  void initState() {
    super.initState();
    _selectedDateOfBirth = DateTime.now();
    _selectedDateOfStart = DateTime.now();
    _selectedDateOfEnd = DateTime.now();
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 30)),
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Registration Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 31, 56),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PendingScreen()),
              ModalRoute.withName('/'),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', widget.name, Icons.person),
            _buildDetailRow('Mentor', widget.mentor, Icons.school),
            _buildDetailRow('City', widget.city, Icons.location_city),
            _buildDetailRow('Club', widget.club, Icons.sports),
            _buildDetailRow('Parent Name', widget.parentname, Icons.person_outline),
            _buildDetailRow('Address', widget.address, Icons.home),
            _buildDetailRow('Age', widget.age, Icons.cake),
            _buildDetailRow('Phone Number', widget.phonenumber, Icons.phone),
            _buildDetailRow('Payment Status', widget.paymentStatus, Icons.payment),
            _buildDetailRow('Number of Magazines Entitled', widget.numberOfMagazines, Icons.library_books),
            _buildDetailRow('Magazine Editions Sent', widget.selectedMagazineEditions.join(', '), Icons.library_books),
            _buildDetailRow('Subscription Plan', widget.subscriptionPlan, Icons.library_books),
            _buildDateRow('Date of Birth', _selectedDateOfBirth, () {
              _selectDate(
                context,
                _selectedDateOfBirth,
                (picked) => setState(() => _selectedDateOfBirth = picked),
              );
            }),
            _buildDateRow('Date of Start', _selectedDateOfStart, () {
              _selectDate(
                context,
                _selectedDateOfStart,
                (picked) => setState(() => _selectedDateOfStart = picked),
              );
            }),
            _buildDateRow('Date of End', _selectedDateOfEnd, () {
              _selectDate(
                context,
                _selectedDateOfEnd,
                (picked) => setState(() => _selectedDateOfEnd = picked),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime selectedDate, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedDate.toLocal().toString().split(' ')[0], style: const TextStyle(fontSize: 16, color: Colors.black)),
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onTap),
          ],
        ),
      ),
    );
  }
}
