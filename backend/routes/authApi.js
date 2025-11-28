const express = require("express");
const router = express.Router();

const { catchErrors } = require("../handlers/errorHandlers");
const {
  isValidToken,
  login,
  logout,
} = require("../controllers/authController");

// Use only the secure login - no demo, no registration
router.route("/login").post(catchErrors(login));
router.route("/logout").post(isValidToken, catchErrors(logout));

module.exports = router;