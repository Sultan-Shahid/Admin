import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_admin_panel/authentication/login.dart';
import 'package:fyp_admin_panel/widgets/button_for_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (index) => TextEditingController());
  int _correctOptionIndex = 0;
  bool _isSubmitting = false;

  void _addQuestion() async {
    if (_questionController.text.isEmpty ||
        _optionControllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Please fill all fields", Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('questions').add({
        'question': _questionController.text,
        'options': _optionControllers.map((c) => c.text).toList(),
        'correctOption': _optionControllers[_correctOptionIndex].text,
        'correctOptionIndex': _correctOptionIndex,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Question Added!", Colors.green),
      );

      _questionController.clear();
      _optionControllers.forEach((c) => c.clear());
      setState(() => _correctOptionIndex = 0);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Error adding question: $error", Colors.red),
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
          "Add Quiz Question",
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
                  'assets/images/quiz2.json',
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
                          "Add Quiz Question",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF076585),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Question Field
                        TextField(
                          controller: _questionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Question",
                            labelStyle: GoogleFonts.poppins(color: Colors.black54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xFF076585),
                                width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Options
                        Text(
                          "Options (Select correct one)",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        Column(
                          children: List.generate(4, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Radio<int>(
                                    value: index,
                                    groupValue: _correctOptionIndex,
                                    onChanged: (value) {
                                      setState(() => _correctOptionIndex = value!);
                                    },
                                    activeColor: Color(0xFF076585),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _optionControllers[index],
                                      decoration: InputDecoration(
                                        labelText: "Option ${index + 1}",
                                        labelStyle: GoogleFonts.poppins(
                                          color: Colors.black54),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Color(0xFF076585),
                                            width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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
                                text: "Add Question".toUpperCase(),
                                text_color: Colors.white,
                                shadowColor: Color(0xFF076585),
                                my_fun: _addQuestion,
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