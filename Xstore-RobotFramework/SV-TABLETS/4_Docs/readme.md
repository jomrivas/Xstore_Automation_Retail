# Proyecto de Automatización QA - Xstore Mobile (Android)

![Robot Framework](https://img.shields.io/badge/Robot_Framework-4.x-green?style=flat-square&logo=robotframework)
![Appium](https://img.shields.io/badge/Appium-2.x-blueviolet?style=flat-square&logo=appium)
![Python](https://img.shields.io/badge/Python-3.10+-blue?style=flat-square&logo=python&logoColor=white)
![Android](https://img.shields.io/badge/Android-Emulator%20%7C%20Device-brightgreen?style=flat-square&logo=android)
![Platform](https://img.shields.io/badge/Plataforma-Tablets%20%2F%20Handhelds-orange?style=flat-square)
![Region](https://img.shields.io/badge/Región-El_Salvador_(SV)-red?style=flat-square)
![Brands](https://img.shields.io/badge/Marcas-SIMAN%20%7C%20Prisma_Moda-yellow?style=flat-square)
![Tests](https://img.shields.io/badge/Test_Scripts-7-informational?style=flat-square)
![Keywords](https://img.shields.io/badge/Utility_Keywords-17+-9cf?style=flat-square)
![Status](https://img.shields.io/badge/Status-En_Desarrollo-yellow?style=flat-square)

---

## 📋 Descripción del Proyecto

Este repositorio aloja la suite de pruebas automatizadas para la validación de flujos de venta en la aplicación **Xstore Mobile (Android)**. El proyecto utiliza **Robot Framework** con **AppiumLibrary** para simular interacciones de usuario en emuladores o dispositivos físicos.

El objetivo principal es asegurar la correcta operación de Xmobile en operaciones de venta que requieren emisión de documentos fiscales, verificando que cada paso del flujo cumpla con los criterios funcionales, fiscales y de negocio definidos para la **Factura de Consumidor Final (FCF)** en El Salvador.

---

## 🚀 Características Técnicas

* **Arquitectura Data-Driven:** Separación total entre lógica de prueba y datos. Los datos (Items, Tarjetas, Usuarios, Clientes) se gestionan en diccionarios de Python (`DataConfig.py`) con soporte multi-marca.
* **Multi-Marca (SIMAN / Prisma Moda):** Selección dinámica de datos por franquicia mediante variable de entorno `BRAND`. Por defecto carga datos de SIMAN.
* **Configuración Centralizada:** Gestión de *Capabilities* de Appium y estrategias de conexión (`noReset`) en un recurso común (`Setup.robot`).
* **Keywords Reutilizables:** Biblioteca de **17+ keywords genéricas** en `Utilidades_Keywords.robot` para manejo de UI, cálculos matemáticos, ADB y Popups.
* **Soporte ADB Directo:** Interacción vía `adb shell input tap` para clic en popups overlay que no responden a clicks nativos de Appium.
* **Escalabilidad Modular:** Estructura de carpetas organizada por Región > Dispositivo > Flujo de Negocio con separación en 4 capas (`Tests`, `Resources`, `Config`, `Docs`).

---

## 📂 Estructura del Proyecto

La arquitectura actual sigue un modelo modular de 4 capas para facilitar el mantenimiento y la escalabilidad:

```text
QA-XSTORE/
└── Xstore-RobotFramework/
    └── SV-TABLETS/                                # 📍 Módulo: El Salvador - Tablets
        │
        ├── 1_Tests/                               # 🧪 Capa de Tests
        │   └── ConsumidorFinalVentas/             # 📂 Suite: Flujos FCF
        │       ├── VentaFCF_Items_Efectivo.robot                          # Venta efectivo items regulares
        │       ├── VentaFCF_Items_2FromasDePago_CredisimanEfectivo.robot   # Pago mixto Credisiman + Efectivo
        │       ├── VentaFCF_VentaEfectivoContigencia.robot                # Venta efectivo en contingencia
        │       ├── VentaFCF_VentaItemsPromos_CertificadoRegalo.robot      # Items promos + Certificado de Regalo
        │       ├── VentaFCF_VentaItemsPromos_CredisimanORCE.robot         # Items promos + ORCE + Credisiman
        │       ├── VentaFCF_VentaItemsSimanPro_Credisiman.robot           # SimanPro + Garantías + Correo DTE
        │       └── VentaCredisimanCiclica.robot                           # Flujo cíclico 3 transacciones
        │
        ├── 2_Resources/                           # 🔧 Capa de Keywords Reutilizables
        │   └── Utilidades_Keywords.robot           # Keywords genéricas (UI, ADB, Cálculos, Popups)
        │
        ├── 3_Config/                              # ⚙️ Capa de Configuración
        │   ├── DataConfig.py                      # Diccionarios de datos multi-marca (Items, Tarjetas, Usuarios)
        │   └── Setup.robot                        # Appium Capabilities + Keywords de Setup/Teardown
        │
        └── 4_Docs/                                # 📄 Capa de Documentación
            ├── readme.md                          # Este archivo
            └── Manual_Instalacion_Ambiente_Xmobile..md  # Guía de instalación del ambiente
```

---

## 🧪 Catálogo de Test Cases

### Suite: `ConsumidorFinalVentas/` — Factura Consumidor Final (FCF)

| # | Script | Descripción | Forma de Pago | Items |
|---|--------|-------------|---------------|-------|
| 1 | `VentaFCF_Items_Efectivo.robot` | Venta de items a precio regular con pago en efectivo | Efectivo | Regulares |
| 2 | `VentaFCF_Items_2FromasDePago_CredisimanEfectivo.robot` | Venta con **2 formas de pago**: mitad Credisiman + mitad Efectivo | Credisiman + Efectivo | Regulares |
| 3 | `VentaFCF_VentaEfectivoContigencia.robot` | Venta en efectivo con manejo de popup **"DOCUMENTO EMITIDO EN CONTINGENCIA"** | Efectivo | Regulares |
| 4 | `VentaFCF_VentaItemsPromos_CertificadoRegalo.robot` | Venta de items con promociones (Regular, Liquidación, RPM) + pago con **Certificado de Regalo serie 73** | Certificado de Regalo + Efectivo | Promos |
| 5 | `VentaFCF_VentaItemsPromos_CredisimanORCE.robot` | Venta de items con promociones (Regular, RPM, ORCE) + pago con **Credisiman serie 40** + esquema financiamiento | Credisiman | Promos + ORCE |
| 6 | `VentaFCF_VentaItemsSimanPro_Credisiman.robot` | Flujo completo **SimanPro**: Item SimanPro → Garantía → Cliente DUI → Credisiman → Monedero → Correo DTE | Credisiman | SimanPro |
| 7 | `VentaCredisimanCiclica.robot` | Flujo **cíclico de 3 transacciones** consecutivas con Credisiman (validación de estabilidad) | Credisiman | Promos |

---

## 🔧 Keywords Reutilizables (`Utilidades_Keywords.robot`)

Biblioteca centralizada con **17+ keywords genéricas** para uso en todos los test cases:

| Keyword | Descripción |
|---------|-------------|
| `Ingresar Tarjeta En Teclado Visual` | Ingresa una serie de dígitos en el teclado visual (Credisiman, Certificados, Monedero) |
| `Obtener y Pagar Monto Exacto` | Lee el monto pendiente de pantalla e ingresa el valor exacto |
| `Obtener y Pagar Mitad del Monto` | Lee el monto pendiente, lo divide entre 2, y lo ingresa (para pagos mixtos) |
| `Clic Botón Imprimir DTE` | Fuerza clic vía ADB en el popup de impresión DTE (Sí/No) |
| `Clic Boton Acumulacion a Monedero` | Fuerza clic vía ADB en el popup de acumulación a Monedero (Sí/No) |
| `Clip Boton Aceptar Popup` | Fuerza clic ADB en botón "Aceptar" del popup de Facturación Electrónica |
| `Clip Boton Aceptar Popup Credenciales` | Maneja el popup de "Conexión a la caja registradora" |
| `Clip Boton Continuar Popup` | Fuerza clic ADB en botón "Continuar" del popup de Tarjeta de Crédito |
| `Ingresar Credenciales` | Flujo completo de login con usuario y contraseña (keycodes) |
| `Escribir Texto Alfanumerico` | Simula pulsaciones físicas para campos protegidos (passwords) |
| `Procesar Caracter` | Auxiliar para presionar tecla correcta (Mayúscula/Minúscula) |
| `Clic Boton Popup` | Clic genérico vía ADB en cualquier botón de un popup overlay |
| `Clic Boton Enviar Correo DTE` | Maneja el popup de envío de correo electrónico DTE |
| `Clic Boton Proceso Popup` | Clic en botón "Proceso" (usado en búsqueda de Clientes y Correo) |
| `Clic Boton Popup SIMANPRO` | Maneja popups específicos del flujo SimanPro |
| `Manejar Seleccion Impresora` | Manejo inteligente de impresoras: detecta Error → Omitir, o selecciona USB/RED |

---

## ⚙️ Configuración de Datos (`DataConfig.py`)

El proyecto utiliza **Diccionarios de Python** con **selección dinámica por marca** para gestionar la data de prueba.

### Diccionarios Disponibles

| Variable | Descripción | Marca |
|----------|-------------|-------|
| `SIMAN_ITEMS_PROMOS` | Items con promociones (Regular, Liquidación, RPM, ORCE) | SIMAN |
| `SIMAN_ITEMS_PRECIO_REGULAR` | 11 items a precio regular | SIMAN |
| `ITEMS_SIMANPRO` | Items aplicables a programa SimanPro | SIMAN |
| `SIMAN_ITEMS_ITEMS_MAYOR_1K` | Items con precio mayor a $1,000 | SIMAN |
| `SIMAN_ITEMS_CLUBES` | Items de clubes (pendiente datos) | SIMAN |
| `SIMAN_10106_USUARIOS` | Credenciales Cajero/Vendedor/Gerente tienda 10106 | SIMAN |
| `PRISMA_ITEMS_PRECIO_REGULAR` | Items a precio regular (pendiente datos) | Prisma Moda |
| `PRISMA_ITEMS_PROMOS` | Items con promociones (pendiente datos) | Prisma Moda |
| `PRISMA_10209_USUARIOS` | Credenciales tienda 10209 | Prisma Moda |
| `TARJETAS` | Credisiman, Certificado de Regalo, Anticipo Gravado, Monedero | Compartido |
| `CLIENTES` | DUI, NIT, NRC, Diplomático, Exento | Compartido |

### Cambio de Marca vía Variable de Entorno

```powershell
# PowerShell → Ejecutar como Prisma Moda
$env:BRAND="PRISMA"; robot VentaEfectivo.robot

# CMD → Ejecutar como Prisma Moda
set BRAND=PRISMA && robot VentaEfectivo.robot
```

> Por defecto, si no se establece `BRAND`, se utiliza **SIMAN**.

### Ejemplo de uso en un Test Case

```robotframework
# En DataConfig.py:  ITEMS_PROMOS = {"regular": "100000045"}

# En el Script Robot:
Input Text    ${INPUT_FIELD}    ${ITEMS_PROMOS}[regular]
```

---

## 🛠️ Requisitos Previos

### Entorno de Ejecución

* **Python:** 3.10+
* **Robot Framework:** `pip install robotframework`
* **Appium Library:** `pip install robotframework-appiumlibrary`
* **Appium Server:** v2.x (Corriendo en puerto 4723)
* **Android SDK / Emulador:** Configurado y accesible vía ADB
* **ADB:** Disponible en PATH del sistema
* **App Xstore Mobile:** Instalada en el dispositivo (`com.oracle.retail.xstore`)

### Configuración de Appium (`Setup.robot`)

| Variable | Valor | Descripción |
|----------|-------|-------------|
| `REMOTE_URL` | `http://127.0.0.1:4723` | URL del servidor Appium |
| `PLATFORM` | `Android` | Plataforma target |
| `DEVICE` | `emulator-5554` | Nombre del dispositivo/emulador |
| `APP_PACKAGE` | `com.oracle.retail.xstore` | Paquete de la aplicación |
| `APP_ACTIVITY` | `XstoreM` | Activity principal |
| `AUTOMATION` | `UiAutomator2` | Motor de automatización |

---

## 🧪 Ejecución de Pruebas

Para ejecutar un flujo específico, use el comando `robot` desde la raíz del proyecto:

```bash
# Venta en Efectivo
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/VentaFCF_Items_Efectivo.robot

# Venta con 2 Formas de Pago (Credisiman + Efectivo)
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/VentaFCF_Items_2FromasDePago_CredisimanEfectivo.robot

# Venta en Contingencia
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/VentaFCF_VentaEfectivoContigencia.robot

# Venta con Certificado de Regalo
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/VentaFCF_VentaItemsPromos_CertificadoRegalo.robot

# Venta con Credisiman + ORCE
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/VentaFCF_VentaItemsPromos_CredisimanORCE.robot

# Venta SimanPro con Garantías y Correo
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/VentaFCF_VentaItemsSimanPro_Credisiman.robot

# Flujo Cíclico (3 transacciones)
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/VentaCredisimanCiclica.robot

# Ejecutar toda la suite
robot SV-TABLETS/1_Tests/ConsumidorFinalVentas/
```

---

## ✅ Alcance de las Pruebas (Scope)

El proyecto valida los criterios de aceptación funcionales y fiscales definidos en las Historias de Usuario (HU), incluyendo:

* ✅ Venta de items a precio regular, liquidación, y con promociones (RPM, ORCE).
* ✅ Flujos de pago: Efectivo, Credisiman (Serie 40), Certificado de Regalo (Serie 73).
* ✅ Pagos mixtos con 2 formas de pago (división del monto 50/50).
* ✅ Flujo completo **SimanPro** con garantías, búsqueda de cliente por DUI, y envío de correo DTE.
* ✅ Manejo de documentos emitidos en **contingencia**.
* ✅ Esquemas de financiamiento y selección de Rotativo Cliente Siman.
* ✅ Acumulación a Monedero electrónico.
* ✅ Impresión de DTE y manejo inteligente de impresoras (USB/RED/Error).
* ✅ Flujos cíclicos para validación de estabilidad (3 transacciones consecutivas).

---

## 🆕 Últimos Cambios y Mejoras

* **Estructuración de Pruebas:** Separación de entornos en scripts de flujos individuales y suites de pruebas regresivas (Consumidor Final y Crédito Fiscal).
* **Nuevos Casos de Prueba:** Agregado de soporte para Venta con SimanPro, Descuentos de Ítems, Certificados de Regalo, y manejo de contingencia.
* **Reportes:** Implementación de **Allure Reports** para la suite de regresión, mejorando la visualización de resultados.
* **Core & Utilidades:** Mejoras en `Utilidades_Keywords` (optimización de Omitir Impresión e integración ADB) y reorganización de `DataConfig.py` con nueva data.
* **Entorno Local:** Configuración y estandarización del entorno virtual `.venv` local de Python.

---

## 🤝 Contribuciones

Para realizar cambios en el código:

1. Crear una rama con el formato `feature/nombre-funcionalidad`.
2. Asegurar que los nuevos scripts importan los recursos compartidos desde las rutas relativas correctas:
   ```robotframework
   Resource    ../../3_Config/Setup.robot
   Variables   ../../3_Config/DataConfig.py
   Resource    ../../2_Resources/Utilidades_Keywords.robot
   ```
3. Agregar nuevos Keywords genéricos a `Utilidades_Keywords.robot` en lugar de duplicarlos en cada test.
4. Enviar Pull Request para revisión.

---

*Documentación actualizada: Abril 2026*  
*Powered by JOMRivas*
