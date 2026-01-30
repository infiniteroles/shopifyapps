# 🚀 Shopify Apps Starter Kit

Plantilla para crear apps de Shopify con Remix, desplegadas en servidor propio.

## ⚡ Inicio Rápido

```bash
# 1. Clonar el repositorio
git clone https://github.com/infiniteroles/shopifyapps.git mi-nueva-app
cd mi-nueva-app

# 2. Ejecutar el script de inicialización
./init.sh
```

El script te preguntará:
- 📛 **Nombre de la app** (ej: `my-awesome-app`)
- 🌐 **Dominio** para el backend (ej: `myapp.infiniteroles.com`)
- 🔐 **Credenciales del servidor** (SSH)
- 🔑 **Client ID** de Shopify Partners
- 📝 **Descripción** de la funcionalidad

## 📋 Requisitos Previos

### En tu Mac (desarrollo)
- Node.js 18+
- npm o pnpm
- Shopify CLI: `npm install -g @shopify/cli`
- Cuenta en [Shopify Partners](https://partners.shopify.com)

### En el servidor
- Node.js 18+
- PM2: `npm install -g pm2`
- Nginx (para proxy reverso)
- Certbot (para SSL)

## 🏗️ Estructura del Proyecto

```
mi-app/
├── app/                    # Código Remix
│   ├── routes/             # Rutas de la app
│   ├── shopify.server.ts   # Configuración Shopify
│   └── db.server.ts        # Cliente Prisma
├── extensions/             # Extensiones Shopify (opcional)
├── prisma/                 # Schema de base de datos
├── scripts/                # Scripts de utilidad
│   ├── deploy.sh           # Deploy al servidor
│   └── setup-server.sh     # Configurar servidor
├── docs/                   # Documentación
└── .env.example            # Variables de entorno ejemplo
```

## 🔧 Configuración Manual (alternativa)

Si prefieres configurar manualmente:

### 1. Crear app en Shopify Partners
1. Ve a [partners.shopify.com](https://partners.shopify.com)
2. Apps → Create app → Create app manually
3. Guarda el **Client ID** y **Client Secret**

### 2. Configurar variables de entorno
```bash
cp .env.example .env
# Editar .env con tus credenciales
```

### 3. Instalar dependencias
```bash
npm install
npx prisma generate
```

### 4. Desarrollo local
```bash
npm run dev
```

## 🚀 Deploy

### Deploy rápido
```bash
./scripts/deploy.sh
```

### Deploy manual
```bash
# 1. Build
npm run build

# 2. Deploy extensiones (si hay)
shopify app deploy --force

# 3. Subir al servidor
./scripts/deploy.sh
```

## 📚 Documentación

- [Guía de Desarrollo](docs/DEVELOPMENT.md)
- [Configuración del Servidor](docs/SERVER-SETUP.md)
- [Extensiones de Shopify](docs/EXTENSIONS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🎯 Apps Creadas con este Starter

| App | Descripción | Repo |
|-----|-------------|------|
| BirthdaySync | Captura cumpleaños en POS y Checkout | [birthdaysync](https://github.com/infiniteroles/birthdaysync) |
| Free Shipping | Envío gratis por umbral de precio | [free-shipping](https://github.com/infiniteroles/free-shipping) |

## 📄 Licencia

MIT - White & One
