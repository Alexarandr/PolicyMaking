import React from "react";

export default function PolicyViewer({ policy }) {
  if (!policy) return null;

  return (
    <div className="bg-[#161b22] border border-[#30363d] p-4 rounded-lg shadow-md">
    <h3 className="text-lg font-bold text-cyan-400 mb-2">Generated IAM Policy</h3>
    <pre className="text-sm text-white font-mono whitespace-pre-wrap">
        {JSON.stringify(policy, null, 2)}
    </pre>
    </div>
  );
}
