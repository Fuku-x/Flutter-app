import { useState } from 'react';
import { Plus, X, ChevronRight, ArrowLeft, FileText, MoreVertical } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import type { Note } from '../App';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from './ui/dropdown-menu';

type NoteDetailScreenProps = {
  note: Note;
  onUpdateNote: (noteId: string, updates: Partial<Note>) => void;
  onRegenerateSummary: (noteId: string) => void;
  onEditTranscript: (noteId: string, transcript: string) => void;
  onDeleteNote: (noteId: string) => void;
  onBack: () => void;
};

export function NoteDetailScreen({
  note,
  onUpdateNote,
  onRegenerateSummary,
  onEditTranscript,
  onDeleteNote,
  onBack,
}: NoteDetailScreenProps) {
  const [isAddingTag, setIsAddingTag] = useState(false);
  const [newTag, setNewTag] = useState('');

  const handleAddTag = () => {
    if (newTag.trim()) {
      const updatedTags = [...note.tags, newTag.trim()];
      onUpdateNote(note.id, { tags: updatedTags });
      setNewTag('');
      setIsAddingTag(false);
    }
  };

  const handleRemoveTag = (tagToRemove: string) => {
    const updatedTags = note.tags.filter((tag) => tag !== tagToRemove);
    onUpdateNote(note.id, { tags: updatedTags });
  };

  const handleEditTranscriptClick = () => {
    // モックの文字起こしテキスト
    const mockTranscript = `これは元の文字起こしテキストです。実際の実装では、録音時の文字起こしをキャッシュから取得します。

音声入力から生成された詳細な文字起こしがここに表示されます。ユーザーはこのテキストを編集して、より正確な要約を生成することができます。

例えば、固有名詞の修正や、不要な部分の削除などを行うことができます。`;
    
    onEditTranscript(note.id, mockTranscript);
  };

  const formatDate = (date: Date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    
    return `${year}-${month}/${day} ${hours}:${minutes}`;
  };

  return (
    <div className="w-full min-h-screen bg-gradient-to-b from-gray-50 to-white px-4 py-4">
      {/* Header with Back Button and Menu */}
      <div className="flex items-center justify-between mb-4">
        <button
          onClick={onBack}
          className="w-10 h-10 flex items-center justify-center rounded-xl bg-white hover:bg-gray-100 transition-all shadow-sm border border-gray-100"
          aria-label="戻る"
        >
          <ArrowLeft className="w-5 h-5 text-gray-700" />
        </button>
        
        {/* Menu Button */}
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <button
              className="w-10 h-10 flex items-center justify-center rounded-xl bg-white hover:bg-gray-100 transition-all shadow-sm border border-gray-100"
              aria-label="メニュー"
            >
              <MoreVertical className="w-5 h-5 text-gray-700" />
            </button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuItem
              onClick={handleEditTranscriptClick}
            >
              編集
            </DropdownMenuItem>
            <DropdownMenuItem
              onClick={() => {
                if (window.confirm('このメモを削除しますか？')) {
                  onDeleteNote(note.id);
                }
              }}
              className="text-red-600 focus:text-red-600"
            >
              削除
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>

      {/* タイトル */}
      <h1 className="mb-4 text-gray-900">{note.title}</h1>

      {/* メタ情報 */}
      <div className="mb-4 flex items-center gap-3 text-sm text-gray-500">
        <div className="flex items-center gap-2">
          <div className="w-1 h-1 rounded-full bg-gray-400"></div>
          {formatDate(note.date)}
        </div>
        {note.folder && (
          <>
            <div className="w-1 h-1 rounded-full bg-gray-300"></div>
            <div>{note.folder}</div>
          </>
        )}
      </div>

      {/* タグ一覧 */}
      <div className="mb-4">
        <div className="flex flex-wrap gap-1.5">
          {note.tags.map((tag) => (
            <div
              key={tag}
              className="group flex items-center gap-1.5 px-3 py-1.5 bg-gray-100 text-gray-700 rounded-lg border border-gray-200 shadow-sm"
            >
              <span className="text-sm">#{tag}</span>
              <button
                onClick={() => handleRemoveTag(tag)}
                className="opacity-0 group-hover:opacity-100 transition-opacity hover:bg-white rounded-full p-0.5"
              >
                <X className="w-3 h-3" />
              </button>
            </div>
          ))}
          
          {isAddingTag ? (
            <div className="flex items-center gap-2">
              <input
                type="text"
                value={newTag}
                onChange={(e) => setNewTag(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && handleAddTag()}
                onBlur={handleAddTag}
                placeholder="タグ名"
                className="px-3 py-1.5 border border-blue-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm"
                autoFocus
              />
            </div>
          ) : (
            <button
              onClick={() => setIsAddingTag(true)}
              className="flex items-center gap-1.5 px-3 py-1.5 bg-white hover:bg-gray-50 text-gray-600 rounded-lg transition-all border border-gray-200 shadow-sm"
            >
              <Plus className="w-3.5 h-3.5" />
              <span className="text-sm">タグを追加</span>
            </button>
          )}
        </div>
      </div>

      {/* 本文（Note） */}
      <div className="mb-4">
        <div className="px-2 py-2">
          <div className="prose prose-sm max-w-none">
            <ReactMarkdown
              className="text-gray-700 leading-relaxed"
              components={{
                h1: ({node, ...props}) => <h1 className="text-xl mt-4 mb-2" {...props} />,
                h2: ({node, ...props}) => <h2 className="text-lg mt-3 mb-2" {...props} />,
                h3: ({node, ...props}) => <h3 className="text-base mt-2 mb-1" {...props} />,
                p: ({node, ...props}) => <p className="mb-3" {...props} />,
                ul: ({node, ...props}) => <ul className="list-disc list-inside mb-3 space-y-1" {...props} />,
                ol: ({node, ...props}) => <ol className="list-decimal list-inside mb-3 space-y-1" {...props} />,
                li: ({node, ...props}) => <li className="ml-2" {...props} />,
                code: ({node, inline, ...props}: any) => 
                  inline ? (
                    <code className="bg-gray-100 px-1.5 py-0.5 rounded text-sm" {...props} />
                  ) : (
                    <code className="block bg-gray-100 p-3 rounded-lg my-2 text-sm" {...props} />
                  ),
                blockquote: ({node, ...props}) => (
                  <blockquote className="border-l-4 border-blue-500 pl-4 italic text-gray-600 my-3" {...props} />
                ),
                strong: ({node, ...props}) => <strong className="font-semibold" {...props} />,
                em: ({node, ...props}) => <em className="italic" {...props} />,
              }}
            >
              {note.summary}
            </ReactMarkdown>
          </div>
        </div>
      </div>
    </div>
  );
}