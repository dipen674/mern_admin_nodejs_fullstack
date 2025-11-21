# 🚀 MERN Admin Dashboard

A Dockerized MERN stack admin panel with secure authentication, built on top of the [IDURAR ERP/CRM](https://github.com/idurar/erp-crm) starter project.
## 🗂️ Project Structure

```
mern-admin/
├── controllers/
│   └── authController.js       # Authentication logic
├── routes/
│   └── authApi.js             # Authentication routes
├── models/                     # MongoDB schemas
├── middleware/                 # Auth & validation middleware
├── frontend/
│   ├── src/
│   │   ├── components/        # React components
│   │   ├── redux/            # Redux store & actions
│   │   ├── pages/            # Page components
│   │   └── config/           # Configuration files
│   └── Dockerfile            # Frontend container config
├── docker-compose.yml         # Multi-container setup
├── Dockerfile                 # Backend container config
├── .variables.env            # Environment variables
└── package.json              # Backend dependencies
```

## ✨ Features

### Backend
- Built with Node.js, Express.js, and MongoDB
- Generic CRUD API (Create / Read / Update / Delete)
- Admin (User) Management API
- JWT Authentication (JSON Web Token)
- RESTful API architecture

### Frontend
- React.js with [Ant Design (AntD)](https://ant.design/)
- Redux & Redux-thunk for state management
- Generic CRUD Components/Modules
- Admin Management Interface
- Protected Routes (Private/Public)
- Beautiful Dashboard UI
- Responsive Design

## 📋 Prerequisites

### For Docker Setup (Recommended)
- Docker
- Docker Compose

### For Manual Setup
- Node.js (v16.x or higher)
- MongoDB (local or Atlas)
- npm or yarn

## 🐳 Quick Start with Docker (Recommended)

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/mern-admin.git
cd mern-admin
```

### 2. Run the Application

```bash
# Build and start all services
docker-compose up --build

# Run in detached mode
docker-compose up -d --build

# Stop services
docker-compose down
```

### 3. Access Points

- **Frontend**: [http://localhost:3000](http://localhost:3000)
- **Backend API**: [http://localhost:8888](http://localhost:8888)
- **MongoDB**: `localhost:27017`

### 4. Default Login Credentials

```
Email: system@admin.com
Password: AdminSecurePass123!
```

⚠️ **Important**: Change these credentials in production! Update in `controllers/authController.js`

## 🔧 Manual Setup (Alternative)

### Backend Setup

1. **Configure MongoDB**
   - Create a MongoDB Atlas account or use local MongoDB
   - Get your database connection URL

2. **Environment Variables**
   ```bash
   # Rename the file
   mv .variables.env.tmp .variables.env
   ```
   
3. **Update `.variables.env`**
   ```env
   DATABASE=your-mongodb-url
   JWT_SECRET=your-secret-key
   PORT=8888
   ```

4. **Install Dependencies & Setup**
   ```bash
   npm install
   npm setup
   ```

5. **Start Backend Server**
   ```bash
   npm start
   ```

### Frontend Setup

1. **Navigate to Frontend Directory**
   ```bash
   cd frontend
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Configure API Endpoint**
   - Open `src/config/serverApiConfig.js`
   - Set API URL to `http://localhost:8888`

4. **Start Frontend App**
   ```bash
   npm start
   ```

The application will be available at [http://localhost:3000](http://localhost:3000)

## 🛠️ Troubleshooting

### Docker Issues

**Check Container Status**
```bash
docker-compose ps
docker-compose logs -f backend
docker-compose logs -f frontend
```

**Restart Services**
```bash
# Restart specific service
docker-compose restart backend

# Rebuild specific service
docker-compose up -d --build backend
```

**Check Database**
```bash
# Verify admin user exists in MongoDB
docker-compose exec mongodb mongo mern_admin --eval "db.admins.find().pretty()"
```

### Common Problems & Solutions

1. **CORS Errors**
   - **Problem**: Frontend can't connect to backend
   - **Solution**: Environment variables are used instead of proxy

2. **Any Email/Password Works**
   - **Problem**: Demo authentication was enabled
   - **Solution**: Replaced with secure hardcoded credentials

3. **Registration Not Working**
   - **Problem**: No registration route defined
   - **Solution**: Use secure initial login; admins created through UI

4. **Database Connection Issues**
   - **Problem**: MongoDB connection failures
   - **Solution**: Fixed Docker network configuration

### API Testing

**Test Login Endpoint**
```bash
curl -X POST http://localhost:8888/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "system@admin.com",
    "password": "AdminSecurePass123!"
  }'
```

## 🔒 Security Notes

- ⚠️ Change default credentials before production deployment
- The system creates the admin user automatically on first login
- Additional admins can be created through the UI after initial login
- JWT tokens are used for secure authentication
- Environment variables should never be committed to version control

### Development Workflow

```bash
# Watch backend logs
docker-compose logs -f backend

# Watch frontend logs
docker-compose logs -f frontend

# Access backend container
docker-compose exec backend sh

# Access frontend container
docker-compose exec frontend sh
```

## 🌐 Deployment

### Deploy with Docker

```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Deploy to server
docker-compose -f docker-compose.prod.yml up -d
```

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- [IDURAR ERP/CRM](https://github.com/idurar/idurar-erp-crm) - Base starter project
- [Ant Design](https://ant.design/) - UI Component library
- [Express.js](https://expressjs.com/) - Backend framework
- [React.js](https://reactjs.org/) - Frontend library

**Built with ❤️ using MERN Stack**