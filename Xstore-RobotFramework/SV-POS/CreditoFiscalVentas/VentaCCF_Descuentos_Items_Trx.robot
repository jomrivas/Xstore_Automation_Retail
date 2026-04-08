*** Settings ***
Documentation     Venta CCF con items precio regular con descuentos y forma de pago cheque - Descuentos al item y a la trx
Suite Setup       Inicializar Entorno
Test Teardown     Finalizar Y Generar Reporte
Library           AutoItLibrary
Library           OperatingSystem
Library           DateTime
Library           Collections
Library           Screenshot
Library           String
Library           config/ocr_utils.py

*** Variables ***
${CARPETA_REPORTE}      ${CURDIR}${/}reporte_final
${CARPETA_EVIDENCIAS}   ${CARPETA_REPORTE}${/}capturas
${VENTANA_PRINCIPAL}    NONE
${ID_CAJERO}            NONE
${CONTRASEÑA}           NONE
${ID_GERENTE}           NONE
${CONTRA_GERENTE}       NONE
${ID_CLIENTE_DUI}       NONE
${ID_VENDEDOR}          NONE
${ITEM_DESCUENTO_1}     NONE
${ITEM_DESCUENTO_2}     NONE
${ITEM_DESCUENTO_3}     NONE
${ITEM_DESCUENTO_4}     NONE
${TIEMPO_INICIO_TEST}   NONE
${MONTO_DESCUENTOS}     NONE


*** Test Cases ***
Flujo de venta CCF con items precio regular con descuento manual forma de pago Cheque
    [Documentation]    Flujo de venta con documento CCF, items a precio regular con descuentos al items y a la trx, forma de pago cheque
    
    ${start_ts}=    Evaluate    time.time()    modules=time
    Set Suite Variable    ${TIEMPO_INICIO_TEST}    ${start_ts}
    
    # --- INICIO DEL FLUJO ---

    Activar Ventana    ${VENTANA_PRINCIPAL}
    Verificar Ventana Activa
    
    Accion_IngresarCajero
    Accion_ConfirmarVendedor
    Accion_MenuPrincipal_TiposComprobantes
    Accion_IngresarArticulo
    Accion_AplicarDescuentosItems
    Accion_AplicarDescuentoTransaccion
    Accion_SeleccionarBoton_FormaDePago
    Accion_IngresarCliente
    Accion_SeleccionarFormaDePago_Cheque
    Accion_IngresoDatosCheque
    Accion_Ingresar_MontoVenta
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
    Set Suite Variable    ${ID_GERENTE}           ${env["ID_GERENTE"]}
    Set Suite Variable    ${CONTRA_GERENTE}       ${env["CONTRA_GERENTE"]}
    Set Suite Variable    ${ITEM_DESCUENTO_1}     ${env["ITEM_DESCUENTO_1"]}
    Set Suite Variable    ${ITEM_DESCUENTO_2}     ${env["ITEM_DESCUENTO_2"]}
    Set Suite Variable    ${ITEM_DESCUENTO_3}     ${env["ITEM_DESCUENTO_3"]}
    Set Suite Variable    ${ITEM_DESCUENTO_4}     ${env["ITEM_DESCUENTO_4"]}
    Set Suite Variable    ${ID_CLIENTE_DUI}       ${env["ID_CLIENTE_DUI"]}
    Set Suite Variable    ${MONTO_DESCUENTOS}     ${env["MONTO_DESCUENTOS"]}

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
    # Seleccionar Credito Fiscal
    Send And Wait    {F2}

Accion_IngresarArticulo
    Send And Wait    ${ITEM_DESCUENTO_1}
    Send    {ENTER}
    Send And Wait    ${ITEM_DESCUENTO_2}
    Send    {ENTER}

Accion_AplicarDescuentosItems
    Activar Ventana    ${VENTANA_PRINCIPAL}
    # Aplicar descuento a/los items
    # Item 1
    Send And Wait    {UP}{UP}{UP}
    Send And Wait    {F7}
    Send And Wait    {1}
    Send And Wait    {ENTER}{ENTER}
    Send And Wait    ${ID_GERENTE}
    Send And Wait    {ENTER}
    Send And Wait    ${CONTRA_GERENTE}
    Send And Wait    {F8}
    Send And Wait    {ENTER}
    Send And Wait    10
    Send And Wait    {ENTER}
    # Item 2
    Send And Wait    {UP}
    Send And Wait    {F7}
    Send And Wait    {1}
    Send And Wait    {ENTER}{ENTER}
    Send And Wait    ${ID_GERENTE}
    Send And Wait    {ENTER}
    Send And Wait    ${CONTRA_GERENTE}
    Send And Wait    {F8}
    Send And Wait    {ENTER}
    Send And Wait    10
    Send And Wait    {ENTER}

Accion_AplicarDescuentoTransaccion
    # Se aplica decuento a toda la transacción - Descuento a aplicar: 10%
    Send And Wait    {F7}
    Send And Wait    {2}
    Send And Wait    {ENTER}
    Send And Wait    ${ID_GERENTE}
    Send And Wait    {ENTER}
    Send And Wait    ${CONTRA_GERENTE}
    Send And Wait    {F8}
    Send And Wait    {ENTER}
    Send And Wait    10
    Send And Wait    {ENTER}

