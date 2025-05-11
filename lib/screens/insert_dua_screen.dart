import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/authentication/login.dart';
import 'package:fyp_admin_panel/screens/read_dua_screen.dart';
import 'package:fyp_admin_panel/widgets/button_for_auth.dart';
import 'package:fyp_admin_panel/widgets/custom_fields_for_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class InsertDuaScreen extends StatefulWidget {
  const InsertDuaScreen({super.key});

  @override
  State<InsertDuaScreen> createState() => _InsertDuaScreenState();
}

class _InsertDuaScreenState extends State<InsertDuaScreen> {
  final TextEditingController duaNameController = TextEditingController();
  final TextEditingController duaController = TextEditingController();
  final TextEditingController translationController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> addDua() async {
    if (duaNameController.text.isEmpty ||
        duaController.text.isEmpty ||
        translationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Please fill in all fields", Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance
          .collection("Dua")
          .doc(duaNameController.text)
          .set({
        "duaName": duaNameController.text,
        "dua": duaController.text,
        "translation": translationController.text,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Dua added successfully!", Colors.green),
      );

      duaNameController.clear();
      duaController.clear();
      translationController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Failed to add Dua: $error", Colors.red),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  SnackBar _buildSnackBar(String message, Color color) {
    return SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Dua",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF076585),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Login()),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF076585),
              Color(0xFF0E4D7B),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Header
                Lottie.asset(
                  'assets/images/dua.json',
                  height: 150,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24),
                
                // Form Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          "Add New Dua",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF076585),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Dua Name Field
                        CustomFieldsForAuth(
                          height: 0.06,
                          width: 0.9,
                          controller: duaNameController,
                          label_txt: "Dua Name",
                          shadowColor: Colors.blueGrey.withOpacity(0.2),
                        ),
                        SizedBox(height: 16),
                        
                        // Arabic Dua Field
                        CustomFieldsForAuth(
                          height: 0.06,
                          width: 0.9,
                          controller: duaController,
                          label_txt: "Arabic Dua",
                          shadowColor: Colors.blueGrey.withOpacity(0.2),
                        ),
                        SizedBox(height: 16),
                        
                        // Translation Field
                        CustomFieldsForAuth(
                          height: 0.06,
                          width: 0.9,
                          controller: translationController,
                          label_txt: "Translation",
                          shadowColor: Colors.blueGrey.withOpacity(0.2),
                        ),
                        SizedBox(height: 24),
                        
                        // Submit Button
                        _isSubmitting
                            ? CircularProgressIndicator(color: Color(0xFF076585))
                            : ButtonForAuth(
                                height: 0.06,
                                width: 0.9,
                                border_color: Color(0xFF076585),
                                background_color: Color(0xFF076585),
                                text: "Save Dua".toUpperCase(),
                                text_color: Colors.white,
                                shadowColor: Color(0xFF076585),
                                my_fun: addDua,
                              ),
                        SizedBox(height: 16),
                        
                        // View Duas Button
                        ButtonForAuth(
                          height: 0.06,
                          width: 0.9,
                          border_color: Colors.white,
                          background_color: Colors.white,
                          text: "View All Duas".toUpperCase(),
                          text_color: Color(0xFF076585),
                          shadowColor: Colors.grey,
                          my_fun: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadDuaScreen(),
                              ),
                            );
                          },
                        ),
                      ],
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
}