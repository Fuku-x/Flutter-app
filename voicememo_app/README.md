# VoiceMemo App

音声メモを録音し、自動で文字起こし・要約を生成するiOSアプリケーションです。

## はじめに

### 前提条件

| ソフトウェア | バージョン | 確認コマンド |
|------------|-----------|-------------|
| macOS | 13.0+ | `sw_vers` |
| Xcode | 15.0+ | `xcodebuild -version` |
| Flutter | 3.x | `flutter --version` |
| CocoaPods | 1.14+ | `pod --version` |

### クイックスタート

```bash
# Flutter のインストール確認
flutter --version

# 依存関係のインストール
flutter pub get

# iOS シミュレータの起動
open -a Simulator

# ビルド & 実行
flutter run
```

### Flutter のインストール

#### Homebrew を使用する場合（推奨）

```bash
# Homebrew のインストール（未インストールの場合）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Flutter のインストール
brew install --cask flutter

# インストール確認
flutter doctor -v
```

#### 手動インストールの場合

```bash
# Flutter SDK をダウンロード
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
```

**bash の場合:**
```bash
# パスを ~/.bashrc に追加
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc

# 設定を反映
source ~/.bashrc
```

**zsh の場合:**
```zsh
# パスを ~/.zshrc に追加
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc

# 設定を反映
source ~/.zshrc
```

```bash
# インストール確認
flutter doctor -v
```

### Xcode のセットアップ

```bash
# Xcode コマンドラインツールのインストール
xcode-select --install

# ライセンスの同意
sudo xcodebuild -license accept

# CocoaPods のインストール
sudo gem install cocoapods
```

### プロジェクトのセットアップ

```bash
# リポジトリをクローン
git clone git@github.com:Fuku-x/Flutter-app.git
cd Flutter-app/voicememo_app

# Flutter パッケージのインストール
flutter pub get

# iOS の依存関係をインストール
cd ios
pod install
cd ..
```

### アプリケーションの実行

```bash
# シミュレータを起動
open -a Simulator

# アプリを実行
flutter run

# 特定のデバイスを指定して実行
flutter devices  # 利用可能なデバイスを確認
flutter run -d "iPhone 17 Pro"
```

## 技術スタック

- **Flutter** 3.x (Stable)
- **Dart** 3.x
- **iOS** 17+ (ターゲット)
- **状態管理**: Provider
- **Markdown**: flutter_markdown
- **画像キャッシュ**: cached_network_image

## 主要な依存関係

### Flutter コア
- **Material Design** - UIコンポーネント
- **Cupertino Icons** - iOSスタイルアイコン

### 状態管理
- **Provider** ^6.1.2 - アプリケーション状態管理

### UI/UX
- **flutter_markdown** ^0.7.4 - Markdownレンダリング
- **cached_network_image** ^3.4.1 - ネットワーク画像キャッシュ

### 将来の拡張予定
- **Firebase Auth** - Google認証
- **Cloud Firestore** - データ永続化
- **Speech to Text** - 音声認識
- **OpenAI API** - 要約生成

## プロジェクト構成

```
lib/
├── main.dart                    # エントリーポイント
├── models/                      # データモデル
│   ├── note.dart               # メモモデル
│   ├── user.dart               # ユーザーモデル
│   └── folder_category.dart    # フォルダカテゴリ
├── providers/                   # 状態管理
│   └── app_state.dart          # アプリケーション状態
├── screens/                     # 画面
│   ├── login_screen.dart       # ログイン画面
│   ├── home_screen.dart        # ホーム画面
│   ├── search_screen.dart      # 検索画面
│   ├── record_screen.dart      # 録音画面
│   ├── note_detail_screen.dart # メモ詳細画面
│   ├── account_screen.dart     # アカウント設定画面
│   └── transcript_edit_screen.dart # 文字起こし編集画面
├── widgets/                     # 共通ウィジェット
│   └── edit_title_modal.dart   # タイトル編集モーダル
└── theme/                       # テーマ設定
    └── app_theme.dart          # カラー・スタイル定義
```

## チーム開発について

### 言語設定
- **アプリケーションのロケール**: 日本語 (ja_JP)
- **タイムゾーン**: Asia/Tokyo
- **文字エンコーディング**: UTF-8

### コーディング規約
- Dart公式スタイルガイドに準拠
- `flutter analyze` でエラー・警告がないこと
- 状態管理は Provider パターンを使用

## テストについて

### テストの実行

```bash
# 全テスト実行
flutter test

# 特定のテストファイルを実行
flutter test test/widget_test.dart

# カバレッジ付きでテスト実行
flutter test --coverage

# テストレポートの確認
open coverage/lcov-report/index.html
```

### テストの書き方

ウィジェットテストの例：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:voicememo_app/main.dart';

void main() {
  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.text('Googleでログイン'), findsOneWidget);
  });
}
```

## ビルド

### iOS ビルド

```bash
# デバッグビルド（シミュレータ用）
flutter build ios --simulator

# リリースビルド（実機用、コード署名なし）
flutter build ios --no-codesign

# リリースビルド（App Store用）
flutter build ios --release
```

### 実機でのテスト

1. Xcode で `ios/Runner.xcworkspace` を開く
2. Signing & Capabilities でチームを設定
3. 実機を接続して実行

## 開発ガイドライン

### ブランチ戦略
- `main` - 本番リリース用
- `develop` - 開発用メインブランチ
- `feature/*` - 機能開発用
- `fix/*` - バグ修正用

### コミットメッセージ
```
feat: 新機能の追加
fix: バグ修正
docs: ドキュメント更新
style: コードスタイル修正
refactor: リファクタリング
test: テスト追加・修正
```

### プルリクエスト
1. `flutter analyze` でエラーがないこと
2. `flutter test` が全てパスすること
3. レビュアーの承認を得ること

## トラブルシューティング

### よくある問題

**シミュレータが見つからない場合**
```bash
# 利用可能なシミュレータを確認
xcrun simctl list devices available

# シミュレータを起動
xcrun simctl boot "iPhone 17 Pro"
open -a Simulator
```

**依存関係のエラー**
```bash
# キャッシュをクリアして再インストール
flutter clean
flutter pub get
```

**iOS ビルドエラー**
```bash
# CocoaPods を更新
cd ios
pod deintegrate
pod install --repo-update
cd ..
flutter build ios
```

## ライセンス

Private - All rights reserved
