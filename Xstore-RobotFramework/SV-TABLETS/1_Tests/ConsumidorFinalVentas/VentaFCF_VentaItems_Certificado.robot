*** Settings ***
Documentation    Flujo de venta items con Promociones + Pago con Certificado de Regalo.
Library          AppiumLibrary
# Importación de Configuración y Datos
Resource         ../../3_Config/Setup.robot
Variables        ../../3_Config/DataConfig.py
# Importación de Keywords Compartidas
Resource         ../../2_Resources/Utilidades_Keywords.robot

*** Variables ***
# Solo conservamos la variable que usa el Test Case directamente
${INPUT_ITEMS}    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText

*** Test Cases ***
Venta Items con Precio Regular, forma de Pago Certificado de Regalo
    [Documentation]    Flujo de venta items precio regular con forma de pago Certificado de Regalo serie 73.

    Iniciar App Xmobile

    # Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Seleccionar documento Fiscal

    # Ingresar Items a vender
    # 1. Item Regular
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_1] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 2. Item Regular
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_2] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 3. Item Regular
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_3]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s

    # Ir a Pagar
    Click Element    xpath=//android.view.View[@resource-id="P_AMOUNT_DUE"]//android.widget.TextView[@text="Importe pendiente"]
    Sleep    1s

    # Omitir Cliente
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  2s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    1s
    
    # Seleccionar Medio de Pago: Certificado
    Wait Until Element Is Visible    xpath=//*[@text="CERTIFICADO DE REGALOS"]  2s
    Click Element    xpath=//*[@text="CERTIFICADO DE REGALOS"]
    Sleep    1s

    # Ingresar número de Certificado (Usando Keyword de Utilidad)
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[certificado_regalo]
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s

    # Pagar Monto Exacto (Usando Keyword de Utilidad)
    Obtener y Pagar Monto Exacto
    Sleep    0.5s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s

    # Cierre de venta
    Wait Until Element Is Visible    xpath=//*[@text="EFECTIVO"]  2s
    Click Element    xpath=//*[@text="EFECTIVO"]
    Sleep    0.5s
    Click Element    accessibility_id=Devolución
    Sleep    2s

    # Confirmación FEL
    Clip Boton Aceptar Popup
    
    # Imprimir DTE
    Clic Botón Imprimir DTE    Sí
    Sleep    2s 
    
    # Seleccionar Impresora
    Manejar Seleccion Impresora
    Sleep    2s

    Cerrar App Xmobile