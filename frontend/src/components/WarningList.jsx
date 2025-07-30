import React from "react";

export default function WarningList({ warnings }) {
  if (!warnings || warnings.length === 0) return null;

  return (
    <div className="bg-yellow-100 text-yellow-900 p-4 rounded-md border-l-4 border-yellow-600 shadow-md">
    <h4 className="font-semibold mb-1">⚠️ Linter Warnings</h4>
    <ul className="list-disc list-inside text-sm">
        {warnings.map((warn, i) => <li key={i}>{warn}</li>)}
    </ul>
    </div>

  );
}
