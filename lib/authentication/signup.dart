import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/authentication/login.dart';
import 'package:fyp_admin_panel/widgets/button_for_auth.dart';
import 'package:fyp_admin_panel/widgets/custom_fields_for_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  // Sign up method
  Future<void> signUp(BuildContext context) async {
    if (passwordController.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Password must consist of 8 characters.",
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
      return;
    }

    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        // Create User with Email & Password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Save Admin Data to Firestore
        await FirebaseFirestore.instance
            .collection("adminUsers")
            .doc(emailController.text)
            .set({
          "Email": emailController.text.toLowerCase(),
          "First_Name": firstNameController.text,
          "Last_Name": lastNameController.text,
        });

        // Clear Text Fields
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Sign Up Successful!",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );

        // Navigate to Login Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Error: ${e.toString()}",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please fill out all fields.",
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.04),
              Center(
                child: Text(
                  "Create Account",
                  style: GoogleFonts.poppins(
                    color: Color(0xff1F41BB),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.04),
              Center(
                child: Container(
                  height: height * 0.27,
                  width: width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("assets/images/admin2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              _buildTextField("Enter Your First Name", firstNameController),
              SizedBox(height: height * 0.02),
              _buildTextField("Enter Your Last Name", lastNameController),
              SizedBox(height: height * 0.02),
              _buildTextField("Enter Your Email", emailController),
              SizedBox(height: height * 0.02),
              _buildPasswordField(),
              SizedBox(height: height * 0.02),
              _buildSignupButton(context),
              SizedBox(height: height * 0.02),
              _buildSigninButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomFieldsForAuth(
          label_txt: labelText,
          controller: controller,
          height: 0.06,
          width: 0.8,
          shadowColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomFieldsForAuth(
              label_txt: "Enter Your Password",
              controller: passwordController,
              height: 0.06,
              width: 0.8,
              shadowColor: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              "Password must be 8 characters!",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return ButtonForAuth(
      height: 0.06,
      width: 0.8,
      border_color: Color(0xff1F41BB),
      background_color: Color(0xff1F41BB),
      text: "Sign Up".toUpperCase(),
      text_color: Colors.white,
      shadowColor: Color(0xff1F41BB),
      my_fun: () => signUp(context),
    );
  }

  Widget _buildSigninButton(BuildContext context) {
    return ButtonForAuth(
      height: 0.06,
      width: 0.8,
      border_color: Color(0xff1F41BB),
      background_color: Colors.white,
      text: "Sign in".toUpperCase(),
      shadowColor: Colors.grey,
      text_color: Colors.black,
      my_fun: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      },
    );
  }
}
