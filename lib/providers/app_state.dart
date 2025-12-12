import 'dart:math';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/user.dart';

enum TabType { home, search, record, summary, account }

class AppState extends ChangeNotifier {
  bool _isAuthenticated = false;
  AppUser? _user;
  TabType _activeTab = TabType.home;
  List<Note> _notes = [];
  String? _currentNoteId;
  bool _isRecording = false;
  String? _editingTranscript;
  String? _selectedFolder;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  AppUser? get user => _user;
  TabType get activeTab => _activeTab;
  List<Note> get notes => _notes;
  String? get currentNoteId => _currentNoteId;
  bool get isRecording => _isRecording;
  String? get editingTranscript => _editingTranscript;
  String? get selectedFolder => _selectedFolder;

  Note? get currentNote {
    if (_currentNoteId == null) return null;
    try {
      return _notes.firstWhere((n) => n.id == _currentNoteId);
    } catch (e) {
      return null;
    }
  }

  List<Note> get recentNotes => _notes.take(3).toList();

  AppState() {
    _notes = _generateNotes();
  }

  List<Note> _generateNotes() {
    final List<Note> notesData = [];
    final random = Random();

    final folders = [
      {'name': 'Projects', 'category': 'Work', 'count': 12},
      {'name': 'Meetings', 'category': 'Work', 'count': 8},
      {'name': 'Client Notes', 'category': 'Work', 'count': 5},
      {'name': 'Learning', 'category': 'Personal', 'count': 15},
      {'name': 'Ideas', 'category': 'Personal', 'count': 9},
      {'name': 'Reading Notes', 'category': 'Personal', 'count': 7},
      {'name': 'Old Projects', 'category': 'Archive', 'count': 23},
    ];

    final titles = [
      'プロジェクト計画書', 'ミーティング議事録', 'デザインレビュー', 'コードレビュー',
      '週次報告', '月次レポート', 'アイデアメモ', '学習ノート', 'タスクリスト',
      '要件定義書', 'システム設計', 'API仕様書', 'テスト計画', 'リリースノート',
      'ブレインストーミング', 'リサーチノート', '技術調査', '市場分析',
      'ユーザーインタビュー', 'フィードバック', '改善提案', 'バグ報告',
    ];

    final tags = [
      ['仕事', 'プロジェクト'], ['ミーティング', '重要'], ['デザイン', 'UI'],
      ['開発', 'コード'], ['学習', '技術'], ['アイデア', '企画'],
      ['レビュー', '品質'], ['ドキュメント'], ['計画', 'スケジュール'],
    ];

    int id = 1;
    for (final folder in folders) {
      for (int i = 0; i < (folder['count'] as int); i++) {
        final date = DateTime.now().subtract(Duration(
          days: random.nextInt(60),
          hours: random.nextInt(24),
          minutes: random.nextInt(60),
        ));

        final title = '${titles[random.nextInt(titles.length)]} #${i + 1}';
        final selectedTags = List<String>.from(tags[random.nextInt(tags.length)]);

        notesData.add(Note(
          id: id.toString(),
          title: title,
          tags: selectedTags,
          summary: '''## $title

これは${folder['name']}フォルダーのメモです。

### 概要
本メモは自動生成されたテストデータです。実際のプロジェクトでは、ここに詳細な内容が記載されます。

### ポイント
- 項目1: 重要な内容
- 項目2: 詳細情報
- 項目3: 追加メモ

> このメモは${folder['category']}カテゴリーに属しています。''',
          date: date,
          folder: folder['name'] as String,
        ));
        id++;
      }
    }

    // 元の3つのメモも追加
    notesData.addAll([
      Note(
        id: '1000',
        title: 'プロジェクト会議の議事録',
        tags: ['仕事', 'ミーティング', '重要'],
        summary: '''## 会議概要
本日のプロジェクト会議では、新機能のリリーススケジュールについて議論しました。

### 主な決定事項
- **β版リリース日**: 2024年12月15日
- **フィードバック収集期間**: 2週間

### UI/UXチームからの報告
ユーザビリティテストの結果が共有され、以下の改善が必要との指摘がありました：
1. ナビゲーションの改善
2. ボタン配置の最適化
3. レスポンシブデザインの強化

> 次回会議は12月20日を予定しています。''',
        date: DateTime(2024, 11, 26, 14, 30),
        folder: 'Meetings',
      ),
      Note(
        id: '1001',
        title: '読書メモ：デザイン思考',
        tags: ['学習', '読書', 'デザイン'],
        summary: '''# デザイン思考の5つのステップ

デザイン思考のプロセスを通じて、**ユーザー中心の解決策**を見つけることができます。

## プロセス
1. **共感** - ユーザーの潜在的なニーズを理解する
2. **問題定義** - 本質的な課題を明確にする
3. **アイデア創出** - 多様な解決策を考える
4. **プロトタイプ** - 具体的な形にする
5. **テスト** - フィードバックを得る

### ポイント
特に*共感のフェーズ*では、ユーザーの潜在的なニーズを理解することが重要です。

```
観察 → インタビュー → 分析
```''',
        date: DateTime(2024, 11, 25, 9, 15),
        folder: 'Reading Notes',
      ),
      Note(
        id: '1002',
        title: 'アプリアイデア：習慣トラッカー',
        tags: ['アイデア', '開発', 'アプリ'],
        summary: '''## コンセプト
習慣を継続するためのシンプルなアプリ

### 主な機能
- 毎日の習慣をチェックリストで管理
- 連続記録をビジュアル化
- モチベーション維持のための仕組み

### デザイン方針
**Notion**のようなシンプルなインターフェース

#### UI要素
- カレンダービュー
- ストリーク表示
- 統計グラフ

> シンプルで継続しやすいデザインを目指す''',
        date: DateTime(2024, 11, 24, 21, 0),
        folder: 'Ideas',
      ),
    ]);

    notesData.sort((a, b) => b.date.compareTo(a.date));
    return notesData;
  }

