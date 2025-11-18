require("dotenv").config({ path: __dirname + "/../.variables.env" });
const fs = require("fs");

const mongoose = require("mongoose");
mongoose.connect(process.env.DATABASE);
mongoose.Promise = global.Promise; // Tell Mongoose to use ES6 promises

async function createAdmin() {
  try {
    const Admin = require("../models/Admin");
    
    // Check if admin already exists
    const existingAdmin = await Admin.findOne({ email: "admin@demo.com" });
    if (existingAdmin) {
      console.log("👍👍👍👍👍👍👍👍 Admin already exists, skipping creation.");
      process.exit();
    }

    var newAdmin = new Admin();
    const passwordHash = newAdmin.generateHash("123456");

    await new Admin({
      email: "admin@demo.com",
      password: passwordHash,
      name: "admin",
      surname: "demo",
    }).save();
    console.log("👍👍👍👍👍👍👍👍 Admin created : Done!");
    process.exit();
  } catch (e) {
    console.log("\n👎👎👎👎👎👎👎👎 Error! The Error info is below");
    console.log(e);
    process.exit();
  }
}
createAdmin();
