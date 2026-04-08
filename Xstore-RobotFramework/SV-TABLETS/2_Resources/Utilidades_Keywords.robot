*** Settings ***
Documentation    Colección de Keywords genéricas para manejo de UI, cálculos matemáticos, ADB y Popups en Xstore Mobile.
Library          AppiumLibrary
Library          String
Library          Collections
Library          Process
Variables        ../3_Config/DataConfig.py

*** Variables ***
# Variables extraídas que son dependencias directas de los Keywords de utilidades
${POPUP_CLIENTE}                        xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]/android.view.View/android.view.View/android.view.View[2]/android.view.View
${LBL_MONTO_PENDIENTE}                  xpath=//android.widget.TextView[@text="Importe pendiente"]/following-sibling::android.widget.TextView[1]
${POPUP}                                xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Facturación Electronica El Salvador"]    
${POPUP_TARJETA_DE_CREDITO}             xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Tarjeta de crédito"]
${POPUP_CONEXION_CAJA_REGISTRADORA}     xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Conexión en caja registradora"]

*** Keywords ***
# ---======= Ingreso de datos Tarjeta =======--- 

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

Escribir Texto Alfanumerico
    [Arguments]    ${texto}
    [Documentation]    Escribe texto simulando pulsaciones físicas (útil para campos de password protegidos).
    
    # Convertimos el texto en lista de caracteres
    @{lista_caracteres}=    Split String To Characters    ${texto}
    
    # Diccionario de Keycodes Android (A-Z, 0-9)
    &{KEYCODES}=    Create Dictionary
    ...    a=29    b=30    c=31    d=32    e=33    f=34    g=35    h=36
    ...    i=37    j=38    k=39    l=40    m=41    n=42    o=43    p=44
    ...    q=45    r=46    s=47    t=48    u=49    v=50    w=51    x=52
    ...    y=53    z=54
    ...    0=7     1=8     2=9     3=10    4=11
    ...    5=12    6=13    7=14    8=15    9=16
    
    FOR    ${char}    IN    @{lista_caracteres}
        Procesar Caracter    ${char}    ${KEYCODES}
        Sleep    150ms
    END

Procesar Caracter
    [Arguments]    ${char}    ${mapa_codigos}
    [Documentation]    Auxiliar para presionar la tecla correcta (Mayúscula/Minúscula).
    
    ${es_mayuscula}=    Evaluate    '${char}'.isupper()
    ${char_lower}=      Convert To Lower Case    ${char}
    
    # Manejo de error si el caracter no está en el mapa
    ${status}    ${codigo}=    Run Keyword And Ignore Error    Get From Dictionary    ${mapa_codigos}    ${char_lower}
    
    IF    '${status}' == 'PASS'
        IF    ${es_mayuscula} == ${TRUE}
            Press Keycode    59    # Shift Left
            Press Keycode    ${codigo} 
        ELSE
            Press Keycode    ${codigo}
        END
    ELSE
        Log    Caracter no mapeado: ${char}    WARN
    END

# ---======= Ingreso de datos Credenciales =======---

Ingresar Credenciales
    [Arguments]    ${cajero}    ${contraseña_cajero}
    [Documentation]    Realiza el flujo completo de login con usuario y contraseña dados.
    
    # Selectores internos de la keyword
    ${INPUT_CAJERO}    Set Variable    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]/android.widget.EditText
    
    Wait Until Element Is Visible    ${INPUT_CAJERO}    5s
    Click Element    ${INPUT_CAJERO}
    Sleep    1s
    # Ingresar Usuario
    Run Process    adb    -s    emulator-5554    shell    input    text    ${cajero}
    Press Keycode    66
    Sleep    1s
    # Ingresar Contraseña (Usando la lógica de keycodes)
    Run Process    adb    -s    emulator-5554    shell    input    text    ${contraseña_cajero}
    Sleep    2s
    
    # Ocultar teclado y confirmar
    Click Element    ${POPUP_CONEXION_CAJA_REGISTRADORA}
    Sleep    1s
    Clip Boton Aceptar Popup Credenciales
    Sleep    1s

