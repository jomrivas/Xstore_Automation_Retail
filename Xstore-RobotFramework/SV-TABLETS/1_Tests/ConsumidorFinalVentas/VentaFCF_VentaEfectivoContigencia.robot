*** Settings ***
Library    AppiumLibrary
Library    String
Library    Collections
Library    Process
Resource    ../Setup.robot
Variables   ../DataConfig.py

*** Variables ***
${INPUT_ITEMS}    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText
${BTN_ACEPTAR_POPUP}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Aceptar"]
${POPUP}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@text="DOCUMENTO EMITIDO EN CONTINGENCIA"]
${BTN_ACEPTAR_POPUP_CONTINGENCIA}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Aceptar"]

*** Test Cases ***
Venta Efectivo Contingencia
    [Documentation]    Flujo de venta efectivo con contingencia

    #=====+Ingresar credenciales de vendedor manualmente primero+=====+
    Iniciar App Xmobile

    #=====+ Inicio de Transacción +=====+
    # Esperamos a que la pantalla principal este lista
    Accion_IniciarVenta_SeleccionarDocumentoFiscal
    Accion_IngresarItems
    Accion_SeleccionarMetodoDePago
    Accion_DocumentoEmitidoEnContingencia
    #=====+ fin transacción +=====+ 
    Cerrar App Xmobile


*** Keywords ***
# ============================= ACCIONES DEL FLUJO =======================================
Accion_IniciarVenta_SeleccionarDocumentoFiscal
    # Esperamos a que la pantalla principal este lista
    Wait Until Element Is Visible    xpath=//*[@text="Iniciar venta"]  2s
    # Clic en boton "Iniciar venta" 
    Click Element    xpath=//*[@text="Iniciar venta"]
    Sleep    2s
    # Dar Aceptar para confirmar vendedor 0
    Click Element    ${BTN_ACEPTAR_POPUP}
    Sleep    2s
    # Seleccionar menu lateral
    Click Element    accessibility_id=Menú de contexto
    Sleep    2s
    # Seleccionar tipos de comprobante
    Click Element    xpath=//*[@text="Tipos de Comprobantes"]
    Sleep    2s
    # Seleccionar facturacion    
    Click Element    xpath=//android.widget.TextView[@text="Facturación"]
    Sleep    2s    
    # Seleccionar factura de consumidor final    
    Click Element    xpath=//android.widget.TextView[@text="Factura Consumidor Final"]
    Sleep    2s  

Accion_IngresarItems 
    # Ingresar Items a vender
    Input Text    ${INPUT_ITEMS}    ${ITEMS_PRECIO_REGULAR}[item_1]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Input Text    ${INPUT_ITEMS}    ${ITEMS_PRECIO_REGULAR}[item_2]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Input Text    ${INPUT_ITEMS}    ${ITEMS_PRECIO_REGULAR}[item_3]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s

Accion_SeleccionarMetodoDePago
    # 5. seleccionar medio de pago
    Click Element    xpath=//*[@text="Importe pendiente"]
    Sleep    1s
    # 6. seleccionar "Omitir"
    Wait Until Element Is Visible    xpath=//*[@text="Búsqueda de clientes"]  0.5s
    Click Element    xpath=//*[@text="Búsqueda de clientes"]
    Sleep    0.5s
    Click Element    xpath=//*[@text="Omitir"]
    Sleep    1s
    Wait Until Element Is Visible    xpath=//*[@text="EFECTIVO"]  0.5s
    # 7. Seleccionar medio de pago "Efectivo"
    Click Element    xpath=//*[@text="EFECTIVO"]
    Sleep    0.5s
    # 8. Confirmar monto
    Click Element    accessibility_id=Devolución
    Sleep    1s

Accion_DocumentoEmitidoEnContingencia
    # Confirmación "DOCUMENTO EMITIDO EN CONTINGENCIA"
    Wait Until Element Is Visible    ${POPUP}    3s
    #========Inicio proceso seleccionar aceptar popup contingencia========
    # Definimos el selector
    ${BTN_ACEPTAR}    Set Variable    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.Button[@text="Aceptar"]
    # a. Esperamos a que sea visible (solo para asegurar que el popup cargó)
    Wait Until Element Is Visible    ${BTN_ACEPTAR}    10s
    # b. Obtenemos las coordenadas del botón
    ${elemento}=    Get Webelement    ${BTN_ACEPTAR}
    ${location}=    Get Element Location    ${elemento}
    ${size}=        Get Element Size    ${elemento}
    # c. Calculamos el centro exacto (X + ancho/2, Y + alto/2)
    ${center_x}=    Evaluate    ${location['x']} + (${size['width']} * 0.5)
    ${center_y}=    Evaluate    ${location['y']} + (${size['height']} * 0.5)
    # d. CONVERTIR A ENTEROS (ADB falla si le envías decimales como 500.5)
    ${x_int}=    Convert To Integer    ${center_x}
    ${y_int}=    Convert To Integer    ${center_y}
    Log To Console    \nForzando toque ADB en: ${x_int}, ${y_int}
    # e. Ejecutar comando directo de Android. Esto simula un dedo físico tocando la pantalla
    Run Process    adb    -s    emulator-5554    shell    input    tap    ${x_int}    ${y_int}
    # f. Pausa de seguridad para que la animación de cierre termine
    Sleep    2s
    #========Fin proceso seleccionar aceptar popup contingencia========
    # Imprimir DTE -> SI
    Click Element    xpath=//*[@text="Sí"]
    Sleep    2s   
    # Seleccionar Impresora -> RED    
    Click Element    xpath=//*[@text="Impresor RED"]
    Sleep    2s   

 
    