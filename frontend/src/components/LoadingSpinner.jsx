import React from "react";

export default function LoadingSpinner() {
  return (
    <div className="bg-[#161b22] rounded-xl border border-[#30363d] h-full flex flex-col items-center justify-center p-8">
      <div className="w-8 h-8 border-4 border-green-500 border-t-transparent rounded-full animate-spin mb-4"></div>
      <div className="text-center">
        <h3 className="text-xl font-medium mb-2">Generating Policy...</h3>
        <p className="text-gray-400">Processing your request using local AI</p>
      </div>
    </div>
  );
}
