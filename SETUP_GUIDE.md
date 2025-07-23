# Multi-Agent Social Media Management System - Setup Guide

This guide provides step-by-step instructions for setting up the complete n8n-based multi-agent social media management system.

## System Overview

The system consists of 6 main n8n workflows that work together to create a sophisticated AI-powered social media management platform:

1. **Parent Social Media Manager** - Central orchestrator (ID: gkHaFgutli310owI)
2. **Brand Agent - AI Content Creator** - Individual brand agents (ID: tcTCr3hdzUpMQIzF)
3. **Agent Communication Hub** - Inter-agent communication (ID: REWHyqaOVprEJSDh)
4. **Feedback Processing Pipeline** - Content review system (ID: 3uRK3SmqT8HfMuBV)
5. **Agent Meeting Workflow** - Daily coordination meetings (ID: 3zx6WOGClqbkaS0h)
6. **Multi-Platform Publisher** - Content distribution (ID: 8TBpA3GGVCAhaUM6)

## Prerequisites

### Software Requirements
- **n8n** (self-hosted or cloud) - Version 1.0+
- **PostgreSQL** - Version 13+ with vector extension
- **Slack Workspace** - For agent communication
- **Pinecone** (optional) - For vector embeddings

### API Keys Required
- **OpenAI API Key** - For GPT-4 and embeddings
- **Slack Bot Token** - For Slack integration
- **ElevenLabs API Key** - For voice synthesis (optional)
- **HeyGen API Key** - For video generation (optional)
- **Social Media Platform APIs**:
  - Twitter API v2 (Bearer Token + OAuth)
  - LinkedIn API (OAuth)
  - Facebook/Instagram Graph API (Access Token)
  - TikTok API (OAuth)

## Step 1: Database Setup

### 1.1 Install PostgreSQL with Vector Extension

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo apt install postgresql-14-pgvector

# macOS with Homebrew
brew install postgresql
brew install pgvector

# Start PostgreSQL service
sudo systemctl start postgresql
# or on macOS
brew services start postgresql
```

### 1.2 Create Database and User

```sql
-- Connect as postgres user
sudo -u postgres psql

-- Create database and user
CREATE DATABASE social_media_agents;
CREATE USER n8n_user WITH PASSWORD 'secure_password_here';
GRANT ALL PRIVILEGES ON DATABASE social_media_agents TO n8n_user;

-- Connect to the new database
\c social_media_agents

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Grant schema permissions
GRANT ALL ON SCHEMA public TO n8n_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO n8n_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO n8n_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO n8n_user;
```

### 1.3 Run Database Schema

Execute the provided `database_setup.sql` file:

```bash
psql -U n8n_user -d social_media_agents -f database_setup.sql
```

## Step 2: n8n Installation and Configuration

### 2.1 Install n8n

```bash
# Using npm (recommended for development)
npm install -g n8n

# Using Docker (recommended for production)
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=password \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=localhost \
  -e DB_POSTGRESDB_PORT=5432 \
  -e DB_POSTGRESDB_DATABASE=social_media_agents \
  -e DB_POSTGRESDB_USER=n8n_user \
  -e DB_POSTGRESDB_PASSWORD=secure_password_here \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### 2.2 Environment Variables

Create `.env` file or set environment variables:

```env
# Database Configuration
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=localhost
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=social_media_agents
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_PASSWORD=secure_password_here

# n8n Configuration
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=password
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/

# API Keys (set these in n8n credentials)
OPENAI_API_KEY=your_openai_api_key
SLACK_BOT_TOKEN=xoxb-your-slack-bot-token
ELEVENLABS_API_KEY=your_elevenlabs_api_key
HEYGEN_API_KEY=your_heygen_api_key
```

## Step 3: Slack App Configuration

### 3.1 Create Slack App

1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Click "Create New App" → "From scratch"
3. Name: "AI Agent Coordinator"
4. Select your workspace

