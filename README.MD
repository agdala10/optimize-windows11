# 🚀 Optimizador Windows 11

![Windows](https://img.shields.io/badge/Windows-11-blue?logo=windows)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?logo=powershell)
![License](https://img.shields.io/badge/licencia-MIT-green)
![Autor](https://img.shields.io/badge/by-Agdala-orange)

Script de optimización para **Windows 11** creado para mejorar el rendimiento del sistema, reducir la telemetría y eliminar aplicaciones innecesarias.

---

## 📋 ¿Qué hace?

| Paso | Acción |
|------|--------|
| 1️⃣ | Desactiva la telemetría de Windows |
| 2️⃣ | Desactiva servicios innecesarios (SysMain, Xbox, etc.) |
| 3️⃣ | Desinstala OneDrive |
| 4️⃣ | Elimina aplicaciones preinstaladas (bloatware) |
| 5️⃣ | Desactiva tareas programadas de telemetría |
| 6️⃣ | Ajusta efectos visuales y prioridad del sistema |
| 7️⃣ | Configura la política de actualizaciones automáticas |
| 8️⃣ | Limpia archivos temporales del sistema |

---

## ✅ Requisitos

- Windows 11
- PowerShell 5.1 o superior
- Permisos de **Administrador**

---

## 🔧 Cómo usarlo (paso a paso)

### Opción A — Ejecutar directamente desde PowerShell (recomendado)

1. Abre el menú **Inicio**.
2. Escribe `PowerShell`, clic derecho → **Ejecutar como administrador**.
3. Copia y pega este comando y presiona **Enter**:

```powershell
irm "https://raw.githubusercontent.com/agdala10/optimize-windows11/main/Optimizador%20Windows%2011.ps1" | iex
```

### Opción B — Ejecutar el archivo descargado

1. Descarga el repositorio (botón verde **Code → Download ZIP**).
2. Extrae la carpeta.
3. Clic derecho en `Optimizador Windows 11.ps1` → **Ejecutar con PowerShell**.
4. Si PowerShell bloquea el script, abre PowerShell como administrador y ejecuta:

```powershell
Set-ExecutionPolicy Bypass -Scope Process
.\Optimizador Windows 11.ps1
```

### Opción C — Versión BAT (alternativa rápida)

Clic derecho en `Optimizador power by Agdala 2026.bat` → **Ejecutar como administrador**.

---

## ⚙️ Parámetros opcionales

| Parámetro | Descripción |
|-----------|-------------|
| `-SkipOneDrive` | No desinstala OneDrive |
| `-SkipAppRemoval` | No elimina aplicaciones preinstaladas |

Ejemplo:

```powershell
.\Optimizador Windows 11.ps1 -SkipOneDrive -SkipAppRemoval
```

---

## ⚠️ Advertencias

- Úsalo **bajo tu propio riesgo**. Modifica el registro de Windows y desinstala aplicaciones.
- Se recomienda **crear un punto de restauración** antes de ejecutarlo:

```powershell
Checkpoint-Computer -Description "Antes de optimizar" -RestorePointType MODIFY_SETTINGS
```

- Reinicia el equipo al finalizar para aplicar todos los cambios.

---

## 📁 Estructura del proyecto

```
├── Optimizador Windows 11.ps1            # Script principal (PowerShell)
├── Optimizador power by Agdala 2026.bat  # Alternativa (CMD/BAT)
└── README.MD                             # Documentación
```

---

## 👤 Autor

**Agdala** — 2026

> Si este proyecto te ayudó, ¡no olvides dejar una ⭐ en el repositorio!
