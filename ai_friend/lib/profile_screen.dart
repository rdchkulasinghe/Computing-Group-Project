import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_friend/backend/collect_data.dart';

class ProfileScreen extends StatefulWidget {
  final UserData userData;
  final Function(UserData updatedUser) onProfileSaved;

  const ProfileScreen({
    Key? key,
    required this.userData,
    required this.onProfileSaved,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController pronounsController;
  late TextEditingController bioController;
  late TextEditingController interestController;
  late List<String> interests;
  DateTime? selectedBirthday;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData.name);
    pronounsController = TextEditingController(text: widget.userData.pronouns);
    bioController = TextEditingController(text: widget.userData.bio);
    interestController = TextEditingController();
    interests = List.from(widget.userData.interests);
    selectedBirthday = widget.userData.birthday;
  }

  void _saveProfile() async {
    final updatedUser = widget.userData.copyWith(
      name: nameController.text.trim(),
      pronouns: pronounsController.text.trim(),
      bio: bioController.text.trim(),
      interests: interests,
      birthday: selectedBirthday,
    );

    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedUser.userId)
        .update(updatedUser.toJson());

    widget.onProfileSaved(updatedUser);
    Navigator.pop(context);
  }

  void _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthday ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedBirthday = picked;
      });
    }
  }

  String _formatBirthday(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(221, 20, 6, 121),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(221, 20, 6, 121),
              Color.fromARGB(255, 28, 20, 151),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Name', nameController),
                        const SizedBox(height: 16),
                        _buildTextField(
                            'Pronouns (e.g., she/her)', pronounsController),
                        const SizedBox(height: 16),
                        _buildTextField('Bio', bioController, maxLines: 3),
                        const SizedBox(height: 20),

                        // Birthday Section
                        Text(
                          'Birthday',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedBirthday != null
                                    ? _formatBirthday(selectedBirthday!)
                                    : 'Select your birthday',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_today,
                                    color: Colors.white),
                                onPressed: _pickBirthday,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Interests Section
                        Text(
                          'Interests',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (interests.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: interests
                                .map((interest) => Chip(
                                      label: Text(
                                        interest,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.indigo.shade400,
                                      deleteIcon: Icon(Icons.close, size: 18),
                                      onDeleted: () {
                                        setState(
                                            () => interests.remove(interest));
                                      },
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: interestController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Add new interest',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: Colors.indigo.shade400,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  final interest =
                                      interestController.text.trim();
                                  if (interest.isNotEmpty) {
                                    setState(() {
                                      interests.add(interest);
                                      interestController.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 137, 153, 245),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16, vertical: maxLines > 1 ? 12 : 16),
          ),
        ),
      ],
    );
  }
}
