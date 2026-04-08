*** Settings ***
Documentation    Configuración centralizada para Xstore Mobile (Android).
...              Incluye Keywords de inicio (Setup) y cierre (Teardown).
Library          AppiumLibrary
Library          Process

*** Variables ***
# --- CONFIGURACIÓN DE APPIUM ---
${REMOTE_URL}          http://127.0.0.1:4723
${PLATFORM}            Android
${DEVICE}              emulator-5554
${APP_PACKAGE}         com.oracle.retail.xstore
${APP_ACTIVITY}        com.oracle.retail.xstore.XstoreM
${AUTOMATION}          UiAutomator2


*** Keywords ***
Iniciar App Xmobile
    [Documentation]    Abre la aplicación Xstore Mobile manteniendo la sesión (noReset=true).
    Open Application    ${REMOTE_URL}
    ...    platformName=${PLATFORM}
    ...    deviceName=${DEVICE}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    automationName=${AUTOMATION}
    ...    noReset=true
    ...    dontStopAppOnReset=true
    ...    ensureWebviewsHavePages=true
    ...    newCommandTimeout=3600
    ...    connectHardwareKeyboard=false
    #...    nativeWebScreenshot=true

    Activate Application    ${APP_PACKAGE}
    Sleep    3s

Cerrar App Xmobile
    [Documentation]    Cierra únicamente la conexión (el driver) de Appium, dejando la app en primer plano.
    
    # 1. Cierre amable de Appium
    Close Application
    
    Sleep    3s