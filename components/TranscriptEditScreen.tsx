import { useState } from 'react';
import { Save, X } from 'lucide-react';

type TranscriptEditScreenProps = {
  title: string;
  transcript: string;
  onSave: (newTitle: string, newTranscript: string) => void;
  onCancel: () => void;
};

export function TranscriptEditScreen({
  title,
  transcript,
  onSave,
  onCancel,
}: TranscriptEditScreenProps) {
  const [editedTitle, setEditedTitle] = useState(title);
  const [editedTranscript, setEditedTranscript] = useState(transcript);

  const handleSave = () => {
    onSave(editedTitle, editedTranscript);
  };

  return (
    <div className="h-full flex flex-col bg-gradient-to-b from-gray-50 to-white">
      {/* ヘッダー */}
      <div className="px-4 py-4 bg-white border-b border-gray-100 flex items-center justify-between shadow-sm">
        <h2 className="text-gray-900">文字起こしを編集</h2>
        <button
          onClick={onCancel}
          className="w-9 h-9 flex items-center justify-center rounded-xl hover:bg-gray-100 text-gray-500 hover:text-gray-700 transition-all"
        >
          <X className="w-5 h-5" />
        </button>
      </div>

      {/* タイトルエリア */}
      <div className="p-4 bg-white border-b border-gray-100">
        <input
          value={editedTitle}
          onChange={(e) => setEditedTitle(e.target.value)}
          className="w-full p-2 bg-white border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent leading-relaxed shadow-sm"
          placeholder="タイトルを編集..."
        />
      </div>

      {/* テキストエリア */}
      <div className="flex-1 p-4 overflow-auto">
        <textarea
          value={editedTranscript}
          onChange={(e) => setEditedTranscript(e.target.value)}
          className="w-full h-full p-4 bg-white border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none leading-relaxed shadow-sm"
          placeholder="文字起こしテキストを編集..."
        />
      </div>

      {/* フッター */}
      <div className="p-4 bg-white border-t border-gray-100 flex gap-2.5 shadow-sm">
        <button
          onClick={onCancel}
          className="flex-1 px-5 py-3 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-all"
        >
          キャンセル
        </button>
        <button
          onClick={handleSave}
          className="flex-1 px-5 py-3 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white rounded-xl flex items-center justify-center gap-2 transition-all shadow-lg hover:shadow-xl"
        >
          <Save className="w-4 h-4" />
          要約を再生成する
        </button>
      </div>
    </div>
  );
}