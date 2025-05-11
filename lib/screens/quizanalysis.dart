// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class AdminAnalyticsDashboard extends StatelessWidget {
//   const AdminAnalyticsDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text('Islamic Quiz Analytics', 
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Poppins',
//               color: Colors.white
//             )),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Color(0xFF2E7D32), // Islamic green color
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {},
//           ),
//           _buildTimeFilterDropdown(),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Islamic-themed summary cards
//             _buildIslamicSummaryCards(),
            
//             // Main Content
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Performance Overview with Islamic touch
//                   _buildSectionTitle('Performance Overview', Icons.analytics),
//                   const SizedBox(height: 16),
//                   _buildPerformanceCharts(),
                  
//                   const SizedBox(height: 24),
                  
//                   // Leaderboard & Recent Activity
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Column(
//                           children: [
//                             _buildSectionTitle('Top Performers', Icons.emoji_events),
//                             const SizedBox(height: 8),
//                             _buildIslamicLeaderboard(),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           children: [
//                             _buildSectionTitle('Recent Activity', Icons.history),
//                             const SizedBox(height: 8),
//                             _buildRecentActivity(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 24),
                  
//                   // Quiz Statistics with Islamic categories
//                   _buildSectionTitle('Quiz Statistics', Icons.stacked_bar_chart),
//                   const SizedBox(height: 16),
//                   _buildIslamicQuizStats(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeFilterDropdown() {
//     return PopupMenuButton<String>(
//       icon: const Icon(Icons.filter_alt, color: Colors.white),
//       onSelected: (value) {},
//       itemBuilder: (context) => [
//         const PopupMenuItem(value: 'today', child: Text('Today')),
//         const PopupMenuItem(value: 'week', child: Text('This Week')),
//         const PopupMenuItem(value: 'month', child: Text('This Month')),
//         const PopupMenuItem(value: 'year', child: Text('This Year')),
//         const PopupMenuItem(value: 'all', child: Text('All Time')),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, color: Color(0xFF2E7D32)),
//         SizedBox(width: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF2E7D32),
//             fontFamily: 'Poppins',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildIslamicSummaryCards() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFF2E7D32),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       child: Row(
//         children: [
//           _buildIslamicSummaryCard(
//             title: 'Total Users',
//             value: '1,245',
//             icon: Icons.people_outline,
//             color: Colors.amber,
//             islamicText: 'بسم الله',
//           ),
//           _buildIslamicSummaryCard(
//             title: 'Active Today',
//             value: '324',
//             icon: Icons.today,
//             color: Colors.lightGreen,
//             islamicText: 'الحمد لله',
//           ),
//           _buildIslamicSummaryCard(
//             title: 'Avg Score',
//             value: '78%',
//             icon: Icons.assessment,
//             color: Colors.lightBlue,
//             islamicText: 'ما شاء الله',
//           ),
//           _buildIslamicSummaryCard(
//             title: 'Quizzes',
//             value: '2,456',
//             icon: Icons.quiz,
//             color: Colors.pinkAccent,
//             islamicText: 'الله أكبر',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIslamicSummaryCard({
//     required String title, 
//     required String value, 
//     required IconData icon, 
//     required Color color,
//     required String islamicText,
//   }) {
//     return Expanded(
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 islamicText,
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Color(0xFF2E7D32),
//                   fontFamily: 'Lateef',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPerformanceCharts() {
//     return SizedBox(
//       height: 300,
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Text(
//                 'User Participation & Performance',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                   color: Color(0xFF2E7D32),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance.collection('user_scores').snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(child: CircularProgressIndicator());
//                     }
                    
//                     // Process data from Firebase
//                     var userScores = snapshot.data!.docs;
//                     int totalParticipants = userScores.length;
//                     int totalScore = userScores.fold(0, (sum, doc) {
//                     return sum + (doc['scores'] as List).fold<int>(
//   0,
//   (innerSum, score) => innerSum + (score['score'] as num).toInt(),
// );

//                     });
//                     double avgScore = totalParticipants > 0 ? totalScore / totalParticipants : 0;
                    
//                     // Sample weekly data (in a real app, you'd calculate this from Firebase)
//                     List<ChartData> chartData = [
//                       ChartData('Mon', 120, (avgScore * 0.9).round()),
//                       ChartData('Tue', 150, (avgScore * 0.85).round()),
//                       ChartData('Wed', 200, (avgScore * 0.95).round()),
//                       ChartData('Thu', 180, (avgScore * 0.88).round()),
//                       ChartData('Fri', 250, (avgScore * 1.0).round()),
//                       ChartData('Sat', 100, (avgScore * 0.8).round()),
//                       ChartData('Sun', 80, (avgScore * 0.75).round()),
//                     ];

//                     return SfCartesianChart(
//                       primaryXAxis: CategoryAxis(
//                         labelRotation: -45,
//                         title: AxisTitle(text: 'Day of Week', textStyle: TextStyle(fontFamily: 'Poppins')),
//                       ),
//                       series: <CartesianSeries>[
//                         ColumnSeries<ChartData, String>(
//                           dataSource: chartData,
//                           xValueMapper: (ChartData data, _) => data.day,
//                           yValueMapper: (ChartData data, _) => data.participants,
//                           name: 'Participants',
//                           color: Color(0xFF2E7D32),
//                         ),
//                         LineSeries<ChartData, String>(
//                           dataSource: chartData,
//                           xValueMapper: (ChartData data, _) => data.day,
//                           yValueMapper: (ChartData data, _) => data.avgScore,
//                           name: 'Avg Score %',
//                           color: Colors.amber,
//                           markerSettings: const MarkerSettings(isVisible: true),
//                           yAxisName: 'secondary',
//                         ),
//                       ],
//                       primaryYAxis: NumericAxis(
//                         title: AxisTitle(text: 'Participants', textStyle: TextStyle(fontFamily: 'Poppins')),
//                       ),
//                       axes: <ChartAxis>[
//                         NumericAxis(
//                           name: 'secondary',
//                           opposedPosition: true,
//                           title: AxisTitle(text: 'Avg Score %', textStyle: TextStyle(fontFamily: 'Poppins')),
//                           minimum: 70,
//                           maximum: 90,
//                           interval: 5,
//                         ),
//                       ],
//                       legend: Legend(
//                         isVisible: true,
//                         textStyle: TextStyle(fontFamily: 'Poppins'),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIslamicLeaderboard() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('user_scores').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Card(
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         }

//         var scores = snapshot.data!.docs.map((doc) {
//           return {
//             'email': doc.id,
//             'totalScore': doc['scores'].fold(0, (sum, item) => sum + item['score']),
//             'lastActive': doc['scores'].last['date'],
//             'quizzesTaken': doc['scores'].length,
//           };
//         }).toList();

//         scores.sort((a, b) => b['totalScore'].compareTo(a['totalScore']));

//         return Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Rank', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
//                     Text('User', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
//                     Text('Score', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
//                   ],
//                 ),
//                 Divider(),
//                 ...scores.take(5).map((data) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Color(0xFF2E7D32).withOpacity(0.2),
//                           radius: 16,
//                           child: Text(
//                             '${scores.indexOf(data) + 1}',
//                             style: TextStyle(
//                               color: Color(0xFF2E7D32),
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 8),
//                             child: Text(
//                               data['email'].toString().split('@')[0],
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'Poppins',
//                               ),
//                             ),
//                           ),
//                         ),
//                         Chip(
//                           label: Text('${data['totalScore']} pts',
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               color: Color(0xFF2E7D32),
//                             ),
//                           ),
//                           backgroundColor: Color(0xFF2E7D32).withOpacity(0.1),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text('View All', 
//                       style: TextStyle(
//                         color: Color(0xFF2E7D32),
//                         fontFamily: 'Poppins',
//                       )),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildRecentActivity() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('user_scores').orderBy('scores.date', descending: true).limit(5).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         }

