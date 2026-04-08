# Proyecto de Automatización de Flujos de Venta en POS (Xstore)

![Robot Framework](https://img.shields.io/badge/Robot_Framework-4.x-green?style=flat-square&logo=robotframework)
![Python](https://img.shields.io/badge/Python-3.10+-blue?style=flat-square&logo=python&logoColor=white)
![Status](https://img.shields.io/badge/Status-En_Desarrollo-yellow?style=flat-square)

**Automatización con Robot Framework – Factura de Consumidor Final (FCF) – El Salvador**

## Descripción del Proyecto

Este proyecto contiene un conjunto de pruebas automatizadas desarrolladas con **Robot Framework** para validar flujos de venta en **Xstore POS**, incluyendo la generación, registro y validación del ***Factura de Consumidor Final (FCF)** conforme a los requerimientos fiscales de **El Salvador**.

El objetivo principal es asegurar la correcta operación de Xstore en operaciones de venta que requieren emisión de documentos fiscales, verificando que cada paso del flujo cumpla con los criterios funcionales, fiscales y de negocio definidos.

***

## Características Principales

*   Automatización de flujos completos de venta en POS
*   Pruebas de generación, impresión y registro del documento
*   Framework modular y escalable basado en Robot Framework
*   Separación clara entre lógica, keywords y datos de prueba

***

## Estructura del Proyecto

    /ConsumidorFinalVentas
        /config
            /_pycache_
            ocr_utils.cpython-3-10.pyc
        config.env
        ocr_utils.py
    requirement.txt
    VentaFCF_VentaItemsPromos_Credisiman
    VentaFCF_VentaItemsPromos_CertificadoRegalo
    VentaFCF_VentaItemsPromos_TarjetaExterna
    VentaFCF_VentaItemsSimanPro_Credisiman
    VentaFCF_VentaItemsSimanPro_TarjetaExterna
    VentaFCF_VentaItems_2FormasPago
    VentaFCF_Venta11k_Efectivo
    VentaFCF_Descuentos_Items_Trx
    VentaFCF_VentaItems_AnticipoGravado
    VentaFCF_VentaItems_Credisiman
    VentaFCF_VentaItems_CertificadoRegalo
    VentaFCF_VentaItems_TarjetaDevolucion
    VentaFCF_VentaItems_Efectivo
    README.md

***

## Requisitos Previos

*   **Python 3.10+**
*   **AutoUI**
*   **Tesseract-OCR**
*   **Robot Framework**
        pip install robotframework
*   Librerías adicionales:
        robotframework
        robotframework-autoitlibrary
        opencv-python
        pytesseract
        pyautogui
        keyboard
        python-dotenv
        pandas
        pyserial
*   Acceso a:
    *   Xstore
    *   Entorno de pruebas (QA / UAT)
    *   Credenciales de acceso y data de pruebas
    *   Datos de Clientes válidos para FCF en El Salvador

***


## Casos de Prueba Cubiertos

Flujos de venta con Items, descuentos y Formas de pago:

ITEMS:
*   Precios regular
*   Promociones ORCE y RPM
*   Liquidación o cambios de precio

FORMAS DE PAGO:
*   Efectivo
*   Tarjeta Credisiman
*   Certificado de Regalo
*   Tarjeta Externa
*   Tarjeta Externa no Integrada

DESCUENTOS:
*   A los items
*   A la transacción


## Normativa Considerada para CCF

El proyecto se basa en los criterios de aceptación de las HU correpondientes.

Incluye validación de:

*   Cálculo de IVA (13%)
*   Aplicxación de descuentos
*   validación de montos mayores a $11k
*   Datos obligatorios del documento
*   Estructura del Tickey impreso

***

## 🆕 Últimos Cambios y Mejoras

* **Estructuración de Pruebas:** Separación de entornos en scripts de flujos individuales y suites de pruebas regresivas (Consumidor Final y Crédito Fiscal).
* **Nuevos Casos de Prueba:** Agregado de soporte para Venta con SimanPro, Descuentos de Ítems, Certificados de Regalo, y manejo de contingencia.
* **Reportes:** Implementación de **Allure Reports** para la suite de regresión, mejorando la visualización de resultados.
* **Core & Utilidades:** Mejoras en `Utilidades_Keywords` (optimización de Omitir Impresión e integración ADB) y reorganización de `DataConfig.py` con nueva data.
* **Entorno Local:** Configuración y estandarización del entorno virtual `.venv` local de Python.

***

## Contribuciones

Las contribuciones son bienvenidas. Para cambios sustanciales:

1.  Cree una rama (`feature/nueva-funcionalidad`)
2.  Envíe un pull request
3.  Incluya documentación y pruebas nuevas

***
