import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';

class EditTitleModal extends StatefulWidget {
  final Note note;
  final Function(String) onSave;

  const EditTitleModal({
    super.key,
    required this.note,
    required this.onSave,
  });

  @override
  State<EditTitleModal> createState() => _EditTitleModalState();
}

class _EditTitleModalState extends State<EditTitleModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      widget.onSave(title);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 8, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'タイトルを編集',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppTheme.gray600),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.gray100),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'タイトルを入力',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.blue500, width: 2),
                  ),
                ),
                onSubmitted: (_) => _handleSave(),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: const BoxDecoration(
                color: AppTheme.gray50,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(color: AppTheme.gray700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.blue600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
