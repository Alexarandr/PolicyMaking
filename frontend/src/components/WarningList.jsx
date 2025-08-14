import React from "react";

export default function WarningList({ warnings }) {
  if (!warnings || warnings.length === 0) return null;

  return (
    <div className="bg-[#161b22] rounded-xl border border-[#30363d] mt-4">
      <div className="border-b border-[#30363d] p-4 flex items-center space-x-2">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
          <line x1="12" y1="9" x2="12" y2="13"/>
          <line x1="12" y1="17" x2="12.01" y2="17"/>
        </svg>
        <h4 className="text-sm font-medium text-amber-500">Policy Warnings</h4>
      </div>
      <ul className="p-4 space-y-2">
        {warnings.map((warn, i) => (
          <li key={i} className="text-sm text-gray-300 flex items-start space-x-2">
            <span className="text-amber-500">•</span>
            <span>{warn}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}
