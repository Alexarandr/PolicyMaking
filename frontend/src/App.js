import React, { useState } from "react";
import PromptBox from "./components/PromptBox";
import PolicyViewer from "./components/PolicyViewer";
import WarningList from "./components/WarningList";
import SettingsModal from "./components/SettingsModal";
import { generatePolicy } from "./api";
import LoadingSpinner from "./components/LoadingSpinner";
import { motion } from "framer-motion";


function App() {
  const [policy, setPolicy] = useState(null);
  const [warnings, setWarnings] = useState([]);
  const [loading, setLoading] = useState(false);
  const [settingsOpen, setSettingsOpen] = useState(false);
  
  // For future authentication implementation
  const [isAuthenticated, setIsAuthenticated] = useState(false);


  const handlePromptSubmit = async (prompt) => {
    setLoading(true);
    setPolicy(null);
    setWarnings([]);

    try {
      const result = await generatePolicy(prompt);
      setPolicy(result.policy_json);
      setWarnings(result.warnings || []);
    } catch (error) {
      setWarnings(["Error calling backend: " + error.message]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#0d1117] text-white">
      <header className="border-b border-[#30363d] px-4 py-2 flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <img src="/logo.png" alt="GRAIN" className="w-8 h-8" />
          <span className="text-white font-medium text-lg">GRAIN</span>
        </div>
        <div className="flex items-center space-x-4">
          {isAuthenticated ? (
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setIsAuthenticated(false)}
              className="p-2 hover:bg-[#161b22] rounded-md text-gray-400 hover:text-white"
              title="Sign Out"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                <polyline points="16 17 21 12 16 7"></polyline>
                <line x1="21" y1="12" x2="9" y2="12"></line>
              </svg>
            </motion.button>
          ) : (
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setIsAuthenticated(true)}
              className="p-2 hover:bg-[#161b22] rounded-md text-gray-400 hover:text-white"
              title="Sign In"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                <polyline points="10 17 15 12 10 7"></polyline>
                <line x1="15" y1="12" x2="3" y2="12"></line>
              </svg>
            </motion.button>
          )}
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => setSettingsOpen(true)}
            className="p-2 hover:bg-[#161b22] rounded-md text-gray-400 hover:text-white"
            title="Settings"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="3"></circle>
              <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
            </svg>
          </motion.button>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-4 py-8 space-y-6">
        <div className="text-center mb-8">
          <div className="flex items-center justify-center space-x-4 mb-2">
            <img src="/logo.png" alt="GRAIN" className="w-12 h-12" />
            <h1 className="text-3xl font-bold tracking-wide">GRAIN</h1>
          </div>
          <div className="flex items-center justify-center space-x-2 text-green-500 text-sm">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            <span>Secure, local AI-powered IAM policy generation</span>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-6">
          <div className="space-y-4">
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-green-500 rounded"></div>
              <h2 className="text-lg font-medium">IAM Policy Generator</h2>
            </div>
            <PromptBox onSubmit={handlePromptSubmit} />
          </div>
          <div className="space-y-4">
            {loading ? (
              <LoadingSpinner />
            ) : policy ? (
              <PolicyViewer policy={policy} />
            ) : (
              <div className="bg-[#161b22] rounded-xl p-6 border border-[#30363d] h-full flex flex-col items-center justify-center text-center space-y-4">
                <div className="w-16 h-16 rounded-full bg-[#30363d] flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                </div>
                <div>
                  <h3 className="text-xl font-medium">Ready to Generate</h3>
                  <p className="text-gray-400 mt-2">Enter your requirements in the chat box to generate a custom IAM policy. The AI will create a policy based on your specific needs.</p>
                </div>
              </div>
            )}
            <WarningList warnings={warnings} />
          </div>
        </div>

        <div className="bg-[#161b22] rounded-xl p-6 border border-[#30363d]">
          <h3 className="text-xl font-medium mb-4">Usage Tips</h3>
          <div className="grid grid-cols-3 gap-6">
            <div>
              <h4 className="text-green-500 font-medium mb-2">Be Specific</h4>
              <p className="text-gray-400 text-sm">Include specific AWS services, actions, and resource names for accurate policies.</p>
            </div>
            <div>
              <h4 className="text-green-500 font-medium mb-2">Use Examples</h4>
              <p className="text-gray-400 text-sm">Mention bucket names, table names, or specific resources to get targeted policies.</p>
            </div>
            <div>
              <h4 className="text-green-500 font-medium mb-2">Review Carefully</h4>
              <p className="text-gray-400 text-sm">Always review generated policies before applying them to your AWS environment.</p>
            </div>
          </div>
        </div>
      </main>

      <SettingsModal isOpen={settingsOpen} onClose={() => setSettingsOpen(false)} />
    </div>
  );

}

export default App;
