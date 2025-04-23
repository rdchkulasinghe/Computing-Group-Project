import 'package:flutter/material.dart';
import 'package:ai_friend/diary_entry.dart';

class DiaryInsideScreen extends StatefulWidget {
  final DiaryEntry? entry;
  final Future<void> Function(String title, String content) onSave;
  final String? date;

  const DiaryInsideScreen({
    super.key,
    this.entry,
    required this.onSave,
    this.date,
  });

  @override
  _DiaryInsideScreenState createState() => _DiaryInsideScreenState();
}

class _DiaryInsideScreenState extends State<DiaryInsideScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isEdited = false;
  bool _isSaving = false;
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController =
        TextEditingController(text: widget.entry?.content ?? '');

    _titleController.addListener(_checkForChanges);
    _contentController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final isEdited = _titleController.text != widget.entry?.title ||
        _contentController.text != widget.entry?.content;
    if (_isEdited != isEdited) {
      setState(() => _isEdited = isEdited);
    }
  }

  Future<void> _saveAndClose() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);
    try {
      await widget.onSave(
        _titleController.text.trim(),
        _contentController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        title: Text(
          widget.entry != null ? 'Edit Entry' : 'New Entry',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _onBackPressed(context),
        ),
        actions: [
          if ((_isEdited || widget.entry == null) && !_isSaving)
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: _saveAndClose,
            ),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Container(
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.date != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.date!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _contentFocusNode.requestFocus(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  focusNode: _contentFocusNode,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Write your thoughts here...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onBackPressed(BuildContext context) async {
    if (!_isEdited) {
      Navigator.pop(context, false);
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple.shade800,
        title: const Text('Discard changes?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDiscard == true && mounted) {
      Navigator.pop(context, false);
    }
  }
}
