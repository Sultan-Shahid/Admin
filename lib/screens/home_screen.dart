import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/authentication/login.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // For larger screens (like tablets or web), adjust layout accordingly
    if (width >= 600) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF0f2140),
            centerTitle: true,
            title: Text(
              "Welcome to Home Screen",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Home Screen for Larger Devices',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // For smaller screens (mobile), use standard layout
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF0f2140),
            centerTitle: true,
            title: Text(
              "Welcome to Home Screen",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Home Screen for Mobile Devices',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: GoogleFonts.poppins(fontSize: 14),
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
}
