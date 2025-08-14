import React from "react";

export default function PolicyViewer({ policy }) {
  if (!policy) return null;

  return (
    <div className="bg-[#161b22] rounded-xl border border-[#30363d]">
      <div className="border-b border-[#30363d] p-4 flex items-center justify-between">
        <h3 className="text-sm font-medium">Generated IAM Policy</h3>
        <div className="flex items-center space-x-2">
          <button className="text-gray-400 hover:text-white p-1 rounded">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>
              <rect x="8" y="2" width="8" height="4" rx="1" ry="1"/>
            </svg>
          </button>
          <button className="text-gray-400 hover:text-white p-1 rounded">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/>
              <polyline points="16 6 12 2 8 6"/>
              <line x1="12" y1="2" x2="12" y2="15"/>
            </svg>
          </button>
        </div>
      </div>
      <div className="p-4">
        <pre className="text-sm text-white font-mono whitespace-pre-wrap overflow-auto max-h-[500px]">
          {JSON.stringify(policy, null, 2)}
        </pre>
      </div>
    </div>
  );
}
