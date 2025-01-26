import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lifelog/screens/home_screen.dart';
import 'package:lifelog/screens/login_screen.dart';
import 'package:lifelog/widgets/custom_text_form_field.dart';
import 'package:lifelog/widgets/gradient_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFF94BCEB), Color(0xFFA49EF4)],
                          ).createShader(bounds);
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Start your mental wellness journey now', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),),
                      const SizedBox(height: 50,),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  label: 'First Name', 
                                  controller: _firstNameController,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Expanded(
                                child: CustomTextFormField(
                                  label: 'Last Name', 
                                  controller: _lastNameController,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          CustomTextFormField(
                            label: 'Email',
                            controller: _emailController,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          CustomTextFormField(
                            label: 'Date of Birth',
                            controller: _dateOfBirthController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
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
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          CustomTextFormField(
                            label: 'Password',
                            obscureText: _obscurePassword,
                            controller: _passwordController,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined, color: const Color.fromARGB(255, 207, 207, 207),),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
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
                        child: const Text('Register'),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 50)),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                color: Color(0xFF5D9EEA),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }  
}
