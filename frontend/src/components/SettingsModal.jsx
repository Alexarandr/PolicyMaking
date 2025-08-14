import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';

export default function SettingsModal({ isOpen, onClose }) {
  if (!isOpen) return null;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.95 }}
          className="bg-[#161b22] rounded-xl border border-[#30363d] w-full max-w-md p-6 shadow-xl"
        >
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-medium">Settings</h2>
            <button
              onClick={onClose}
              className="text-gray-400 hover:text-white"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
          
          <div className="space-y-4">
            <div className="border-b border-[#30363d] pb-4">
              <h3 className="text-sm font-medium text-gray-300 mb-2">Theme</h3>
              <select className="w-full bg-[#0d1117] text-white rounded-md border border-[#30363d] px-3 py-2">
                <option value="dark">Dark</option>
                <option value="light" disabled>Light (Coming soon)</option>
              </select>
            </div>

            <div className="border-b border-[#30363d] pb-4">
              <h3 className="text-sm font-medium text-gray-300 mb-2">Model</h3>
              <select className="w-full bg-[#0d1117] text-white rounded-md border border-[#30363d] px-3 py-2">
                <option value="gemma">Gemma 2B</option>
                <option value="other" disabled>More models coming soon</option>
              </select>
            </div>

            <div>
              <h3 className="text-sm font-medium text-gray-300 mb-2">About</h3>
              <p className="text-sm text-gray-400">
                IAM Policy Generator v1.0.0<br/>
                Running on local AI for secure, private policy creation.
              </p>
            </div>
          </div>

          <div className="mt-6 flex justify-end">
            <button
              onClick={onClose}
              className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium"
            >
              Close
            </button>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