### 3.2 Configure OAuth & Permissions

**Bot Token Scopes:**
```
channels:history
channels:join
channels:read
chat:write
files:read
app_mentions:read
reactions:read
reactions:write
users:read
im:history
mpim:history
groups:history
```

**User Token Scopes:**
```
channels:read
users:read
```

### 3.3 Enable Event Subscriptions

**Request URL:** `http://your-n8n-domain.com/webhook/slack`

**Subscribe to Bot Events:**
```
app_mention
message.channels
reaction_added
```

### 3.4 Configure Interactive Components

**Request URL:** `http://your-n8n-domain.com/webhook/slack-interactive`

### 3.5 Install App to Workspace

1. Go to "Install App" section
2. Click "Install to Workspace"
3. Copy the Bot User OAuth Token (starts with `xoxb-`)

### 3.6 Create Slack Channels

Create these channels in your Slack workspace:
- `#social-media-manager` - Main coordination
- `#agent-coordination` - Agent communication
- `#content-review` - Content approval
- `#agent-meetings` - Meeting summaries
- `#publishing-results` - Publication status

## Step 4: n8n Credentials Setup

### 4.1 OpenAI Credentials

1. In n8n, go to Settings → Credentials
2. Add "OpenAI" credential
3. Enter your OpenAI API key

### 4.2 Slack Credentials

1. Add "Slack" credential
2. Choose "OAuth2" authentication
3. Enter Bot User OAuth Token

### 4.3 PostgreSQL Credentials

1. Add "PostgreSQL" credential
2. Enter database connection details

### 4.4 Social Media Platform Credentials

