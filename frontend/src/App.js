import React, { useState } from "react";
import PromptBox from "./components/PromptBox";
import PolicyViewer from "./components/PolicyViewer";
import WarningList from "./components/WarningList";
import { generatePolicy } from "./api";
import LoadingSpinner from "./components/LoadingSpinner";


function App() {
  const [policy, setPolicy] = useState(null);
  const [warnings, setWarnings] = useState([]);

  const [loading, setLoading] = useState(false);


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
        <div className="flex items-center space-x-2">
          <div className="w-6 h-6 bg-green-500 rounded-md"></div>
          <span className="text-white font-medium">IAM Policy Generator</span>
        </div>
        <div className="flex items-center space-x-4">
          <button className="p-2 hover:bg-[#161b22] rounded-md">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M13.8 12H3"/></svg>
          </button>
          <button className="p-2 hover:bg-[#161b22] rounded-md">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
          </button>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-4 py-8 space-y-6">
        <div className="text-center space-y-2">
          <h1 className="text-4xl font-bold">IAM Policy Generator</h1>
          <p className="text-gray-400">Generate AWS IAM policies using natural language. Powered by local AI for secure, private policy creation.</p>
          <div className="flex items-center justify-center space-x-2 text-green-500">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            <span className="text-sm">All processing happens locally - no data leaves your environment</span>
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
    </div>
  );

}

export default App;
