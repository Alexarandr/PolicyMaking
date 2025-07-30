import React from "react";

export default function LoadingSpinner() {
  return (
    <div className="flex justify-center mt-6">
      <div className="w-6 h-6 border-4 border-cyan-500 border-t-transparent rounded-full animate-spin"></div>
    </div>
  );
}
