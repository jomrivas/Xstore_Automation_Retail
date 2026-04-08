import os

print("==================================================")
print("      INICIANDO SUITE DE PRUEBAS XMOBILE          ")
print("==================================================")
print("              POWERED BY JOMRIVAS                 ")
print("==================================================")

# 1. Hacer que el script detecte su propia ubicación exacta
directorio_actual = os.path.dirname(os.path.abspath(__file__))

# 2. Definir las rutas absolutas a los archivos
archivo_robot_1 = os.path.join(directorio_actual, "Regresivas_ConsumidorFinal_1.robot")
carpeta_resultados = os.path.join(directorio_actual, "allure-results")

print("\n[Paso 1] Ejecutando scripts y recolectando datos de Allure...")

# Armamos el comando inyectando las rutas dinámicas y manejando los espacios en las carpetas
comando_robot = f'robot --listener "allure_robotframework;{carpeta_resultados}" "{archivo_robot_1}"'
os.system(comando_robot)

print("\n[Paso 2] Levantando el servidor de reportes...")
comando_allure = f'allure serve "{carpeta_resultados}"'
os.system(comando_allure)

print("\n Proceso finalizado. Revisae el navegador web.")