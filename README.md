# FISI Prácticas - Sistema de Gestión de Prácticas Pre-profesionales

Este proyecto es una aplicación móvil desarrollada en Flutter para gestionar las prácticas pre-profesionales de los estudiantes de la Facultad de Ingeniería de Sistemas e Informática (FISI).

## 📱 Características Principales

- **Multi-rol**: Sistema con roles específicos para estudiantes, reclutadores y administradores
- **Gestión de Ofertas**: Publicación y aplicación a ofertas de prácticas
- **Perfiles Empresariales**: Información detallada de empresas participantes
- **Chat Integrado**: Comunicación directa entre estudiantes y reclutadores
- **Panel Administrativo**: Gestión de usuarios y supervisión del sistema

## 🚀 Estructura del Proyecto

```
lib/
├── core/                   # Configuraciones centrales y utilidades
│   ├── constants/         # Constantes globales
│   ├── data/             # Capa de datos
│   ├── di/               # Inyección de dependencias
│   ├── routes/           # Configuración de rutas
│   └── utils/            # Utilidades generales
│
├── features/              # Módulos principales
│   ├── admin/            # Funcionalidades del administrador
│   ├── auth/             # Autenticación y autorización
│   ├── recruiter/        # Funcionalidades del reclutador
│   ├── shared/           # Componentes compartidos
│   └── student/          # Funcionalidades del estudiante
│
└── main.dart             # Punto de entrada de la aplicación
```

## 🛠️ Requisitos de Instalación

1. **Flutter SDK**
   ```bash
   # Verifica que cumples los requisitos
   flutter doctor
   ```

2. **Dependencias del Proyecto**
   ```bash
   # Instala todas las dependencias
   flutter pub get
   ```

3. **Configuración del Entorno**
   - Asegúrate de tener configurado un emulador o dispositivo físico
   - Configura las variables de entorno necesarias

## 🏃‍♂️ Ejecutar el Proyecto

1. **Modo Desarrollo**
   ```bash
   flutter run
   ```

2. **Construir para Producción**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## 🔄 Flujo de la Aplicación

### 1. Inicio de Sesión
- Selección de tipo de usuario (Estudiante/Reclutador/Admin)
- Autenticación específica para cada rol

### 2. Flujo del Estudiante
1. Explorar ofertas de prácticas
2. Ver detalles de empresas
3. Aplicar a ofertas
4. Chatear con reclutadores
5. Gestionar postulaciones

### 3. Flujo del Reclutador
1. Gestionar perfil de empresa
2. Publicar ofertas de prácticas
3. Revisar postulaciones
4. Comunicarse con estudiantes
5. Ver estadísticas

### 4. Flujo del Administrador
1. Gestionar usuarios
2. Supervisar empresas
3. Moderar ofertas
4. Ver estadísticas generales

## 🤝 Contribución

1. Crea un fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add: AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
