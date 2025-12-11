import { Folder, Tag, ChevronRight, Search, FileText, MoreVertical } from 'lucide-react';
import { useState } from 'react';
import type { Note, User } from '../App';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from './ui/dropdown-menu';
import { EditTitleModal } from './EditTitleModal';

type HomeScreenProps = {
  notes: Note[];
  user: User | null;
  onNoteClick: (noteId: string) => void;
  onSearchClick: () => void;
  onFolderClick: (folderName: string) => void;
  onDeleteNote?: (noteId: string) => void;
  onUpdateNote?: (noteId: string, updates: Partial<Note>) => void;
  onAccountClick: () => void;
};

export function HomeScreen({ notes, user, onNoteClick, onSearchClick, onFolderClick, onDeleteNote, onUpdateNote, onAccountClick }: HomeScreenProps) {
  const recentNotes = notes.slice(0, 3);
  const [expandedCategories, setExpandedCategories] = useState<Record<string, boolean>>({
    'Work': true,
    'Personal': true,
    'Archive': false,
  });
  const [editingNoteId, setEditingNoteId] = useState<string | null>(null);
  const [editingTitle, setEditingTitle] = useState('');
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editingNote, setEditingNote] = useState<Note | null>(null);
  
  const folderStructure = [
    {
      category: 'Work',
      color: 'bg-blue-500',
      folders: [
        { name: 'Projects', indent: 1 },
        { name: 'Meetings', indent: 1 },
        { name: 'Client Notes', indent: 1 },
      ]
    },
    {
      category: 'Personal',
      color: 'bg-purple-500',
      folders: [
        { name: 'Learning', indent: 1 },
        { name: 'Ideas', indent: 1 },
        { name: 'Reading Notes', indent: 1 },
      ]
    },
    {
      category: 'Archive',
      color: 'bg-gray-500',
      folders: [
        { name: 'Old Projects', indent: 1 },
      ]
    },
  ];

  const toggleCategory = (category: string) => {
    setExpandedCategories(prev => ({
      ...prev,
      [category]: !prev[category]
    }));
  };

  const handleFolderClick = (folderName: string) => {
    // そのフォルダーの最初のメモを開く
    const folderNote = notes.find(note => note.folder === folderName);
    if (folderNote) {
      onNoteClick(folderNote.id);
    }
  };

  // フォルダー内のメモ数をカウント
  const getFolderCount = (folderName: string) => {
    return notes.filter(note => note.folder === folderName).length;
  };

  const handleEditTitle = (noteId: string) => {
    const note = notes.find(n => n.id === noteId);
    if (note) {
      setEditingNoteId(noteId);
      setEditingTitle(note.title);
      setEditingNote(note);
      setIsEditModalOpen(true);
    }
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
    <div className="w-full min-h-screen bg-gradient-to-b from-gray-50 to-white px-4 py-4 pb-24">
      {/* Header - Notion Style */}
      <div className="sticky top-0 bg-gradient-to-b from-gray-50 to-white flex items-center justify-between mb-6 py-3 -mx-4 px-4 z-10">
        <button
          onClick={onAccountClick}
          className="flex items-center gap-2 px-2 py-1.5 hover:bg-gray-100 rounded-lg transition-all"
        >
          <img
            src={user?.photoURL || 'https://api.dicebear.com/7.x/avataaars/svg?seed=default'}
            alt={user?.name || 'User'}
            className="w-6 h-6 rounded"
          />
          <span className="text-sm text-gray-900">
            {user?.name || 'Workspace'}
          </span>
        </button>
        <button
          onClick={onSearchClick}
          className="w-10 h-10 flex items-center justify-center rounded-xl bg-white hover:bg-gray-100 transition-all shadow-sm hover:shadow border border-gray-100"
          aria-label="検索"
        >
          <Search className="w-5 h-5 text-gray-700" />
        </button>
      </div>

      {/* 最近のメモ */}
      <section className="mb-6">
        <h2 className="mb-3 text-gray-900 flex items-center gap-2">
          <div className="w-1 h-5 bg-blue-500 rounded-full"></div>
          最近のメモ
        </h2>
        <div className="space-y-2">
          {recentNotes.map((note) => (
            <div
              key={note.id}
              className="w-full bg-white hover:bg-gray-50 rounded-xl transition-all shadow-sm hover:shadow-md border border-gray-100 group"
            >
              <div className="flex items-center justify-between p-3">
                <button
                  onClick={() => onNoteClick(note.id)}
                  className="flex-1 flex items-center justify-between text-left"
                >
                  <div className="flex-1">
                    <div className="mb-1 text-gray-900 group-hover:text-blue-600 transition-colors">{note.title}</div>
                    <div className="text-sm text-gray-500 flex items-center gap-2">
                      <div className="w-1 h-1 rounded-full bg-gray-400"></div>
                      {formatDate(note.date)}
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-gray-400 group-hover:text-blue-500 group-hover:translate-x-1 transition-all ml-2" />
                </button>
                
                {/* Menu Button */}
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <button
                      onClick={(e) => e.stopPropagation()}
                      className="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-gray-200 transition-colors opacity-0 group-hover:opacity-100 ml-2"
                      aria-label="メニュー"
                    >
                      <MoreVertical className="w-4 h-4 text-gray-600" />
                    </button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuItem
                      onClick={(e) => {
                        e.stopPropagation();
                        handleEditTitle(note.id);
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
          ))}
        </div>
      </section>

      {/* フォルダ一覧 - Obsidian風 */}
      <section className="pb-4">
        <h2 className="mb-3 text-gray-900 flex items-center gap-2">
          <div className="w-1 h-5 bg-green-500 rounded-full"></div>
          フォルダ
        </h2>
        <div className="py-2 px-1">
          {folderStructure.map((category, catIndex) => (
            <div key={category.category}>
              {/* カテゴリーヘッダー - Obsidian風 */}
              <button
                onClick={() => toggleCategory(category.category)}
                className="w-full flex items-center gap-2 px-3 py-2.5 hover:bg-gray-100 rounded transition-colors text-left group"
              >
                <ChevronRight className={`w-4 h-4 text-gray-500 transition-transform flex-shrink-0 ${expandedCategories[category.category] ? 'rotate-90' : ''}`} />
                <Folder className="w-5 h-5 text-gray-500 flex-shrink-0" />
                <span className="text-gray-700">{category.category}</span>
              </button>
              
              {/* サブフォルダー - Obsidian風 */}
              {expandedCategories[category.category] && (
                <div className="ml-6">
                  {category.folders.map((folder) => (
                    <button
                      key={folder.name}
                      onClick={() => onFolderClick(folder.name)}
                      className="w-full flex items-center justify-between gap-2 px-3 py-2.5 hover:bg-gray-100 rounded transition-colors text-left group"
                    >
                      <div className="flex items-center gap-2 flex-1 min-w-0">
                        <FileText className="w-4 h-4 text-gray-400 flex-shrink-0" />
                        <span className="text-gray-600 truncate">{folder.name}</span>
                      </div>
                      <span className="text-sm text-gray-400 tabular-nums flex-shrink-0">{getFolderCount(folder.name)}</span>
                    </button>
                  ))}
                </div>
              )}
            </div>
          ))}
        </div>
      </section>

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