  // Auth methods
  void login(AppUser userData) {
    _user = userData;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    _activeTab = TabType.home;
    notifyListeners();
  }

  // Navigation methods
  void setActiveTab(TabType tab) {
    if (_isRecording && tab != TabType.record) {
      // Will be handled by UI with confirmation dialog
      return;
    }
    _activeTab = tab;
    if (tab == TabType.record) {
      _isRecording = true;
    }
    notifyListeners();
  }

  void forceSetActiveTab(TabType tab) {
    _activeTab = tab;
    if (tab == TabType.record) {
      _isRecording = true;
    } else {
      _isRecording = false;
    }
    notifyListeners();
  }

  void setSelectedFolder(String? folder) {
    _selectedFolder = folder;
    notifyListeners();
  }

  // Note methods
  void setCurrentNote(String? noteId) {
    _currentNoteId = noteId;
    if (noteId != null) {
      _activeTab = TabType.summary;
    }
    notifyListeners();
  }

  void updateNote(String noteId, {String? title, List<String>? tags, String? summary}) {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      final note = _notes[index];
      _notes[index] = note.copyWith(
        title: title,
        tags: tags,
        summary: summary,
      );
      notifyListeners();
    }
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((n) => n.id == noteId);
    if (_currentNoteId == noteId) {
      _currentNoteId = null;
      _activeTab = TabType.home;
    }
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  // Recording methods
  void startRecording() {
    _isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    notifyListeners();
  }

  void completeRecording(String transcript, int duration) {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '新しいメモ',
      tags: [],
      summary: '${transcript.substring(0, transcript.length > 150 ? 150 : transcript.length)}...（要約版）\n\nこのメモは録音から自動生成されました。',
      date: DateTime.now(),
    );

    _notes.insert(0, newNote);
    _currentNoteId = newNote.id;
    _isRecording = false;
    _activeTab = TabType.summary;
    notifyListeners();
  }

  // Transcript editing
  void setEditingTranscript(String? transcript) {
    _editingTranscript = transcript;
    notifyListeners();
  }

  void updateTranscript(String newTitle, String newTranscript) {
    if (_currentNoteId != null) {
      final newSummary = '''# $newTitle

【編集された文字起こしから再生成】

${newTranscript.substring(0, newTranscript.length > 200 ? 200 : newTranscript.length)}...

この要約は編集された文字起こしから生成されました。''';
      updateNote(_currentNoteId!, title: newTitle, summary: newSummary);
      _editingTranscript = null;
      _activeTab = TabType.summary;
      notifyListeners();
    }
  }

  void regenerateSummary(String noteId) {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      final note = _notes[index];
      final newSummary = '''${note.summary}

【再生成された要約】
この内容は再生成されました。より詳細な分析と構造化された情報が含まれています。''';
      _notes[index] = note.copyWith(summary: newSummary);
      notifyListeners();
    }
  }

  // Back to home
  void backToHome() {
    _activeTab = TabType.home;
    _currentNoteId = null;
    _editingTranscript = null;
    _selectedFolder = null;
    notifyListeners();
  }

  // User update
  void updateUser({String? name, String? photoURL}) {
    if (_user != null) {
      _user = _user!.copyWith(name: name, photoURL: photoURL);
      notifyListeners();
    }
  }

  // Folder count
  int getFolderCount(String folderName) {
    return _notes.where((n) => n.folder == folderName).length;
  }

  // Filter notes by folder
  List<Note> getNotesByFolder(String? folder) {
    if (folder == null) return _notes;
    return _notes.where((n) => n.folder == folder).toList();
  }
}
