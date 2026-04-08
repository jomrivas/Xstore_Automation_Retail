*** Settings ***
Documentation    Flujos de Facturación Consumidor Final
Library          AppiumLibrary
Resource         ../../3_Config/Setup.robot
Variables        ../../3_Config/DataConfig.py
Resource         ../../2_Resources/Utilidades_Keywords.robot

*** Variables ***
# Aquí solo quedan las variables exclusivas de este test
${INPUT_ITEMS}    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText


*** Test Cases ***
Venta Items con monto mayor a 25k, forma de Pago Cheque
    [Documentation]    Flujo de venta items precio regular con monto mayor a 25k y con forma de pago Cheque

    Iniciar App Xmobile

    #Ingresar Credenciales        ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    # =====+ Inicio de Transacción +=====+
    # 1. Iniciar Venta
    Seleccionar documento Fiscal

    # 2. Ingresar Items
    Ingresar Items En Bucle Masivo    ${LISTA_ITEMS_MASIVOS}    ${INPUT_ITEMS}

    # 3. Ir a Pagar
    Click Element    xpath=//android.view.View[@resource-id="P_AMOUNT_DUE"]//android.widget.TextView[@text="Importe pendiente"]
    Sleep    1s
    
    # 4. Ingresar documento cliente
    Accion Ingresar Cliente DUI    ${CLIENTES}[dui]
    Click Element    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0"]
    Sleep    1s
    Seleccionar Documento de Cliente

    # 5. Seleccionar medio de paago
    Wait Until Element Is Visible    xpath=//*[@text="CHEQUES"]  1s
    Click Element    xpath=//*[@text="CHEQUES"]
    Sleep    1s
    Escribir Datos Cheque    cheque
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    Escribir Datos Cheque    certificado
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    Click Element    accessibility_id=Devolución
    Sleep    1s

    # 6. Documentos y DTE
    Clic Boton Enviar Correo DTE    Sí
    Sleep    1s
    Clic Boton Proceso Popup
    Sleep    0.5s
    Clip Boton Aceptar Popup
    Sleep    1s 
    Clic Botón Imprimir DTE    Sí
    Sleep    1s 
    
    # 7. Seleccionar Impresora o Manejar Error
    Manejar Seleccion Impresora
    Sleep    1s

    Cerrar App Xmobile