//         var recentActivities = snapshot.data!.docs;

//         return Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.history, size: 20, color: Color(0xFF2E7D32)),
//                     SizedBox(width: 8),
//                     Text('Recent Quiz Completions', 
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Poppins',
//                         )),
//                   ],
//                 ),
//                 Divider(),
//                 ...recentActivities.map((doc) {
//                   var lastScore = (doc['scores'] as List).last;
//                   DateTime date = DateTime.parse(lastScore['date']);
//                   String timeAgo = _formatTimeDifference(DateTime.now().difference(date));
                  
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 16,
//                           backgroundColor: Colors.grey,
//                           child: Icon(Icons.person, size: 16, color: Colors.white),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 doc.id.split('@')[0],
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: 'Poppins',
//                                 ),
//                               ),
//                               Text(
//                                 'Scored ${lastScore['score']} points',
//                                 style: TextStyle(
//                                   fontSize: 12, 
//                                   color: Colors.grey,
//                                   fontFamily: 'Poppins',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           timeAgo,
//                           style: TextStyle(
//                             fontSize: 12, 
//                             color: Colors.grey,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text('View All', 
//                       style: TextStyle(
//                         color: Color(0xFF2E7D32),
//                         fontFamily: 'Poppins',
//                       )),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildIslamicQuizStats() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('questions').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         }

