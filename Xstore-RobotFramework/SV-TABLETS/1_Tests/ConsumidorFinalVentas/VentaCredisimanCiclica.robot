*** Settings ***
Library    AppiumLibrary
Library    String
Library    Collections
Library    Process

*** Variables ***
${REMOTE_URL}     http://127.0.0.1:4723
${PLATFORM}       Android
${DEVICE}         emulator-5554
${APP_PACKAGE}    com.oracle.retail.xstore
${APP_ACTIVITY}   XstoreM
${INPUT_ITEMS}    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText
${ITEM_1}    100000045
${ITEM_2}    100000726
${ITEM_3}    100000404
${KEYBOARD_NUMBERS}    xpath=//android.view.View[contains(@resource-id="XMDialogOverlayDisplay")]//android.widget.TextView[@text="Ingrese el número de tarjeta."]
${INGRESAR_SERIE}    6008314001006992
${LBL_MONTO_PENDIENTE}    xpath=//*[@text="$111.50"]
${POPUP_ESQUEMAS_FINANCIAMIENTO}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Esquemas de financiamiento."]
${ROTATIVO_CLIENTE_SIMAN}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0" and @text="Rotativo Cliente Siman"]
${IMPRMIR_DTE_SI}    xpath=////android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Sí"]


*** Test Cases ***
Venta Items con Promos, forma de Pago Credisiman serie 40
    [Documentation]    Flujo de venta ciclico items precio regular, promoción y liquidacion con forma de pago Credisiman serie 40

    # Abrir la aplicación
    Open Application    ${REMOTE_URL}    
    ...    platformName=${PLATFORM}    
    ...    deviceName=${DEVICE}    
    ...    appPackage=${APP_PACKAGE}    
    ...    appActivity=${APP_ACTIVITY}    
    ...    automationName=UiAutomator2
    ...    noReset=true    
    ...    dontStopAppOnReset=true
    ...    ensureWebviewsHavePages=true
    ...    newComandTimeout=3600
    ...    connectHardwareKeyboard=false
    ...    nativeWebScreenshot=true

    #=====+Inicio de flujo+=====+
    #=====+Primera transacción+=====+
    # Esperamos a que la pantalla principal este lista
    Wait Until Element Is Visible    xpath=//*[@text="Iniciar venta"]  2s
    
    # Clic en boton "Iniciar venta" 
    Click Element    xpath=//*[@text="Iniciar venta"]
    Sleep    2s
    
    # Esperamos a que la pantalla de vendedor a comisión este lista
    Wait Until Element Is Visible    xpath=//*[@text="Vendedor a comisión"]  2s
    
    # 1. Dar Aceotar para confirmar vendedor 0
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    2s

    # 2. seleccionar menu
    Click Element    accessibility_id=Menú de contexto
    Sleep    2s
    
    # 3. seleccionar tipos de comprobante
    Click Element    xpath=//*[@text="Tipos de Comprobantes"]
    Sleep    2s

    # 4. seleccionar facturacion    
    Click Element    xpath=//android.widget.TextView[@text="Facturación"]
    Sleep    2s    
    
    # 5. seleccionar factura de consumidor final    
    Click Element    xpath=//android.widget.TextView[@text="Factura Consumidor Final"]
    Sleep    2s 

    # 6. Ingresar Items a vender. Item_1=Regular, Item_2=Promocion (ORCE), Item_3=Liquidacion (RPM)
    # Item_1=Regular
    Input Text    ${INPUT_ITEMS}    ${ITEM_1} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    # Item_2=Promocion (ORCE) Este item aplicara la promocion al ingresar la serie de la credisiman
    Input Text    ${INPUT_ITEMS}    ${ITEM_2} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    # Item_3=Liquidacion (RPM)
    Input Text    ${INPUT_ITEMS}    ${ITEM_3} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s

    # 7. seleccionar medio de pago
    Click Element    xpath=//*[@text="Importe pendiente"]
    Sleep    1s

    # 8. seleccionar "Omitir"
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  0.5s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    1s
    Wait Until Element Is Visible    xpath=//*[@text="CREDISIMAN"]  0.5s
    
    # 9. Seleccionar medio de pago "CREDISIMAN"
    Click Element    xpath=//*[@text="CREDISIMAN"]
    Sleep    1s
    
    # 10. Ingresar serie
    Ingresar Tarjeta En Teclado Visual    ${INGRESAR_SERIE}
    
    # 11. Dar clic en "Aceptar"
    Wait Until Element Is Visible    xpath=//*[@text="Aceptar"]    2s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    2s
    
    # 12. Ingresar monto
    Obtener y Pagar Monto Exacto
    # Confirmar pago (Clic en Enter/Aceptar)
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s
    
    # 13. Confirmar esquema de financiamiento o Rotativo Cliente Siman
    Click Element    ${POPUP_ESQUEMAS_FINANCIAMIENTO}
    Click Element    ${ROTATIVO_CLIENTE_SIMAN}
    Sleep    5s
    
    # 14. Confirmación FEL - INFILE
    Click Element    xpath=//android.widget.TextView[@text="Facturación Electronica El Salvador"]
    Sleep    1s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    
    # 15. Imprimir DTE -> SI
    # Cuando aparece el popup "¿Imprimir DTE?" para clic en cualquier botn colocar ya sea "Sí" o "No"
    Clic Botón Imprimir DTE    Sí
    Sleep    2s 
    
    # 16. Seleccionar Impresora -> RED
    #Click Element    xpath=//*[@text="Impresor RED"]
    #Sleep    2s
    
    #=====+fin primera transacción+=====+
    #=====+Segunda transacción+=====+
    # Esperamos a que la pantalla de vendedor a comisión este lista
    Wait Until Element Is Visible    xpath=//*[@text="Vendedor a comisión"]  2s
    
    # 1. Dar Aceotar para confirmar vendedor 0
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    2s

    # 2. seleccionar menu
    Click Element    accessibility_id=Menú de contexto
    Sleep    2s
    
    # 3. seleccionar tipos de comprobante
    Click Element    xpath=//*[@text="Tipos de Comprobantes"]
    Sleep    2s

    # 4. seleccionar facturacion    
    Click Element    xpath=//android.widget.TextView[@text="Facturación"]
    Sleep    2s    
    
    # 5. seleccionar factura de consumidor final    
    Click Element    xpath=//android.widget.TextView[@text="Factura Consumidor Final"]
    Sleep    2s 

    # 6. Ingresar Items a vender. Item_1=Regular, Item_2=Promocion (ORCE), Item_3=Liquidacion (RPM)
    # Item_1=Regular
    Input Text    ${INPUT_ITEMS}    ${ITEM_1} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    # Item_2=Promocion (ORCE) Este item aplicara la promocion al ingresar la serie de la credisiman
    Input Text    ${INPUT_ITEMS}    ${ITEM_2} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    # Item_3=Liquidacion (RPM)
    Input Text    ${INPUT_ITEMS}    ${ITEM_3} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s

    # 7. seleccionar medio de pago
    Click Element    xpath=//*[@text="Importe pendiente"]
    Sleep    1s

    # 8. seleccionar "Omitir"
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  0.5s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    1s
    Wait Until Element Is Visible    xpath=//*[@text="CREDISIMAN"]  0.5s
    
    # 9. Seleccionar medio de pago "CREDISIMAN"
    Click Element    xpath=//*[@text="CREDISIMAN"]
    Sleep    1s
    
    # 10. Ingresar serie
    Ingresar Tarjeta En Teclado Visual    ${INGRESAR_SERIE}
    
    # 11. Dar clic en "Aceptar"
    Wait Until Element Is Visible    xpath=//*[@text="Aceptar"]    2s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    2s
    
    # 12. Ingresar monto
    Obtener y Pagar Monto Exacto
    # Confirmar pago (Clic en Enter/Aceptar)
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s
    
    # 13. Confirmar esquema de financiamiento o Rotativo Cliente Siman
    Click Element    ${POPUP_ESQUEMAS_FINANCIAMIENTO}
    Click Element    ${ROTATIVO_CLIENTE_SIMAN}
    Sleep    5s
    
    # 14. Confirmación FEL - INFILE
    Click Element    xpath=//android.widget.TextView[@text="Facturación Electronica El Salvador"]
    Sleep    1s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    
    # 15. Imprimir DTE -> SI
    # Cuando aparece el popup "¿Imprimir DTE?" para clic en cualquier botn colocar ya sea "Sí" o "No"
    Clic Botón Imprimir DTE    Sí
    Sleep    2s 
    
    # 16. Seleccionar Impresora -> RED
    #Click Element    xpath=//*[@text="Impresor RED"]
    #Sleep    2s
    
    #=====+fin segunda transacción+=====+  
    #=====+Tercera transacción+=====+
    # Esperamos a que la pantalla de vendedor a comisión este lista
    Wait Until Element Is Visible    xpath=//*[@text="Vendedor a comisión"]  2s
    
    # 1. Dar Aceotar para confirmar vendedor 0
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    2s

    # 2. seleccionar menu
    Click Element    accessibility_id=Menú de contexto
    Sleep    2s
    
    # 3. seleccionar tipos de comprobante
    Click Element    xpath=//*[@text="Tipos de Comprobantes"]
    Sleep    2s

    # 4. seleccionar facturacion    
    Click Element    xpath=//android.widget.TextView[@text="Facturación"]
    Sleep    2s    
    
    # 5. seleccionar factura de consumidor final    
    Click Element    xpath=//android.widget.TextView[@text="Factura Consumidor Final"]
    Sleep    2s 

    # 6. Ingresar Items a vender. Item_1=Regular, Item_2=Promocion (ORCE), Item_3=Liquidacion (RPM)
    # Item_1=Regular
    Input Text    ${INPUT_ITEMS}    ${ITEM_1} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    # Item_2=Promocion (ORCE) Este item aplicara la promocion al ingresar la serie de la credisiman
    Input Text    ${INPUT_ITEMS}    ${ITEM_2} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    # Item_3=Liquidacion (RPM)
    Input Text    ${INPUT_ITEMS}    ${ITEM_3} 
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s

    # 7. seleccionar medio de pago
    Click Element    xpath=//*[@text="Importe pendiente"]
    Sleep    1s

    # 8. seleccionar "Omitir"
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  0.5s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    1s
    Wait Until Element Is Visible    xpath=//*[@text="CREDISIMAN"]  0.5s
    
    # 9. Seleccionar medio de pago "CREDISIMAN"
    Click Element    xpath=//*[@text="CREDISIMAN"]
    Sleep    1s
    
    # 10. Ingresar serie
    Ingresar Tarjeta En Teclado Visual    ${INGRESAR_SERIE}
    
    # 11. Dar clic en "Aceptar"
    Wait Until Element Is Visible    xpath=//*[@text="Aceptar"]    2s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    2s
    
    # 12. Ingresar monto
    Obtener y Pagar Monto Exacto
    # Confirmar pago (Clic en Enter/Aceptar)
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s
    
    # 13. Confirmar esquema de financiamiento o Rotativo Cliente Siman
    Click Element    ${POPUP_ESQUEMAS_FINANCIAMIENTO}
    Click Element    ${ROTATIVO_CLIENTE_SIMAN}
    Sleep    5s
    
    # 14. Confirmación FEL - INFILE
    Click Element    xpath=//android.widget.TextView[@text="Facturación Electronica El Salvador"]
    Sleep    1s
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    0.5s
    
    # 15. Imprimir DTE -> SI
    # Cuando aparece el popup "¿Imprimir DTE?" para clic en cualquier botn colocar ya sea "Sí" o "No"
    Clic Botón Imprimir DTE    Sí
    Sleep    2s 
    
    # 16. Seleccionar Impresora -> RED
    #Click Element    xpath=//*[@text="Impresor RED"]
    #Sleep    2s
    
    #=====+fin tercera transacción+=====+  
    #=====+Fin de flujo+=====+  


