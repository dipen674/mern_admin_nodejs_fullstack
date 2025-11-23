console.log(
  "process env REACT_APP_API_BASE_URL",
  process.env.REACT_APP_API_BASE_URL
);

// If the Env variable is set (which we did in Docker), use it.
// Otherwise, fallback to localhost for local non-docker development.
export const API_BASE_URL =
  process.env.REACT_APP_API_BASE_URL || "http://localhost:8888/api/";

export const ACCESS_TOKEN_NAME = "x-auth-token";