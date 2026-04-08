*** Settings ***
Documentation    Flujo de venta SimanPro con pago Credisiman (Incluye Garantías y Envío de Correo).
Library          AppiumLibrary
# Recursos Compartidos
Resource         ../../3_Config/Setup.robot
Variables        ../../3_Config/DataConfig.py
Resource         ../../2_Resources/Utilidades_Keywords.robot

*** Variables ***
# Variables visuales específicas de este flujo
${INPUT_ITEMS}                      xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText
${POPUP_CLIENTE}                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Búsqueda de clientes"]
${POPUP_PLANES_GARANTIA}            xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Planes de garantía"]
${POPUP_ESQUEMAS_FINANCIAMIENTO}    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Esquemas de financiamiento."]
${ROTATIVO_CLIENTE_SIMAN}           xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0" and @text="Rotativo Cliente Siman"]
${POPUP_CORREO}                     xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Facturación Electronica El Salvador"]

*** Test Cases ***
Venta Items SimanPro, forma de Pago Credisiman
    [Documentation]    Venta de items aplicables a garantia SimanPRO con forma de pago Credisiman.

    Iniciar App Xmobile

    # Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]
    #=====+ Inicio de Transacción +=====+
    Seleccionar documento Fiscal

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
    Ingresar Tarjeta En Teclado Visual    ${TARJETAS}[credisiman]
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
    Wait Until Element Is Visible    ${POPUP_ESQUEMAS_FINANCIAMIENTO}   2s    
    Click Element    ${ROTATIVO_CLIENTE_SIMAN}
    Sleep    2s

    # --- FINALIZACIÓN Y DOCUMENTOS ---
    
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
    Sleep    2s
    
    Cerrar App Xmobile