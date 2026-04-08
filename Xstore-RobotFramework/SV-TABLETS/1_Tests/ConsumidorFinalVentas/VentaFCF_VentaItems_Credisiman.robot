*** Settings ***
Documentation    Flujo de venta items (Regular, RPM, ORCE) con pago Credisiman (Serie 40).
Library          AppiumLibrary
# Importación de Configuración y Datos
Resource         ../../3_Config/Setup.robot
Variables        ../../3_Config/DataConfig.py
# Importación de Keywords Compartidas
Resource         ../../2_Resources/Utilidades_Keywords.robot

*** Variables ***
# Variables utilizadas directamente en este Test Case
${INPUT_ITEMS}                      xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText
${POPUP_ESQUEMAS_FINANCIAMIENTO}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Esquemas de financiamiento."]
${ROTATIVO_CLIENTE_SIMAN}           xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0" and @text="Rotativo Cliente Siman"]

*** Test Cases ***
Venta Items con Promos, forma de Pago Credisiman serie 40
    [Documentation]    Flujo de venta items precio regular, promoción y liquidacion con forma de pago Credisiman serie 40.

    Iniciar App Xmobile

    # Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Seleccionar documento Fiscal

    # Ingreso de Items
    # 1. Regular
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_1] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 2. Liquidacion (RPM)
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_2] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 3. Promoción RPM
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_3]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 4. Promocion ORCE (Aplica al ingresar la tarjeta)
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_4]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s

    # Ir a Pagar
    Click Element    xpath=//*[@text="Importe pendiente"]
    Sleep    1s

    # Omitir Cliente
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  2s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    1s
    
    # Seleccionar Medio de Pago: CREDISIMAN
    Wait Until Element Is Visible    xpath=//*[@text="CREDISIMAN"]  2s
    Click Element    xpath=//*[@text="CREDISIMAN"]
    Sleep    1s

    # Ingresar Tarjeta (Keyword de Utilidad)
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[credisiman]
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s

    # Acumulación a Monedero (Keyword de Utilidad)
    Clic Botón Acumulacion a Monedero    Sí
    Sleep    0.5s

    # Pagar Monto Exacto (Keyword de Utilidad)
    Obtener y Pagar Monto Exacto
    Sleep    0.5s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s

    # Confirmar financiamiento (Variables locales)
    Wait Until Element Is Visible    ${POPUP_ESQUEMAS_FINANCIAMIENTO}    5s
    Click Element    ${POPUP_ESQUEMAS_FINANCIAMIENTO}
    Click Element    ${ROTATIVO_CLIENTE_SIMAN}
    Sleep    5s

    # Confirmar FEL (Keyword de Utilidad)
    Clip Boton Aceptar Popup
    
    # Ingresar Tarjeta Monedero (Si aplica flujo extra)
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[monedero]
    Click Element    xpath=//*[@text="Aceptar"]
    Clip Boton Continuar Popup
    Sleep    0.5s
    
    # Imprimir DTE
    Clic Botón Imprimir DTE    Sí
    Sleep    2s 
    
    # Seleccionar Impresora
    Manejar Seleccion Impresora
    Sleep    1s

    Cerrar App Xmobile