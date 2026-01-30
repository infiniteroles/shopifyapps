#!/bin/bash
# =============================================================================
# Shopify App Starter - Script de Inicialización
# =============================================================================
# Este script configura una nueva app de Shopify desde cero
# =============================================================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo ""
echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                                                               ║${NC}"
echo -e "${PURPLE}║   🚀 ${CYAN}SHOPIFY APP STARTER KIT${PURPLE}                               ║${NC}"
echo -e "${PURPLE}║      ${NC}by White & One${PURPLE}                                         ║${NC}"
echo -e "${PURPLE}║                                                               ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar requisitos
echo -e "${BLUE}📋 Verificando requisitos...${NC}"

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 no está instalado${NC}"
        echo -e "   Instalar con: $2"
        exit 1
    else
        echo -e "${GREEN}✓ $1 instalado${NC}"
    fi
}

check_command "node" "https://nodejs.org"
check_command "npm" "viene con node"
check_command "git" "xcode-select --install"

echo ""

# =============================================================================
# RECOGER INFORMACIÓN
# =============================================================================

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📝 CONFIGURACIÓN DE LA APP${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Nombre de la app
read -p "$(echo -e ${GREEN}📛 Nombre de la app ${NC}[ej: my-awesome-app]: )" APP_NAME
APP_NAME=${APP_NAME:-"my-shopify-app"}
APP_NAME_SLUG=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

# Dominio
read -p "$(echo -e ${GREEN}🌐 Dominio del backend ${NC}[ej: myapp.infiniteroles.com]: )" APP_DOMAIN
APP_DOMAIN=${APP_DOMAIN:-"app.example.com"}

# Puerto
read -p "$(echo -e ${GREEN}🔌 Puerto de la app ${NC}[default: 3000]: )" APP_PORT
APP_PORT=${APP_PORT:-"3000"}

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🖥️  CONFIGURACIÓN DEL SERVIDOR${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Servidor SSH
read -p "$(echo -e ${GREEN}🖥️  Host del servidor ${NC}[ej: root@myserver.com]: )" SERVER_HOST
SERVER_HOST=${SERVER_HOST:-"root@your-server.com"}

# Contraseña SSH (opcional, se puede usar keys)
echo -e "${YELLOW}⚠️  La contraseña se guardará en .env.local (ignorado por git)${NC}"
read -s -p "$(echo -e ${GREEN}🔐 Contraseña SSH ${NC}[Enter para usar SSH keys]: )" SSH_PASSWORD
echo ""

# Path en servidor
read -p "$(echo -e ${GREEN}📁 Path en servidor ${NC}[default: /opt/apps/${APP_NAME_SLUG}]: )" SERVER_PATH
SERVER_PATH=${SERVER_PATH:-"/opt/apps/${APP_NAME_SLUG}"}

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔑 CREDENCIALES DE SHOPIFY${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}ℹ️  Obtén estas credenciales en partners.shopify.com > Apps > Tu App${NC}"
echo ""

read -p "$(echo -e ${GREEN}🆔 Client ID ${NC}: )" SHOPIFY_CLIENT_ID
read -s -p "$(echo -e ${GREEN}🔒 Client Secret ${NC}: )" SHOPIFY_CLIENT_SECRET
echo ""

# Tienda de desarrollo
read -p "$(echo -e ${GREEN}🏪 Tienda de desarrollo ${NC}[ej: my-store.myshopify.com]: )" DEV_STORE
DEV_STORE=${DEV_STORE:-"your-store.myshopify.com"}

# Scopes
echo ""
echo -e "${BLUE}Scopes disponibles comunes:${NC}"
echo "  - read_products, write_products"
echo "  - read_customers, write_customers"
echo "  - read_orders, write_orders"
echo "  - read_discounts, write_discounts"
echo ""
read -p "$(echo -e ${GREEN}📋 Scopes ${NC}[default: read_products,write_products]: )" SHOPIFY_SCOPES
SHOPIFY_SCOPES=${SHOPIFY_SCOPES:-"read_products,write_products"}

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🎯 FUNCIONALIDAD DE LA APP${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}Describe qué hará tu app (puedes ser detallado):${NC}"
echo -e "${BLUE}Ejemplo: 'App que muestra productos relacionados basados en compras anteriores'${NC}"
echo ""
read -p "$(echo -e ${GREEN}📝 Descripción: ${NC})" APP_DESCRIPTION
APP_DESCRIPTION=${APP_DESCRIPTION:-"Una app de Shopify"}

echo ""
echo -e "${BLUE}¿Qué tipo de extensiones necesitas?${NC}"
echo "  1) Solo Admin (interfaz en admin de Shopify)"
echo "  2) Admin + Checkout Extension"
echo "  3) Admin + POS Extension"
echo "  4) Admin + Shopify Function (descuentos, envío, etc)"
echo "  5) Todo lo anterior"
echo "  6) Solo Admin (empezar simple)"
echo ""
read -p "$(echo -e ${GREEN}Selecciona ${NC}[1-6, default: 6]: )" EXTENSION_TYPE
EXTENSION_TYPE=${EXTENSION_TYPE:-"6"}

# =============================================================================
# CONFIRMAR CONFIGURACIÓN
# =============================================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📋 RESUMEN DE CONFIGURACIÓN${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BLUE}App:${NC}"
echo -e "    Nombre:      ${GREEN}${APP_NAME}${NC}"
echo -e "    Slug:        ${GREEN}${APP_NAME_SLUG}${NC}"
echo -e "    Dominio:     ${GREEN}https://${APP_DOMAIN}${NC}"
echo -e "    Puerto:      ${GREEN}${APP_PORT}${NC}"
echo ""
echo -e "  ${BLUE}Servidor:${NC}"
echo -e "    Host:        ${GREEN}${SERVER_HOST}${NC}"
echo -e "    Path:        ${GREEN}${SERVER_PATH}${NC}"
echo ""
echo -e "  ${BLUE}Shopify:${NC}"
echo -e "    Client ID:   ${GREEN}${SHOPIFY_CLIENT_ID:0:10}...${NC}"
echo -e "    Tienda Dev:  ${GREEN}${DEV_STORE}${NC}"
echo -e "    Scopes:      ${GREEN}${SHOPIFY_SCOPES}${NC}"
echo ""
echo -e "  ${BLUE}Descripción:${NC}"
echo -e "    ${GREEN}${APP_DESCRIPTION}${NC}"
echo ""

read -p "$(echo -e ${YELLOW}¿Continuar con esta configuración? ${NC}[Y/n]: )" CONFIRM
CONFIRM=${CONFIRM:-"Y"}

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Cancelado${NC}"
    exit 1
fi

# =============================================================================
# CREAR ESTRUCTURA DE ARCHIVOS
# =============================================================================

echo ""
echo -e "${BLUE}🔨 Creando estructura del proyecto...${NC}"

# Limpiar archivos del starter (manteniendo git)
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name 'init.sh' -exec rm -rf {} \; 2>/dev/null || true

# Crear directorios
mkdir -p app/routes
mkdir -p prisma/migrations
mkdir -p extensions
mkdir -p public
mkdir -p scripts
mkdir -p docs
mkdir -p .vscode

echo -e "${GREEN}✓ Directorios creados${NC}"

# =============================================================================
# CREAR ARCHIVOS DE CONFIGURACIÓN
# =============================================================================

# .env
cat > .env << EOF
# Shopify App Configuration
SHOPIFY_API_KEY=${SHOPIFY_CLIENT_ID}
SHOPIFY_API_SECRET=${SHOPIFY_CLIENT_SECRET}
SCOPES=${SHOPIFY_SCOPES}

# App Configuration
HOST=https://${APP_DOMAIN}
PORT=${APP_PORT}
NODE_ENV=development

# Database
DATABASE_URL="file:./dev.sqlite"
EOF

echo -e "${GREEN}✓ .env creado${NC}"

# .env.local (credenciales sensibles - NO va a git)
cat > .env.local << EOF
# ⚠️ ESTE ARCHIVO NO DEBE IR A GIT
# Credenciales del servidor
SERVER_HOST=${SERVER_HOST}
SERVER_PATH=${SERVER_PATH}
SSH_PASSWORD=${SSH_PASSWORD}
EOF

echo -e "${GREEN}✓ .env.local creado (ignorado por git)${NC}"

# .env.example
cat > .env.example << EOF
# Shopify App Configuration
SHOPIFY_API_KEY=your_client_id
SHOPIFY_API_SECRET=your_client_secret
SCOPES=read_products,write_products

# App Configuration
HOST=https://your-app-domain.com
PORT=3000
NODE_ENV=development

# Database
DATABASE_URL="file:./dev.sqlite"
EOF

echo -e "${GREEN}✓ .env.example creado${NC}"

# .gitignore
cat > .gitignore << EOF
node_modules
.DS_Store

# Build
/.cache
/build
/app/build
/public/build/

# Database
/prisma/dev.sqlite
/prisma/dev.sqlite-journal
database.sqlite

# Environment
.env
.env.local
.env.production

# Deploy artifacts
*.tar.gz
deploy.tar.gz

# Extensions dist
/extensions/*/dist

# Shopify
.shopify/*
.shopify.lock

# Secrets
*-credentials.json
secrets.json
EOF

echo -e "${GREEN}✓ .gitignore creado${NC}"

# package.json
cat > package.json << EOF
{
  "name": "${APP_NAME_SLUG}",
  "version": "1.0.0",
  "description": "${APP_DESCRIPTION}",
  "private": true,
  "type": "module",
  "scripts": {
    "build": "remix vite:build",
    "dev": "shopify app dev",
    "start": "remix-serve ./build/server/index.js",
    "lint": "eslint --ignore-path .gitignore --cache --cache-location ./node_modules/.cache/eslint .",
    "typecheck": "tsc",
    "deploy": "./scripts/deploy.sh",
    "setup": "npm install && npx prisma generate"
  },
  "dependencies": {
    "@prisma/client": "^5.11.0",
    "@remix-run/node": "^2.9.2",
    "@remix-run/react": "^2.9.2",
    "@remix-run/serve": "^2.9.2",
    "@shopify/app-bridge-react": "^4.1.2",
    "@shopify/polaris": "^12.0.0",
    "@shopify/shopify-app-remix": "^3.0.0",
    "@shopify/shopify-app-session-storage-prisma": "^5.0.0",
    "isbot": "^5.1.6",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@remix-run/dev": "^2.9.2",
    "@shopify/api-codegen-preset": "^1.0.1",
    "@types/react": "^18.2.20",
    "@types/react-dom": "^18.2.7",
    "eslint": "^8.57.0",
    "prettier": "^3.2.5",
    "prisma": "^5.11.0",
    "typescript": "^5.4.5",
    "vite": "^5.2.11",
    "vite-tsconfig-paths": "^4.3.2"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF

echo -e "${GREEN}✓ package.json creado${NC}"

# shopify.app.toml
cat > shopify.app.toml << EOF
# Shopify App Configuration
# Learn more: https://shopify.dev/docs/apps/tools/cli/configuration

name = "${APP_NAME}"
client_id = "${SHOPIFY_CLIENT_ID}"
application_url = "https://${APP_DOMAIN}"
dev_store_url = "${DEV_STORE}"

[build]
automatically_update_urls_on_dev = true
include_config_on_deploy = true

[auth]
redirect_urls = [
  "https://${APP_DOMAIN}/auth/callback",
  "https://${APP_DOMAIN}/auth/shopify/callback",
  "https://${APP_DOMAIN}/api/auth/callback"
]

[webhooks]
api_version = "2025-01"

[access_scopes]
scopes = "${SHOPIFY_SCOPES}"
EOF

echo -e "${GREEN}✓ shopify.app.toml creado${NC}"

# shopify.web.toml
cat > shopify.web.toml << EOF
[commands]
dev = "npm exec remix vite:dev"
build = "npm run build"

[webhooks]
api_version = "2025-01"
EOF

echo -e "${GREEN}✓ shopify.web.toml creado${NC}"

# tsconfig.json
cat > tsconfig.json << EOF
{
  "include": ["env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules", "build", "extensions"],
  "compilerOptions": {
    "lib": ["DOM", "DOM.Iterable", "ES2022"],
    "types": ["@shopify/app-bridge-types", "node"],
    "isolatedModules": true,
    "esModuleInterop": true,
    "jsx": "react-jsx",
    "module": "ES2022",
    "moduleResolution": "bundler",
    "target": "ES2022",
    "resolveJsonModule": true,
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "paths": {
      "~/*": ["./app/*"]
    }
  }
}
EOF

echo -e "${GREEN}✓ tsconfig.json creado${NC}"

# vite.config.ts
cat > vite.config.ts << EOF
import { vitePlugin as remix } from "@remix-run/dev";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

declare module "@remix-run/node" {
  interface Future {
    v3_singleFetch: true;
  }
}

export default defineConfig({
  plugins: [
    remix({
      future: {
        v3_fetcherPersist: true,
        v3_relativeSplatPath: true,
        v3_throwAbortReason: true,
        v3_singleFetch: true,
        v3_lazyRouteDiscovery: true,
      },
    }),
    tsconfigPaths(),
  ],
  server: {
    port: Number(process.env.PORT) || 3000,
    host: true,
  },
});
EOF

echo -e "${GREEN}✓ vite.config.ts creado${NC}"

# env.d.ts
cat > env.d.ts << EOF
/// <reference types="vite/client" />
/// <reference types="@remix-run/node" />
EOF

echo -e "${GREEN}✓ env.d.ts creado${NC}"

# =============================================================================
# CREAR ARCHIVOS DE LA APP
# =============================================================================

# app/shopify.server.ts
cat > app/shopify.server.ts << EOF
import "@shopify/shopify-app-remix/adapters/node";
import {
  ApiVersion,
  AppDistribution,
  shopifyApp,
} from "@shopify/shopify-app-remix/server";
import { PrismaSessionStorage } from "@shopify/shopify-app-session-storage-prisma";
import prisma from "./db.server";

const shopify = shopifyApp({
  apiKey: process.env.SHOPIFY_API_KEY!,
  apiSecretKey: process.env.SHOPIFY_API_SECRET || "",
  apiVersion: ApiVersion.January25,
  scopes: process.env.SCOPES?.split(",") || [],
  appUrl: process.env.HOST || "",
  authPathPrefix: "/auth",
  sessionStorage: new PrismaSessionStorage(prisma),
  distribution: AppDistribution.AppStore,
  future: {
    unstable_newEmbeddedAuthStrategy: true,
    wrapWithRecoveryLayout: true,
  },
  ...(process.env.SHOP_CUSTOM_DOMAIN
    ? { customShopDomains: [process.env.SHOP_CUSTOM_DOMAIN] }
    : {}),
});

export default shopify;
export const apiVersion = ApiVersion.January25;
export const addDocumentResponseHeaders = shopify.addDocumentResponseHeaders;
export const authenticate = shopify.authenticate;
export const unauthenticated = shopify.unauthenticated;
export const login = shopify.login;
export const registerWebhooks = shopify.registerWebhooks;
export const sessionStorage = shopify.sessionStorage;
EOF

echo -e "${GREEN}✓ app/shopify.server.ts creado${NC}"

# app/db.server.ts
cat > app/db.server.ts << EOF
import { PrismaClient } from "@prisma/client";

declare global {
  var prisma: PrismaClient;
}

const prisma: PrismaClient = globalThis.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== "production") {
  globalThis.prisma = prisma;
}

export default prisma;
EOF

echo -e "${GREEN}✓ app/db.server.ts creado${NC}"

# app/root.tsx
cat > app/root.tsx << EOF
import { Links, Meta, Outlet, Scripts, ScrollRestoration } from "@remix-run/react";

export default function App() {
  return (
    <html>
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <link rel="preconnect" href="https://cdn.shopify.com/" />
        <link
          rel="stylesheet"
          href="https://cdn.shopify.com/static/fonts/inter/v4/styles.css"
        />
        <Meta />
        <Links />
      </head>
      <body>
        <Outlet />
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  );
}
EOF

echo -e "${GREEN}✓ app/root.tsx creado${NC}"

# app/entry.server.tsx
cat > app/entry.server.tsx << EOF
import { PassThrough } from "stream";
import { renderToPipeableStream } from "react-dom/server";
import { RemixServer } from "@remix-run/react";
import { createReadableStreamFromReadable, type EntryContext } from "@remix-run/node";
import { isbot } from "isbot";
import { addDocumentResponseHeaders } from "./shopify.server";

const ABORT_DELAY = 5000;

export default async function handleRequest(
  request: Request,
  responseStatusCode: number,
  responseHeaders: Headers,
  remixContext: EntryContext
) {
  addDocumentResponseHeaders(request, responseHeaders);
  const userAgent = request.headers.get("user-agent");
  const callbackName = isbot(userAgent ?? "") ? "onAllReady" : "onShellReady";

  return new Promise((resolve, reject) => {
    const { pipe, abort } = renderToPipeableStream(
      <RemixServer context={remixContext} url={request.url} abortDelay={ABORT_DELAY} />,
      {
        [callbackName]: () => {
          const body = new PassThrough();
          const stream = createReadableStreamFromReadable(body);
          responseHeaders.set("Content-Type", "text/html");
          resolve(
            new Response(stream, {
              headers: responseHeaders,
              status: responseStatusCode,
            })
          );
          pipe(body);
        },
        onShellError(error) {
          reject(error);
        },
        onError(error) {
          responseStatusCode = 500;
          console.error(error);
        },
      }
    );
    setTimeout(abort, ABORT_DELAY);
  });
}
EOF

echo -e "${GREEN}✓ app/entry.server.tsx creado${NC}"

# app/routes.ts
cat > app/routes.ts << EOF
import { type RouteConfig } from "@remix-run/route-config";
import { flatRoutes } from "@remix-run/fs-routes";

export default flatRoutes() satisfies RouteConfig;
EOF

echo -e "${GREEN}✓ app/routes.ts creado${NC}"

# app/globals.d.ts
cat > app/globals.d.ts << EOF
declare module "*.css";
EOF

echo -e "${GREEN}✓ app/globals.d.ts creado${NC}"

# app/routes/app.tsx
cat > app/routes/app.tsx << EOF
import type { HeadersFunction, LoaderFunctionArgs } from "@remix-run/node";
import { Link, Outlet, useLoaderData, useRouteError } from "@remix-run/react";
import { boundary } from "@shopify/shopify-app-remix/server";
import { AppProvider } from "@shopify/shopify-app-remix/react";
import { NavMenu } from "@shopify/app-bridge-react";
import polarisStyles from "@shopify/polaris/build/esm/styles.css?url";
import { authenticate } from "../shopify.server";

export const links = () => [{ rel: "stylesheet", href: polarisStyles }];

export const loader = async ({ request }: LoaderFunctionArgs) => {
  await authenticate.admin(request);
  return { apiKey: process.env.SHOPIFY_API_KEY || "" };
};

export default function App() {
  const { apiKey } = useLoaderData<typeof loader>();

  return (
    <AppProvider isEmbeddedApp apiKey={apiKey}>
      <NavMenu>
        <Link to="/app" rel="home">Inicio</Link>
        <Link to="/app/settings">Configuración</Link>
      </NavMenu>
      <Outlet />
    </AppProvider>
  );
}

export function ErrorBoundary() {
  return boundary.error(useRouteError());
}

export const headers: HeadersFunction = (headersArgs) => {
  return boundary.headers(headersArgs);
};
EOF

echo -e "${GREEN}✓ app/routes/app.tsx creado${NC}"

# app/routes/app._index.tsx - Página principal
cat > app/routes/app._index.tsx << EOF
import type { LoaderFunctionArgs } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import {
  Page,
  Layout,
  Card,
  BlockStack,
  Text,
  Banner,
  List,
} from "@shopify/polaris";
import { TitleBar } from "@shopify/app-bridge-react";
import { authenticate } from "../shopify.server";

export const loader = async ({ request }: LoaderFunctionArgs) => {
  const { session } = await authenticate.admin(request);
  
  return {
    shop: session.shop,
  };
};

export default function Index() {
  const { shop } = useLoaderData<typeof loader>();

  return (
    <Page>
      <TitleBar title="${APP_NAME}" />
      <BlockStack gap="500">
        <Layout>
          <Layout.Section>
            <Card>
              <BlockStack gap="400">
                <Text as="h2" variant="headingMd">
                  Bienvenido a ${APP_NAME} 🎉
                </Text>
                <Text as="p" variant="bodyMd">
                  ${APP_DESCRIPTION}
                </Text>
                <Banner tone="info">
                  <Text as="p">
                    Conectado a: <strong>{shop}</strong>
                  </Text>
                </Banner>
              </BlockStack>
            </Card>
          </Layout.Section>

          <Layout.Section variant="oneThird">
            <Card>
              <BlockStack gap="200">
                <Text as="h2" variant="headingMd">
                  Próximos pasos
                </Text>
                <List>
                  <List.Item>Configura tu app en Configuración</List.Item>
                  <List.Item>Revisa la documentación de Shopify</List.Item>
                  <List.Item>Desarrolla tu funcionalidad</List.Item>
                </List>
              </BlockStack>
            </Card>
          </Layout.Section>
        </Layout>
      </BlockStack>
    </Page>
  );
}
EOF

echo -e "${GREEN}✓ app/routes/app._index.tsx creado${NC}"

# app/routes/app.settings.tsx
cat > app/routes/app.settings.tsx << EOF
import type { LoaderFunctionArgs } from "@remix-run/node";
import {
  Page,
  Layout,
  Card,
  BlockStack,
  Text,
  FormLayout,
  TextField,
  Button,
} from "@shopify/polaris";
import { TitleBar } from "@shopify/app-bridge-react";
import { authenticate } from "../shopify.server";

export const loader = async ({ request }: LoaderFunctionArgs) => {
  await authenticate.admin(request);
  return null;
};

export default function Settings() {
  return (
    <Page>
      <TitleBar title="Configuración" />
      <Layout>
        <Layout.Section>
          <Card>
            <BlockStack gap="400">
              <Text as="h2" variant="headingMd">
                Configuración de la App
              </Text>
              <FormLayout>
                <TextField
                  label="Configuración ejemplo"
                  autoComplete="off"
                  helpText="Añade tu configuración aquí"
                />
                <Button variant="primary">Guardar</Button>
              </FormLayout>
            </BlockStack>
          </Card>
        </Layout.Section>
      </Layout>
    </Page>
  );
}
EOF

echo -e "${GREEN}✓ app/routes/app.settings.tsx creado${NC}"

# app/routes/auth.$.tsx
cat > app/routes/auth.\$.tsx << EOF
import type { LoaderFunctionArgs } from "@remix-run/node";
import { authenticate } from "../shopify.server";

export const loader = async ({ request }: LoaderFunctionArgs) => {
  await authenticate.admin(request);
  return null;
};
EOF

echo -e "${GREEN}✓ app/routes/auth.$.tsx creado${NC}"

# app/routes/auth.login/route.tsx
mkdir -p app/routes/auth.login
cat > app/routes/auth.login/route.tsx << EOF
import type { ActionFunctionArgs, LoaderFunctionArgs } from "@remix-run/node";
import { Form, useLoaderData } from "@remix-run/react";
import {
  AppProvider,
  BlockStack,
  Button,
  Card,
  FormLayout,
  Page,
  Text,
  TextField,
} from "@shopify/polaris";
import polarisStyles from "@shopify/polaris/build/esm/styles.css?url";
import { login } from "../../shopify.server";
import { loginErrorMessage } from "./error.server";

export const links = () => [{ rel: "stylesheet", href: polarisStyles }];

export const loader = async ({ request }: LoaderFunctionArgs) => {
  const errors = loginErrorMessage(await login(request));
  return { errors, polarisTranslations: require("@shopify/polaris/locales/en.json") };
};

export const action = async ({ request }: ActionFunctionArgs) => {
  const errors = loginErrorMessage(await login(request));
  return { errors };
};

export default function Auth() {
  const { errors, polarisTranslations } = useLoaderData<typeof loader>();

  return (
    <AppProvider i18n={polarisTranslations}>
      <Page>
        <Card>
          <Form method="post">
            <FormLayout>
              <Text variant="headingMd" as="h2">Log in</Text>
              <TextField
                type="text"
                name="shop"
                label="Shop domain"
                helpText="example.myshopify.com"
                autoComplete="on"
                error={errors?.shop}
              />
              <Button submit>Log in</Button>
            </FormLayout>
          </Form>
        </Card>
      </Page>
    </AppProvider>
  );
}
EOF

cat > app/routes/auth.login/error.server.tsx << EOF
import { LoginErrorType, type LoginError } from "@shopify/shopify-app-remix/server";

export function loginErrorMessage(loginErrors: LoginError) {
  if (loginErrors?.shop === LoginErrorType.MissingShop) {
    return { shop: "Please enter your shop domain to log in" };
  } else if (loginErrors?.shop === LoginErrorType.InvalidShop) {
    return { shop: "Please enter a valid shop domain to log in" };
  }
  return null;
}
EOF

echo -e "${GREEN}✓ app/routes/auth.login creado${NC}"

# Webhooks
cat > app/routes/webhooks.app.uninstalled.tsx << EOF
import type { ActionFunctionArgs } from "@remix-run/node";
import { authenticate } from "../shopify.server";
import db from "../db.server";

export const action = async ({ request }: ActionFunctionArgs) => {
  const { shop, session, topic } = await authenticate.webhook(request);
  console.log(\`Received \${topic} webhook for \${shop}\`);

  if (session) {
    await db.session.deleteMany({ where: { shop } });
  }

  return new Response();
};
EOF

cat > app/routes/webhooks.app.scopes_update.tsx << EOF
import type { ActionFunctionArgs } from "@remix-run/node";
import { authenticate } from "../shopify.server";

export const action = async ({ request }: ActionFunctionArgs) => {
  const { topic, shop } = await authenticate.webhook(request);
  console.log(\`Received \${topic} webhook for \${shop}\`);
  return new Response();
};
EOF

echo -e "${GREEN}✓ Webhooks creados${NC}"

# Index route
mkdir -p app/routes/_index
cat > app/routes/_index/route.tsx << EOF
import type { LoaderFunctionArgs } from "@remix-run/node";
import { redirect } from "@remix-run/node";
import { login } from "../../shopify.server";

export const loader = async ({ request }: LoaderFunctionArgs) => {
  const url = new URL(request.url);
  if (url.searchParams.get("shop")) {
    throw redirect(\`/app?shop=\${url.searchParams.get("shop")}\`);
  }
  return login(request);
};
EOF

echo -e "${GREEN}✓ app/routes/_index creado${NC}"

# =============================================================================
# PRISMA
# =============================================================================

cat > prisma/schema.prisma << EOF
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

model Session {
  id            String    @id
  shop          String
  state         String
  isOnline      Boolean   @default(false)
  scope         String?
  expires       DateTime?
  accessToken   String
  userId        BigInt?
  firstName     String?
  lastName      String?
  email         String?
  accountOwner  Boolean   @default(false)
  locale        String?
  collaborator  Boolean?  @default(false)
  emailVerified Boolean?  @default(false)
}

// Añade tus modelos aquí
// model AppConfig {
//   id        String   @id @default(cuid())
//   shop      String   @unique
//   setting1  String?
//   createdAt DateTime @default(now())
//   updatedAt DateTime @updatedAt
// }
EOF

echo -e "${GREEN}✓ prisma/schema.prisma creado${NC}"

# =============================================================================
# SCRIPTS DE DEPLOY
# =============================================================================

cat > scripts/deploy.sh << 'DEPLOY_SCRIPT'
#!/bin/bash
# Deploy script - Carga configuración desde .env.local

set -e

# Cargar variables de .env.local
if [ -f .env.local ]; then
    export $(cat .env.local | grep -v '^#' | xargs)
fi

SERVER=${SERVER_HOST:-"user@your-server.com"}
REMOTE_DIR=${SERVER_PATH:-"/opt/apps/my-app"}
APP_NAME=$(basename "$REMOTE_DIR")

echo "🚀 Deploying to $SERVER:$REMOTE_DIR..."

# Build
echo "📦 Building..."
npm run build

# Create package
echo "📦 Packaging..."
tar -czf deploy.tar.gz build prisma package.json package-lock.json

# Upload
echo "📤 Uploading..."
if [ -n "$SSH_PASSWORD" ]; then
    sshpass -p "$SSH_PASSWORD" scp deploy.tar.gz "$SERVER:/tmp/"
    sshpass -p "$SSH_PASSWORD" ssh "$SERVER" "
        mkdir -p $REMOTE_DIR &&
        cd $REMOTE_DIR &&
        tar -xzf /tmp/deploy.tar.gz &&
        npm install --production &&
        npx prisma generate &&
        pm2 restart $APP_NAME 2>/dev/null || pm2 start npm --name $APP_NAME -- start
    "
else
    scp deploy.tar.gz "$SERVER:/tmp/"
    ssh "$SERVER" "
        mkdir -p $REMOTE_DIR &&
        cd $REMOTE_DIR &&
        tar -xzf /tmp/deploy.tar.gz &&
        npm install --production &&
        npx prisma generate &&
        pm2 restart $APP_NAME 2>/dev/null || pm2 start npm --name $APP_NAME -- start
    "
fi

# Cleanup
rm deploy.tar.gz

echo "✅ Deploy complete!"
echo "   App running at: https://$(grep HOST .env | cut -d'=' -f2 | sed 's|https://||')"
DEPLOY_SCRIPT

chmod +x scripts/deploy.sh
echo -e "${GREEN}✓ scripts/deploy.sh creado${NC}"

# Setup server script
cat > scripts/setup-server.sh << 'SETUP_SCRIPT'
#!/bin/bash
# Configura el servidor con Nginx y SSL

set -e

if [ -f .env.local ]; then
    export $(cat .env.local | grep -v '^#' | xargs)
fi
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

SERVER=${SERVER_HOST:-"user@your-server.com"}
DOMAIN=$(echo $HOST | sed 's|https://||')
PORT=${PORT:-3000}

echo "🔧 Configurando servidor para $DOMAIN..."

# Crear configuración Nginx
NGINX_CONFIG="
server {
    listen 443 ssl http2;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \\\$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \\\$host;
        proxy_set_header X-Real-IP \\\$remote_addr;
        proxy_set_header X-Forwarded-For \\\$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \\\$scheme;
        proxy_cache_bypass \\\$http_upgrade;
    }
}

server {
    listen 80;
    server_name $DOMAIN;
    return 301 https://\\\$server_name\\\$request_uri;
}
"

echo "$NGINX_CONFIG"
echo ""
echo "📝 Guarda esta configuración en /etc/nginx/sites-available/$DOMAIN"
echo "   y ejecuta: sudo certbot --nginx -d $DOMAIN"
SETUP_SCRIPT

chmod +x scripts/setup-server.sh
echo -e "${GREEN}✓ scripts/setup-server.sh creado${NC}"

# =============================================================================
# DOCUMENTACIÓN
# =============================================================================

cat > docs/DEVELOPMENT.md << EOF
# Guía de Desarrollo

## Estructura de Archivos

\`\`\`
app/
├── routes/
│   ├── app.tsx           # Layout principal (NavMenu)
│   ├── app._index.tsx    # Página de inicio
│   ├── app.settings.tsx  # Configuración
│   ├── auth.$.tsx        # Auth handler
│   └── webhooks.*.tsx    # Webhooks
├── shopify.server.ts     # Configuración Shopify
└── db.server.ts          # Cliente Prisma
\`\`\`

## Añadir una Nueva Página

1. Crear archivo en \`app/routes/app.nueva-pagina.tsx\`
2. Añadir al NavMenu en \`app/routes/app.tsx\`

\`\`\`tsx
// app/routes/app.mi-pagina.tsx
import { Page, Card, Text } from "@shopify/polaris";
import { TitleBar } from "@shopify/app-bridge-react";

export default function MiPagina() {
  return (
    <Page>
      <TitleBar title="Mi Página" />
      <Card>
        <Text as="p">Contenido</Text>
      </Card>
    </Page>
  );
}
\`\`\`

## Usar GraphQL API de Shopify

\`\`\`tsx
import { authenticate } from "../shopify.server";

export const loader = async ({ request }) => {
  const { admin } = await authenticate.admin(request);
  
  const response = await admin.graphql(\`
    query {
      products(first: 10) {
        nodes {
          id
          title
        }
      }
    }
  \`);
  
  const { data } = await response.json();
  return { products: data.products.nodes };
};
\`\`\`

## Base de Datos

1. Editar \`prisma/schema.prisma\`
2. Ejecutar migración:
   \`\`\`bash
   npx prisma migrate dev --name nombre_cambio
   \`\`\`
3. Usar en el código:
   \`\`\`tsx
   import db from "../db.server";
   const items = await db.myModel.findMany();
   \`\`\`
EOF

cat > docs/SERVER-SETUP.md << EOF
# Configuración del Servidor

## Requisitos

- Ubuntu 20.04+ o similar
- Node.js 18+
- PM2
- Nginx
- Certbot (Let's Encrypt)

## Instalación Inicial

\`\`\`bash
# Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# PM2
npm install -g pm2

# Nginx y Certbot
sudo apt install nginx certbot python3-certbot-nginx
\`\`\`

## Configurar Nginx

1. Ejecutar \`./scripts/setup-server.sh\` para ver la configuración
2. Crear archivo de configuración
3. Obtener certificado SSL:
   \`\`\`bash
   sudo certbot --nginx -d tu-dominio.com
   \`\`\`

## Firewall

\`\`\`bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
\`\`\`

## PM2 - Comandos Útiles

\`\`\`bash
pm2 status              # Ver estado
pm2 logs app-name       # Ver logs
pm2 restart app-name    # Reiniciar
pm2 save                # Guardar configuración
pm2 startup             # Auto-inicio
\`\`\`
EOF

cat > docs/EXTENSIONS.md << EOF
# Extensiones de Shopify

## Tipos de Extensiones

### 1. Admin UI Extension
Para añadir UI en el admin de Shopify.

### 2. Checkout UI Extension
Para personalizar el checkout.

\`\`\`bash
shopify app generate extension --type checkout_ui
\`\`\`

### 3. POS UI Extension
Para el punto de venta.

\`\`\`bash
shopify app generate extension --type pos_ui
\`\`\`

### 4. Shopify Functions
Para lógica de backend (descuentos, envío, etc).

\`\`\`bash
shopify app generate extension --type function --function-type delivery_customization
\`\`\`

## Desplegar Extensiones

\`\`\`bash
shopify app deploy --force
\`\`\`
EOF

cat > docs/TROUBLESHOOTING.md << EOF
# Troubleshooting

## Error: "App can't be installed"

**Causa:** Método de distribución no configurado
**Solución:** En Partners > App > Distribution, seleccionar método

## Error: Backend no responde

\`\`\`bash
# Verificar proceso
pm2 status

# Ver logs
pm2 logs app-name --lines 50

# Reiniciar
pm2 restart app-name
\`\`\`

## Error: SSL/HTTPS

\`\`\`bash
# Renovar certificado
sudo certbot renew

# Verificar Nginx
sudo nginx -t
sudo systemctl reload nginx
\`\`\`

## Error: Database

\`\`\`bash
# Regenerar cliente Prisma
npx prisma generate

# Aplicar migraciones
npx prisma migrate deploy
\`\`\`

## Error: Scopes insuficientes

Actualizar scopes en \`shopify.app.toml\` y re-instalar la app.
EOF

echo -e "${GREEN}✓ Documentación creada${NC}"

# =============================================================================
# VS CODE
# =============================================================================

cat > .vscode/extensions.json << EOF
{
  "recommendations": [
    "shopify.ruby-extensions-pack",
    "prisma.prisma",
    "esbenp.prettier-vscode"
  ]
}
EOF

cat > .vscode/settings.json << EOF
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "typescript.preferences.importModuleSpecifier": "relative"
}
EOF

echo -e "${GREEN}✓ Configuración VS Code creada${NC}"

# =============================================================================
# FINALIZAR
# =============================================================================

echo ""
echo -e "${BLUE}📦 Instalando dependencias...${NC}"
npm install

echo ""
echo -e "${BLUE}🗄️  Generando cliente Prisma...${NC}"
npx prisma generate

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ ¡APP CREADA EXITOSAMENTE!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Próximos pasos:${NC}"
echo ""
echo -e "  1. ${BLUE}Desarrollo local:${NC}"
echo -e "     npm run dev"
echo ""
echo -e "  2. ${BLUE}Deploy:${NC}"
echo -e "     npm run deploy"
echo ""
echo -e "  3. ${BLUE}Configurar servidor (primera vez):${NC}"
echo -e "     ./scripts/setup-server.sh"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}  📚 Documentación en: docs/${NC}"
echo -e "${PURPLE}  🔧 Configuración en: .env${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
