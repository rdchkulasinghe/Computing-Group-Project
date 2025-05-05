import 'package:ai_friend/diary_inside.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_friend/backend/collect_data.dart';
import 'package:ai_friend/diary_entry.dart';

class DiaryScreen extends StatefulWidget {
  final UserData userData;

  const DiaryScreen({super.key, required this.userData});

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<DiaryEntry> entries = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    if (widget.userData.userId.isEmpty) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      _showErrorSnackbar('User ID is empty!');
      return;
    }

    try {
      setState(() => isLoading = true);

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.userId)
          .collection('diaryEntries')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        entries = snapshot.docs
            .map((doc) => DiaryEntry.fromMap(doc.id, doc.data()))
            .toList();
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      _showErrorSnackbar('Error loading entries: ${e.toString()}');
    }
  }

  Future<void> _addNewEntry(String title, String content) async {
    if (title.trim().isEmpty && content.trim().isEmpty) return;
    if (widget.userData.userId.isEmpty) {
      _showErrorSnackbar('User ID is missing!');
      return;
    }

    try {
      setState(() => isLoading = true);

      final newEntryRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.userId)
          .collection('diaryEntries')
          .add({
        'title': title,
        'content': content,
        'date': Timestamp.fromDate(DateTime.now()),
      });

      setState(() {
        entries.insert(
          0,
          DiaryEntry(
            id: newEntryRef.id,
            title: title,
            content: content,
            date: DateTime.now(),
          ),
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackbar('Error adding entry: ${e.toString()}');
    }
  }

  Future<void> _deleteEntry(int index) async {
    final entryToDelete = entries[index];
    try {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.userId)
          .collection('diaryEntries')
          .doc(entryToDelete.id)
          .delete();

      setState(() {
        entries.removeAt(index);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackbar('Error deleting entry: ${e.toString()}');
    }
  }

  Future<void> _updateEntry(
      DiaryEntry entry, String newTitle, String newContent) async {
    try {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.userId)
          .collection('diaryEntries')
          .doc(entry.id)
          .update({
        'title': newTitle,
        'content': newContent,
      });

      setState(() {
        final index = entries.indexWhere((e) => e.id == entry.id);
        if (index != -1) {
          entries[index] = entries[index].copyWith(
            title: newTitle,
            content: newContent,
          );
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackbar('Error updating entry: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Diary",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromRGBO(49, 27, 146, 1),
              Colors.deepPurple.shade700,
            ],
          ),
        ),
        child: _buildBodyContent(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade700,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToAddNewEntry(),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    if (isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Failed to load entries',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEntries,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No entries yet. Tap + to add your first entry!',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEntries,
      color: Colors.deepPurple.shade700,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _buildEntryCard(entry, index);
        },
      ),
    );
  }

  Widget _buildEntryCard(DiaryEntry entry, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToEditEntry(entry),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(entry.date),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (entry.content.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        entry.content.length > 50
                            ? '${entry.content.substring(0, 50)}...'
                            : entry.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white70),
                onPressed: () => _confirmDelete(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToAddNewEntry() async {
    final shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryInsideScreen(
          onSave: _addNewEntry,
          date: _formatDate(DateTime.now()),
        ),
      ),
    );

    if (shouldRefresh == true) {
      await _loadEntries();
    }
  }

  Future<void> _navigateToEditEntry(DiaryEntry entry) async {
    final shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryInsideScreen(
          entry: entry,
          onSave: (newTitle, newContent) =>
              _updateEntry(entry, newTitle, newContent),
          date: _formatDate(entry.date),
        ),
      ),
    );

    if (shouldRefresh == true) {
      await _loadEntries();
    }
  }

  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteEntry(index);
    }
  }
}
