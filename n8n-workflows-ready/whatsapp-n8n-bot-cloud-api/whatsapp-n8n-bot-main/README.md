<img width="1295" height="354" alt="Screenshot 2025-10-25 210526 (2)" src="https://github.com/user-attachments/assets/61738804-4430-4c17-b302-3b72ce1cb350" />


 
 # WhatsApp AI Bot n8n Workflow

This repository contains an **n8n workflow** for handling WhatsApp messages using the **WhatsApp Cloud API**.  
It supports **text, voice, image, and document messages**, with AI-powered responses using **OpenAI GPT models**.

---

## Features

- Receive WhatsApp messages (text, voice, image, document).    
- Convert voice messages to text.  
- Analyze images and generate descriptive context.  
- AI-powered responses using OpenAI GPT models.  
- Optional voice replies to user messages.  
- Maintain conversation context with a memory buffer.  

---

## Setup Instructions

### 1. WhatsApp Cloud API

1. Create a [Facebook Developer App](https://developers.facebook.com/).  
2. Go to **WhatsApp > Getting Started** and set up your **WhatsApp Business Account**.  
3. Obtain the following credentials:

| Credential        | Description                           |
|------------------|---------------------------------------|
| Client ID         | Your WhatsApp App Client ID           |
| Client Secret     | Your WhatsApp App Client Secret       |
| Phone Number ID   | Your WhatsApp Business Phone Number ID|
| Access Token      | Your WhatsApp Access Token            |

> **Keep credentials secure**. Do not commit them to GitHub.

---

### 2. n8n Workflow

1. Import the workflow JSON (`whatsapp-n8n-workflow.json`) into your n8n instance.  
2. Update the workflow nodes with your credentials:

| Node                         | Field                                  |
|-------------------------------|---------------------------------------|
| WhatsApp Trigger              | Webhook ID (unique)                    |
| Send Message (WhatsApp node)  | Phone Number ID                        |
| HTTP Request / Media Nodes    | Authentication → Bearer Access Token  |
| OpenAI Nodes (Text/Voice/Image) | API Key                               |

---

### 3. Environment Variables (Recommended)

```bash
WHATSAPP_CLIENT_ID=your_client_id
WHATSAPP_CLIENT_SECRET=your_client_secret
WHATSAPP_PHONE_NUMBER_ID=your_phone_number_id
WHATSAPP_ACCESS_TOKEN=your_access_token
OPENAI_API_KEY=your_openai_api_key

---
###4. Running the Bot
Start your n8n instance.

The WhatsApp Trigger node listens for incoming messages.

Messages are routed and processed by type (text, voice, image, document).

Responses (text or voice) are sent automatically.

###5. Notes
Voice messages are converted to text before AI processing.

Images are analyzed using OpenAI vision models.

Memory buffer allows context-aware responses.

Customize bot personality via the AI Response Engine node system prompt.

###6. Contributing
Fork the repository.

Make improvements or fixes.

Submit a pull request with a clear description of changes.   upto 2 lines correct in fonyts after all in one font only
