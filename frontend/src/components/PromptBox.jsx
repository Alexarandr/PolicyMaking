import React, { useState } from "react";
import { motion } from "framer-motion";

export default function PromptBox({ onSubmit }) {
  const [prompt, setPrompt] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    if (prompt.trim()) {
      onSubmit(prompt);
      setPrompt("");
    }
  };

  const handleKeyDown = (e) => {
    // Ctrl+Enter (ou Cmd+Enter sur Mac) pour envoyer
    if ((e.ctrlKey || e.metaKey) && e.key === "Enter") {
      e.preventDefault();
      if (prompt.trim()) {
        onSubmit(prompt);
        setPrompt("");
      }
    }
  };

  return (
    <div className="bg-[#161b22] rounded-xl border border-[#30363d]">
      <form onSubmit={handleSubmit} className="h-full">
        <div className="p-4">
          <div className="text-sm text-gray-400 mb-2">Describe your requirements in natural language</div>
          <textarea
            value={prompt}
            onChange={(e) => setPrompt(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="Example: Create a policy for S3 read-only access to bucket 'my-data'"
            rows={8}
            className="w-full bg-[#0d1117] text-white font-mono p-3 rounded-md border border-[#30363d] focus:outline-none focus:ring-1 focus:ring-green-500 resize-none text-sm"
          />
          <div className="text-xs text-gray-500 mt-2">
            Tip: Be specific about services, actions, and resources • Press <kbd className="bg-[#0d1117] border border-[#30363d] px-2 py-1 rounded">Ctrl+Enter</kbd> to send
          </div>
        </div>
        <div className="border-t border-[#30363d] p-4 flex items-center justify-between">
          <div className="text-xs text-gray-400">
            {prompt.length}/2000 characters
          </div>
          <motion.button
            type="submit"
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="bg-green-600 hover:bg-green-700 px-4 py-2 rounded-md text-white text-sm font-medium flex items-center space-x-2"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M22 2L11 13"/><path d="M22 2l-7 20-4-9-9-4 20-7z"/>
            </svg>
            <span>Generate Policy</span>
          </motion.button>
        </div>
      </form>
    </div>
  );
}
