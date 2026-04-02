const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || '/api';

export async function fetchUserDashboard(userId) {
  const response = await fetch(
    `${API_BASE_URL}/user/dashboard?userId=${encodeURIComponent(userId)}`
  );
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(data.message || 'The user dashboard could not be loaded.');
  }

  return data;
}
