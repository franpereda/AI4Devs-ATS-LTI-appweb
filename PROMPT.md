# Project Brief — LTI ATS from Scratch

> Prompt inicial utilizado para generar el proyecto con GitHub Copilot (Claude Sonnet 4.6).

---

You are a senior full-stack software engineer with deep expertise in Java backend development (Spring Boot, Domain-Driven Design) and modern React frontend development. You write production-quality code — clean, well-structured, and immediately runnable — and you apply architectural constraints consistently across the entire codebase. You do not add patterns, dependencies, or configuration that have not been explicitly requested.

## Context and Goal

Bootstrap a new full-stack monorepo for the LTI Applicant Tracking System (ATS) — a web application that helps manage open job positions and candidates through a hiring pipeline.

This initial version is a seed: it establishes the full technical foundation (backend, frontend, database, Docker images, developer tooling, documentation) with a minimal but real domain slice — "Job Positions" — so the application can be demonstrated end-to-end from day one and iterated on by AI coding agents from that point forward.

The application must be fully runnable locally with a single Docker Compose command for infrastructure and standard mvn / npm commands for the applications. Every file generated must compile and run without modification.

## Tech Stack

- **Backend:** Java 21, Spring Boot 3.x (Web, Data JPA, Validation), Maven.
- **Frontend:** React 18, TypeScript, Vite, Tailwind CSS.
- **Database:** PostgreSQL.
- **Infrastructure:** Docker & Docker Compose.

## Project Structure (Monorepo)

```
/lti-ats
  ├── /backend (Spring Boot app)
  ├── /frontend (React Vite app)
  ├── docker-compose.yml
  └── README.md
```

## Scope: The "Job Position" Seed

Implement ONLY a basic CRUD for a "JobPosition" entity to prove the end-to-end connection. Do not add authentication, complex error handling, or other domains (like Candidates or Interviews) yet.

1. **Database:** Configure a `docker-compose.yml` at the root that spins up a PostgreSQL 15 database (Port 5432, DB name: `lti_ats`).
2. **Backend:**
   - Configure `application.yml` to connect to the Postgres database and auto-update the schema (hibernate.ddl-auto=update).
   - Create a `JobPosition` entity (id, title, description, status [OPEN, CLOSED]).
   - Create the necessary Repository, Service, and REST Controller mapping to `/api/v1/jobs`.
   - IMPORTANT: Configure CORS globally in Spring Boot to allow requests from `http://localhost:5173` (Vite's default port).
3. **Frontend:**
   - Set up the Vite + React + TS project.
   - Configure Tailwind CSS.
   - Create a simple service using `fetch` or `axios` to call `http://localhost:8080/api/v1/jobs`.
   - Create a single main view (`App.tsx`) that fetches and displays a list of Job Positions in a clean UI grid/list, and includes a simple form to create a new Job Position.
4. **Documentation:**
   - Create a root `README.md` with clear, step-by-step instructions on how to start the database via Docker, the backend via Maven, and the frontend via npm.

## Constraints & Rules

- Do NOT generate dummy text or placeholders like `// Add code here`. Write the actual working code.
- Ensure all imports are correct.
- Ensure port configurations do not clash (Backend on 8080, Frontend on 5173, DB on 5432).
- Keep the UI minimal but professional using Tailwind utility classes.
