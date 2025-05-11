import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/screens/quizanalysis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp_admin_panel/screens/add_question_screen.dart';
import 'package:fyp_admin_panel/screens/insert_dua_screen.dart';
import 'package:fyp_admin_panel/screens/insert_tasbeeh_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> screens = [
    InsertDuaScreen(),
    InsertTasbeehScreen(),
    AddQuestionScreen(),
   
   
    // ✅ Added Quiz Analysis screen
  ];

  int _selectedIndex = 0;
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop) _buildDesktopNavigation(),
          Expanded(
            child: Container(
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: screens[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop ? _buildMobileNavigation() : null,
    );
  }

  Widget _buildDesktopNavigation() {
    return Container(
      width: _isExpanded ? 250 : 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _isExpanded
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF076585).withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF076585),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.mosque,
                              size: 30,
                              color: Color(0xFF076585),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Deen AI',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF076585),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF076585).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF076585),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.mosque,
                            size: 20,
                            color: Color(0xFF076585),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _NavItem(
                  icon: Icons.nightlight_round,
                  label: 'Insert Dua',
                  isSelected: _selectedIndex == 0,
                  isExpanded: _isExpanded,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                _NavItem(
                  icon: Icons.all_inclusive,
                  label: 'Insert Tasbeeh',
                  isSelected: _selectedIndex == 1,
                  isExpanded: _isExpanded,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                _NavItem(
                  icon: Icons.question_answer,
                  label: 'Insert Quiz',
                  isSelected: _selectedIndex == 2,
                  isExpanded: _isExpanded,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                // _NavItem(
                //   icon: Icons.analytics,
                //   label: 'Quiz Analysis',
                //   isSelected: _selectedIndex == 3,
                //   isExpanded: _isExpanded,
                //   onTap: () => setState(() => _selectedIndex = 3),
                // ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF076585).withOpacity(0.1),
                  border: Border.all(
                    color: Color(0xFF076585),
                    width: 1.5,
                  ),
                ),
                child: AnimatedRotation(
                  duration: Duration(milliseconds: 300),
                  turns: _isExpanded ? 0.0 : 0.5,
                  child: Icon(
                    Icons.chevron_left,
                    color: Color(0xFF076585),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavigation() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF076585),
            Color(0xFF0E4D7B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight_round),
            label: 'Dua',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: 'Tasbeeh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Quiz',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.analytics),
          //   label: 'Analysis',
          // ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF076585).withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Color(0xFF076585).withOpacity(0.3))
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xFF076585).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Color(0xFF076585) : Colors.grey,
                size: 20,
              ),
            ),
            if (isExpanded) ...[
              SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: isSelected ? Color(0xFF076585) : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