*** Keywords ***
Ingresar Tarjeta En Teclado Visual
    [Arguments]    ${numero_tarjeta}
    [Documentation]    Busca los números de la serie en la variable y busca el botón visual en la grilla para hacer clic.

    # 1. Convertimos el string en caracteres individuales
    @{digitos}=    Split String To Characters    ${numero_tarjeta}

    # 2. Recorremos dígito por dígito
    FOR    ${num}    IN    @{digitos}

        ${xpath_dinamico}=    Set Variable    xpath=//android.widget.GridView//android.view.View[@text='${num}']

        Wait Until Element Is Visible    ${xpath_dinamico}    2s
        Click Element    ${xpath_dinamico}
        
        Sleep    200ms
    END

Obtener y Pagar Monto Exacto
    [Documentation]    Lee el monto de la pantalla, lo limpia e ingresa en el teclado visual.
    
    # Lee el texto del monto pendiente
    Wait Until Element Is Visible    ${LBL_MONTO_PENDIENTE}    5s
    ${texto_capturado}=    Get Text    ${LBL_MONTO_PENDIENTE}
    Log To Console    \nMonto detectado en pantalla: ${texto_capturado}
    
    ${monto_limpio}=    Remove String    ${texto_capturado}    $    ${SPACE}

    ${monto_final}=     Replace String    ${monto_limpio}    .    ,
    
    Log To Console    Monto a ingresar en teclado: ${monto_final}
    
    Ingresar Tarjeta En Teclado Visual    ${monto_final}

Clic Botón Imprimir DTE
    [Arguments]    ${opcion}
    [Documentation]    Recibe "Sí" o "No" como argumento y fuerza el clic vía ADB.
    
    # 1. Selector dinámico (Busca botón con texto "Sí" o "No" dentro del popup)
    ${selector}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="${opcion}"]
    
    Log To Console    \nAccionando popup DTE: opción "${opcion}"
    
    # 2. Esperar visibilidad
    Wait Until Element Is Visible    ${selector}    10s
    
    # 3. Calcular coordenadas
    ${elemento}=    Get Webelement    ${selector}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    
    # 4. Toque ADB
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    2s
