import React, { useState } from "react";
import { motion } from "framer-motion";
import { copyToClipboard, downloadPolicy } from "../utils/clipboard";

export default function PolicyViewer({ policy }) {
  const [copySuccess, setCopySuccess] = useState(false);
  
  if (!policy) return null;

  const handleCopy = async () => {
    const success = await copyToClipboard(JSON.stringify(policy, null, 2));
    if (success) {
      setCopySuccess(true);
      setTimeout(() => setCopySuccess(false), 2000);
    }
  };

  const handleDownload = () => {
    downloadPolicy(policy);
  };

  return (
    <div className="bg-[#161b22] rounded-xl border border-[#30363d]">
      <div className="border-b border-[#30363d] p-4 flex items-center justify-between">
        <h3 className="text-sm font-medium">Generated IAM Policy</h3>
        <div className="flex items-center space-x-2">
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={handleCopy}
            className="text-gray-400 hover:text-white p-1 rounded relative group"
            title="Copy to clipboard"
          >
            {copySuccess ? (
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M20 6L9 17l-5-5"/>
              </svg>
            ) : (
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>
                <rect x="8" y="2" width="8" height="4" rx="1" ry="1"/>
              </svg>
            )}
            <span className="absolute -top-8 left-1/2 transform -translate-x-1/2 bg-black text-white text-xs py-1 px-2 rounded opacity-0 group-hover:opacity-100 transition-opacity">
              {copySuccess ? 'Copied!' : 'Copy to clipboard'}
            </span>
          </motion.button>
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={handleDownload}
            className="text-gray-400 hover:text-white p-1 rounded relative group"
            title="Download policy"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/>
              <polyline points="16 6 12 2 8 6"/>
              <line x1="12" y1="2" x2="12" y2="15"/>
            </svg>
            <span className="absolute -top-8 left-1/2 transform -translate-x-1/2 bg-black text-white text-xs py-1 px-2 rounded opacity-0 group-hover:opacity-100 transition-opacity">
              Download policy
            </span>
          </motion.button>
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
