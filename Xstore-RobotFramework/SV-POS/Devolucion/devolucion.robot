*** Settings ***
Documentation     Script de Devolución Única con Reporte de Auditoría y Captura de Errores.
Suite Setup       Inicializar Entorno
Test Teardown     Finalizar Y Generar Reporte
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
${ID_EMPLEADO}          NONE
${CONTRASEÑA}           NONE
${ID_CLIENTE}           NONE
${ID_VENDEDOR}          NONE
${ITEM_1}               NONE

*** Test Cases ***
Ejecutar Flujo Devolucion Una Vez
    [Documentation]    Ejecuta el ciclo completo de devolución y detecta errores automáticamente.
    ${start_ts}=    Evaluate    time.time()    modules=time
    Set Suite Variable    ${TIEMPO_INICIO_TEST}    ${start_ts}
    
    # --- INICIO DEL FLUJO ---
    Activar Ventana    ${VENTANA_PRINCIPAL}
    Verificar Ventana Activa
    
    Accion_Login
    Accion_Contraseña
    Accion_ConfirmarID
    Accion_MenuPrincipal
    Accion_IngresarCliente
    Accion_SeleccionarCliente
    Accion_Verificada
    Accion_IngresoDevolucion
    Accion_SeleccionArticulos
    Accion_FormasPago
    Accion_FinalizarVenta
    Accion_ImprimirFactura
    Accion_FacturaEmitida_Logica
    
    Log    Flujo completado exitosamente.

*** Keywords ***
Inicializar Entorno
    # Carga de variables desde ocr_utils (que usa dotenv)
    ${env}=    Obtener Variables Env
    Set Suite Variable    ${VENTANA_PRINCIPAL}    ${env["VENTANA_PRINCIPAL"]}
    Set Suite Variable    ${ID_EMPLEADO}          ${env["ID_EMPLEADO"]}
    Set Suite Variable    ${ID_VENDEDOR}          ${env["ID_VENDEDOR"]}
    Set Suite Variable    ${CONTRASEÑA}           ${env["CONTRASEÑA"]}
    Set Suite Variable    ${ITEM_1}               ${env["ITEM_1"]}
    Set Suite Variable    ${ID_CLIENTE}           ${env["ID_CLIENTE"]}
    
    Asegurar Carpeta    ${CARPETA_REPORTE}
    Asegurar Carpeta    ${CARPETA_EVIDENCIAS}

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

Send And Wait
    [Arguments]    ${keys}
    Sleep    0.2s
    Send    ${keys}

Verificar Ventana Activa
    ${ventana_activa}=    WinGetTitle    [ACTIVE]
    IF    '${VENTANA_PRINCIPAL}' not in '${ventana_activa}'
        Fail    La ventana activa '${ventana_activa}' no coincide con '${VENTANA_PRINCIPAL}'
    END

Asegurar Carpeta
    [Arguments]    ${ruta}
    ${existe}=    Evaluate    os.path.exists(r'${ruta}')    modules=os
    IF    not ${existe}    Create Directory    ${ruta}

# --- ACCIONES DEL POS ---

Accion_Login
    Send And Wait    ${ID_EMPLEADO}{ENTER}

Accion_Contraseña
    Send And Wait    ${CONTRASEÑA}{ENTER}

Accion_ConfirmarID
    Send And Wait    ^a{DELETE}${ID_VENDEDOR}{ENTER}

Accion_MenuPrincipal
    Send And Wait    {F6}

Accion_IngresarCliente
    Send And Wait    ${ID_CLIENTE}{F8}

Accion_SeleccionarCliente
    Send And Wait    {ENTER}

Accion_Verificada
    Send And Wait    s

Accion_IngresoDevolucion
    
    Send And Wait    {TAB}{TAB}
    Send And Wait    ${ID_TICKET}
    Send And Wait    {F8}
    Send And Wait    {TAB}
    Send And Wait    ${ID_TIENDA}
    Send And Wait    {TAB}
    Send And Wait    ${ID_CAJA}

Accion_SeleccionArticulos
    Send And Wait    {F8}{ENTER}

Accion_FormasPago
    Send And Wait    {F10}

Accion_FinalizarVenta
    Send And Wait    4{ENTER}

Accion_ImprimirFactura
    Send And Wait    s

Accion_FacturaEmitida_Logica
    Send And Wait    {ENTER}
