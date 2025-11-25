console.log(
  "process env REACT_APP_API_BASE_URL",
  process.env.REACT_APP_API_BASE_URL
);

// We changed the fallback from the absolute URL to a relative path ('/api/').
// This ensures that even if the environment variable fails to load,
// the browser will still use its current host/port, routing traffic through Nginx.
export const API_BASE_URL =
  process.env.REACT_APP_API_BASE_URL || "/api/";

export const ACCESS_TOKEN_NAME = "x-auth-token";
