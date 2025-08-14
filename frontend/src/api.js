import axios from 'axios';

const API_BASE = "http://localhost:8000";

export async function generatePolicy(prompt) {
  const response = await axios.post(`${API_BASE}/iam/generate`, {
    prompt
  });
  return response.data;
}
