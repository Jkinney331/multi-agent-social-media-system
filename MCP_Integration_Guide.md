# MCP Integration Guide
# Multi-Agent Social Media Management System

**Version:** 1.0  
**Date:** January 2024  
**Target:** Development Agency Multi-Client Environment  

---

## 🎯 Overview

This guide covers the integration of **Model Context Protocol (MCP) servers** with your n8n multi-agent social media management system. MCPs enable your agents to access external tools and services seamlessly.

## 📋 Table of Contents

1. [MCP Servers Overview](#mcp-servers-overview)
2. [Composio MCP Integration](#composio-mcp-integration)
3. [Zapier MCP Integration](#zapier-mcp-integration)
4. [Custom MCP Development](#custom-mcp-development)
5. [Security & Best Practices](#security--best-practices)
6. [Troubleshooting](#troubleshooting)

---

## 🌐 MCP Servers Overview

### What are MCPs?
Model Context Protocol servers provide standardized interfaces for AI agents to access external tools, APIs, and services. They act as middleware between your AI agents and external platforms.

### Key Benefits for Your Agency:
- **🔗 Unified Tool Access**: Single interface for multiple platforms
- **🔒 Security**: Centralized credential management
- **📊 Analytics**: Usage tracking and rate limiting
- **🚀 Scalability**: Easy to add new tools and clients
- **🛡️ Reliability**: Error handling and retry mechanisms

### Supported MCP Servers:

| MCP Server | Type | Use Cases | Monthly Quota |
|------------|------|-----------|---------------|
| **Composio** | Social Media | Platform publishing, analytics | 10,000 calls |
| **Zapier** | Automation | Productivity, integrations | 300 calls |
| **Custom** | Specialized | Client-specific tools | Unlimited |

---

## 🎨 Composio MCP Integration

### Overview
Composio provides direct integrations with major social media platforms through a unified API.

### Available Tools:
- `LINKEDIN_CREATE_LINKED_IN_POST`
- `TWITTER_CREATION_OF_A_POST`
- `REDDIT_CREATE_REDDIT_POST`
- `INSTAGRAM_CREATE_POST`
- `FACEBOOK_CREATE_PAGE_POST`
- `YOUTUBE_UPLOAD_VIDEO`
- `TIKTOK_CREATE_VIDEO_POST`

### Setup Instructions:

#### 1. Account Setup
```bash
# Install Composio CLI
npm install -g composio-core

# Login to Composio
composio login

# List available apps
composio apps
```

#### 2. n8n Configuration
```javascript
// n8n HTTP Request Node Configuration
{
  "url": "https://backend.composio.dev/api/v1/actions/LINKEDIN_CREATE_LINKED_IN_POST/execute",
  "method": "POST",
  "headers": {
    "X-API-Key": "{{ $credentials.composio.apiKey }}",
    "Content-Type": "application/json"
  },
  "body": {
    "entityId": "{{ $json.brand_id }}",
    "input": {
      "text": "{{ $json.content_text }}",
      "visibility": "PUBLIC"
    }
  }
}
```

#### 3. Platform Authentication
```javascript
// Authenticate platforms for each brand
const platforms = ['linkedin', 'twitter', 'instagram'];

for (const platform of platforms) {
  const authUrl = await composio.getAuthUrl({
    app: platform,
    entityId: brandId,
    redirectUrl: `${process.env.BASE_URL}/auth/callback`
  });
  
  // Send auth URL to client for approval
  console.log(`Authenticate ${platform}: ${authUrl}`);
}
```

#### 4. n8n Workflow Integration
```json
{
  "name": "Composio Publisher Node",
  "parameters": {
    "url": "https://backend.composio.dev/api/v1/actions/{{ $json.platform_action }}/execute",
    "method": "POST",
    "authentication": "headerAuth",
    "headerParameters": {
      "parameters": [
        {
          "name": "X-API-Key",
          "value": "{{ $credentials.composio.apiKey }}"
        }
      ]
    },
    "sendBody": true,
    "bodyParameters": {
      "parameters": [
        {
          "name": "entityId",
          "value": "{{ $json.brand_id }}"
        },
        {
          "name": "input",
          "value": "{{ JSON.stringify($json.platform_content) }}"
        }
      ]
    }
  }
}
```

### Error Handling:
```javascript
// n8n Error Handling Code
const response = $input.first().json;

if (response.error) {
  // Log error and retry with fallback
  return {
    status: 'failed',
    error: response.error,
    retry_needed: true,
    fallback_action: 'manual_posting'
  };
}

return {
  status: 'success',
  platform_post_id: response.data.id,
  post_url: response.data.url
};
```

---

## ⚡ Zapier MCP Integration

### Overview
Zapier MCP enables integration with productivity tools and internal systems.

### Available Tools:
- `google_sheets_append`
- `slack_send_message`
- `gmail_send_email`
- `calendar_create_event`
- `notion_create_page`
- `airtable_create_record`

### Setup Instructions:

#### 1. Zapier Configuration
```javascript
// n8n Zapier Integration
{
  "url": "https://hooks.zapier.com/hooks/catch/{{ $credentials.zapier.hookId }}/",
  "method": "POST",
  "body": {
    "trigger": "content_published",
    "brand_id": "{{ $json.brand_id }}",
    "client_name": "{{ $json.client_name }}",
    "content_type": "{{ $json.content_type }}",
    "platform": "{{ $json.platform }}",
    "performance_metrics": "{{ $json.engagement_data }}"
  }
}
```

#### 2. Common Zapier Workflows:

**Client Reporting:**
```javascript
// Auto-generate client reports
{
  "action": "google_sheets_append",
  "spreadsheet_id": "{{ $json.client_config.reporting_sheet }}",
  "data": {
    "date": "{{ new Date().toISOString().split('T')[0] }}",
    "brand": "{{ $json.brand_name }}",
    "content_count": "{{ $json.daily_content_count }}",
    "engagement_rate": "{{ $json.avg_engagement }}",
    "reach": "{{ $json.total_reach }}"
  }
}
```

**Slack Notifications:**
```javascript
// Alert on high-performing content
{
  "action": "slack_send_message",
  "channel": "#client-success",
  "message": "🚀 High-performing content alert!\n\nBrand: {{ $json.brand_name }}\nEngagement: {{ $json.engagement_rate }}%\nReach: {{ $json.reach }} people\n\nContent: {{ $json.content_preview }}"
}
```

---

## 🛠️ Custom MCP Development

### When to Build Custom MCPs:
- Client-specific platforms
- Proprietary tools
- Complex authentication
- Specialized analytics

### Example: Custom CRM Integration
```javascript
// custom-crm-mcp.js
import { McpServer } from '@modelcontextprotocol/sdk/server';
import { z } from 'zod';

const server = new McpServer({
  name: 'custom-crm-mcp',
  version: '1.0.0'
});

// Define tools
server.tool('crm_create_lead', {
  description: 'Create a new lead in CRM from social media engagement',
  inputSchema: z.object({
    name: z.string(),
    email: z.string().email(),
    source_platform: z.string(),
    engagement_type: z.string(),
    brand_id: z.string()
  })
}, async (input) => {
  // CRM API integration
  const lead = await crmClient.createLead({
    name: input.name,
    email: input.email,
    source: `Social Media - ${input.source_platform}`,
    tags: [input.brand_id, input.engagement_type],
    custom_fields: {
      social_engagement: true,
      original_platform: input.source_platform
    }
  });
  
  return {
    lead_id: lead.id,
    status: 'created',
    follow_up_scheduled: lead.next_action_date
  };
});

server.listen();
```

### Integration with n8n:
```json
{
  "name": "Custom CRM Tool",
  "parameters": {
    "url": "http://localhost:3001/mcp/crm_create_lead",
    "method": "POST",
    "body": {
      "name": "{{ $json.commenter_name }}",
      "email": "{{ $json.commenter_email }}",
      "source_platform": "{{ $json.platform }}",
      "engagement_type": "comment",
      "brand_id": "{{ $json.brand_id }}"
    }
  }
}
```

---

## 🔒 Security & Best Practices

### API Key Management:
```javascript
// Environment Variables (.env)
COMPOSIO_API_KEY=comp_live_xxxxxxxxxxxxxx
ZAPIER_WEBHOOK_SECRET=zap_xxxxxxxxxxxxxxx
CUSTOM_MCP_TOKEN=custom_xxxxxxxxxxxxxx

// n8n Credentials Configuration
{
  "name": "Composio API",
  "type": "httpHeaderAuth",
  "data": {
    "name": "X-API-Key",
    "value": "{{ $env.COMPOSIO_API_KEY }}"
  }
}
```

### Rate Limiting:
```javascript
// Rate limiting implementation
const rateLimiter = {
  composio: {
    maxCalls: 10000,
    timeWindow: 'monthly',
    current: 0
  },
  zapier: {
    maxCalls: 300,
    timeWindow: 'monthly',
    current: 0
  }
};

// Check before API call
if (rateLimiter[provider].current >= rateLimiter[provider].maxCalls) {
  throw new Error(`Rate limit exceeded for ${provider}`);
}
```

### Error Handling:
```javascript
// Robust error handling
const executeWithRetry = async (mcpCall, maxRetries = 3) => {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await mcpCall();
    } catch (error) {
      if (attempt === maxRetries) {
        // Log to monitoring system
        await logError({
          error: error.message,
          mcp: mcpCall.name,
          attempt: attempt,
          timestamp: new Date().toISOString()
        });
        throw error;
      }
      
      // Exponential backoff
      await new Promise(resolve => 
        setTimeout(resolve, Math.pow(2, attempt) * 1000)
      );
    }
  }
};
```

### Monitoring & Logging:
```javascript
// MCP usage tracking
const trackMcpUsage = async (mcpName, toolName, success, responseTime) => {
  await database.query(`
    INSERT INTO mcp_usage_log 
    (mcp_name, tool_name, success, response_time_ms, created_at)
    VALUES ($1, $2, $3, $4, NOW())
  `, [mcpName, toolName, success, responseTime]);
};
```

---

## 🔧 Troubleshooting

### Common Issues:

#### 1. Authentication Failures
```bash
# Check Composio auth status
composio whoami

# Refresh expired tokens
composio triggers refresh --app=linkedin

# Test connection
composio triggers test --app=linkedin --entityId=brand_123
```

#### 2. Rate Limit Errors
```javascript
// Handle rate limiting gracefully
if (error.status === 429) {
  const retryAfter = error.headers['retry-after'] || 60;
  
  return {
    status: 'rate_limited',
    retry_after: retryAfter,
    scheduled_retry: new Date(Date.now() + retryAfter * 1000)
  };
}
```

#### 3. Platform API Changes
```javascript
// Version checking
const checkApiVersion = async (platform) => {
  const response = await fetch(`https://api.${platform}.com/version`);
  const version = await response.json();
  
  if (version.deprecated) {
    await notifications.send({
      type: 'warning',
      message: `${platform} API version deprecated. Update required.`
    });
  }
};
```

### Debugging Tips:

1. **Enable Verbose Logging:**
```javascript
// n8n workflow settings
{
  "settings": {
    "saveDataErrorExecution": "all",
    "saveDataSuccessExecution": "all",
    "saveExecutionProgress": true
  }
}
```

2. **Test Individual Tools:**
```bash
# Test Composio tools individually
curl -X POST https://backend.composio.dev/api/v1/actions/LINKEDIN_CREATE_LINKED_IN_POST/execute \
  -H "X-API-Key: YOUR_API_KEY" \
  -d '{"entityId": "test", "input": {"text": "Test post"}}'
```

3. **Monitor Performance:**
```sql
-- Check MCP performance metrics
SELECT 
  mcp_name,
  AVG(response_time_ms) as avg_response_time,
  COUNT(*) as total_calls,
  SUM(CASE WHEN success THEN 1 ELSE 0 END) as successful_calls
FROM mcp_usage_log 
WHERE created_at >= NOW() - INTERVAL '24 hours'
GROUP BY mcp_name;
```

---

## 📊 Performance Optimization

### Caching Strategy:
```javascript
// Cache frequently used data
const mcpCache = {
  linkedin_profiles: new Map(),
  twitter_analytics: new Map(),
  ttl: 5 * 60 * 1000 // 5 minutes
};

const getCachedOrFetch = async (key, fetchFn) => {
  const cached = mcpCache[key];
  if (cached && Date.now() - cached.timestamp < mcpCache.ttl) {
    return cached.data;
  }
  
  const data = await fetchFn();
  mcpCache[key] = { data, timestamp: Date.now() };
  return data;
};
```

### Batch Operations:
```javascript
// Batch multiple posts to same platform
const batchPublish = async (posts, platform) => {
  const batches = chunk(posts, 5); // Process 5 at a time
  
  for (const batch of batches) {
    await Promise.all(
      batch.map(post => publishToMCP(post, platform))
    );
    
    // Rate limiting delay
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
};
```

---

## 🎯 Next Steps

1. **Set up Composio account** and authenticate first platform
2. **Configure Zapier webhooks** for client reporting
3. **Test FT News workflow** with MCP integrations
4. **Monitor performance** and optimize based on usage
5. **Develop custom MCPs** for client-specific needs

---

## 📞 Support & Resources

- **Composio Documentation:** https://docs.composio.dev
- **Zapier Platform Documentation:** https://platform.zapier.com
- **MCP Specification:** https://spec.modelcontextprotocol.io
- **n8n Community:** https://community.n8n.io

---

**Remember:** MCPs are the bridge between your AI agents and the external world. Proper configuration ensures reliable, scalable, and secure operations for all your clients. 