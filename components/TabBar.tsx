import { Home, Search, Mic, FileText } from 'lucide-react';
import type { TabType } from '../App';

type TabBarProps = {
  activeTab: TabType;
  onTabChange: (tab: TabType) => void;
};

export function TabBar({ activeTab, onTabChange }: TabBarProps) {
  const tabs = [
    { id: 'home' as TabType, icon: Home, label: 'Home' },
    { id: 'search' as TabType, icon: Search, label: 'Search' },
    { id: 'record' as TabType, icon: Mic, label: 'Record' },
    { id: 'summary' as TabType, icon: FileText, label: 'Summary' },
  ];

  return (
    <div className="border-t border-gray-200 bg-white">
      <div className="flex justify-around items-center h-16">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={`flex flex-col items-center justify-center gap-1 px-4 py-2 transition-colors ${
                isActive ? 'text-blue-600' : 'text-gray-400'
              }`}
            >
              <Icon className="w-6 h-6" />
              <span className="text-xs">{tab.label}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
