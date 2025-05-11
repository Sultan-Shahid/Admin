import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadTasbeehScreen extends StatefulWidget {
  const ReadTasbeehScreen({super.key});

  @override
  State<ReadTasbeehScreen> createState() => _ReadTasbeehScreenState();
}

class _ReadTasbeehScreenState extends State<ReadTasbeehScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final _editFormKey = GlobalKey<FormState>();
  late TextEditingController _editNameController;
  late TextEditingController _editTasbeehController;
  late TextEditingController _editTranslationController;
  String? _editingDocId;

  @override
  void initState() {
    super.initState();
    _editNameController = TextEditingController();
    _editTasbeehController = TextEditingController();
    _editTranslationController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _editNameController.dispose();
    _editTasbeehController.dispose();
    _editTranslationController.dispose();
    super.dispose();
  }

  Future<void> _deleteTasbeeh(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection("Tasbeeh").doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasbeeh deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete tasbeeh: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateTasbeeh() async {
    if (_editFormKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection("Tasbeeh").doc(_editingDocId).update({
          'tasbeehName': _editNameController.text,
          'tasbeeh': _editTasbeehController.text,
          'translation': _editTranslationController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tasbeeh updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update tasbeeh: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditDialog(DocumentSnapshot doc) {
    _editingDocId = doc.id;
    _editNameController.text = doc['tasbeehName'] ?? '';
    _editTasbeehController.text = doc['tasbeeh'] ?? '';
    _editTranslationController.text = doc['translation'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Tasbeeh', style: GoogleFonts.roboto()),
        content: Form(
          key: _editFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _editNameController,
                  decoration: InputDecoration(labelText: 'Tasbeeh Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _editTasbeehController,
                  decoration: InputDecoration(labelText: 'Tasbeeh Content'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _editTranslationController,
                  decoration: InputDecoration(labelText: 'Translation'),
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
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _updateTasbeeh,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff076585),
            ),
            child: Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff076585),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFFADB5BD)),
          title: Text(
            "All Tasbeeh",
            style: GoogleFonts.roboto(
              fontSize: width > 600 ? 28 : 22,
              color: Color(0xFFADB5BD),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff076585), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Search Bar
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.search, color: Colors.grey),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: "Search tasbeeh...",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(height: 1.0),
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
                              icon: Icon(Icons.clear, color: Colors.grey),
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
                ),
                SizedBox(height: 16),
                
                // Tasbeeh List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Tasbeeh").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: Colors.white));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 80, color: Colors.white54),
                              SizedBox(height: 16),
                              Text(
                                "No Tasbeeh Found",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      var data = snapshot.data!.docs;
                      var filteredData = _searchQuery.isEmpty
                          ? data
                          : data.where((doc) {
                              final name = doc['tasbeehName'].toString().toLowerCase();
                              final content = doc['tasbeeh'].toString().toLowerCase();
                              return name.contains(_searchQuery) || content.contains(_searchQuery);
                            }).toList();

                      if (filteredData.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 80, color: Colors.white54),
                              SizedBox(height: 16),
                              Text(
                                "No matching tasbeeh found",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = filteredData[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: _buildTasbeehCard(doc, width, height),
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
      ),
    );
  }

  Widget _buildTasbeehCard(DocumentSnapshot doc, double width, double height) {
    return ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tilePadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      collapsedBackgroundColor: Colors.blueGrey.shade800,
      backgroundColor: Colors.blueGrey.shade700,
      childrenPadding: EdgeInsets.all(15),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: height * 0.06,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff076585), Color(0xff42a5f5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                textAlign: TextAlign.center,
                "${doc["tasbeehName"]}",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width > 600 ? 18 : 15,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => _showEditDialog(doc),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red.shade200),
                onPressed: () => _showDeleteDialog(doc.id, doc["tasbeehName"]),
              ),
            ],
          ),
        ],
      ),
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "${doc["tasbeeh"]}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: width > 600 ? 20 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Text(
                  "${doc["translation"]}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: width > 600 ? 18 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(String docId, String tasbeehName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '$tasbeehName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTasbeeh(docId);
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}