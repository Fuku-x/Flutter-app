import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int _duration = 0;
  bool _isPaused = false;
  String _transcript = '';
  Timer? _timer;
  final Random _random = Random();

  final List<String> _mockPhrases = [
    'これは音声入力のテストです。',
    '今日の会議では重要な決定事項がありました。',
    'プロジェクトの進捗状況について報告します。',
    '新しいアイデアを思いつきました。',
    'この機能は非常に便利だと思います。',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _duration++;
          // Simulate real-time transcription
          if (_duration % 3 == 0) {
            final randomPhrase = _mockPhrases[_random.nextInt(_mockPhrases.length)];
            _transcript += (_transcript.isEmpty ? '' : ' ') + randomPhrase;
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _handleCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('録音を破棄'),
        content: const Text('録音を破棄しますか?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _timer?.cancel();
              context.read<AppState>().stopRecording();
              context.read<AppState>().backToHome();
            },
            child: const Text('破棄', style: TextStyle(color: AppTheme.red600)),
          ),
        ],
      ),
    );
  }

  void _handleComplete(BuildContext context) {
    _timer?.cancel();
    final transcript = _transcript.isNotEmpty
        ? _transcript
        : 'サンプルの文字起こしテキストです。これは録音から生成された内容を表しています。実際の実装では、音声認識APIを使用して文字起こしを行います。';
    context.read<AppState>().completeRecording(transcript, _duration);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      onTap: () => _handleCancel(context),
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
                  // Recording indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.red50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.red100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.red500,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.red500.withOpacity(0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _formatTime(_duration),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB91C1C), // red-700
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer for balance
                ],
              ),
            ),

            // Waveform visualization
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.gray100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(40, (i) {
                      final height = _isPaused ? 8.0 : (_random.nextDouble() * 48 + 8);
                      final hue = 220.0 + i * 2;
                      return Container(
                        width: 3,
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: _isPaused
                              ? AppTheme.gray400.withOpacity(0.3)
                              : HSLColor.fromAHSL(1, hue, 0.8, 0.5 + _random.nextDouble() * 0.2).toColor(),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Real-time transcript
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.gray100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.blue500,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'リアルタイム文字起こし',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.gray600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _transcript.isEmpty ? '音声を認識中...' : _transcript,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: AppTheme.gray700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppTheme.gray100)),
              ),
              child: Row(
                children: [
                  // Pause/Play button
                  Material(
                    color: AppTheme.gray100,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _togglePause,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isPaused ? Icons.play_arrow : Icons.pause,
                          color: AppTheme.gray700,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Complete button
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: primaryGradient(),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.blue600.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleComplete(context),
                          borderRadius: BorderRadius.circular(12),
                          child: const Center(
                            child: Text(
                              '完了して要約する',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