Ingresar Credenciales Gerente Aplicar Descuentos
    [Arguments]    ${gerente}    ${contraseña_gerente}
    [Documentation]    Inyecta credenciales mediante texto de ADB de forma directa, respetando mayúsculas y usando TAB.
    
    # Esperar a que el popup cargue (el foco se pone automáticamente en el Usuario)
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Seguridad"]    5s
    Sleep    1.5s    
    
    # --- 1. INGRESAR USUARIO ---
    # Uso directo de ADB text.
    Run Process    adb    -s    emulator-5554    shell    input    text    ${gerente}
    Sleep    1s
    Press Keycode    61
    Sleep    1s
    
    # --- 3. INGRESAR CONTRASEÑA ---
    # ADB text respetará la 'S' mayúscula exacta de la contraseña
    Run Process    adb    -s    emulator-5554    shell    input    text    ${contraseña_gerente}
    Sleep    1s
    
    # --- 4. CONFIRMAR ---
    # Bajar el teclado dando clic al título inerte del popup
    Click Element    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Seguridad"]
    Sleep    0.5s
    
    Clic Boton Proceso Popup
    Sleep    1s

# ---======= Ingreso de datos Monto =======--- 

Obtener y Pagar Monto Exacto
    [Documentation]    Lee el monto de la pantalla, lo limpia e ingresa en el teclado visual.
    
    Wait Until Element Is Visible    ${LBL_MONTO_PENDIENTE}    5s
    ${texto_capturado}=    Get Text    ${LBL_MONTO_PENDIENTE}
    Log To Console    \nMonto detectado en pantalla: ${texto_capturado}
    
    ${monto_limpio}=    Remove String    ${texto_capturado}    $    ${SPACE}
    ${monto_final}=     Replace String    ${monto_limpio}    .    ,
    Log To Console    Monto a ingresar en teclado: ${monto_final}
    
    Ingresar Tarjeta En Teclado Visual    ${monto_final}

Ingresar Cliente
    [Documentation]    Ingresa el ID del cliente usando ADB para bypassear restricciones de WebView.
    # 1. Asegurar foco en el campo (Clic físico)
    Wait Until Element Is Visible    ${POPUP_CLIENTE}    5s
    # 2. Escribir texto usando el método genérico por ADB
    Escribir Texto Alfanumerico    ${CLIENTES}[dui]
    # 3. Cerrar teclado dando clic en el texto del popup
    Click Element    ${POPUP_CLIENTE}
    Sleep    1s
    Clic Boton Proceso Popup
    # 4. Continuar con el flujo de selección de cliente
    Wait Until Element Is Visible    ${POPUP_CLIENTE}    5s
    Click Element    xpath=//android.view.View[@resource-id, "XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0"]
    Sleep    1s 

Accion Ingresar Cliente DUI
    [Arguments]    ${dui}
    [Documentation]    Flujo completo y robusto para ingresar el cliente en cualquier script, sin depender de variables externas.
    
    Log To Console    \n--- Iniciando Ingreso de Cliente ---
    
    # 1. Selector fijo del Título (No usamos variables externas para evitar fallos)
    ${TITULO_POPUP}    Set Variable    xpath=//android.widget.TextView[@text="Búsqueda de clientes"]
    Wait Until Element Is Visible    ${TITULO_POPUP}    10s
    
    # 2. Selector del Input (relativo al texto "Documento Personal")
    ${INPUT_DOC}    Set Variable    xpath=//android.widget.TextView[@text="Documento Personal"]/../android.widget.EditText
    Wait Until Element Is Visible    ${INPUT_DOC}    5s
    
    # 3. Forzar el Foco con ADB Tap (Opción Nuclear)
    ${elemento}=    Get Webelement    ${INPUT_DOC}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    
    Log To Console    Forzando Tap físico en input Documento Personal (${x_int}, ${y_int})
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    1.5s
    
    # 4. Escribir DUI usando tu librería de keycodes
    Escribir Texto Alfanumerico    ${dui}
    
    # 5. Cerrar teclado (Clic en el título) y presionar Proceso
    Click Element    ${TITULO_POPUP}
    Sleep    1s
    Clic Boton Proceso Popup

# ---======= Clic's en botones Popup =======---

Clic Botón Imprimir DTE
    [Arguments]    ${opcion}
    [Documentation]    Recibe "Sí" o "No" como argumento y fuerza el clic vía ADB.
    
    ${selector}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="${opcion}"]
    Log To Console    \nAccionando popup DTE: opción "${opcion}"
    
    Wait Until Element Is Visible    ${selector}    10s
    ${elemento}=    Get Webelement    ${selector}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    2s

Clic Botón Acumulacion a Monedero
    [Arguments]    ${opcion}
    [Documentation]    Recibe "Sí" o "No" como argumento y fuerza el clic vía ADB.
    
    ${selector}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="${opcion}"]
    Log To Console    \nAccionando popup DTE: opción "${opcion}"
    
    Wait Until Element Is Visible    ${selector}    10s
    ${elemento}=    Get Webelement    ${selector}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    2s

