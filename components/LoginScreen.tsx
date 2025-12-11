import { Mic } from 'lucide-react';

type User = {
  name: string;
  email: string;
  photoURL: string;
};

type LoginScreenProps = {
  onLogin: (user: User) => void;
};

export function LoginScreen({ onLogin }: LoginScreenProps) {
  const handleGoogleLogin = () => {
    // 実際のアプリではGoogle OAuth認証を実装
    // ここではモックとしてダミーユーザー情報を生成
    const mockUser: User = {
      name: 'Tanaka Taro',
      email: 'tanaka.taro@example.com',
      photoURL: 'https://api.dicebear.com/7.x/avataaars/svg?seed=tanaka'
    };
    onLogin(mockUser);
  };

  return (
    <div className="w-full h-screen bg-gradient-to-b from-gray-50 to-white flex flex-col items-center justify-center px-6">
      {/* Logo / Brand */}
      <div className="mb-12 text-center">
        <div className="w-20 h-20 mx-auto mb-6 bg-gradient-to-r from-blue-600 to-blue-700 rounded-3xl shadow-2xl flex items-center justify-center">
          <Mic className="w-10 h-10 text-white" />
        </div>
        <h1 className="text-3xl text-gray-900 mb-2">VoiceMemo</h1>
        <p className="text-gray-600">音声からアイデアを記録</p>
      </div>

      {/* Features */}
      <div className="w-full max-w-sm mb-12 space-y-4">
        <div className="flex items-start gap-3">
          <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
            <span className="text-blue-600">🎤</span>
          </div>
          <div>
            <h3 className="text-gray-900 mb-1">簡単な音声入力</h3>
            <p className="text-sm text-gray-600">ボタン一つで録音開始</p>
          </div>
        </div>
        <div className="flex items-start gap-3">
          <div className="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
            <span className="text-purple-600">✨</span>
          </div>
          <div>
            <h3 className="text-gray-900 mb-1">自動文字起こし</h3>
            <p className="text-sm text-gray-600">AIが音声をテキスト化</p>
          </div>
        </div>
        <div className="flex items-start gap-3">
          <div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
            <span className="text-green-600">📝</span>
          </div>
          <div>
            <h3 className="text-gray-900 mb-1">スマートな整理</h3>
            <p className="text-sm text-gray-600">タグとフォルダで管理</p>
          </div>
        </div>
      </div>

      {/* Login Button */}
      <div className="w-full max-w-sm">
        <button
          onClick={handleGoogleLogin}
          className="w-full flex items-center justify-center gap-3 px-6 py-4 bg-white hover:bg-gray-50 rounded-xl shadow-lg hover:shadow-xl transition-all border border-gray-200"
        >
          <svg className="w-6 h-6" viewBox="0 0 24 24">
            <path
              fill="#4285F4"
              d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
            />
            <path
              fill="#34A853"
              d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
            />
            <path
              fill="#FBBC05"
              d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
            />
            <path
              fill="#EA4335"
              d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
            />
          </svg>
          <span className="text-gray-900">Googleでログイン</span>
        </button>

        <p className="text-center text-sm text-gray-500 mt-6">
          ログインすることで、
          <a href="#" className="text-blue-600 hover:underline">利用規約</a>
          と
          <a href="#" className="text-blue-600 hover:underline">プライバシーポリシー</a>
          に同意したものとみなされます
        </p>
      </div>
    </div>
  );
}