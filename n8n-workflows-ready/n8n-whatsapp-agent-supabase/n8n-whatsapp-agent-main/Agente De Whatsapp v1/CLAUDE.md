# CLAUDE.md — Agente WhatsApp para Joyería

> Contrato de trabajo entre el usuario y Claude para construir workflows profesionales en n8n.
> **Idioma**: Siempre en español. Toda respuesta, comentario y documentación va en español.

---

## 1. Objetivo del Proyecto

Automatizar la comunicación y operaciones del negocio de joyería mediante un agente inteligente en WhatsApp, construido sobre n8n self-hosted. El agente atenderá clientes, gestionará pedidos, consultará catálogo y coordinará con el equipo interno.

**Casos de uso principales:**
- Atención al cliente por WhatsApp (respuestas automáticas e inteligentes)
- Consulta de catálogo de productos (piezas, precios, disponibilidad)
- Gestión de pedidos y seguimiento
- Integración con Instagram para captación de leads
- Notificaciones internas al equipo de la joyería

---

## 2. Stack Tecnológico

| Componente | Detalle |
|---|---|
| **Automatización** | n8n self-hosted (local) |
| **Mensajería** | Meta WhatsApp Business API (Cloud API) |
| **Redes sociales** | Instagram Graph API |
| **Base de datos** | Supabase (PostgreSQL) |
| **IA** | Claude API (para respuestas inteligentes) |
| **OS** | Windows 11 Pro |

---

## 3. Herramientas de Claude en Este Proyecto

### MCP Server (n8n-mcp)
Permite a Claude interactuar directamente con n8n para:
- Buscar nodos disponibles
- Crear y modificar workflows
- Validar configuraciones
- Ejecutar pruebas

**Estado**: INSTALADO y CONECTADO a n8n local
- `N8N_API_URL` = http://localhost:5678
- `N8N_API_KEY` = configurada en .claude.json

### Skills de n8n disponibles
Claude tiene acceso a skills especializados que se activan automáticamente:
- `n8n-mcp-tools-expert` — Para usar herramientas MCP de n8n
- `n8n-workflow-patterns` — Patrones arquitectónicos de workflows
- `n8n-node-configuration` — Configuración correcta de nodos
- `n8n-code-javascript` — Código JavaScript en nodos Code
- `n8n-expression-syntax` — Expresiones `{{ }}` de n8n
- `n8n-validation-expert` — Interpretar y corregir errores de validación

---

## 4. Convenciones de Nomenclatura

Todos los nombres van en **español**, usando guiones bajos, sin acentos ni caracteres especiales en IDs técnicos.

### Workflows
```
[Area] - [Funcion] - [Version]
Ejemplos:
  WhatsApp - Atencion al Cliente - v1
  Catalogo - Consulta de Productos - v1
  Pedidos - Gestion y Seguimiento - v1
  Instagram - Captacion de Leads - v1
```

### Nodos
```
[Accion] [Objeto]
Ejemplos:
  Recibir Mensaje WhatsApp
  Buscar Producto en Supabase
  Enviar Respuesta al Cliente
  Guardar Pedido
  Notificar al Equipo
```

### Variables y campos
- Usar español: `nombre_cliente`, `precio_pieza`, `estado_pedido`
- Sin acentos en nombres técnicos: `numero_telefono` (no `número_teléfono`)
- Constantes en mayúsculas: `WHATSAPP_TOKEN`, `SUPABASE_URL`

---

## 5. Integraciones Prioritarias

### 5.1 Meta WhatsApp Business API
- **Tipo**: Cloud API (webhooks)
- **Webhooks**: Recibir mensajes entrantes via POST
- **Autenticación**: Token permanente de usuario del sistema
- **Capacidades**: Texto, imágenes, botones, listas interactivas, plantillas
- **Credenciales necesarias** [PENDIENTE]:
  - `WHATSAPP_TOKEN` — Token de acceso permanente
  - `WHATSAPP_PHONE_ID` — ID del número de teléfono
  - `WHATSAPP_BUSINESS_ACCOUNT_ID` — ID de la cuenta de negocio
  - `WEBHOOK_VERIFY_TOKEN` — Token de verificación del webhook

### 5.2 Instagram Graph API
- **Tipo**: REST API
- **Uso**: Recibir mensajes DM, comentarios, menciones
- **Credenciales necesarias** [PENDIENTE]:
  - `INSTAGRAM_TOKEN` — Token de acceso de página
  - `INSTAGRAM_PAGE_ID` — ID de la página de Facebook vinculada