Clip Boton Aceptar Popup
    [Documentation]    Fuerza el clic vía ADB en el botón Aceptar del popup.
    Wait Until Element Is Visible    ${POPUP}    2s
    
    ${BTN_ACEPTAR}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Aceptar"]
    Wait Until Element Is Visible    ${BTN_ACEPTAR}    2s
    
    ${elemento}=    Get Webelement    ${BTN_ACEPTAR}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    Log To Console    \nForzando toque ADB en: ${x_int}, ${y_int}
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    2s

Clip Boton Aceptar Popup Credenciales
    [Documentation]    Fuerza el clic vía ADB en el botón Aceptar del popup de Credenciales.
    Wait Until Element Is Visible    ${POPUP_CONEXION_CAJA_REGISTRADORA}    2s
    
    ${BTN_ACEPTAR}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Aceptar"]

    ${elemento}=    Get Webelement    ${BTN_ACEPTAR}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    Log To Console    \nForzando toque ADB en: ${x_int}, ${y_int}
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    2s

Clip Boton Continuar Popup
    [Documentation]    Fuerza el clic vía ADB en el botón Continuar del popup.
    Wait Until Element Is Visible    ${POPUP_TARJETA DE CREDITO}    2s
    
    ${BTN_CONTINUAR}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Continuar"]
    Wait Until Element Is Visible    ${BTN_CONTINUAR}    1s
    
    ${elemento}=    Get Webelement    ${BTN_CONTINUAR}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    Log To Console    \nForzando toque ADB en: ${x_int}, ${y_int}
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    2s

Clic Boton Popup
    [Arguments]    ${opcion}
    [Documentation]    Recibe "Sí" o "No" como argumento y fuerza el clic vía ADB en el Popup "SIMANPRO".
    
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
    
    Sleep    1s

Clic Boton Enviar Correo DTE
    [Arguments]    ${opcion}
    [Documentation]    Fuerza el clic en Sí/No para el popup de Enviar Correo.
    ${selector}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="${opcion}"]
    Log To Console    \nAccionando popup Correo: opción "${opcion}"
    
    Wait Until Element Is Visible    ${selector}    10s
    ${elemento}=    Get Webelement    ${selector}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    1s

Clic Boton Proceso Popup
    [Documentation]    Hace clic en el botón "Proceso" (usado en Cliente y Correo).
    ${BTN_PROCESO}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Proceso"]
    
    Wait Until Element Is Visible    ${BTN_PROCESO}    2s
    ${elemento}=    Get Webelement    ${BTN_PROCESO}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    Log To Console    \nForzando toque ADB en botón Proceso
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    1s

Clic Boton Popup SIMANPRO
    [Arguments]    ${opcion}
    [Documentation]    Recibe "Sí" o "No" como argumento y fuerza el clic vía ADB en el Popup "SIMANPRO".
    
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
    
    Sleep    1s

Clic Boton Acumulacion a Monedero
    [Arguments]    ${opcion}
    [Documentation]    Recibe "Sí" o "No" como argumento y fuerza el clic vía ADB en el Popup "Acumulación a Monedero".
    
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
    
    Sleep    1s

Clic Boton Imprimir DTE
    [Arguments]    ${opcion}
    [Documentation]    Recibe "Sí" o "No" como argumento y fuerza el clic vía ADB en el Popup "Imprimir DTE".
    
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
    
    Sleep    1s

Clic Boton Omitir Impresion
    [Documentation]    Hace clic en el botón "Omitir impresión" (usado en el flujo de impresión).
    ${BTN_OMITIR_IMPRESION}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Omitir impresión"]
    
    Wait Until Element Is Visible    ${BTN_OMITIR_IMPRESION}    2s
    ${elemento}=    Get Webelement    ${BTN_OMITIR_IMPRESION}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    Log To Console    \nForzando toque ADB en botón Omitir Impresión
    
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    1s

# ---======= Funciones varias =======--- 

