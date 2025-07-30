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
  <div className="min-h-screen bg-[#0d1117] text-white px-4 py-8">
    <div className="max-w-3xl mx-auto space-y-6">
      <h1 className="text-3xl font-bold text-center text-white">🛡️ IAM Policy Generator</h1>
      <PromptBox onSubmit={handlePromptSubmit} />
      {loading && <LoadingSpinner />}
      <WarningList warnings={warnings} />
      <PolicyViewer policy={policy} />
    </div>
  </div>
);

}

export default App;