Accion_SeleccionarBoton_FormaDePago
    Send And Wait    {F10}

Accion_IngresarCliente
    # Aplica si el documento fiscal lo requiere
    Send And Wait    ${ID_CLIENTE_DUI}
    Send And Wait    {F8}
    Send And Wait    {ENTER}

Accion_SeleccionarFormaDePago_Cheque
    #Selecciona forma de pago "Tender Cheque"
    Send And Wait    8

Accion_IngresoDatosCheque
    # Ingreso de datos del Cheque - datos aleatorios
    ${num_cheque}=    Generate Random String    9    [NUMBERS]
    ${num_cuenta}=    Generate Random String    5    [NUMBERS]
    
    # Ingresar número de cheque
    Send And Wait    ${num_cheque}
    Send And Wait    {ENTER}
    
    # Ingresar Número de cuenta
    Send And Wait    ${num_cuenta}
    Send And Wait    {ENTER}

Accion_Ingresar_MontoVenta
    Send And Wait    ${MONTO_DESCUENTOS}
    Send And Wait    {ENTER}
    Sleep    0.5s
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

    

Accion_GuardarTicketPDF
    Log    --- Iniciando guardado de Ticket PDF ---
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${nombre_archivo}=    Set Variable    Ticket_GT_${timestamp}
    Log    Nombre generado para el PDF: ${nombre_archivo}
    Send    ${nombre_archivo}
    Send And Wait    {ENTER}
    Log    Esperando que Windows termine de guardar el archivo...
    Sleep    5s

    Log    Guardado de PDF finalizado.

Accion_GuardarImpresion
    # LÓGICA DE INTERACCIÓN DIRECTA: FUERZA EL FOCO Y ENVÍA EL NOMBRE DEL PDF + ENTER
    ${now_ts}=    Evaluate    int(time.time())    modules=time
    ${lapso}=    Evaluate    time.strftime('%H_%M_%S', time.localtime(${now_ts}))    modules=time
    ${nombre_pdf}=    Catenate    PDF_lapso_    ${lapso}.pdf
    ${ventana_dialogo}=    Set Variable    Guardar impresión como
    Log    Intentando forzar el foco en la ventana '${ventana_dialogo}' antes de escribir.
    ${activado}=    Run Keyword And Return Status    WinActivate    ${ventana_dialogo}
    IF    ${activado}
        Log    Foco asegurado en la ventana '${ventana_dialogo}'.
    ELSE
        Log    No se pudo activar la ventana. Intentando con WinWaitActive.
        ${wait_activado}=    Run Keyword And Return Status    WinWaitActive    ${ventana_dialogo}    timeout=2s
        IF    not ${wait_activado}
            Log To Console    FALLO CRÍTICO: No se pudo activar la ventana '${ventana_dialogo}'.
            Fail    Fallo al activar la ventana de Guardar Impresión.
        END
    END
    Send And Wait    ${nombre_pdf}
    Send And Wait    {ENTER}
    # Presionar ENTER para confirmar el guardado
    ${Closed}=    Run Keyword And Return Status    WinWaitClose    ${ventana_dialogo}    timeout=5s
    IF    ${Closed}
        Log    Diálogo de Guardar Impresión cerrado exitosamente.
    ELSE
        Log To Console    FALLO CRÍTICO: La ventana '${ventana_dialogo}' sigue abierta tras 5s.
        Activar Ventana    ${VENTANA_PRINCIPAL}
        Fail    Fallo al guardar el PDF. El diálogo no se cerró.
    END


Finalizar Y Generar Reporte
    [Documentation]    Se ejecuta siempre al final para auditar el resultado.
    ${status}=    Set Variable    ${TEST_STATUS}
    ${mensaje_error}=    Set Variable    ${TEST_MESSAGE}
    ${end_ts}=    Evaluate    time.time()    modules=time
    ${duracion}=    Evaluate    round(${end_ts} - ${TIEMPO_INICIO_TEST}, 2)
    ${fecha}=     Evaluate    time.strftime('%Y%m%d_%H%M%S')    modules=time

    # Si falló, tomamos evidencia
    IF    '${status}' == 'FAIL'
        Take Screenshot    ${CARPETA_EVIDENCIAS}${/}Error_${fecha}.png
    END

    # Construcción del Reporte TXT
    ${reporte_path}=    Set Variable    ${CARPETA_REPORTE}${/}Resultado_${fecha}.txt
    ${contenido}=    Catenate    SEPARATOR=\n
    ...    ==========================================
    ...    REPORTE DE AUDITORÍA - XSTORE
    ...    ==========================================
    ...    Fecha: ${fecha}
    ...    Estado Final: ${status}
    ...    Duración: ${duracion} segundos
    ...    Mensaje de Error: ${mensaje_error}
    ...    ==========================================
    
    Create File    ${reporte_path}    ${contenido}
    Log To Console    \n[INFO] Ejecución terminada. Estado: ${status}. Reporte en: ${reporte_path}
   
   
