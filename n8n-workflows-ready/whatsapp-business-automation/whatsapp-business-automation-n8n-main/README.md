# WhatsApp Business Query Automation using n8n

This project automates WhatsApp Business customer support using **n8n**, **Meta WhatsApp Cloud API**, **Webhooks**, and **Google Sheets**.

The workflow receives customer messages from WhatsApp, classifies the query, sends automated replies, stores lead details in Google Sheets, and escalates unknown queries to a human support team.

---

## Project Overview

Many small businesses receive repetitive WhatsApp queries such as pricing, timings, location, service details, and contact information. This project solves that problem by creating an automated WhatsApp support workflow.

### Workflow

```text
Customer WhatsApp Message
        ↓
Meta WhatsApp Cloud API Webhook
        ↓
n8n Webhook Node
        ↓
Extract Customer Message
        ↓
Classify Query
        ↓
Send Automated WhatsApp Reply
        ↓
Save Lead in Google Sheets
        ↓
Escalate Unknown Queries to Human Support
```

---

## Features

- WhatsApp Business Cloud API integration
- n8n webhook automation
- Automated FAQ replies
- Customer lead capture
- Google Sheets CRM integration
- Human escalation workflow
- JavaScript-based query classification
- Portfolio-ready business automation project

---

## Tech Stack

- n8n
- Meta WhatsApp Cloud API
- Google Sheets
- JavaScript Code Node
- HTTP Request Node
- Webhooks
- Email escalation

---

## Sample Queries Supported

Customers can send messages like:

```text
Hi
Course details
Pricing
Timings
Location
Contact
Human support
```

---

## Repository Structure

```text
whatsapp-business-automation-n8n/
│
├── README.md
├── .gitignore
├── .env.example
│
├── workflow/
│   └── whatsapp_business_automation_workflow.json
│
├── docs/
│   ├── setup_steps.md
│   ├── architecture.md
│   ├── testing_guide.md
│   ├── code_nodes.md
│   └── resume_linkedin.md
│
├── sample-data/
│   └── sample_leads.csv
│
└── assets/
    └── add_your_screenshots_here.txt
```

---

## Important Security Note

Do not upload your real access tokens, API keys, Google credentials, or private phone numbers to GitHub.

Use `.env.example` only as a reference.

---

## Future Enhancements

- Add AI-based intent detection using OpenAI/Gemini/Groq
- Add multilingual support for English, Telugu, and Hindi
- Add CRM integration such as HubSpot or Airtable
- Add appointment booking
- Add payment link automation
- Add analytics dashboard
