import 'package:flutter/material.dart';
import 'package:lifelog/models/app_user.dart';
import 'package:lifelog/screens/home_screen.dart';
import 'package:lifelog/screens/landing_screen.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/custom_text_form_field.dart';
import 'package:lifelog/widgets/gradient_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppUser user = AppUser(
    firstName: 'John', 
    lastName: 'Doe', 
    email: 'john.doe@example.com', 
    dateOfBirth: DateTime(2000, 5, 15)
  );
  
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
    _dateOfBirthController.text = '${user.dateOfBirth.toLocal()}'.split(' ')[0];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(showLogo: true),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CentralCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            CustomTextFormField(
                              label: 'First Name', 
                              controller: _firstNameController
                            ),
                            CustomTextFormField(
                              label: 'Last Name', 
                              controller: _lastNameController,
                            ),
                            CustomTextFormField(
                              label: 'Email',
                              controller: _emailController,
                            ),
                            CustomTextFormField(
                              label: 'Date of Birth',
                              controller: _dateOfBirthController,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: user.dateOfBirth,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  builder: (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Color(0xFF5D9EEA),
                                          onPrimary: Colors.white
                                        )
                                      ),
                                      child: child!
                                    );
                                  }
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _dateOfBirthController.text = '${pickedDate.toLocal()}'.split(' ')[0];
                                  });
                                }
                              },
                              suffixIcon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 207, 207, 207)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.maxFinite, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF5D9EEA),
                              ),  
                              child: const Text('Submit'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LandingScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.maxFinite, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF5D9EEA),
                              ),  
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}