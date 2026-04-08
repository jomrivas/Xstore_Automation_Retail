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
Venta Items con 2 Formas de Pago, forma de Pago Credisiman y Efectivo
    [Documentation]    Flujo de venta items precio regular con forma de pago Credisiman y Efectivo

    Iniciar App Xmobile

    #Ingresar Credenciales        ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    # =====+ Inicio de Transacción +=====+
    Seleccionar documento Fiscal

    # 3. Ingresar Items
    Input Text        ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_1] 
    Click Element     ${INPUT_ITEMS}
    Sleep    0.5s
    Press Keycode    66
    
    Input Text        ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_2] 
    Click Element     ${INPUT_ITEMS}
    Sleep    0.5s
    Press Keycode    66
    
    Input Text    ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_3]
    Click Element    ${INPUT_ITEMS}
    Sleep    0.5s
    Press Keycode    66
    Sleep    0.5s

    # 4. Ir a Pagar
    Click Element    xpath=//android.view.View[@resource-id="P_AMOUNT_DUE"]//android.widget.TextView[@text="Importe pendiente"]
    Sleep    1s

    # 5. Omitir cliente
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  0.5s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    0.5s
    
    # 6. Seleccionar primer medio de pago - Credisiman
    Wait Until Element Is Visible    xpath=//*[@text="CREDISIMAN"]  0.5s
    Click Element    xpath=//*[@text="CREDISIMAN"]
    Sleep    1s
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[credisiman]
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    Clic Boton Acumulacion a Monedero    Sí
    Sleep    0.5s
    # 7. Pagar Mitad del Monto -> Forma de pago Credisiman
    Obtener y Pagar Mitad del Monto
    Sleep    0.5s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s

    # 8. Pagar restante del monto -> Forma de pago Efectivo
    Wait Until Element Is Visible    xpath=//*[@text="EFECTIVO"]  0.5s
    Click Element    xpath=//*[@text="EFECTIVO"]
    Sleep    0.5s
    Click Element    accessibility_id=Devolución
    Sleep    1s

    # 9. Documentos y DTE
    Clip Boton Aceptar Popup
    Sleep    1s
    Clic Botón Imprimir DTE    Sí
    Sleep    1s 
    
    # 10. Seleccionar Impresora o Manejar Error
    Manejar Seleccion Impresora
    Sleep    1s

    Cerrar App Xmobile

    