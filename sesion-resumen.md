# 📋 Resumen de sesión — LTI ATS from Scratch

**Fecha:** 19 de marzo de 2026
**Asistente IA:** GitHub Copilot (modelo: Claude Sonnet 4.6)
**Repo:** https://github.com/franpereda/AI4Devs-ATS-LTI-appweb.git
**Instrucciones para levantar la app:** ver [`lti-ats/README.md`](lti-ats/README.md)

---

## ¿Qué hicimos?

Arrancamos de cero un monorepo full-stack para el **LTI ATS** (Applicant Tracking System), una app web para gestionar posiciones de trabajo y candidatos en un pipeline de contratación.

El objetivo de esta primera sesión era tener una base técnica sólida y funcional de extremo a extremo, con un CRUD real de "Job Positions" que demuestre la conexión completa entre frontend, backend y base de datos.

---

## Stack usado

### Backend
- Java 21
- Spring Boot 3.3 (Web, Data JPA, Validation)
- Maven
- PostgreSQL 15 (via Docker)

### Frontend
- React 18 + TypeScript
- Vite 5
- Tailwind CSS 3

### Infraestructura
- Docker + Docker Compose (solo para la base de datos)

---

## Lo que se generó

Estructura completa del monorepo `lti-ats/`:

```
lti-ats/
├── docker-compose.yml          → PostgreSQL 15 en :5432
├── README.md                   → instrucciones paso a paso
├── backend/
│   ├── pom.xml
│   ├── run-backend.ps1         → script para Windows (descarga Maven automáticamente)
│   └── src/
│       └── ...
│           ├── CorsConfig.java             → CORS para localhost:5173
│           ├── JobPosition.java            → entidad JPA
│           ├── JobPositionController.java  → /api/v1/jobs (GET, POST, PUT, DELETE)
│           └── ...
└── frontend/
    ├── package.json / vite.config.ts / tailwind.config.js
    └── src/
        ├── App.tsx                 → lista de posiciones + formulario de creación
        ├── services/jobPositionService.ts
        └── types/JobPosition.ts
```

---

## Problemas que nos encontramos (y cómo los resolvimos)

### 1. `mvn` no reconocido en PowerShell
**Problema:** Al intentar `mvn spring-boot:run`, PowerShell devolvía `El término 'mvn' no se reconoce`.
**Causa:** Maven no estaba instalado ni en el PATH.
**Solución:** Creamos un script `run-backend.ps1` que descarga Maven 3.9.9 automáticamente en `backend/.tools/` la primera vez, sin necesidad de instalación global. Solo requiere Java.

### 2. Maven no está en `winget`
**Problema:** Al intentar `winget install Apache.Maven`, winget decía que no encontraba el paquete.
**Causa:** Apache Maven no tiene paquete oficial en winget.
**Solución:** El script `run-backend.ps1` descarga Maven directamente desde `archive.apache.org` con `Invoke-WebRequest`.

### 3. Java instalado pero no en el PATH
**Problema:** El script detectaba que `java` no estaba disponible aunque Java 21 sí estaba instalado (`C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot`).
**Causa:** La instalación de Java no había actualizado el PATH de la sesión actual de PowerShell, y el `try/catch` del script no capturaba bien el `CommandNotFoundException`.
**Solución:** Reescribimos la detección de Java en el script para que busque en las rutas de instalación más comunes (`Eclipse Adoptium`, `Java`, `Microsoft`, `Amazon Corretto`, etc.), configure `JAVA_HOME` y actualice el `PATH` de la sesión sin necesidad de reiniciar.

### 4. Error de codificación en el script `.ps1`
**Problema:** El script daba un error de parser en PowerShell: `Token ')' inesperado`.
**Causa:** Un carácter em dash (`—`) en un `Write-Host` se guardó con codificación incorrecta y PowerShell no lo interpretaba bien.
**Solución:** Reemplazamos el em dash por un guion normal (`-`).


---

## Estado final

- Backend arrancado y respondiendo en `http://localhost:8080/api/v1/jobs`
- Frontend instalado (`npm install` OK) y corriendo con `npm run dev` en `http://localhost:5173`
- Base de datos PostgreSQL levantada via Docker Compose
- CRUD completo de Job Positions funcionando end-to-end