//         // Sample data - in a real app, you'd calculate these from Firebase
//         int totalQuestions = snapshot.data!.docs.length;
//         int easyQuestions = (totalQuestions * 0.35).round();
//         int mediumQuestions = (totalQuestions * 0.45).round();
//         int hardQuestions = totalQuestions - easyQuestions - mediumQuestions;

//         return Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text('Quiz Categories Analysis', 
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins',
//                       color: Color(0xFF2E7D32),
//                     )),
//                 SizedBox(height: 16),
//                 SizedBox(
//                   height: 200,
//                   child: PieChart(
//                     PieChartData(
//                       sections: [
//                         PieChartSectionData(
//                           value: easyQuestions.toDouble(),
//                           color: Colors.green,
//                           title: 'Quran ${(easyQuestions/totalQuestions*100).round()}%',
//                           radius: 60,
//                           titleStyle: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         PieChartSectionData(
//                           value: mediumQuestions.toDouble(),
//                           color: Colors.amber,
//                           title: 'Hadith ${(mediumQuestions/totalQuestions*100).round()}%',
//                           radius: 60,
//                           titleStyle: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         PieChartSectionData(
//                           value: hardQuestions.toDouble(),
//                           color: Colors.orange,
//                           title: 'Fiqh ${(hardQuestions/totalQuestions*100).round()}%',
//                           radius: 60,
//                           titleStyle: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                       centerSpaceRadius: 40,
//                       sectionsSpace: 2,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   crossAxisCount: 2,
//                   childAspectRatio: 3,
//                   children: [
//                     _buildIslamicStatItem('Most Attempted', 'Quran Quiz', Icons.menu_book),
//                     _buildIslamicStatItem('Highest Score', 'Seerah Quiz', Icons.emoji_events),
//                     _buildIslamicStatItem('Lowest Score', 'Fiqh Quiz', Icons.warning),
//                     _buildIslamicStatItem('Avg Time', '3.5 mins', Icons.timer),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildIslamicStatItem(String title, String value, IconData icon) {
//     return ListTile(
//       leading: Icon(icon, color: Color(0xFF2E7D32)),
//       title: Text(title, 
//           style: TextStyle(
//             fontSize: 12,
//             fontFamily: 'Poppins',
//           )),
//       subtitle: Text(value, 
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Poppins',
//           )),
//     );
//   }

//   String _formatTimeDifference(Duration difference) {
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }

// class ChartData {
//   final String day;
//   final int participants;
//   final int avgScore;

//   ChartData(this.day, this.participants, this.avgScore);
// }