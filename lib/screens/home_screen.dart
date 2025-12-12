import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_state.dart';
import '../models/note.dart';
import '../models/folder_category.dart';
import '../theme/app_theme.dart';
import '../widgets/edit_title_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _expandedCategories = {
    'Work': true,
    'Personal': true,
    'Archive': false,
  };

  String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$year-$month/$day $hours:$minutes';
  }

  void _showNoteMenu(BuildContext context, Note note) {
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
                _showEditTitleModal(context, note);
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

  void _showEditTitleModal(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => EditTitleModal(
        note: note,
        onSave: (newTitle) {
          final appState = context.read<AppState>();
          final lines = note.summary.split('\n');
          if (lines.isNotEmpty && lines[0].startsWith('#')) {
            lines[0] = '# $newTitle';
            appState.updateNote(note.id, title: newTitle, summary: lines.join('\n'));
          } else {
            appState.updateNote(note.id, title: newTitle);
          }
        },
      ),
    );
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
    final user = appState.user;
    final recentNotes = appState.recentNotes;

    return Container(
      decoration: gradientBackground(),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => appState.forceSetActiveTab(TabType.account),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: user?.photoURL ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=default',
                                width: 24,
                                height: 24,
                                placeholder: (context, url) => Container(
                                  width: 24,
                                  height: 24,
                                  color: AppTheme.gray200,
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 24,
                                  height: 24,
                                  color: AppTheme.gray200,
                                  child: const Icon(Icons.person, size: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user?.name ?? 'Workspace',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.gray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 1,
                      shadowColor: Colors.black.withOpacity(0.05),
                      child: InkWell(
                        onTap: () {
                          appState.setSelectedFolder(null);
                          appState.forceSetActiveTab(TabType.search);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.gray100),
                          ),
                          child: const Icon(Icons.search, color: AppTheme.gray700, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Notes Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.blue500,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '最近のメモ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gray900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Recent Notes List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final note = recentNotes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: _buildNoteCard(context, note, appState),
                  );
                },
                childCount: recentNotes.length,
              ),
            ),

            // Folders Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.green500,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'フォルダ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Folder List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildFolderList(context, appState),
              ),
            ),

            // Bottom padding for FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, AppState appState) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      child: InkWell(
        onTap: () => appState.setCurrentNote(note.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.gray100),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                            fontSize: 13,
                            color: AppTheme.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showNoteMenu(context, note),
                icon: const Icon(Icons.more_vert, color: AppTheme.gray400, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.gray400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolderList(BuildContext context, AppState appState) {
    return Column(
      children: folderStructure.map((category) {
        final isExpanded = _expandedCategories[category.name] ?? false;
        return Column(
          children: [
            // Category Header
            InkWell(
              onTap: () {
                setState(() {
                  _expandedCategories[category.name] = !isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.chevron_right, color: AppTheme.gray500, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.folder_outlined, color: AppTheme.gray500, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.gray700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Subfolders
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: category.folders.map((folder) {
                    final count = appState.getFolderCount(folder);
                    return InkWell(
                      onTap: () {
                        appState.setSelectedFolder(folder);
                        appState.forceSetActiveTab(TabType.search);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.description_outlined, color: AppTheme.gray400, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                folder,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.gray600,
                                ),
                              ),
                            ),
                            Text(
                              count.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.gray400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
