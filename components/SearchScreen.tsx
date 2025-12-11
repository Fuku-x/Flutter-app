import { Search, ArrowLeft, Tag, ChevronRight, MoreVertical } from 'lucide-react';
import { useState } from 'react';
import type { Note } from '../App';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from './ui/dropdown-menu';
import { EditTitleModal } from './EditTitleModal';

type SearchScreenProps = {
  notes: Note[];
  onNoteClick: (noteId: string) => void;
  onBack: () => void;
  initialFolder?: string;
  onDeleteNote?: (noteId: string) => void;
  onUpdateNote?: (noteId: string, updates: Partial<Note>) => void;
};

export function SearchScreen({ notes, onNoteClick, onBack, initialFolder, onDeleteNote, onUpdateNote }: SearchScreenProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editingNote, setEditingNote] = useState<Note | null>(null);
  const [editingNoteId, setEditingNoteId] = useState<string | null>(null);
  
  const searchHistory = ['プロジェクト会議', 'デザイン思考', 'アプリアイデア'];
  const popularTags = ['#仕事', '#学習', '#アイデア', '#ミーティング', '#開発'];

  // フォルダーフィルタリングを適用
  const displayNotes = initialFolder
    ? notes.filter(note => note.folder === initialFolder)
    : notes;

  const filteredNotes = searchQuery
    ? displayNotes.filter((note) =>
        note.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        note.summary.toLowerCase().includes(searchQuery.toLowerCase()) ||
        note.tags.some((tag) =>
          tag.toLowerCase().includes(searchQuery.toLowerCase())
        )
      )
    : displayNotes;

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
      {/* Header with Back Button */}
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={onBack}
          className="w-10 h-10 flex items-center justify-center rounded-xl bg-white hover:bg-gray-100 transition-all shadow-sm border border-gray-100"
          aria-label="戻る"
        >
          <ArrowLeft className="w-5 h-5 text-gray-700" />
        </button>
        <div>
          <h1 className="text-gray-900">{initialFolder ? initialFolder : '検索'}</h1>
          {initialFolder && (
            <p className="text-sm text-gray-500">{displayNotes.length}件のメモ</p>
          )}
        </div>
      </div>

      {/* 検索バー */}
      <div className="mb-6">
        <div className="relative">
          <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            placeholder="メモを検索..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-12 pr-12 py-3 bg-white border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent shadow-sm transition-all"
          />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery('')}
              className="absolute right-3 top-1/2 transform -translate-y-1/2 w-6 h-6 flex items-center justify-center rounded-full bg-gray-200 hover:bg-gray-300 transition-colors"
              aria-label="クリア"
            >
              <span className="text-gray-600 text-sm">✕</span>
            </button>
          )}
        </div>
      </div>

      {/* 検索結果 */}
      {(searchQuery || initialFolder) && (
        <section className="mb-6">
          <h2 className="mb-3 text-gray-900 flex items-center gap-2">
            <div className="w-1 h-5 bg-blue-500 rounded-full"></div>
            {searchQuery ? `検索結果 (${filteredNotes.length}件)` : `すべてのメモ (${filteredNotes.length}件)`}
          </h2>
          <div className="space-y-2">
            {filteredNotes.length > 0 ? (
              filteredNotes.map((note) => (
                <div
                  key={note.id}
                  className="w-full p-3 bg-white hover:bg-gray-50 rounded-xl transition-all shadow-sm hover:shadow-md border border-gray-100 group relative"
                >
                  <div className="flex items-start justify-between gap-2">
                    <button
                      onClick={() => onNoteClick(note.id)}
                      className="flex-1 text-left"
                    >
                      <div className="mb-2 text-gray-900 group-hover:text-blue-600 transition-colors">{note.title}</div>
                      <div className="flex flex-wrap gap-1.5 mb-2">
                        {note.tags.slice(0, 3).map((tag) => (
                          <span
                            key={tag}
                            className="px-2 py-0.5 bg-gray-100 text-gray-700 rounded-lg text-xs border border-gray-200"
                          >
                            #{tag}
                          </span>
                        ))}
                      </div>
                      <div className="text-sm text-gray-500 flex items-center gap-2">
                        <div className="w-1 h-1 rounded-full bg-gray-400"></div>
                        {formatDate(note.date)}
                      </div>
                    </button>
                    
                    {/* Menu Button */}
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <button
                          onClick={(e) => e.stopPropagation()}
                          className="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-gray-200 transition-colors opacity-0 group-hover:opacity-100"
                          aria-label="メニュー"
                        >
                          <MoreVertical className="w-4 h-4 text-gray-600" />
                        </button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem
                          onClick={(e) => {
                            e.stopPropagation();
                            setEditingNote(note);
                            setEditingNoteId(note.id);
                            setIsEditModalOpen(true);
                          }}
                        >
                          編集
                        </DropdownMenuItem>
                        <DropdownMenuItem
                          onClick={(e) => {
                            e.stopPropagation();
                            if (onDeleteNote && window.confirm('このメモを削除しますか？')) {
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
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-400 bg-white rounded-xl border border-gray-100">
                該当するメモが見つかりませんでした
              </div>
            )}
          </div>
        </section>
      )}

      {/* 検索履歴 */}
      {!searchQuery && !initialFolder && (
        <>
          <section className="mb-6">
            <h2 className="mb-3 text-gray-900 flex items-center gap-2">
              <div className="w-1 h-5 bg-orange-500 rounded-full"></div>
              検索履歴
            </h2>
            <div className="space-y-2">
              {searchHistory.map((query) => (
                <button
                  key={query}
                  onClick={() => setSearchQuery(query)}
                  className="w-full flex items-center justify-between p-3 bg-white hover:bg-gray-50 rounded-xl transition-all shadow-sm border border-gray-100 group text-left"
                >
                  <span className="text-gray-700 group-hover:text-gray-900">{query}</span>
                  <ChevronRight className="w-5 h-5 text-gray-400 group-hover:text-blue-500 group-hover:translate-x-1 transition-all" />
                </button>
              ))}
            </div>
          </section>

          {/* タグ候補 */}
          <section>
            <h2 className="mb-3 text-gray-900 flex items-center gap-2">
              <div className="w-1 h-5 bg-purple-500 rounded-full"></div>
              人気のタグ
            </h2>
            <div className="flex flex-wrap gap-2">
              {popularTags.map((tag) => (
                <button
                  key={tag}
                  onClick={() => setSearchQuery(tag)}
                  className="flex items-center gap-2 px-4 py-2 bg-white hover:bg-gradient-to-r hover:from-blue-50 hover:to-purple-50 rounded-lg transition-all shadow-sm hover:shadow border border-gray-100 group"
                >
                  <div className="w-2 h-2 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full"></div>
                  <span className="text-sm text-gray-700 group-hover:text-gray-900">{tag}</span>
                </button>
              ))}
            </div>
          </section>
        </>
      )}

      {/* Edit Title Modal */}
      <EditTitleModal
        isOpen={isEditModalOpen}
        onClose={() => setIsEditModalOpen(false)}
        note={editingNote}
        onTitleChange={(newTitle) => {
          if (onUpdateNote && editingNoteId && editingNote) {
            // summaryの最初の行（# タイトル）を更新
            const lines = editingNote.summary.split('\n');
            if (lines[0].startsWith('#')) {
              lines[0] = `# ${newTitle}`;
              const updatedSummary = lines.join('\n');
              onUpdateNote(editingNoteId, { title: newTitle, summary: updatedSummary });
            } else {
              onUpdateNote(editingNoteId, { title: newTitle });
            }
          }
        }}
      />
    </div>
  );
}