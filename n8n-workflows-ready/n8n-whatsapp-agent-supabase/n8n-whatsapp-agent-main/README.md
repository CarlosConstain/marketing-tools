# 💎 Valentina — Agente IA para WhatsApp Business

Agente conversacional inteligente para joyerías, construido sobre **n8n**. Valentina atiende clientes por WhatsApp, consulta catálogo, gestiona pedidos y procesa pagos de forma autónoma, con la capacidad de transferir al equipo humano cuando es necesario.

---

## 🏗️ Arquitectura

```
Cliente WhatsApp
      │
      ▼
 Meta Cloud API (Webhook)
      │
      ▼
   n8n (self-hosted)
      │
      ├──► Supabase ──► Historial, Catálogo, Clientes, Pedidos
      ├──► Claude Haiku 4.5 ──► Respuestas inteligentes + Function Calling
      ├──► Groq Whisper ──► Transcripción de audio (speech-to-text)
      └──► Mercado Pago ──► Links de pago con descuento
```

**Flujo general:**

1. El cliente envía un mensaje (texto, imagen o audio) por WhatsApp
2. n8n recibe el webhook, consulta historial y catálogo en paralelo
3. Si hay takeover activo, el mensaje se guarda y Valentina no responde
4. Claude analiza el contexto y responde con texto o ejecuta herramientas (crear pedido, consultar estado, etc.)
5. La respuesta se envía al cliente y se persiste en Supabase

---

## ✨ Features

- 🤖 **Agente IA conversacional** — Claude Haiku 4.5 con personalidad de asesora de joyería
- 🛠️ **Function calling** — 4 herramientas: pedido Mercado Pago, pedido contra entrega, consultar pedido, transferir a admin
- 💬 **Multimodal** — Soporta texto, imágenes (vision) y audio (speech-to-text)
- 🎙️ **Transcripción de audio** — Groq Whisper (whisper-large-v3) en español
- 👁️ **Análisis de imágenes** — Describe fotos del cliente y recomienda productos similares del catálogo
- 💳 **Pagos Mercado Pago** — Links de pago con 2% de descuento automático
- 📦 **Pedidos contra entrega** — Registro con dirección, ciudad y departamento
- 📋 **Catálogo inteligente** — Búsqueda de productos con envío de imágenes
- 💍 **Guía de tallas** — 20 tallas de anillos (3 a 12.5) con medidas en mm
- 🔄 **Takeover manual** — El admin toma control de la conversación; Valentina se pausa automáticamente
- 💾 **Persistencia** — Historial completo de conversaciones en Supabase
- 📝 **Resumen automático** — Comprime conversaciones largas (>10 mensajes) para optimizar tokens
- 🔔 **Notificaciones de estado** — Avisa al cliente cuando cambia el estado de su pedido
- ⚡ **Prompt caching** — Reduce ~50% del consumo de tokens en el system prompt
- 🛡️ **Tolerancia a fallos** — Retry, timeouts y fallbacks en todos los nodos HTTP

---

## 🧰 Stack / Tecnologías

![n8n](https://img.shields.io/badge/n8n-Self--Hosted-EA4B71?style=for-the-badge&logo=n8n&logoColor=white)
![WhatsApp](https://img.shields.io/badge/WhatsApp_Business-Cloud_API-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3FCF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Claude](https://img.shields.io/badge/Claude_Haiku_4.5-Anthropic-CC785C?style=for-the-badge&logo=anthropic&logoColor=white)
![Mercado Pago](https://img.shields.io/badge/Mercado_Pago-009EE3?style=for-the-badge&logo=mercadopago&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Groq](https://img.shields.io/badge/Groq-Whisper_STT-F55036?style=for-the-badge&logoColor=white)

---

## 📋 Requisitos Previos

- **Docker** y **Docker Compose** instalados
- Cuenta de **Meta for Developers** con WhatsApp Business API configurada
- Proyecto en **Supabase** (plan gratuito funciona)
- API Key de **Anthropic** (Claude)
- API Key de **Groq** (para transcripción de audio)
- Cuenta de **Mercado Pago** con credenciales de integración
- Puerto **5678** disponible para n8n

---

## 🔐 Variables de Entorno

Configurar en `docker-compose.yml` o en n8n Settings:

```env
# WhatsApp Business API
WHATSAPP_TOKEN=
WHATSAPP_PHONE_ID=
WHATSAPP_VERIFY_TOKEN=

# Supabase
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_KEY=

# Anthropic (Claude)
CLAUDE_API_KEY=

# Groq (Speech-to-Text)
GROQ_API_KEY=

# Mercado Pago
MP_ACCESS_TOKEN=
```

---

## 🗄️ Tablas Supabase

| Tabla | Descripción |
|---|---|
| `products` | Catálogo de productos (nombre, categoría, precio, imágenes) |
| `orders` | Pedidos con datos de envío, pago y tracking |
| `customers` | Clientes registrados (teléfono, email, ciudad) |
| `whatsapp_conversaciones` | Historial de mensajes por número de teléfono |
| `chat_takeover` | Control de conversaciones tomadas por admin |

**Edge Functions:**
- `create-preference` — Crea links de pago MP y registra pedidos COD
- `mp-webhook` — Recibe notificaciones de pago de Mercado Pago

---

## 📄 Workflows

| Workflow | Función |
|---|---|
| **WhatsApp - Agente IA Joyeria - v2** | Workflow principal: recibe mensajes, procesa con IA, ejecuta herramientas, responde |
| **WhatsApp - Notificacion Estado Pedido - v1** | Notifica al cliente por WhatsApp cuando cambia el estado de su pedido |
| **WhatsApp - Respuesta Manual Admin - v1** | Permite al admin enviar mensajes manuales durante takeover |

---

## 📄 Licencia

Este proyecto está bajo la licencia [MIT](LICENSE).

---

Desarrollado con 🤍 para el sector joyero.
