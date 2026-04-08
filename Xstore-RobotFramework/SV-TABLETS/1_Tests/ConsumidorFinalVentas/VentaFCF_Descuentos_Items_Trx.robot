*** Settings ***
Documentation    Flujos de Facturación Consumidor Final
Library          AppiumLibrary
Resource         ../../3_Config/Setup.robot
Variables        ../../3_Config/DataConfig.py
Resource         ../../2_Resources/Utilidades_Keywords.robot

*** Variables ***
${INPUT_ITEMS}    xpath=//android.view.View[contains(@resource-id, 'promptTextBox')]//android.widget.EditText

*** Test Cases ***
Venta de Items con descuento manual y forma de pago efectivo
    [Documentation]    Flujo de venta 

    Iniciar App Xmobile

    #Ingresar Credenciales    ${USUARIOS}[cajero]    ${USUARIOS}[contraseña_cajero]

    #=====+ Inicio de flujo +=====+
    Seleccionar documento Fiscal

    # Ingreso de Items
    Click Element    ${INPUT_ITEMS}
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_1]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_2]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    
    Input Text       ${INPUT_ITEMS}    ${ITEMS_REGULAR}[items_3]
    Click Element    ${INPUT_ITEMS}
    Sleep    1s
    Press Keycode    66
    Sleep    1s

    # Aplicar descuentos a los items
    Wait Until Element Is Visible    xpath=//android.webkit.WebView[@text="Xstore"]/android.view.View/android.view.View/android.view.View[2]    2s
    Click Element                    xpath=//android.webkit.WebView[@text="Xstore"]//android.view.View[@resource-id="_li_0"]
    Sleep    1s
    
    # Popup de opciones item
    Wait Until Element Is Visible    xpath=//com.google.android.material.navigation.NavigationView/android.view.View    2s
    Click Element                    xpath=//android.view.View[@resource-id="_li_6"]
    Sleep    1s

    # Popup de seleccion de descuento
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Descuento"]    2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_0" and @text="Descuento de articulo: % de descuento"]
    Sleep    1s

    Ingresar Credenciales Gerente Aplicar Descuentos    ${USUARIOS}[gerente]    ${USUARIOS}[contraseña_gerente]
    Sleep    1s

    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Código de motivo"]    2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_2" and @text="Servicio al cliente"]
    Sleep    1s

    # Ingresar descuento
    Escribir Texto Alfanumerico    ${DESCUENTOS}[descuento_porcentaje_1]
    Sleep    1s
    Click Element    accessibility_id=Devolución
    Sleep    2s

    # Agregar descuento a la transacción
    Click Element    accessibility_id=Menú de contexto
    Sleep    1s
    Click Element    xpath=//android.widget.ListView//android.widget.TextView[@text="Agregar descuentos"]
    Sleep    1s
    Click Element    xpath=//android.widget.ListView//android.view.View[@resource-id="_li_1" and @text="Agregar descuento de transacción"]
    Sleep    1s

    # Popup de seleccion de descuento
    Wait Until Element Is Visible    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.widget.TextView[@text="Descuento"]    2s
    Click Element                    xpath=//android.view.View[@resource-id="XMDialogOverlayDisplay"]//android.view.View[@resource-id="_li_1" and @text="Descuento de transaccion: $"]
    Sleep    1s

    # Ingresar descuento por monto
    Escribir Texto Alfanumerico    ${DESCUENTOS}[descuento_monto_1]
    Sleep    1s
    Click Element    accessibility_id=Devolución
    Sleep    2s


    Cerrar App Xmobile