Manejar Seleccion Impresora
    [Documentation]    Maneja el flujo final de impresión:
    ...                - Si sale "Error de impresora", hace clic en "Omitir impresión".
    ...                - Si salen las opciones de impresora, selecciona USB o RED.
    
    Log To Console    \nVerificando servicio de impresión...
    
    # Definimos los selectores a buscar
    ${BTN_ERROR_OMITIR}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Omitir impresión"]
    ${BTN_USB}             Set Variable    xpath=//*[@text="Impresor USB"]
    ${BTN_RED}             Set Variable    xpath=//*[@text="Impresor RED"]
    
    # Bucle de escaneo (Intenta 5 veces, 1 segundo por intento)
    FOR    ${i}    IN RANGE    5
        # 1. ¿Apareció el Error?
        ${hay_error}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${BTN_ERROR_OMITIR}    1s
        
        # 2. ¿Apareció la opción USB?
        ${hay_usb}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${BTN_USB}    1s
        
        # 3. ¿Apareció la opción RED?
        ${hay_red}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${BTN_RED}    1s
        
        # --- TOMA DE DECISIÓN ---
        IF    ${hay_error}
            Log To Console    >> Error de impresora detectado. Omitiendo impresión.
            Clic Boton Omitir Impresion
            BREAK
            
        ELSE IF    ${hay_usb}
            Log To Console    >> Servicio disponible. Seleccionando Impresor USB.
            Click Element    ${BTN_USB}
            BREAK
            
        ELSE IF    ${hay_red}
            Log To Console    >> Servicio disponible. Seleccionando Impresor RED.
            Click Element    ${BTN_RED}
            BREAK
        END
        
        # Si no encontró nada, espera un poco antes del siguiente intento
        Sleep    0.5s
    END

Obtener y Pagar Mitad del Monto
    [Documentation]    Lee el monto de la pantalla, lo divide entre 2 e ingresa el resultado en el teclado visual.
    
    # 1. Captura del texto
    Wait Until Element Is Visible    ${LBL_MONTO_PENDIENTE}    5s
    ${texto_capturado}=    Get Text    ${LBL_MONTO_PENDIENTE}
    Log To Console    \nMonto detectado en pantalla: ${texto_capturado}
    
    # 2. Limpieza (Quitar $ y espacios)
    ${monto_limpio}=    Remove String    ${texto_capturado}    $    ${SPACE}
    
    # 3. Cálculo Matemático (Python)
    # Usamos 'Evaluate' para convertir a float y dividir entre 2
    ${mitad_numerica}=    Evaluate    float(${monto_limpio}) / 2
    
    # 4. Formateo a String (2 decimales obligatorios)
    # Esto asegura que 50.5 se convierta en "50.50" y no "50.5"
    ${mitad_string}=    Evaluate    "{:.2f}".format(${mitad_numerica})
    
    # 5. Ajuste de separador (Cambiar punto por coma para el teclado visual)
    ${monto_final}=     Replace String    ${mitad_string}    .    ,
    
    Log To Console    Monto a ingresar (50%): ${monto_final}
    
    # 6. Ingreso en el teclado
    Ingresar Tarjeta En Teclado Visual    ${monto_final}

Ingresar Items En Bucle Masivo
    [Arguments]    ${lista_items}    ${input_selector}
    [Documentation]    Recorre una lista de items y repite el proceso 5 veces.
    ...                Total de ingresos: 5 items * 5 vueltas = 25 items.
    
    Log To Console    \n--- INICIANDO CARGA MASIVA (25 Items) ---
    
    # === BUCLE EXTERNO: Controla las 5 repeticiones globales ===
    FOR    ${vuelta}    IN RANGE    1    6
        Log To Console    ... Iniciando Vuelta número: ${vuelta}
        
        # === BUCLE INTERNO: Recorre los 5 items de la lista ===
        FOR    ${sku}    IN    @{lista_items}
            
            # 1. Esperar que el campo esté listo
            Wait Until Element Is Visible    ${input_selector}    5s
            
            # 2. Escribir el código (SKU)
            Input Text    ${input_selector}    ${sku}
            
            # 3. Dar Clic en el campo (a veces necesario para activar el botón Enter)
            Click Element    ${input_selector}
            
            # 4. Presionar ENTER (Keycode 66)
            Press Keycode    66
            
            Log To Console    Item ingresado: ${sku}
            
            # 5. Pequeña pausa para no saturar la memoria de la Tablet
            Sleep    1s
            
        END
        # Fin del Bucle Interno
        
    END
    # Fin del Bucle Externo
    
    Log To Console    \n--- CARGA MASIVA COMPLETADA ---

