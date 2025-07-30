import React, { useState } from "react";
import { motion } from "framer-motion";

export default function PromptBox({ onSubmit }) {
  const [prompt, setPrompt] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(prompt);
  };

  return (
    <motion.form
      onSubmit={handleSubmit}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
      className="bg-[#161b22] p-6 rounded-xl shadow-2xl border border-[#30363d]"
    >
      <textarea
        rows={4}
        value={prompt}
        onChange={(e) => setPrompt(e.target.value)}
        placeholder="Type your access request here..."
        className="w-full bg-[#0d1117] text-white font-mono p-3 rounded-md border border-[#30363d] focus:outline-none focus:ring-2 focus:ring-cyan-500 resize-y"
      />
      <motion.button
        type="submit"
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        className="mt-4 bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-600 hover:to-blue-700 px-5 py-2 rounded-md text-white font-semibold shadow-md transition-all"
      >
        Generate Policy
      </motion.button>
    </motion.form>
  );
}
