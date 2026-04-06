import os
import time
import cv2
import numpy as np
import pytesseract
import pyautogui
import autoit
import keyboard
import pandas as pd
from PIL import Image
from difflib import SequenceMatcher
from robot.api.deco import keyword
from dotenv import dotenv_values

# Configuración de Tesseract
# Asegúrate de que esta ruta sea correcta
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# ────────────────────────────────
# 🔧 Utilidades de Imagen (OPTIMIZADA)
# ────────────────────────────────

def upscale_image(img, scale=1.5):
    # Reducimos la escala de 2 a 1.5. Si el texto es nítido, prueba con scale=1.0 para más velocidad.
    if scale > 1:
        # Usamos INTER_LINEAR para un equilibrio entre calidad y velocidad
        return cv2.resize(img, None, fx=scale, fy=scale, interpolation=cv2.INTER_LINEAR)
    return img

def preprocess_image(img):
    # Simplificamos el preprocesamiento: sin GaussianBlur para ganar velocidad.
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # Aplicar OTSU directamente al gris
    _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    return thresh

def capture_and_prepare(region=None, scale=1.5):
    # ⚡️ Clave de Velocidad: Capturar solo la región de interés si es posible (ej: el centro de la pantalla).
    screenshot = pyautogui.screenshot(region=region) 
    img = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
    return preprocess_image(upscale_image(img, scale))

# ────────────────────────────────
# 🔍 OCR y Reconocimiento (OPTIMIZADA)
# ────────────────────────────────

@keyword
def obtener_texto_ocr(region=None, config='--oem 3 --psm 3'):
    # Usamos PSM 3 (default) y OEM 3 (default/mejorado) para velocidad y precisión.
    try:
        # Usamos scale=1.5 como punto de partida.
        img = capture_and_prepare(region, scale=1.5)
        
        texto = pytesseract.image_to_string(img, lang='eng+spa', config=config)
        
        if len(texto.strip()) < 5:
            # Evitar guardar archivos por insuficiente. Solo logueamos.
            print("⚠️ Texto OCR insuficiente. Se retornará vacío para evitar falsos positivos.")
            return "" 
        
        return texto.strip()
    except Exception as e:
        # Evitar I/O de disco al fallar.
        print(f"❌ Error durante OCR: {str(e)}")
        return f"OCR error: {str(e)}"

@keyword
def esperar_palabra_clave(palabra_clave, timeout=5, region=None):
    # Este keyword ahora es más rápido gracias al OCR optimizado.
    start_time = time.time()
    while time.time() - start_time < timeout:
        texto = obtener_texto_ocr(region)
        if palabra_clave.lower() in texto.lower():
            return True
        time.sleep(0.1) # Reducir la pausa
    return False

@keyword
def texto_contiene(texto, palabra_clave, umbral=0.80):
    # Funciones de comparación sin cambios, ya que son rápidas.
    ratio = SequenceMatcher(None, texto.replace("\n", " ").lower(), palabra_clave.lower()).ratio()
    print(f"🔍 Similitud entre OCR y clave '{palabra_clave}': {ratio:.3f}")
    return ratio >= umbral

@keyword
def texto_contiene_por_linea(texto, palabra_clave, umbral=0.75):
    if not texto or not palabra_clave:
        return False
    palabra_normalizada = palabra_clave.lower().strip()
    for linea in texto.splitlines():
        ratio = SequenceMatcher(None, linea.lower().strip(), palabra_normalizada).ratio()
        print(f"🔍 Similitud línea: '{linea.strip()}' vs clave '{palabra_clave}' → {ratio:.3f}")
        if ratio >= umbral:
            return True
    return False

@keyword
def comparar_textos_ocr(texto1, texto2):
    try:
        if not texto1 or not texto2:
            return False
        return texto1.replace("\n", " ").strip().lower() == texto2.replace("\n", " ").strip().lower()
    except Exception as e:
        print(f"Error al comparar textos OCR: {e}")
        return False

# ────────────────────────────────
# 📸 Capturas y Evidencia (MODIFICADAS)
# ────────────────────────────────

def ensure_folder(carpeta):
    if not os.path.exists(carpeta):
        os.makedirs(carpeta)

@keyword
def guardar_captura(nombre_archivo, carpeta="capturas"):
    # Mantener este keyword solo para DEBUG o reportes de fallos
    try:
        ensure_folder(carpeta)
        ruta = os.path.join(carpeta, nombre_archivo)
        pyautogui.screenshot().save(ruta)
        print(f"Captura guardada en: {ruta}")
    except Exception as e:
        print(f"Error al guardar captura: {e}")

@keyword
def guardar_captura_y_texto(nombre_base, carpeta="capturas"):
    # ❌ ELIMINAMOS el cuerpo para que, si se llama accidentalmente desde el flujo principal, no ralentice.
    # Solo guarda en caso de fallos críticos fuera del flujo rápido.
    print(f"⚠️ Guardado de captura y texto omitido para mejorar rendimiento.")
    pass

@keyword
def guardar_datos_ocr(nombre_base, carpeta="capturas"):
    # ❌ ELIMINAMOS el cuerpo para que, si se llama accidentalmente desde el flujo principal, no ralentice.
    print(f"⚠️ Guardado de datos OCR omitido para mejorar rendimiento.")
    pass

# ────────────────────────────────
# 🧩 Utilidades Adicionales
# ────────────────────────────────

# (Mantener el resto de funciones sin cambios)

@keyword
def activar_ventana(titulo_ventana, timeout=5):
    try:
        autoit.win_activate(titulo_ventana)
        autoit.win_wait_active(titulo_ventana, timeout)
    except Exception as e:
        raise Exception(f"No se pudo activar la ventana '{titulo_ventana}': {str(e)}")

@keyword
def tecla_presionada(letra="d"):
    return keyboard.is_pressed(letra)

# ────────────────────────────────
# 📦 Variables desde config.env
# ────────────────────────────────

@keyword
def obtener_variables_env():
    """
    Carga las variables desde config.env ubicado en la misma carpeta que este archivo.
    """
    ruta_env = os.path.join(os.path.dirname(__file__), "config.env")
    if not os.path.exists(ruta_env):
        raise FileNotFoundError(f"No se encontró el archivo config.env en {ruta_env}")

    variables = dotenv_values(ruta_env)

    claves_requeridas = [
        "VENTANA_PRINCIPAL",
        "TIEMPO_TOTAL",
        "ID_EMPLEADO",
        "CONTRASEÑA",
        "ITEM_1",
        "ID_CLIENTE"
    ]
    for clave in claves_requeridas:
        if clave not in variables or variables[clave] is None:
            raise ValueError(f"Variable requerida '{clave}' no encontrada en config.env")

    return variables
