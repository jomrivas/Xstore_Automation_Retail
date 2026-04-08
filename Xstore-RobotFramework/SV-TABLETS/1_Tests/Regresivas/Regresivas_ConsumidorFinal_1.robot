*** Settings ***
Documentation    Flujos de Facturación Consumidor Final
Library          AppiumLibrary
Resource         ../../1_Tests/Regresivas/Setup_Suite.robot
Test Setup       Macro Preparar Entorno Y Cajero
Test Teardown    Cerrar App Y Limpiar Memoria

*** Variables ***
${INPUT_ITEMS}                      xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText
${POPUP_ESQUEMAS_FINANCIAMIENTO}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Esquemas de financiamiento."]
${ROTATIVO_CLIENTE_SIMAN}           xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0" and @text="Rotativo Cliente Siman"]
${POPUP_CLIENTE}                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Búsqueda de clientes"]
${POPUP_PLANES_GARANTIA}            xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Planes de garantía"]
${POPUP_CORREO}                     xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Facturación Electronica El Salvador"]

*** Test Cases ***
Venta Efectivo, item precio regular y liquidacion
    [Documentation]    Flujo de venta con forma de pago efectivo, item precio regular y liquidación.

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
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
    Sleep    5s

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
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[regular] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 2. Liquidacion (RPM)
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[liquidacion] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 3. Promoción RPM
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[promocionRPM]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 4. Promocion ORCE (Aplica al ingresar la tarjeta)
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[orce] 
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

    # Confirmar FEL
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
    Sleep   5s

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s

Venta Items con Promos, forma de Pago Certificado de Regalo
    [Documentation]    Flujo de venta items precio regular, promoción y liquidacion con forma de pago Certificado de Regalo serie 73.

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Iniciar Venta y Seleccionar Vendedor con Documento Fiscal

    Wait Until Page Contains Element    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText    2s

    # Ingreso de Items
    # 1. Item Regular
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[regular] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 2. Item Liquidacion
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[liquidacion] 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    # 3. Item Promoción RPM
    Input Text       ${INPUT_ITEMS}    ${ITEMS_PROMOS}[promocionRPM]
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
    Sleep    5s

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s

Venta Items SimanPro, forma de Pago Credisiman
    [Documentation]    Venta de items aplicables a garantia SimanPRO con forma de pago Credisiman.

    Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Iniciar Venta y Seleccionar Vendedor con Documento Fiscal

    Wait Until Page Contains Element    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText    2s

    # Ingreso de Items
    # --- INGRESAR ITEM SIMANPRO ---
    # Item 1: Aplica a SimanPRO -> TV40P FHD SMART
    Input Text       ${INPUT_ITEMS}    ${ITEMS_SIMANPRO}[simanpro_1]
    Click Element    ${INPUT_ITEMS}
    Press Keycode    66
    Sleep    1s
    
    # Agregar plan de garantía (Popup)
    Wait Until Element Is Visible    ${POPUP_PLANES_GARANTIA}   2s
    Click Element    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0"]
    Sleep    1s

    # --- INGRESAR CLIENTE (DUI) ---
    # Nota: Usamos ADB porque es un campo rebelde
    Wait Until Element Is Visible    ${POPUP_CLIENTE}    5s
    # Escribimos el DUI usando el teclado físico simulado
    Escribir Texto Alfanumerico    ${CLIENTES}[dui]
    # Cerrar teclado (clic en título) y dar Proceso
    Click Element    ${POPUP_CLIENTE}
    Sleep    1s
    Clic Boton Proceso Popup
    
    # Seleccionar el cliente de la lista y confirmar
    Wait Until Element Is Visible    ${POPUP_CLIENTE}    5s
    Click Element    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0"]
    Sleep    1s
    Clic Boton Popup SIMANPRO    Sí
    Sleep    1s

    # --- PAGO ---
    Click Element    xpath=//android.view.View[@resource-id="P_AMOUNT_DUE"]//android.widget.TextView[@text="Importe pendiente"]
    Sleep    0.5s
    
    # Seleccionar Credisiman
    Wait Until Element Is Visible    xpath=//*[@text="CREDISIMAN"]  0.5s
    Click Element    xpath=//*[@text="CREDISIMAN"]
    Sleep    1s
    
    # Ingresar Tarjeta
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[credisiman_2]
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    
    # Acumular a Monedero? -> Sí
    Clic Boton Acumulacion a Monedero    Sí
    
    # Pagar Monto Exacto
    Obtener y Pagar Monto Exacto
    Sleep    0.5s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s

    # Confirmar Financiamiento / Rotativo
    Wait Until Element Is Visible    ${POPUP_ESQUEMAS_FINANCIAMIENTO}   10s    
    Click Element    ${ROTATIVO_CLIENTE_SIMAN}
    Sleep    2s
    
    # 1. Enviar Correo DTE (INFILE)
    Clic Boton Enviar Correo DTE    Sí
    Sleep    1s
    Clic Boton Proceso Popup
    Sleep    0.5s
    
    # 2. Documento Aprobado (FEL)
    Clip Boton Aceptar Popup
    Sleep    0.5s
    
    # 3. Ingresar número de Monedero (Si aplica)
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[monedero]
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    
    # 4. Transacción Finalizada
    Clip Boton Continuar Popup
    Sleep    0.5s
    
    # 5. Imprimir Ticket
    Clic Boton Imprimir DTE    Sí
    Sleep    0.5s
    Manejar Seleccion Impresora
    Sleep    8s

    # Cerrar Sesión
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.TextView[@text="Vendedor a comisión"]  2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View//android.widget.Button[@text="Atrás"]
    Sleep    1s
