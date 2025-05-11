import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadDuaScreen extends StatefulWidget {
  const ReadDuaScreen({super.key});

  @override
  State<ReadDuaScreen> createState() => _ReadDuaScreenState();
}

class _ReadDuaScreenState extends State<ReadDuaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _editFormKey = GlobalKey<FormState>();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editDuaController = TextEditingController();
  TextEditingController _editTranslationController = TextEditingController();
  String? _editingDocId;

  Future<void> deleteDua(String documentId) async {
    try {
      await _firestore.collection("Dua").doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Dua deleted successfully!", Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Failed to delete Dua: ${e.toString()}", Colors.red),
      );
    }
  }

  Future<void> updateDua() async {
    if (_editFormKey.currentState!.validate()) {
      try {
        await _firestore.collection("Dua").doc(_editingDocId).update({
          'duaName': _editNameController.text,
          'dua': _editDuaController.text,
          'translation': _editTranslationController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar("Dua updated successfully!", Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar("Failed to update Dua: ${e.toString()}", Colors.red),
        );
      }
    }
  }

  void _showEditDialog(DocumentSnapshot doc) {
    _editingDocId = doc.id;
    _editNameController.text = doc['duaName'] ?? '';
    _editDuaController.text = doc['dua'] ?? '';
    _editTranslationController.text = doc['translation'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Dua"),
        content: Form(
          key: _editFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _editNameController,
                  decoration: const InputDecoration(labelText: 'Dua Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _editDuaController,
                  decoration: const InputDecoration(labelText: 'Dua Content'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _editTranslationController,
                  decoration: const InputDecoration(labelText: 'Translation'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: updateDua,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF076585),
            ),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
  void dispose() {
    _searchController.dispose();
    _editNameController.dispose();
    _editDuaController.dispose();
    _editTranslationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF076585),
        centerTitle: true,
        title: Text(
          "Manage Duas",
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF076585),
              Color(0xFF0E4D7B),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
         Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      height: 48, // Fixed height for consistent alignment
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search by name or content...",
                  border: InputBorder.none,
                  isDense: true, // Reduces the height of the input
                  contentPadding: EdgeInsets.zero, // Removes default padding
                ),
                style: const TextStyle(
                  height: 1.0, // Adjust text height if needed
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
        ],
      ),
    ),
  ),
), const SizedBox(height: 16),
              
              // Dua List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("Dua").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error.toString());
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    final data = snapshot.data!.docs;
                    final filteredData = _filterData(data);

                    if (filteredData.isEmpty) {
                      return _buildNoResults();
                    }

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final doc = filteredData[index];
                        final duaName = doc['duaName'] ?? '';
                        final duaContent = doc['dua'] ?? '';
                        final translation = doc['translation'] ?? '';
                        
                        return _buildDuaCard(
                          index: index,
                          doc: doc,
                          duaName: duaName,
                          duaContent: duaContent,
                          translation: translation,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<QueryDocumentSnapshot> _filterData(List<QueryDocumentSnapshot> data) {
    if (_searchQuery.isEmpty) return data;
    
    return data.where((doc) {
      final name = doc['duaName']?.toString().toLowerCase() ?? '';
      final content = doc['dua']?.toString().toLowerCase() ?? '';
      final translation = doc['translation']?.toString().toLowerCase() ?? '';
      
      return name.contains(_searchQuery) || 
             content.contains(_searchQuery) || 
             translation.contains(_searchQuery);
    }).toList();
  }

  Widget _buildDuaCard({
    required int index,
    required DocumentSnapshot doc,
    required String duaName,
    required String duaContent,
    required String translation,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF076585).withOpacity(0.2),
          child: Text(
            "${index + 1}",
            style: const TextStyle(color: Color(0xFF076585)),
          ),
        ),
        title: Text(
          duaName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(doc),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(doc.id, duaName),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Dua Content",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      duaContent,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Translation",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      translation,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.white54),
          const SizedBox(height: 16),
          Text(
            "No Duas Found",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            "Add new duas to get started",
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.white54),
          const SizedBox(height: 16),
          Text(
            "No matching Duas found",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "Error loading data",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String docId, String duaName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '$duaName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteDua(docId);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}