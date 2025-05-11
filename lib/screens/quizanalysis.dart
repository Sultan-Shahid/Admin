
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyp_admin_panel/authentication/login.dart';
import 'package:fyp_admin_panel/screens/allquestion.dart';

class AdminAnalyticsDashboard extends StatelessWidget {
  const AdminAnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Islamic Quiz Analytics',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
         actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildIslamicSummaryCards(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Performance Overview', Icons.analytics),
                  const SizedBox(height: 16),
                  _buildPerformanceCharts(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Top Performers', Icons.emoji_events),
                  const SizedBox(height: 8),
                  _buildIslamicLeaderboard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Quiz Questions', Icons.quiz),
                  const SizedBox(height: 8),
                  _buildQuestionsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildIslamicSummaryCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user_scores').snapshots(),
      builder: (context, userScoresSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('questions').snapshots(),
          builder: (context, questionsSnapshot) {
            int totalUsers =
                userScoresSnapshot.hasData ? userScoresSnapshot.data!.docs.length : 0;
            int totalQuestions =
                questionsSnapshot.hasData ? questionsSnapshot.data!.docs.length : 0;

            int totalScore = 0;
            if (userScoresSnapshot.hasData) {
              for (var doc in userScoresSnapshot.data!.docs) {
                var scores = doc['scores'] as List;
                totalScore += scores.fold(0, (sum, item) => sum + (item['score'] as int));
              }
            }
            double avgScore = totalUsers > 0 ? totalScore / totalUsers : 0;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  _buildSummaryCard('Total Users', totalUsers.toString(), Icons.people, Colors.amber),
                  _buildSummaryCard('Total Questions', totalQuestions.toString(), Icons.quiz, Colors.lightGreen),
                  _buildSummaryCard('Avg Score', avgScore.toStringAsFixed(1), Icons.assessment, Colors.lightBlue),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildPerformanceCharts() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('user_scores').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      List<BarChartGroupData> barGroups = [];
      List<String> userNames = [];

      var scores = snapshot.data!.docs.map((doc) {
        final scoresList = (doc['scores'] as List?) ?? [];
        int totalScore = 0;
        for (var item in scoresList) {
          if (item is Map && item['score'] != null) {
            totalScore += (item['score'] as num).toInt();
          }
        }
        return {
          'email': doc.id,
          'totalScore': totalScore,
        };
      }).toList();

      scores.sort((a, b) {
        final scoreA = a['totalScore'] as int? ?? 0;
        final scoreB = b['totalScore'] as int? ?? 0;
        return scoreB.compareTo(scoreA);
      });

      var topScores = scores.take(4).toList();

      double maxScore = topScores.isNotEmpty
          ? (topScores.map((e) => (e['totalScore'] as num).toDouble()).reduce((a, b) => a > b ? a : b) * 1.1)
          : 100;

      for (int i = 0; i < topScores.length; i++) {
        double yValue = (topScores[i]['totalScore'] as num).toDouble();
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: yValue,
                color: const Color(0xFF2E7D32),
                width: 22,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxScore,
                  color: Colors.grey[200],
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        );
        userNames.add(topScores[i]['email'].toString().split('@')[0]);
      }

      return SizedBox(
        height: 320,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Top Performers Score Comparison',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxScore,
                      barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: true, // For mobile tap support
                        touchTooltipData: BarTouchTooltipData(
                          // tooltipBgColor: Colors.black87,
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipBorder: BorderSide(color: Colors.white54, width: 1),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final user = userNames[group.x.toInt()];
                            return BarTooltipItem(
                              '$user\nScore: ${rod.toY.toInt()}',
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: maxScore / 5,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value < userNames.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    userNames[value.toInt()],
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildIslamicLeaderboard() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('user_scores').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      var scores = snapshot.data!.docs.map((doc) {
        var userScores = doc['scores'] as List;
        return {
          'email': doc.id,
          'totalScore': userScores.fold(0, (sum, item) => sum + (item['score'] as int)),
          'lastScore': userScores.isNotEmpty ? userScores.last['score'] : 0,
          'lastDate': userScores.isNotEmpty ? userScores.last['date'] : '',
        };
      }).toList();

      scores.sort((a, b) => b['totalScore'].compareTo(a['totalScore']));

      return Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rank', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              ...scores.take(5).map((data) {
                return GestureDetector(
                  onTap: () => _showUserDetails(context, data),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF2E7D32).withOpacity(0.2),
                          radius: 16,
                          child: Text(
                            '${scores.indexOf(data) + 1}',
                            style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              data['email'].toString().split('@')[0],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Text('${data['totalScore']} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}

void _showUserDetails(BuildContext context, Map<String, dynamic> userData) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('User Details - ${userData['email']}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Score: ${userData['totalScore']}'),
          Text('Last Score: ${userData['lastScore']}'),
          Text('Last Attempt: ${userData['lastDate']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
 Widget _buildQuestionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('questions').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.quiz, size: 20, color: Color(0xFF2E7D32)),
                    SizedBox(width: 8),
                    Text('Latest Questions', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(),
                ...snapshot.data!.docs.take(3).map((doc) {
                  return ListTile(
                    title: Text(doc['question']),
                    subtitle: Text('Correct: ${doc['correctOption']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteQuestion(doc.id, context),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // Navigate to AllQuestionsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllQuestionsScreen()),
                    );
                  },
                  child: const Text('View All Questions', style: TextStyle(color: Color(0xFF2E7D32))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteQuestion(String questionId, BuildContext context) async {
    await FirebaseFirestore.instance.collection('questions').doc(questionId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question deleted successfully')),
    );
  }
}
