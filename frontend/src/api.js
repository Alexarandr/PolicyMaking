import axios from 'axios';

// Use the reverse proxy endpoint for API calls
const API_BASE = process.env.REACT_APP_API_URL || "/api";

export async function generatePolicy(prompt) {
  const response = await axios.post(`${API_BASE}/iam/generate`, {
    prompt
  });
  return response.data;
}
