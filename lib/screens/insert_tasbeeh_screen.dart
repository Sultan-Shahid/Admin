import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/authentication/login.dart';
import 'package:fyp_admin_panel/screens/read_tasbeeh_screen.dart';
import 'package:fyp_admin_panel/widgets/button_for_auth.dart';
import 'package:fyp_admin_panel/widgets/custom_fields_for_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class InsertTasbeehScreen extends StatefulWidget {
  const InsertTasbeehScreen({super.key});

  @override
  State<InsertTasbeehScreen> createState() => _InsertTasbeehScreenState();
}

class _InsertTasbeehScreenState extends State<InsertTasbeehScreen> {
  final TextEditingController tasbeehName = TextEditingController();
  final TextEditingController tasbeehController = TextEditingController();
  final TextEditingController tasbeehTranslation = TextEditingController();
  bool _isSubmitting = false;

  Future<void> addTasbeeh() async {
    if (tasbeehName.text.isEmpty ||
        tasbeehController.text.isEmpty ||
        tasbeehTranslation.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Please fill all fields", Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance
          .collection("Tasbeeh")
          .doc(tasbeehName.text)
          .set({
        "tasbeehName": tasbeehName.text,
        "tasbeeh": tasbeehController.text,
        "translation": tasbeehTranslation.text,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Tasbeeh added successfully!", Colors.green),
      );

      tasbeehName.clear();
      tasbeehController.clear();
      tasbeehTranslation.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Failed to add Tasbeeh: $error", Colors.red),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> deleteTasbeeh() async {
    if (tasbeehName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Enter Tasbeeh Name to delete", Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance
          .collection("Tasbeeh")
          .doc(tasbeehName.text)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Tasbeeh deleted successfully!", Colors.green),
      );

      tasbeehName.clear();
      tasbeehController.clear();
      tasbeehTranslation.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Failed to delete Tasbeeh: $error", Colors.red),
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
          "Add Tasbeeh",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF076585),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
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
                Image.asset(
                  'assets/images/tasbeeh.png',
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
                          "Tasbeeh Form",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF076585),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Tasbeeh Name
                        CustomFieldsForAuth(
                          height: 0.06,
                          width: 0.9,
                          controller: tasbeehName,
                          label_txt: "Tasbeeh Name",
                          shadowColor: Colors.blueGrey.withOpacity(0.2),
                        ),
                        SizedBox(height: 16),
                        
                        // Arabic Tasbeeh
                        CustomFieldsForAuth(
                          height: 0.06,
                          width: 0.9,
                          controller: tasbeehController,
                          label_txt: "Arabic Tasbeeh",
                          shadowColor: Colors.blueGrey.withOpacity(0.2),
                        ),
                        SizedBox(height: 16),
                        
                        // Translation
                        CustomFieldsForAuth(
                          height: 0.06,
                          width: 0.9,
                          controller: tasbeehTranslation,
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
                                text: "Save Tasbeeh".toUpperCase(),
                                text_color: Colors.white,
                                shadowColor: Color(0xFF076585),
                                my_fun: addTasbeeh,
                              ),
                        SizedBox(height: 16),
                        
                        // View Tasbeeh Button
                        ButtonForAuth(
                          height: 0.06,
                          width: 0.9,
                          border_color: Colors.white,
                          background_color: Colors.white,
                          text: "View All Tasbeeh".toUpperCase(),
                          text_color: Color(0xFF076585),
                          shadowColor: Colors.grey,
                          my_fun: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadTasbeehScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Delete Button
                        ButtonForAuth(
                          height: 0.06,
                          width: 0.9,
                          border_color: Colors.red,
                          background_color: Colors.red,
                          text: "Delete Tasbeeh".toUpperCase(),
                          text_color: Colors.white,
                          shadowColor: Colors.red,
                          my_fun: deleteTasbeeh,
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