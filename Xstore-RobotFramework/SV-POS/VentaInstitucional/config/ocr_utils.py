import os
import time
import cv2
import numpy as np
import pytesseract
import pyautogui
import keyboard
from difflib import SequenceMatcher
from robot.api.deco import keyword
from dotenv import dotenv_values
import shutil

# --- CONFIGURACIÓN DINÁMICA DE TESSERACT ---
def configurar_tesseract(ruta_env=None):
    # 1. Prioridad: Ruta en config.env
    if ruta_env and os.path.exists(ruta_env):
        pytesseract.pytesseract.tesseract_cmd = ruta_env
        return
    
    # 2. Rutas estándar
    rutas = [
        r'C:\Program Files\Tesseract-OCR\tesseract.exe',
        r'C:\Program Files (x86)\Tesseract-OCR\tesseract.exe',
        os.path.join(os.getenv('LOCALAPPDATA', ''), 'Tesseract-OCR', 'tesseract.exe')
    ]
    for r in rutas:
        if os.path.exists(r):
            pytesseract.pytesseract.tesseract_cmd = r
            return
            
    # 3. Path del sistema
    en_path = shutil.which("tesseract")
    if en_path:
        pytesseract.pytesseract.tesseract_cmd = en_path

# --- CAPTURA Y PROCESAMIENTO ---
def capturar_pantalla(region=None, scale=1.5):
    try:
        screenshot = pyautogui.screenshot(region=region)
        img = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
        if scale > 1:
            img = cv2.resize(img, None, fx=scale, fy=scale, interpolation=cv2.INTER_LINEAR)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        return thresh
    except Exception:
        return None

# --- KEYWORDS ROBOT FRAMEWORK ---

@keyword
def inicializar_motor_ocr(ruta_tesseract=None):
    configurar_tesseract(ruta_tesseract)

@keyword
def obtener_texto_ocr(region=None):
    img = capturar_pantalla(region)
    if img is None: return ""
    try:
        # --psm 3 (Auto) --oem 3 (Default)
        return pytesseract.image_to_string(img, lang='spa+eng', config='--oem 3 --psm 3').strip()
    except Exception as e:
        print(f"Error OCR: {e}")
        return ""

@keyword
def texto_contiene_fuzzy(texto_pantalla, frase_clave, umbral=0.80):
    if not texto_pantalla or not frase_clave: return False
    frase = frase_clave.lower().strip()
    for linea in texto_pantalla.splitlines():
        ratio = SequenceMatcher(None, linea.lower().strip(), frase).ratio()
        if ratio >= umbral or frase in linea.lower():
            return True
    return False

@keyword
def obtener_variables_env():
    """
    MODIFICADO: Carga config.env desde la MISMA carpeta que este script (Config/)
    """
    # __file__ es la ruta de ocr_utils.py. Buscamos config.env ahí mismo.
    ruta_env = os.path.join(os.path.dirname(__file__), "config.env")
    
    if not os.path.exists(ruta_env):
        raise FileNotFoundError(f"CRITICO: No se halló config.env en {ruta_env}")

    print(f"--- Cargando Configuración: {ruta_env} ---")
    return dotenv_values(ruta_env)