**Twitter API:**
1. Create app at [developer.twitter.com](https://developer.twitter.com)
2. Generate API Key, Secret, Access Token, and Access Token Secret
3. Add "Twitter" credential in n8n

**LinkedIn API:**
1. Create app at [developer.linkedin.com](https://developer.linkedin.com)
2. Add "LinkedIn" credential with OAuth2

**Facebook/Instagram API:**
1. Create app at [developers.facebook.com](https://developers.facebook.com)
2. Add "Facebook Graph API" credential

**TikTok API:**
1. Apply for TikTok for Developers
2. Add "HTTP Request" credential for TikTok API

## Step 5: Import and Configure Workflows

### 5.1 Workflow Import Order

Import workflows in this specific order:

1. **Multi-Platform Publisher** (ID: 8TBpA3GGVCAhaUM6)
2. **Agent Meeting Workflow** (ID: 3zx6WOGClqbkaS0h)
3. **Feedback Processing Pipeline** (ID: 3uRK3SmqT8HfMuBV)
4. **Brand Agent - AI Content Creator** (ID: tcTCr3hdzUpMQIzF)
5. **Agent Communication Hub** (ID: REWHyqaOVprEJSDh)
6. **Parent Social Media Manager** (ID: gkHaFgutli310owI)

### 5.2 Configure Workflow Credentials

For each workflow, update the credential references:
- OpenAI credentials for all AI nodes
- PostgreSQL credentials for all database nodes
- Slack credentials for all Slack nodes
- Platform-specific credentials for publishing nodes

### 5.3 Update Workflow IDs

In the "Parent Social Media Manager" workflow, update the Brand Setup node with the correct workflow IDs:

```javascript
// Update these with your actual workflow IDs
const brands = [
  {
    brand_id: 'humanity-rocks',
    brand_workflow_id: 'tcTCr3hdzUpMQIzF', // Your Brand Agent workflow ID
    // ... other properties
  },
  // ... other brands
];
```

## Step 6: Test System Components

### 6.1 Test Database Connection

1. Execute the "Get Brand Knowledge" node in any Brand Agent workflow
2. Verify it retrieves data from the database

### 6.2 Test OpenAI Integration

1. Execute the "Generate Content" node
2. Verify it produces content using GPT-4

### 6.3 Test Slack Integration

1. Send a test message to `#agent-coordination`
2. Verify the Agent Communication Hub processes it

### 6.4 Test End-to-End Flow

1. Manually trigger the Parent Social Media Manager
2. Monitor execution through all workflows
3. Check content appears in `#content-review` channel

## Step 7: System Activation

### 7.1 Activate Workflows

Activate workflows in this order:
1. Multi-Platform Publisher
2. Agent Meeting Workflow  
3. Feedback Processing Pipeline
4. Agent Communication Hub
5. Brand Agent - AI Content Creator
6. Parent Social Media Manager

### 7.2 Monitor Initial Execution

1. Check n8n execution logs
2. Monitor Slack channels for activity
3. Verify database entries are created

## Step 8: Advanced Configuration

### 8.1 Vector Embeddings (Optional)

If using Pinecone for vector storage:

1. Create Pinecone account and index
2. Set dimension to 1536 (OpenAI embedding size)
3. Update workflows to use Pinecone instead of PostgreSQL vectors

### 8.2 ElevenLabs Voice Integration

1. Sign up for ElevenLabs account
2. Create voice profiles for each brand
3. Update brand_agents table with voice_id values

### 8.3 HeyGen Video Integration

1. Sign up for HeyGen account
2. Create avatar profiles for each brand
3. Update brand_agents table with avatar_id values

### 8.4 Monitoring and Analytics

Set up monitoring for:
- Workflow execution success rates
- Content approval rates
- Publishing success rates
- Agent response times

## Step 9: Usage and Commands

### 9.1 Slack Commands

Use these commands in Slack channels:

```
# Agent commands
AGENT_MEETING: daily_sync
AGENT_TASK: create content for humanity-rocks about community service
AGENT_LEARN: user feedback about post engagement
AGENT_STATUS: show performance metrics
AGENT_COLLABORATE: coordinate cross-brand campaign

# Content review
✅ Approve & Publish
📝 Request Changes  
❌ Reject
```

### 9.2 Manual Triggers

- Trigger Parent Social Media Manager for immediate content generation
- Trigger Agent Meeting Workflow for ad-hoc coordination
- Trigger individual Brand Agents for specific content needs

## Troubleshooting

### Common Issues

**Database Connection Errors:**
- Verify PostgreSQL is running
- Check credentials and permissions
- Ensure vector extension is installed

**Slack Integration Issues:**
- Verify bot token permissions
- Check webhook URLs are accessible
- Ensure channels exist and bot is invited

**OpenAI API Errors:**
- Check API key validity
- Monitor rate limits
- Verify model access (GPT-4)

**Workflow Execution Failures:**
- Check node configurations
- Verify credential assignments
- Monitor execution logs

### Support and Maintenance

- Monitor system performance daily
- Review agent learning events weekly
- Update brand knowledge regularly
- Backup workflows and database regularly

## Security Considerations

1. **Credential Management:**
   - Store all API keys securely in n8n credentials
   - Rotate credentials regularly
   - Use environment variables for sensitive data

2. **Database Security:**
   - Use strong passwords
   - Limit database access
   - Enable SSL connections

3. **Slack Security:**
   - Limit bot permissions to required scopes
   - Monitor channel access
   - Use private channels for sensitive operations

4. **Network Security:**
   - Use HTTPS for all webhook endpoints
   - Implement webhook signature verification
   - Restrict network access to necessary services

## Scaling Considerations

1. **Performance Optimization:**
   - Monitor database query performance
   - Implement caching for frequently accessed data
   - Use connection pooling for database connections

2. **Resource Management:**
   - Monitor n8n memory usage
   - Scale database resources as needed
   - Implement rate limiting for API calls

3. **High Availability:**
   - Set up database replication
   - Use load balancers for n8n instances
   - Implement backup and recovery procedures

This completes the setup guide for your multi-agent social media management system. The system is now ready to autonomously create, review, and publish content across multiple brands and platforms while learning from feedback and coordinating through AI agents. 