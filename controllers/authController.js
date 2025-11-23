const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Admin = mongoose.model("Admin");
require("dotenv").config({ path: ".variables.env" });

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // 1. Validate input
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Email and password are required.",
      });
    }

    // 2. Try to find the admin in the database
    // We check 'removed: false' to ensure deleted admins cannot login
    let admin = await Admin.findOne({ email: email, removed: false });

    // 3. Authentication Logic
    if (admin) {
      // --- SCENARIO A: Admin found in Database ---
      
      // Compare the password sent by user with the hashed password in DB
      // We use await here to prevent blocking the server
      const isMatch = await bcrypt.compare(password, admin.password);

      if (!isMatch) {
        return res.status(401).json({
          success: false,
          message: "Invalid credentials.",
        });
      }
    } else {
      // --- SCENARIO B: Admin NOT found in Database ---
      
      // Check if this is the System Admin using hardcoded recovery credentials
      const SECURE_EMAIL = "system@admin.com";
      const SECURE_PASSWORD = "AdminSecurePass123!";

      if (email === SECURE_EMAIL && password === SECURE_PASSWORD) {
        // Auto-create the system admin since they don't exist in DB yet
        const salt = await bcrypt.genSalt();
        const passwordHash = await bcrypt.hash(SECURE_PASSWORD, salt);

        admin = new Admin({
          email: SECURE_EMAIL,
          password: passwordHash,
          name: "System",
          surname: "Administrator",
          role: "super_admin",
          isLoggedIn: false,
        });
        await admin.save();
        console.log("System admin created successfully via Recovery Login");
      } else {
        // User not found and credentials do not match system admin
        return res.status(401).json({
          success: false,
          message: "Invalid credentials.",
        });
      }
    }

    // 4. Successful Login (Generate Token)
    const token = jwt.sign(
      {
        exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24, // 24 hours
        id: admin._id,
      },
      process.env.JWT_SECRET
    );

    // Update login status in DB
    const result = await Admin.findOneAndUpdate(
      { _id: admin._id },
      { isLoggedIn: true, lastLogin: new Date() },
      { new: true }
    ).exec();

    // Send response
    res.json({
      success: true,
      result: {
        token,
        admin: {
          id: result._id,
          name: result.name,
          email: result.email,
          isLoggedIn: result.isLoggedIn,
          role: result.role, 
        },
      },
      message: "Login successful",
    });

  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({
      success: false,
      result: null,
      message: "Internal server error during authentication.",
    });
  }
};

exports.isValidToken = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token)
      return res.status(401).json({
        success: false,
        result: null,
        message: "No authentication token, authorization denied.",
        jwtExpired: true,
      });

    const verified = jwt.verify(token, process.env.JWT_SECRET);
    if (!verified)
      return res.status(401).json({
        success: false,
        result: null,
        message: "Token verification failed, authorization denied.",
        jwtExpired: true,
      });

    const admin = await Admin.findOne({ _id: verified.id, removed: false });
    if (!admin)
      return res.status(401).json({
        success: false,
        result: null,
        message: "Admin doesn't exist, authorization denied.",
        jwtExpired: true,
      });

    if (admin.isLoggedIn === false)
      return res.status(401).json({
        success: false,
        result: null,
        message: "Admin is already logged out. Please login again.",
        jwtExpired: true,
      });
    else {
      req.admin = admin;
      next();
    }
  } catch (err) {
    res.status(500).json({
      success: false,
      result: null,
      message: err.message,
      jwtExpired: true,
    });
  }
};

exports.logout = async (req, res) => {
  try {
    const result = await Admin.findOneAndUpdate(
      { _id: req.admin._id },
      { isLoggedIn: false },
      { new: true }
    ).exec();

    res.status(200).json({ 
      success: true,
      isLoggedIn: result.isLoggedIn,
      message: "Logout successful"
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: "Error during logout",
      error: err.message
    });
  }
};