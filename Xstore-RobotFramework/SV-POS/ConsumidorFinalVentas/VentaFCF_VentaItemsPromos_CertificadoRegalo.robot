*** Settings ***
Documentation     Script de venta con forma de pago efectivo.
Suite Setup       Inicializar Entorno
Library           AutoItLibrary
Library           OperatingSystem
Library           DateTime
Library           Collections
Library           Screenshot
Library           config/ocr_utils.py

*** Variables ***
${CARPETA_REPORTE}      ${CURDIR}${/}reporte_final
${CARPETA_EVIDENCIAS}   ${CARPETA_REPORTE}${/}capturas
${VENTANA_PRINCIPAL}    NONE
${ID_CAJERO}            NONE
${CONTRASEÑA}           NONE
${ID_CLIENTE}           NONE
${ID_VENDEDOR}          NONE
${ITEM_RPM}             NONE
${ITEM_ORCE}            NONE
${ITEM_LIQUIDACION}     NONE
${TIEMPO_INICIO_TEST}   NONE
${CREDISIMAN_PROMOS}    NONE
${MONTO_PROMOS}         NONE
${CERTIFICADO_REGALO}   NONE
${MONTO_CERTIFICADO}    NONE

*** Test Cases ***
Flujo de venta CF con items com promos y forma de pago Credisiman
    [Documentation]    Flujo de venta con documento CF, items com promos RPM, ORCE, Liquidación y forma de pago Credisiman.
    
    ${start_ts}=    Evaluate    time.time()    modules=time
    Set Suite Variable    ${TIEMPO_INICIO_TEST}    ${start_ts}
    
    # --- INICIO DEL FLUJO ---

    Activar Ventana    ${VENTANA_PRINCIPAL}
    Verificar Ventana Activa
    
    Accion_IngresarCajero
    Accion_ConfirmarVendedor
    Accion_MenuPrincipal_TiposComprobantes
    Accion_IngresarArticulo
    Accion_SeleccionarBoton_FormaDePago
    Accion_IngresarCliente
    Accion_SeleccionarFormaDePago_Certificado
    Accion_IngresarSerie_MontoVenta
    Accion_ConfirmaDocumentoEmitidoEnLinea
    #Accion_GuardarImpresion
  
    # --- FIN DEL FLUJO ---    

*** Keywords ***
Inicializar Entorno
    # Carga de variables desde ocr_utils (que usa dotenv)
    ${env}=    Obtener Variables Env
    Set Suite Variable    ${VENTANA_PRINCIPAL}    ${env["VENTANA_PRINCIPAL"]}
    Set Suite Variable    ${ID_CAJERO}            ${env["ID_CAJERO"]}
    Set Suite Variable    ${ID_VENDEDOR}          ${env["ID_VENDEDOR"]}
    Set Suite Variable    ${CONTRASEÑA}           ${env["CONTRASEÑA"]}
    Set Suite Variable    ${ITEM_RPM}             ${env["ITEM_RPM"]}
    Set Suite Variable    ${ITEM_ORCE}            ${env["ITEM_ORCE"]}
    Set Suite Variable    ${ITEM_LIQUIDACION}     ${env["ITEM_LIQUIDACION"]}
    Set Suite Variable    ${ID_CLIENTE}           ${env["ID_CLIENTE"]}
    Set Suite Variable    ${CREDISIMAN_PROMOS}    ${env["CREDISIMAN_PROMOS"]}
    Set Suite Variable    ${MONTO_PROMOS}         ${env["MONTO_PROMOS"]}
    Set Suite Variable    ${CERTIFICADO_REGALO}   ${env["CERTIFICADO_REGALO"]}
    Set Suite Variable    ${MONTO_CERTIFICADO}    ${env["MONTO_CERTIFICADO"]}

    Asegurar Carpeta    ${CARPETA_REPORTE}
    Asegurar Carpeta    ${CARPETA_EVIDENCIAS}

Send And Wait
    [Arguments]    ${keys}
    Sleep    1s
    Send    ${keys}

Activar Ventana
    [Arguments]    ${title}
    Win Activate    ${title}

Verificar Ventana Activa
    ${ventana_activa}=    WinGetTitle    [ACTIVE]
    IF    '${VENTANA_PRINCIPAL}' not in '${ventana_activa}'
        Fail    La ventana activa '${ventana_activa}' no coincide con '${VENTANA_PRINCIPAL}'
    END

Asegurar Carpeta
    [Arguments]    ${ruta}
    ${existe}=    Evaluate    os.path.exists(r'${ruta}')    modules=os
    IF    not ${existe}    Create Directory    ${ruta}

# ---===+ ACCIONES DEL POS +===---

Accion_IngresarCajero
    Sleep    1s
    Send And Wait    ${ID_CAJERO}{ENTER}
    Sleep    0.5s
    Send And Wait    ${CONTRASEÑA}{ENTER}
    
Accion_ConfirmarVendedor
    Send And Wait    ${ID_VENDEDOR}{ENTER}

Accion_MenuPrincipal_TiposComprobantes
    # Seleccionar Tipos de Comprobante
    Send And Wait    {F4}
    # Seleccionar Facturación
    Send And Wait    {F1}
    # Seleccionar Consumidor Final
    Send And Wait    {ENTER}

Accion_IngresarArticulo
    Send And Wait    ${ITEM_RPM}
    Send    {ENTER}
    Send And Wait    ${ITEM_ORCE}
    Send    {ENTER}
    Send And Wait    ${ITEM_LIQUIDACION}
    Send    {ENTER}
    Sleep    1s

Accion_SeleccionarBoton_FormaDePago
    # Forma de pago con Credisiman
    Send And Wait    {F10}

Accion_IngresarCliente
    Send And Wait    ${ID_CLIENTE}
    Send And Wait    {F8}
    Send And Wait    {ENTER}

Accion_SeleccionarFormaDePago_Certificado
    Send And Wait    5

Accion_IngresarSerie_MontoVenta
    Send And Wait    ${CERTIFICADO_REGALO}
    Sleep    1s
    Send And Wait    {ENTER}
    Send And Wait    ${MONTO_CERTIFICADO}
    Sleep    0.5s
    Send And Wait    {ENTER}
    Send And Wait    4
    Send And Wait    {ENTER}
    
Accion_ConfirmaDocumentoEmitidoEnLinea
    Activar Ventana    ${VENTANA_PRINCIPAL}
    Sleep    2s
    Send And Wait    {F8}
    Sleep    1s
    Send And Wait    s
    Sleep    0.5
    Send And Wait    {F8}
    Send And Wait    {ENTER}
    Activar Ventana    ${VENTANA_PRINCIPAL}
    Send And Wait    s
    Send And Wait    {ENTER}

