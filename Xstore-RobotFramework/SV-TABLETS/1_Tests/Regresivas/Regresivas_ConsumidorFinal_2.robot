*** Settings ***
Documentation    Flujos de Facturación Consumidor Final
Library          AppiumLibrary
Resource         ../../3_Config/Setup.robot
Variables        ../../3_Config/DataConfig.py
Resource         ../../2_Resources/Utilidades_Keywords.robot
Test Setup       Iniciar App Xmobile
Test Teardown    Cerrar App Xmobile

*** Variables ***
${INPUT_ITEMS}                      xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText
${POPUP_ESQUEMAS_FINANCIAMIENTO}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Esquemas de financiamiento."]
${ROTATIVO_CLIENTE_SIMAN}           xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0" and @text="Rotativo Cliente Siman"]
${POPUP_CLIENTE}                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Búsqueda de clientes"]
${POPUP_PLANES_GARANTIA}            xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Planes de garantía"]
${POPUP_CORREO}                     xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Facturación Electronica El Salvador"]

*** Test Cases ***
Venta Items con 2 Formas de Pago, forma de Pago Credisiman y Efectivo
    [Documentation]    Flujo de venta items precio regular con forma de pago Credisiman y Efectivo

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Iniciar Venta y Seleccionar Vendedor con Documento Fiscal

    Wait Until Page Contains Element    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText    2s

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
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[credisiman_3]
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    Clic Boton Acumulacion a Monedero    Sí
    Sleep    0.5s

    # 7. Pagar Mitad del Monto -> Forma de pago Credisiman
    Obtener y Pagar Mitad del Monto
    Sleep    0.5s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s

    # OPCIONAL: Si Xstore muestra la pantalla de cuotas en pagos parciales,
    # descomenta las siguientes 3 líneas para manejar el popup antes de seguir:
    # Wait Until Element Is Visible    ${POPUP_ESQUEMAS_FINANCIAMIENTO}    5s
    # Click Element    ${ROTATIVO_CLIENTE_SIMAN}
    # Sleep    2s

    # 8. Pagar restante del monto -> Forma de pago Efectivo
    # CAMBIO CRÍTICO: Se aumentó la tolerancia de 0.5s a 5s para absorber el "lag" de la suite
    Wait Until Element Is Visible    xpath=//*[@text="EFECTIVO"]  5s
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
    Sleep    5s

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s

Venta Items con monto mayor a 25k, forma de Pago Cheque
    [Documentation]    Flujo de venta items precio regular con monto mayor a 25k y con forma de pago Cheque

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Iniciar Venta y Seleccionar Vendedor con Documento Fiscal

    Wait Until Page Contains Element    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText    2s

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

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s

Venta Items con Promos, forma de Pago Credisiman serie 40
    [Documentation]    Flujo de venta items precio regular, promoción y liquidacion con forma de pago Credisiman serie 40.

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Iniciar Venta y Seleccionar Vendedor con Documento Fiscal

    Wait Until Page Contains Element    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText    2s

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

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s

Venta Items con Precio Regular, forma de Pago Certificado de Regalo
    [Documentation]    Flujo de venta items precio regular con forma de pago Certificado de Regalo serie 73.

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Iniciar Venta y Seleccionar Vendedor con Documento Fiscal

    Wait Until Page Contains Element    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText    2s

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

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s
