import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/record_screen.dart';
import 'screens/note_detail_screen.dart';
import 'screens/account_screen.dart';
import 'screens/transcript_edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'VoiceMemo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!appState.isAuthenticated) {
      return const LoginScreen();
    }

    return const AuthenticatedScreen();
  }
}

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen({super.key});

  Widget _buildScreen(AppState appState) {
    // Check if editing transcript
    if (appState.editingTranscript != null && appState.activeTab == TabType.summary) {
      return const TranscriptEditScreen();
    }

    switch (appState.activeTab) {
      case TabType.home:
        return const HomeScreen();
      case TabType.search:
        return const SearchScreen();
      case TabType.record:
        return const RecordScreen();
      case TabType.summary:
        return const NoteDetailScreen();
      case TabType.account:
        return const AccountScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: _buildScreen(appState),
      floatingActionButton: appState.activeTab == TabType.home
          ? Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: primaryGradient(),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.blue600.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => appState.forceSetActiveTab(TabType.record),
                  customBorder: const CircleBorder(),
                  child: const Center(
                    child: Icon(Icons.mic, color: Colors.white, size: 28),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
