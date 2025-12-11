import { useState, useEffect } from 'react';
import { X, Pause, Play, ArrowLeft } from 'lucide-react';

type RecordScreenProps = {
  isRecording: boolean;
  onStartRecording: () => void;
  onStopRecording: () => void;
  onComplete: (transcript: string, duration: number) => void;
  onBack: () => void;
};

export function RecordScreen({
  isRecording,
  onStartRecording,
  onStopRecording,
  onComplete,
  onBack,
}: RecordScreenProps) {
  const [duration, setDuration] = useState(0);
  const [isPaused, setIsPaused] = useState(false);
  const [transcript, setTranscript] = useState('');

  // 画面に入ったら自動的に録音開始
  useEffect(() => {
    if (!isRecording) {
      onStartRecording();
    }
  }, []);

  useEffect(() => {
    let interval: number | undefined;
    if (isRecording && !isPaused) {
      interval = window.setInterval(() => {
        setDuration((prev) => prev + 1);
        
        // リアルタイム文字起こしのシミュレーション
        if (duration % 3 === 0) {
          const mockPhrases = [
            'これは音声入力のテストです。',
            '今日の会議では重要な決定事項がありました。',
            'プロジェクトの進捗状況について報告します。',
            '新しいアイデアを思いつきました。',
            'この機能は非常に便利だと思います。',
          ];
          const randomPhrase = mockPhrases[Math.floor(Math.random() * mockPhrases.length)];
          setTranscript((prev) => prev + (prev ? ' ' : '') + randomPhrase);
        }
      }, 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [isRecording, isPaused, duration]);

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const handleCancel = () => {
    if (window.confirm('録音を破棄しますか?')) {
      onStopRecording();
      setDuration(0);
      setTranscript('');
      setIsPaused(false);
      onBack();
    }
  };

  const handleComplete = () => {
    onComplete(transcript || 'サンプルの文字起こしテキストです。これは録音から生成された内容を表しています。実際の実装では、音声認識APIを使用して文字起こしを行います。', duration);
    setDuration(0);
    setTranscript('');
    setIsPaused(false);
  };

  const handleTogglePause = () => {
    setIsPaused(!isPaused);
  };

  return (
    <div className="h-full flex flex-col bg-gradient-to-b from-gray-50 to-white">
      {/* ヘッダー */}
      <div className="p-4 flex justify-between items-center">
        <button
          onClick={handleCancel}
          className="w-10 h-10 flex items-center justify-center rounded-xl bg-white hover:bg-gray-100 transition-all shadow-sm border border-gray-100"
          aria-label="戻る"
        >
          <ArrowLeft className="w-5 h-5 text-gray-700" />
        </button>
        <div className="flex items-center gap-2.5 px-3.5 py-1.5 bg-red-50 rounded-xl border border-red-100">
          <div className="w-2 h-2 bg-red-500 rounded-full animate-pulse shadow-sm" />
          <span className="text-sm text-red-700 tabular-nums">{formatTime(duration)}</span>
        </div>
        <div className="w-10" />
      </div>

      {/* 波形表示（簡易版） */}
      <div className="px-4 mb-4">
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center justify-center gap-1 h-14">
            {[...Array(40)].map((_, i) => (
              <div
                key={i}
                className="w-1 rounded-full transition-all"
                style={{
                  height: isPaused ? '8px' : `${Math.random() * 48 + 8}px`,
                  opacity: isPaused ? 0.3 : 1,
                  backgroundColor: isPaused ? '#9CA3AF' : `hsl(${220 + i * 2}, 80%, ${50 + Math.random() * 20}%)`,
                }}
              />
            ))}
          </div>
        </div>
      </div>

      {/* リアルタイム文字起こし */}
      <div className="flex-1 px-4 pb-4 overflow-auto">
        <div className="bg-white rounded-xl p-4 h-full shadow-sm border border-gray-100">
          <div className="mb-2 flex items-center gap-2">
            <div className="w-1.5 h-1.5 bg-blue-500 rounded-full"></div>
            <span className="text-sm text-gray-600">リアルタイム文字起こし</span>
          </div>
          <div className="text-gray-700 leading-relaxed whitespace-pre-wrap">
            {transcript || '音声を認識中...'}
          </div>
        </div>
      </div>

      {/* コントロール */}
      <div className="p-4 flex items-center justify-between bg-white border-t border-gray-100">
        <button
          onClick={handleTogglePause}
          className="w-12 h-12 bg-gray-100 hover:bg-gray-200 rounded-xl flex items-center justify-center transition-all shadow-sm"
        >
          {isPaused ? (
            <Play className="w-5 h-5 text-gray-700" />
          ) : (
            <Pause className="w-5 h-5 text-gray-700" />
          )}
        </button>
        <button
          onClick={handleComplete}
          className="flex-1 ml-3 px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white rounded-xl transition-all shadow-lg hover:shadow-xl"
        >
          完了して要約する
        </button>
      </div>
    </div>
  );
}