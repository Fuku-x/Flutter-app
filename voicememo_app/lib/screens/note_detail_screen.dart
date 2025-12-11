import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  bool _isAddingTag = false;
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$year-$month/$day $hours:$minutes';
  }

  void _addTag(BuildContext context, Note note) {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty) {
      final updatedTags = [...note.tags, tag];
      context.read<AppState>().updateNote(note.id, tags: updatedTags);
      _tagController.clear();
      setState(() {
        _isAddingTag = false;
      });
    }
  }

  void _removeTag(BuildContext context, Note note, String tagToRemove) {
    final updatedTags = note.tags.where((tag) => tag != tagToRemove).toList();
    context.read<AppState>().updateNote(note.id, tags: updatedTags);
  }

  void _showMenu(BuildContext context, Note note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('編集'),
              onTap: () {
                Navigator.pop(context);
                _handleEditTranscript(context, note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppTheme.red600),
              title: const Text('削除', style: TextStyle(color: AppTheme.red600)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, note);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditTranscript(BuildContext context, Note note) {
    const mockTranscript = '''これは元の文字起こしテキストです。実際の実装では、録音時の文字起こしをキャッシュから取得します。

音声入力から生成された詳細な文字起こしがここに表示されます。ユーザーはこのテキストを編集して、より正確な要約を生成することができます。

例えば、固有名詞の修正や、不要な部分の削除などを行うことができます。''';
    
    context.read<AppState>().setEditingTranscript(mockTranscript);
  }

  void _confirmDelete(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('メモを削除'),
        content: const Text('このメモを削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AppState>().deleteNote(note.id);
            },
            child: const Text('削除', style: TextStyle(color: AppTheme.red600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final note = appState.currentNote;

    if (note == null) {
      return Container(
        decoration: gradientBackground(),
        child: const Center(
          child: Text(
            'メモを選択してください',
            style: TextStyle(color: AppTheme.gray400),
          ),
        ),
      );
    }

    return Container(
      decoration: gradientBackground(),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 1,
                    shadowColor: Colors.black.withOpacity(0.05),
                    child: InkWell(
                      onTap: () => appState.backToHome(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.gray100),
                        ),
                        child: const Icon(Icons.arrow_back, color: AppTheme.gray700, size: 20),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 1,
                    shadowColor: Colors.black.withOpacity(0.05),
                    child: InkWell(
                      onTap: () => _showMenu(context, note),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.gray100),
                        ),
                        child: const Icon(Icons.more_vert, color: AppTheme.gray700, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Meta info
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppTheme.gray400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(note.date),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.gray500,
                          ),
                        ),
                        if (note.folder != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppTheme.gray300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            note.folder!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.gray500,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...note.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.gray100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.gray200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '#$tag',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.gray700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => _removeTag(context, note, tag),
                                  child: const Icon(Icons.close, size: 14, color: AppTheme.gray500),
                                ),
                              ],
                            ),
                          );
                        }),
                        if (_isAddingTag)
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: _tagController,
                              autofocus: true,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'タグ名',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppTheme.blue300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppTheme.blue500, width: 2),
                                ),
                              ),
                              onSubmitted: (_) => _addTag(context, note),
                              onEditingComplete: () => _addTag(context, note),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAddingTag = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.gray200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.add, size: 14, color: AppTheme.gray600),
                                  SizedBox(width: 4),
                                  Text(
                                    'タグを追加',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.gray600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Summary content (Markdown)
                    MarkdownBody(
                      data: note.summary,
                      styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.gray900,
                        ),
                        h2: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.gray900,
                        ),
                        h3: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.gray900,
                        ),
                        p: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: AppTheme.gray700,
                        ),
                        listBullet: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.gray700,
                        ),
                        code: TextStyle(
                          fontSize: 14,
                          backgroundColor: AppTheme.gray100,
                          color: AppTheme.gray700,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: AppTheme.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        blockquoteDecoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: AppTheme.blue500, width: 4),
                          ),
                        ),
                        blockquotePadding: const EdgeInsets.only(left: 16),
                        strong: const TextStyle(fontWeight: FontWeight.w600),
                        em: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
