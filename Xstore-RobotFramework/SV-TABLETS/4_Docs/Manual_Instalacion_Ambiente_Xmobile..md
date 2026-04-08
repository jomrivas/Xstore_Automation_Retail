# 📘 Manual de Configuración de Ambiente: Automatización Xstore Mobile (Robot Framework + Appium)
**Versión del Documento: 1.0**
## Objetivo: Configurar el entorno de desarrollo para la automatización de pruebas en dispositivos Android (Tablets/Handhelds) utilizando Robot Framework.


📋 Requisitos Previos
Antes de comenzar, asegúrese de tener los siguientes instaladores descargados.

Herramientas, versión Recomendada

![Static Badge](https://img.shields.io/badge/python-version_3.10_%20o_superior.-brightgree?style=flat&logo=python&logoColor=ffffff&color=%230949C8)
![Static Badge](https://img.shields.io/badge/node.js-version_22.0_%20o_superior.-brightgree?style=flat&logo=node.js)
![Static Badge](https://img.shields.io/badge/java-version_11_%20o_superior.-bright?style=flat&logo=java&color=%236787C5)
![Static Badge](https://img.shields.io/badge/Android%20Studio-SDK_ADB?style=flat&logo=android&color=%233BBBF1)
![Static Badge](https://img.shields.io/badge/vscode_lastest_version-C366F4)


Python	3.10.x o superior	Lenguaje base.  
Node.js	LTS (Long Term Support)	Requerido para correr el servidor de Appium.  
Java JDK	OpenJDK 11 o 17	Requerido para firmar apps de Android.  
Android SDK	Command Line Tools	Para usar ADB y conectar dispositivos.  
VS Code	Última versión	Editor de código (IDE).


### ⚙️ Escenario A: Instalación CON Permisos de Administrador
Para equipos personales o con privilegios elevados.

Python: Ejecutar el instalador. IMPORTANTE: Marcar la casilla "Add Python to PATH" antes de dar clic en "Install Now".

Node.js: Ejecutar el .msi y seguir el asistente (Next > Next > Install).

Java JDK: Instalar el ejecutable estándar.

Android Studio (Opcional): Instalar Android Studio completo, lo cual configura el SDK y las variables de entorno automáticamente.

### 🛠️ Escenario B: Instalación SIN Permisos de Administrador (Modo Portable)
Para equipos corporativos restringidos. La estrategia es usar versiones "portables" o instalar solo para el usuario actual.

1. Python (Instalación Local)
Ejecute el instalador de Python.

**IMPORTANTE: Marque "Add Python to PATH".**

Seleccione "Customize installation".

En Advanced Options, DESMARQUE "Install for all users".

Asegúrese de que la ruta de instalación sea en su usuario, ej: C:\Users\SU_USUARIO\AppData\Local\Programs\Python\Python310.

Instale.

2. Node.js (Versión Zip/Binaria)
Como no podemos ejecutar el .msi:

Descargue la versión Windows Binary (.zip) desde el sitio oficial.

Cree una carpeta llamada C:\Herramientas (o en sus Documentos).

Descomprima el contenido allí (ej: C:\Herramientas\node-v18).

Configurar Variables de Entorno (Usuario):

Presione Win + R, escriba:

```rundll32 sysdm.cpl,EditEnvironmentVariables```

y Enter.

En la sección Variables de usuario para [Tu Usuario] (La de arriba), busca Path, seleccione Editar -> Nuevo.

    Agrega la ruta: C:\Herramientas\node-v18.

3. Java JDK (OpenJDK Portable)
Descargue OpenJDK 11 (formato .zip) desde Adoptium o similar.

Descomprima en C:\Herramientas\jdk-11.

Variables de Entorno (Usuario):

Cree una NUEVA variable de usuario llamada JAVA_HOME con valor: C:\Herramientas\jdk-11.

Edita la variable Path y agregue: %JAVA_HOME%\bin.

4. Android SDK (Command Line Tools)
No necesitamos Android Studio completo (que pide admin), solo las herramientas de línea de comandos.

Descargue "Command line tools only" desde Android Developers.

Cree la estructura de carpetas: C:\Android\cmdline-tools.

Descomprima el zip dentro, asegúrese de que la estructura final sea: C:\Android\cmdline-tools\latest\bin (A veces hay que renombrar la carpeta descomprimida a latest).

Variables de Entorno (Usuario):

Cree variable ANDROID_HOME con valor: C:\Android.

Edite Path y agregue:

    %ANDROID_HOME%\cmdline-tools\latest\bin

    %ANDROID_HOME%\platform-tools (Esta se creará después).

🚀 Configuración de Librerías y Appium (Común para ambos escenarios)
Una vez instalados los programas base, abra una terminal (CMD o PowerShell) y ejecute:

1. Verificar Instalaciones Base

```
python --version  
node -v   
java -version
```

2. Instalar Appium Server


```npm install -g appium``` 

Si da error de permisos en Escenario B, asegúrese de que la carpeta de npm esté en tu PATH.

3. Instalar Driver de Android (UiAutomator2)
Es crucial para automatizar Xstore Mobile.

```appium driver install uiautomator2```

4. Instalar Robot Framework y Librerías
Ejecuta el siguiente comando para instalar todo el stack de Python:


```
pip install robotframework
pip install robotframework-appiumlibrary
pip install robotframework-metrics
```

5. Configurar Android SDK (Solo Escenario B)

Si instalaste las "Command line tools" manualmente, necesita descargar las platform-tools (donde vive ADB). Ejecuta:

```
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
```

(Acepta las licencias presionando 'y' cuando se le solicite).

💻 Configuración del IDE (VS Code)
Instale Visual Studio Code (Existe una versión "User Installer" que no requiere admin).

Vaya al menú de Extensiones (Ctrl+Shift+X) e instale:

Robot Framework Language Server (de Robocorp).

Python (de Microsoft).

Material Icon Theme (Opcional, para ver los iconos de carpetas mejor).

✅ Verificación Final
Para confirmar que el entorno está listo para automatizar Xstore:

Conecte el dispositivo Android / Abra el emulador.

Ejecute adb devices en la terminal. Debe ver el ID del dispositivo.

Ejecute appium. Debe ver el mensaje: "Welcome to Appium v2.x.x".

Solución de Problemas Comunes (Sin Admin)
"pip no se reconoce": Asegúrese de que la carpeta Scripts de Python esté en el Path (Ej: ...\Python310\Scripts).

"adb no se reconoce": Verifique que %ANDROID_HOME%\platform-tools esté en las variables de entorno del usuario.

Este manual garantiza que cualquier desarrollador pueda sumarse al proyecto Xstore Mobile Automation independientemente de los privilegios de su cuenta corporativa.
