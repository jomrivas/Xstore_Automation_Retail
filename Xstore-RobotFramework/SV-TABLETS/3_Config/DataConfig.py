# ==========================================
# CONFIGURACIÓN DE DATOS - XSTORE MOBILE
# ==========================================
#            Powered by JOMRivas
# ==========================================
#        *** DATOS POR FRANQUICIAS *** 
# ==========================================
import os   

# --- DATOS: SIMAN ---
# --- ITEMS ---
SIMAN_ITEMS_PROMOS = {
    "regular":                      "100000001",
    "liquidacion":                  "100000002",
    "promocionRPM":                 "100000003",
    "orce":                         "100000004"
}

SIMAN_ITEMS_PRECIO_REGULAR = {
    "items_1":                      "123456789",
    "items_2":                      "111111111",
    "items_3":                      "222222222",
    "items_4":                      "333333333",
    "items_5":                      "444444444",
    "items_6":                      "555555555",
    "items_7":                      "666666666",
    "items_8":                      "777777777",
    "items_9":                      "888888888",
    "items_10":                     "999999999",
    "items_11":                     "121212121"
}

ITEMS_SIMANPRO = {
    "simanpro_1":                   "111111011",
    "simanpro_2":                   "222222222"
}

SIMAN_ITEMS_CLUBES = {
    "clubes_1":                     "",
    "clubes_2":                     ""
}

LISTA_ITEMS_MASIVOS = [
    "470915600006",
    "104540308",
    "464344100008",
    "101991660",
    "104249890"
]

SIMAN_CLUBES_EVENTOS = {
    "evento_clubes_1":                     "",
    "evento_orce_1":                       "",
    "evento_clubes_2":                     "",
    "evento_orce_2":                       ""
}
# --- CREDENCIALES CAJEROS/VENDEDORES - GERENTES ---
SIMAN_10106_USUARIOS = {
    "cajero":                       "000000",
    "contraseña_cajero":            "Abcde1000",
    "vendedor":                     "0",
    "gerente":                      "111111",
    "contraseña_gerente":           "Abcde2000"
}

# --- DATOS PRISMA MODA ---
# --- ITEMS ---
PRISMA_ITEMS_PRECIO_REGULAR = {
    "items_1":                      "",
    "items_2":                      "",
    "items_3":                      "",
    "items_4":                      "",
    "items_5":                      "", 
    "items_6":                      "",
    "items_7":                      ""
}

PRISMA_ITEMS_PROMOS = {
    "items_1":                      "",
    "items_2":                      "",
    "items_3":                      "",
    "items_4":                      "",
    "items_5":                      "", 
    "items_6":                      "",
    "items_7":                      ""
}

PRISMA_10209_USUARIOS = {
    "cajero":                       "000000",
    "contraseña_cajero":            "Abcde1000",
    "vendedor":                     "0",
    "gerente":                      "111111",
    "contraseña_gerente":           "Abcde2000."
}

# ==========================================
#        *** LÓGICA DE SELECCIÓN ***
# ==========================================

# Usamos 'SIMAN' por defecto.
# Esto nos permite cambiar de marca desde la terminal:
# Powershell -> $env:BRAND="PRISMA"; robot VentaEfectivo.robot
# CMD -> set BRAND=PRISMA && robot VentaEfectivo.robot
MARCA_ACTUAL = os.getenv('BRAND', 'SIMAN').upper()

print(f"\n--- CARGANDO CONFIGURACIÓN PARA: {MARCA_ACTUAL} ---\n")

if MARCA_ACTUAL == 'PRISMA':
    # --- CARGA DE DATOS PRISMA ---
    # Asignamos los diccionarios de Prisma a las variables GENÉRICAS
    ITEMS_PROMOS            = PRISMA_ITEMS_PROMOS
    ITEMS_REGULAR           = PRISMA_ITEMS_PRECIO_REGULAR
    USUARIOS                = PRISMA_10209_USUARIOS

else:
    # --- CARGA DE DATOS SIMAN (Default) ---
    # Asignamos los diccionarios de Siman a las variables GENÉRICAS
    ITEMS_PROMOS            = SIMAN_ITEMS_PROMOS
    ITEMS_REGULAR           = SIMAN_ITEMS_PRECIO_REGULAR
    USUARIOS                = SIMAN_10106_USUARIOS

# ==========================================
#       *** VARIABLES COMPARTIDAS ***
# ==========================================
# --- TARJETAS CREDISIMAN, CERTIFICADOS DE REGALO, NOTAS DE ABONO, TARJETA DEVOLUCION, MONEDERO, ETC. ---
TARJETAS = {
    "credisiman":                   "6008314001217649",
    "credisiman_2":                 "6008314500062124",
    "credisiman_3":                 "6008314001933609",
    "certificado_regalo":           "6008317303753526",
    "anticipo_gravado":             "6008317701351048",
    "monedero":                     "6008316006608235",
    "tarjeta_devolucion":           "6008317511134790"
}

# --- CLIENTES ---
CLIENTES = {
    "dui":                          "123456789",
    "nit":                          "0202020202020202",
    "nrc":                          "5566556655",
    "diplomatico":                  "00110011",
    "exento":                       "12345"
}

DESCUENTOS = {
    "descuento_porcentaje_1":       "10",
    "descuento_porcentaje_2":       "20",
    "descuento_porcentaje_3":       "30",
    "descuento_porcentaje_4":       "40",
    "descuento_porcentaje_5":       "50",
    "descuento_monto_1":            "10",
    "descuento_monto_2":            "20",
    "descuento_monto_3":            "30",
    "descuento_monto_4":            "40",
    "descuento_monto_5":            "50"
}