Escribir Datos Cheque
    [Arguments]    ${texto}
    [Documentation]    Escribe texto simulando pulsaciones físicas (útil para campos de password protegidos).
    
    # Convertimos el texto en lista de caracteres
    ${num_cheque}=    Generate Random String    9    [NUMBERS]
    @{lista_caracteres}=    Split String To Characters    ${num_cheque}
    
    # Diccionario de Keycodes Android (A-Z, 0-9)
    &{KEYCODES}=    Create Dictionary
    ...    a=29    b=30    c=31    d=32    e=33    f=34    g=35    h=36
    ...    i=37    j=38    k=39    l=40    m=41    n=42    o=43    p=44
    ...    q=45    r=46    s=47    t=48    u=49    v=50    w=51    x=52
    ...    y=53    z=54
    ...    0=7     1=8     2=9     3=10    4=11
    ...    5=12    6=13    7=14    8=15    9=16
    
    FOR    ${char}    IN    @{lista_caracteres}
        Procesar Caracter    ${char}    ${KEYCODES}
        Sleep    150ms
    END

    ${num_certificado}=    Generate Random String    5    [NUMBERS]
    @{lista_caracteres}=    Split String To Characters    ${num_certificado}
    
    # Diccionario de Keycodes Android (A-Z, 0-9)
    &{KEYCODES}=    Create Dictionary
    ...    a=29    b=30    c=31    d=32    e=33    f=34    g=35    h=36
    ...    i=37    j=38    k=39    l=40    m=41    n=42    o=43    p=44
    ...    q=45    r=46    s=47    t=48    u=49    v=50    w=51    x=52
    ...    y=53    z=54
    ...    0=7     1=8     2=9     3=10    4=11
    ...    5=12    6=13    7=14    8=15    9=16
    
    FOR    ${char}    IN    @{lista_caracteres}
        Procesar Caracter    ${char}    ${KEYCODES}
        Sleep    150ms
    END

Ingresar DUI Cliente Forzado
    [Arguments]    ${dui}
    [Documentation]    Fuerza el foco en el campo "DUI" mediante un Tap físico de ADB y luego escribe.
    
    # 1. Selector infalible: Busca el EditText que comparte contenedor con el texto "Documento Personal"
    ${INPUT_DOC}    Set Variable    xpath=//android.widget.TextView[@text="Documento Personal"]/../android.widget.EditText
    
    Wait Until Element Is Visible    ${INPUT_DOC}    10s
    
    # 2. Calcular coordenadas exactas del input
    ${elemento}=    Get Webelement    ${INPUT_DOC}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    
    Log To Console    \nForzando Tap físico en input Documento Personal (${x_int}, ${y_int})
    
    # 3. Tap físico vía ADB (Garantiza que Android ponga el cursor ahí)
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    Sleep    1.5s    # Pausa obligatoria para que el teclado virtual suba
    
    # 4. Escribir usando tu lógica de keycodes
    Escribir Texto Alfanumerico    ${dui}

Seleccionar Documento de Cliente
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Identificación Datos de Cliente"]    3s
    hide keyboard
    Sleep    1s
    Clic Boton Proceso Popup
    Sleep    1s

Iniciar Venta y Seleccionar Vendedor con Documento Fiscal
    [Documentation]    iniciar la venta, selecciona el vendedor a comisionar y el documento fiscal: Consumidor Final, Comprobante Credito Fiscal, Venta Exenta, etc.
    Wait Until Element Is Visible    xpath=//*[@text="Iniciar venta"]  2s
    Click Element    xpath=//*[@text="Iniciar venta"]
    Sleep    1s
    Wait Until Element Is Visible    xpath=//*[@text="Vendedor a comisión"]  2s
    
    # 1. Confirmar vendedor
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s

    # 2. Navegación en menús
    Click Element    accessibility_id=Menú de contexto
    Sleep    1s
    Click Element    xpath=//*[@text="Tipos de Comprobantes"]
    Sleep    1s
    Click Element    xpath=//android.widget.TextView[@text="Facturación"]
    Sleep    1s    
    Click Element    xpath=//android.widget.TextView[@text="Factura Consumidor Final"]

Confirmar Vendedor y Seleccionar Documento Fiscal
    [Documentation]    Confirmar vendedor y selecciona el documento fiscal: Consumidor Final, Comprobante Credito Fiscal, Venta Exenta, etc.
    # Esperar pnatalla de Vendedor a comisionar
    Wait Until Element Is Visible    xpath=//*[@text="Vendedor a comisión"]  2s
    
    # 1. Confirmar vendedor
    Click Element    xpath=//*[@text="Aceptar"]
    Sleep    1s

    # 2. Navegación en menús
    Click Element    accessibility_id=Menú de contexto
    Sleep    1s
    Click Element    xpath=//*[@text="Tipos de Comprobantes"]
    Sleep    1s
    Click Element    xpath=//android.widget.TextView[@text="Facturación"]
    Sleep    1s    
    Click Element    xpath=//android.widget.TextView[@text="Factura Consumidor Final"]
    Sleep    1s 
