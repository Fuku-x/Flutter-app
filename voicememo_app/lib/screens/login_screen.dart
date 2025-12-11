import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBackground(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Brand
                  _buildLogo(),
                  const SizedBox(height: 48),
                  
                  // Features
                  _buildFeatures(),
                  const SizedBox(height: 48),
                  
                  // Login Button
                  _buildLoginButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: primaryGradient(),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.blue600.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.mic,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'VoiceMemo',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '音声からアイデアを記録',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    final features = [
      {
        'icon': '🎤',
        'color': AppTheme.blue100,
        'title': '簡単な音声入力',
        'desc': 'ボタン一つで録音開始',
      },
      {
        'icon': '✨',
        'color': AppTheme.purple100,
        'title': '自動文字起こし',
        'desc': 'AIが音声をテキスト化',
      },
      {
        'icon': '📝',
        'color': AppTheme.green100,
        'title': 'スマートな整理',
        'desc': 'タグとフォルダで管理',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: feature['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    feature['icon'] as String,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feature['desc'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            child: InkWell(
              onTap: () => _handleGoogleLogin(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.gray200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Icon - Using high quality Google logo
                    Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.g_mobiledata, size: 24, color: Color(0xFF4285F4)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Googleでログイン',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.gray900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.gray500,
            ),
            children: [
              const TextSpan(text: 'ログインすることで、'),
              TextSpan(
                text: '利用規約',
                style: TextStyle(color: AppTheme.blue600),
              ),
              const TextSpan(text: 'と'),
              TextSpan(
                text: 'プライバシーポリシー',
                style: TextStyle(color: AppTheme.blue600),
              ),
              const TextSpan(text: 'に同意したものとみなされます'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleGoogleLogin(BuildContext context) {
    final mockUser = AppUser(
      name: 'Tanaka Taro',
      email: 'tanaka.taro@example.com',
      photoURL: 'https://api.dicebear.com/7.x/avataaars/svg?seed=tanaka',
    );
    context.read<AppState>().login(mockUser);
  }
}

