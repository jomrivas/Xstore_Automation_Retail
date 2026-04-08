*** Settings ***
Documentation    Configuración EXCLUSIVA para la Suite de Regresivas.
...              Implementa "Pruebas Atómicas" con Hard Kill y Auto-Login 
...              para evitar fugas de memoria en ejecuciones masivas.
Library          AppiumLibrary
Library          Process
Variables        ../../3_Config/DataConfig.py
Resource         ../../2_Resources/Utilidades_Keywords.robot

*** Variables ***
# --- CONFIGURACIÓN DE APPIUM ---
${REMOTE_URL}          http://127.0.0.1:4723
${PLATFORM}            Android
${DEVICE}              emulator-5554
${APP_PACKAGE}         com.oracle.retail.xstore
${APP_ACTIVITY}        com.oracle.retail.xstore.XstoreM
${AUTOMATION}          UiAutomator2


*** Keywords ***
Macro Preparar Entorno Y Cajero
    [Documentation]    Abre la app desde cero, sin engancharse a sesiones previas, y hace el login.
    
    Open Application    ${REMOTE_URL}
    ...    platformName=${PLATFORM}
    ...    deviceName=${DEVICE}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    automationName=${AUTOMATION}
    ...    noReset=true
    ...    ensureWebviewsHavePages=true
    ...    newCommandTimeout=3600
    ...    connectHardwareKeyboard=false

    Activate Application    ${APP_PACKAGE}
    Sleep    3s

    # Login Automático del Cajero
    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]

Cerrar App Y Limpiar Memoria
    [Documentation]    Cierra Appium y ejecuta un "Hard Kill" (ADB) para vaciar la memoria RAM del emulador.
    
    # 1. Desconectar Appium amablemente
    Close Application
    
    # 2. Asesinar el proceso en Android para limpiar la RAM
    Run Process    adb    -s    emulator-5554    shell    am    force-stop    ${APP_PACKAGE}
    Sleep    3s