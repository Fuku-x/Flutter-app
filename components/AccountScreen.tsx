import { useState } from 'react';
import { ArrowLeft, Camera, LogOut } from 'lucide-react';
import type { User } from '../App';

type AccountScreenProps = {
  user: User;
  onBack: () => void;
  onUpdateUser: (updates: Partial<User>) => void;
  onLogout: () => void;
};

export function AccountScreen({ user, onBack, onUpdateUser, onLogout }: AccountScreenProps) {
  const [isEditingName, setIsEditingName] = useState(false);
  const [editedName, setEditedName] = useState(user.name);

  const handleSaveName = () => {
    if (editedName.trim()) {
      onUpdateUser({ name: editedName.trim() });
      setIsEditingName(false);
    }
  };

  const handleLogout = () => {
    if (window.confirm('ログアウトしますか？')) {
      onLogout();
    }
  };

  return (
    <div className="w-full min-h-screen bg-gradient-to-b from-gray-50 to-white">
      {/* ヘッダー */}
      <div className="sticky top-0 bg-white border-b border-gray-100 px-4 py-4 flex items-center gap-3 z-10 shadow-sm">
        <button
          onClick={onBack}
          className="w-9 h-9 flex items-center justify-center rounded-xl hover:bg-gray-100 text-gray-700 transition-all"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h2 className="text-gray-900">アカウント設定</h2>
      </div>

      {/* プロフィール画像 */}
      <div className="flex flex-col items-center py-8 px-4">
        <div className="relative">
          <img
            src={user.photoURL}
            alt={user.name}
            className="w-24 h-24 rounded-full border-4 border-white shadow-lg"
          />
          <button className="absolute bottom-0 right-0 w-8 h-8 bg-blue-600 hover:bg-blue-700 rounded-full flex items-center justify-center shadow-lg transition-all">
            <Camera className="w-4 h-4 text-white" />
          </button>
        </div>
      </div>

      {/* アカウント情報 */}
      <div className="px-4 pb-6">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
          {/* 名前 */}
          <div className="p-4 border-b border-gray-100">
            <label className="block text-sm text-gray-600 mb-2">名前</label>
            {isEditingName ? (
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  value={editedName}
                  onChange={(e) => setEditedName(e.target.value)}
                  className="flex-1 px-3 py-1.5 text-sm border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  autoFocus
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') handleSaveName();
                    if (e.key === 'Escape') {
                      setEditedName(user.name);
                      setIsEditingName(false);
                    }
                  }}
                />
                <button
                  onClick={handleSaveName}
                  className="px-3 py-1.5 text-sm bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-all whitespace-nowrap"
                >
                  保存
                </button>
                <button
                  onClick={() => {
                    setEditedName(user.name);
                    setIsEditingName(false);
                  }}
                  className="px-3 py-1.5 text-sm border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-lg transition-all whitespace-nowrap"
                >
                  キャンセル
                </button>
              </div>
            ) : (
              <div className="flex items-center justify-between">
                <span className="text-gray-900">{user.name}</span>
                <button
                  onClick={() => setIsEditingName(true)}
                  className="px-3 py-1.5 text-sm text-blue-600 hover:bg-blue-50 rounded-lg transition-all"
                >
                  編集
                </button>
              </div>
            )}
          </div>

          {/* メールアドレス */}
          <div className="p-4">
            <label className="block text-sm text-gray-600 mb-2">メールアドレス</label>
            <span className="text-gray-900">{user.email}</span>
          </div>
        </div>
      </div>

      {/* 設定オプション */}
      <div className="px-4 pb-6">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
          <button className="w-full p-4 text-left hover:bg-gray-50 transition-all border-b border-gray-100">
            <div className="text-gray-900 mb-1">通知設定</div>
            <div className="text-sm text-gray-500">プッシュ通知とメール通知</div>
          </button>
          <button className="w-full p-4 text-left hover:bg-gray-50 transition-all border-b border-gray-100">
            <div className="text-gray-900 mb-1">ストレージ</div>
            <div className="text-sm text-gray-500">データの使用状況を確認</div>
          </button>
          <button className="w-full p-4 text-left hover:bg-gray-50 transition-all">
            <div className="text-gray-900 mb-1">プライバシーとセキュリティ</div>
            <div className="text-sm text-gray-500">データ保護とセキュリティ設定</div>
          </button>
        </div>
      </div>

      {/* アプリ情報 */}
      <div className="px-4 pb-6">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
          <button className="w-full p-4 text-left hover:bg-gray-50 transition-all border-b border-gray-100">
            <div className="text-gray-900 mb-1">利用規約</div>
          </button>
          <button className="w-full p-4 text-left hover:bg-gray-50 transition-all border-b border-gray-100">
            <div className="text-gray-900 mb-1">プライバシーポリシー</div>
          </button>
          <button className="w-full p-4 text-left hover:bg-gray-50 transition-all">
            <div className="text-gray-900 mb-1">バージョン</div>
            <div className="text-sm text-gray-500">1.0.0</div>
          </button>
        </div>
      </div>

      {/* ログアウトボタン */}
      <div className="px-4 pb-8">
        <button
          onClick={handleLogout}
          className="w-full flex items-center justify-center gap-2 px-6 py-4 bg-white hover:bg-red-50 text-red-600 rounded-2xl shadow-sm border border-red-200 hover:border-red-300 transition-all"
        >
          <LogOut className="w-5 h-5" />
          <span>ログアウト</span>
        </button>
      </div>
    </div>
  );
}