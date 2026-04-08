*** Settings ***
Documentation    Flujo de Venta Efectivo (Limpiado y Refactorizado)
Library          AppiumLibrary
Resource         ../../3_Config/Setup.robot
Variables        ../../3_Config/DataConfig.py
Resource         ../../2_Resources/Utilidades_Keywords.robot

*** Variables ***
# Variables específicas de este test
${INPUT_ITEMS}    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText

*** Test Cases ***
Venta Efectivo, item precio regular y liquidacion
    [Documentation]    Flujo de venta con forma de pago efectivo, item precio regular y liquidación.

    Iniciar App Xmobile

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]

    #=====+ Inicio de flujo +=====+
    Iniciar Venta y Seleccionar Vendedor con Documento Fiscal

    Wait Until Page Contains Element    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText    2s

    # Ingreso de Items
    Click Element    ${INPUT_ITEMS}
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[regular]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[liquidacion]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[promocionRPM]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s
    
    # Pago
    Click Element    xpath=//*[@text="Importe pendiente"]
    Sleep    1s

    # Omitir Cliente
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  2s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    1s
    
    # Pago en Efectivo
    Wait Until Element Is Visible    xpath=//*[@text="EFECTIVO"]  2s
    Click Element    xpath=//*[@text="EFECTIVO"]
    Sleep    1s
    Click Element    accessibility_id=Devolución
    Sleep    2s

    # Confirmación
    Clip Boton Aceptar Popup

    # Imprimir DTE
    Clic Botón Imprimir DTE    Sí
    Sleep    1s 
    
    # Seleccionar Impresora o Manejar Error
    Manejar Seleccion Impresora
    Sleep    1s

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s

    Cerrar App Xmobile