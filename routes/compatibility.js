const express = require("express");
const { catchErrors } = require("../handlers/errorHandlers");

const router = express.Router();

const adminController = require("../controllers/adminController");
const clientController = require("../controllers/clientController");
const leadController = require("../controllers/leadController");
const productController = require("../controllers/productController");

// Add missing plural list endpoints that frontend expects
router.route("/admins/list").get(catchErrors(adminController.list));
router.route("/clients/list").get(catchErrors(clientController.list));
router.route("/leads/list").get(catchErrors(leadController.list));
router.route("/products/list").get(catchErrors(productController.list));

// Registration endpoints
router.route("/register").post(catchErrors(adminController.create));
router.route("/users").post(catchErrors(adminController.create));
router.route("/users/list").get(catchErrors(adminController.list));

module.exports = router;