### 5.3 Supabase
- **Tipo**: PostgreSQL + API REST
- **Uso**: Catálogo de productos, clientes, pedidos, historial de conversaciones
- **Credenciales necesarias** [PENDIENTE]:
  - `SUPABASE_URL` — URL del proyecto
  - `SUPABASE_ANON_KEY` — Clave anónima
  - `SUPABASE_SERVICE_KEY` — Clave de servicio (para operaciones admin)

---

## 6. Flujo de Trabajo con Claude

Seguimos este proceso para cada nuevo workflow o funcionalidad:

```
1. PROPONER   → Claude describe qué va a construir y cómo
2. CONFIRMAR  → Usuario aprueba o ajusta el plan
3. CREAR      → Claude construye el workflow en n8n
4. REVISAR    → Claude explica cada nodo y su función
5. PROBAR     → Se prueba con datos reales o de ejemplo
6. AJUSTAR    → Correcciones según feedback
```

**Regla importante**: Claude nunca crea workflows sin confirmación previa del usuario.

---

## 7. Credenciales y Configuración

### Variables de entorno en n8n
Configurar en n8n → Settings → Variables de entorno:

```
# WhatsApp
WHATSAPP_TOKEN=         [PENDIENTE]
WHATSAPP_PHONE_ID=      [PENDIENTE]
WHATSAPP_VERIFY_TOKEN=  [PENDIENTE]

# Instagram
INSTAGRAM_TOKEN=        [PENDIENTE]
INSTAGRAM_PAGE_ID=      [PENDIENTE]

# Supabase
SUPABASE_URL=           [PENDIENTE]
SUPABASE_ANON_KEY=      [PENDIENTE]

# Claude API
CLAUDE_API_KEY=         [PENDIENTE]
```

### Credenciales guardadas en n8n
Las credenciales sensibles se guardan en n8n → Credentials (encriptadas):
- `WhatsApp Business API` — Header auth con token
- `Supabase API` — API key + URL
- `Claude API` — API key de Anthropic

---

## 8. Contexto del Negocio de Joyería

Información relevante para que Claude tome mejores decisiones de diseño:

- **Tipo de negocio**: Joyería artesanal / venta de piezas
- **Canales de venta**: WhatsApp directo, Instagram, tienda física
- **Clientes**: Público general, parejas (anillos), regalos especiales
- **Temporadas clave**: San Valentín, Día de la Madre, Navidad, graduaciones
- **Proceso de venta**: Consulta → cotización → pedido → pago → entrega
- **Personalización**: Muchas piezas son bajo pedido (grabados, tallas)
- **Tiempo de respuesta esperado**: Menos de 5 minutos en horario laboral

### Catálogo básico (a definir en Supabase)
Categorías esperadas: Anillos, Aretes, Collares, Pulseras, Sets, Pedidos especiales

---

## 9. Reglas de Calidad

### Manejo de errores
- Todo workflow debe tener nodo de manejo de errores (`Error Trigger`)
- Los errores se notifican internamente (WhatsApp al equipo o log en Supabase)
- Mensaje amigable al cliente si algo falla: "Disculpa, hubo un problema. Te contactamos en breve."

### Documentación de workflows
- Cada workflow incluye un nodo `Sticky Note` al inicio con:
  - Propósito del workflow
  - Fecha de creación
  - Disparador (trigger)
  - Integraciones que usa

### Testing
- Probar siempre con webhook de prueba antes de activar en producción
- Usar datos de ejemplo reales del negocio (sin datos sensibles reales)
- Verificar respuestas en WhatsApp antes de marcar como completo

### Versionado
- Mantener la versión en el nombre del workflow (v1, v2...)
- Al hacer cambios grandes, crear nueva versión y desactivar la anterior

---

## 10. Próximos Pasos

- [x] Instalar n8n localmente — HECHO (corriendo en http://localhost:5678)
- [x] Instalar n8n-mcp server — HECHO (falta agregar credenciales cuando n8n corra)
- [x] Instalar n8n-skills (7 skills) — HECHO
- [ ] Configurar Meta WhatsApp Business API y obtener credenciales
- [ ] Crear proyecto en Supabase y diseñar esquema de base de datos
- [ ] Crear primer workflow: Webhook de WhatsApp → respuesta básica
- [ ] Expandir con IA (Claude) para respuestas inteligentes

---

*Última actualización: 2026-03-02*
*Proyecto: Agente De Whatsapp v1 — Joyería*
