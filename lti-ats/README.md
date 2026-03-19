# LTI ATS — Applicant Tracking System

A full-stack Applicant Tracking System built with Spring Boot, React, and PostgreSQL.

## Tech Stack

- **Backend:** Java 21, Spring Boot 3.3, Maven
- **Frontend:** React 18, TypeScript, Vite, Tailwind CSS
- **Database:** PostgreSQL 15
- **Infrastructure:** Docker & Docker Compose

## Project Structure

```
/lti-ats
├── /backend           # Spring Boot REST API  →  http://localhost:8080
├── /frontend          # React + Vite SPA      →  http://localhost:5173
├── docker-compose.yml # PostgreSQL 15 service
└── README.md
```

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (v24+)
- Java 21 and Maven 3.9+
- Node.js 20+ and npm 10+

---

## Getting Started

All commands below must be run from the **`lti-ats/`** root unless noted.

---

### Step 1 — Start the Database

```bash
docker-compose up -d
```

This starts a PostgreSQL 15 container on **port 5432** with:

| Setting  | Value        |
|----------|--------------|
| Database | `lti_ats`    |
| User     | `lti_user`   |
| Password | `lti_password` |

Verify the container is healthy:

```bash
docker-compose ps
```

---

### Step 2 — Start the Backend

#### Option A — Using the provided PowerShell script (Maven auto-download, no install needed)

Only Java 21 is required. If Java is not installed yet:

```powershell
winget install EclipseAdoptium.Temurin.21.JDK --accept-package-agreements --accept-source-agreements
```

Then close and reopen PowerShell, and run:

```powershell
cd backend
.\run-backend.ps1
```

The script downloads Maven 3.9.9 into `backend/.tools/` automatically on first run (internet connection required).

#### Option B — Using Maven if already installed

```powershell
cd backend
mvn spring-boot:run
```

---

The API starts on **http://localhost:8080**.

Hibernate will automatically create the `job_positions` table on first start (`ddl-auto=update`).

Verify the API is up:

```powershell
curl http://localhost:8080/api/v1/jobs
```

Expected response: `[]`

---

### Step 3 — Start the Frontend

Open a new terminal, navigate to the `frontend/` directory, and run:

```bash
cd frontend
npm install
npm run dev
```

The UI starts on **http://localhost:5173**.

Open your browser at **http://localhost:5173** to use the application.

---

## API Reference

| Method   | Path                  | Description                |
|----------|-----------------------|----------------------------|
| `GET`    | `/api/v1/jobs`        | List all job positions     |
| `GET`    | `/api/v1/jobs/{id}`   | Get a single job position  |
| `POST`   | `/api/v1/jobs`        | Create a new job position  |
| `PUT`    | `/api/v1/jobs/{id}`   | Update a job position      |
| `DELETE` | `/api/v1/jobs/{id}`   | Delete a job position      |

### Example — Create a Job Position

```bash
curl -X POST http://localhost:8080/api/v1/jobs \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Senior Software Engineer",
    "description": "Build and maintain our core platform.",
    "status": "OPEN"
  }'
```

Valid `status` values: `OPEN`, `CLOSED`

---

## Stopping the Application

Stop the database (data is preserved in a Docker volume):

```bash
docker-compose down
```

Stop the database **and delete all data**:

```bash
docker-compose down -v
```
