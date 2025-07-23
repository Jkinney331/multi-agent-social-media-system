# Deployment Guide
# Multi-Agent Social Media Management System for Development Agency

**Version:** 1.0  
**Updated:** January 2024  
**Target Environment:** Production-Ready n8n Setup  

---

## 🎯 Quick Start Overview

Your **Multi-Agent Social Media Management System** is now ready for deployment! This guide will help you:

1. **Deploy 6 Core Workflows** ✅ Created
2. **Set up Database Infrastructure** ✅ Schema Ready
3. **Configure MCP Integrations** ✅ Composio + Zapier
4. **Test FT News System** ✅ Tech News → HeyGen Videos
5. **Onboard Your First Client** 🚀 Ready to Go

---

## 📋 System Architecture Summary

### **Core Workflows Created:**

| Workflow | ID | Purpose | Status |
|----------|-----|---------|--------|
| **Client Onboarding System** | `aumqY4MprVYmcrL0` | Dynamic client & brand creation | ✅ Active |
| **Executive Social Media Manager** | `Ze95xCjfqPrejoSj` | Strategic coordination & MCP integration | ✅ Active |
| **FT News Tech Video System** | `SsXDIZ1fkFK7MgBF` | News → HeyGen avatar videos | ✅ Active |
| **Enhanced Brand Agent** | `6HjY3tonkFa5Mvep` | Multi-sub-agent coordination | ✅ Active |
| **Agent Communication Hub** | `REWHyqaOVprEJSDh` | Slack-based agent coordination | ✅ Active |
| **Multi-Platform Publisher** | `8TBpA3GGVCAyV4VN` | Cross-platform content distribution | ✅ Active |

### **Key Features:**
- **🤖 AI Agent Hierarchy**: Executive → Brand Agents → Sub-Agents
- **📱 9 Platform Support**: Instagram, Facebook, LinkedIn, Twitter, YouTube, TikTok, Reddit, Discord, Telegram
- **🎥 Video Generation**: HeyGen avatars + VEO 3 + ElevenLabs
- **🔗 MCP Integration**: Composio + Zapier + Custom MCPs
- **📊 Dynamic Onboarding**: Slack-triggered client setup
- **🏢 Multi-Client Support**: Unlimited brands and clients

---

## 🚀 Deployment Steps

### Step 1: Database Setup

```bash
# 1. Create PostgreSQL database
createdb social_media_agents

# 2. Run the enhanced schema
psql social_media_agents < enhanced_database_schema.sql

# 3. Verify tables created
psql social_media_agents -c "\dt"
```

**Expected Output:**
```
 Schema |            Name            | Type  |  Owner   
--------+----------------------------+-------+----------
 public | brand_agent_coordination   | table | postgres
 public | brand_agents              | table | postgres
 public | clients                   | table | postgres
 public | content_approvals         | table | postgres
 public | executive_directives      | table | postgres
 public | ft_news_videos           | table | postgres
 public | generated_content         | table | postgres
 public | learning_events           | table | postgres
 public | mcp_configurations        | table | postgres
 public | performance_metrics       | table | postgres
 public | platform_credentials      | table | postgres
 public | published_content         | table | postgres
 public | sub_agents               | table | postgres
 public | system_config            | table | postgres
```

### Step 2: n8n Environment Configuration

Create `.env` file:
```bash
# Core n8n Configuration
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-domain.com

# Database Configuration
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=localhost
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=social_media_agents
DB_POSTGRESDB_USER=postgres
DB_POSTGRESDB_PASSWORD=your_password

# AI Services
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key
ELEVENLABS_API_KEY=your-elevenlabs-key
HEYGEN_API_KEY=your-heygen-key

# MCP Services
COMPOSIO_API_KEY=comp_live_your-composio-key
ZAPIER_WEBHOOK_URL=https://hooks.zapier.com/hooks/catch/your-hook
NEWS_API_KEY=your-newsapi-key

# Platform APIs
SLACK_BOT_TOKEN=xoxb-your-slack-token
SLACK_APP_TOKEN=xapp-your-app-token

# Security
N8N_ENCRYPTION_KEY=your-32-character-encryption-key
JWT_SECRET=your-jwt-secret-key
```

### Step 3: Slack Workspace Setup

1. **Create Slack App**: https://api.slack.com/apps
2. **Required Scopes**:
   ```
   Bot Token Scopes:
   - channels:read
   - channels:join
   - chat:write
   - chat:write.public
   - files:write
   - users:read
   - channels:manage
   - groups:write
   ```

3. **Create Channels**:
   ```bash
   # Agency Channels
   #new-clients          # For client onboarding
   #executive-command     # Executive agent coordination
   #agent-coordination    # Inter-agent communication
   #agent-meetings        # Daily sync meetings
   #content-review        # Content approval workflow
   
   # Brand-Specific Channels (Auto-created)
   #ft-news-content      # FT News brand
   #humanity-rocks-content
   #myreflection-content
   #infinite-ideas-content
   ```

### Step 4: API Credentials Setup

#### Composio Setup:
```bash
# Install Composio CLI
npm install -g composio-core

# Login and setup
composio login
composio apps list

# Connect platforms (for each brand)
composio add linkedin
composio add twitter
composio add instagram
composio add facebook
composio add youtube
```

#### HeyGen Setup:
1. Sign up at https://www.heygen.com
2. Get API key from dashboard
3. Note your preferred avatar IDs
4. Test API connection:
   ```bash
   curl -X GET "https://api.heygen.com/v1/avatars" \
     -H "X-API-Key: YOUR_HEYGEN_KEY"
   ```

#### ElevenLabs Setup:
1. Create account at https://elevenlabs.io
2. Clone or create voices for each brand
3. Test voice generation:
   ```bash
   curl -X POST "https://api.elevenlabs.io/v1/text-to-speech/VOICE_ID" \
     -H "xi-api-key: YOUR_XI_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"text": "Test message"}'
   ```

### Step 5: Workflow Import & Activation

```bash
# Import workflows (already created - just activate)
# In n8n interface:
# 1. Go to each workflow
# 2. Click "Activate" toggle
# 3. Test with manual execution

# Activate workflows in this order:
1. Enhanced Executive Social Media Manager with MCP
2. Client Onboarding & Dynamic Brand Creation System  
3. Enhanced Brand Agent with Sub-Agents
4. FT News - Tech News to Avatar Video System
5. Agent Communication Hub
6. Multi-Platform Publisher
```

---

## 🧪 Testing Your System

### Test 1: Client Onboarding

1. **Go to Slack channel `#new-clients`**
2. **Post this message**:
   ```
   Client: TechStartup Inc
   Brands: InnovateTech, DevTools Pro
   Industry: Software Development
   Platforms: LinkedIn, Twitter, YouTube
   Budget: $5000/month
   Timeline: 2 weeks to launch
   ```

3. **Expected Result**:
   - ✅ Client parsed and stored in database
   - ✅ Brand agents created automatically
   - ✅ Slack channels created for each brand
   - ✅ Onboarding plan generated
   - ✅ Approval buttons presented

### Test 2: FT News Video Generation

1. **Manually trigger FT News workflow**
2. **Expected Process**:
   ```
   TechCrunch/The Verge → News Analysis → Top Story Selection
   ↓
   GPT-4 Script Generation → DALL-E Background → ElevenLabs Voice
   ↓
   HeyGen Avatar Video → Review Notification → Multi-Platform Ready
   ```

3. **Check Results**:
   - Video URL generated
   - Slack notification in `#ft-news-content`
   - Database entry in `ft_news_videos` table

### Test 3: Executive Coordination

1. **Executive agent runs every 2 hours automatically**
2. **Manual test**: Trigger from `#executive-command`
3. **Expected Output**:
   - Brand status analysis
   - Strategic directives sent to brand agents
   - Performance metrics collection
   - Cross-brand coordination opportunities

---

## 📊 Monitoring & Analytics

### Database Views for Monitoring:

```sql
-- Quick system overview
SELECT * FROM client_dashboard;

-- Brand performance summary
SELECT * FROM brand_performance_overview;

-- Recent activity (last 7 days)
SELECT * FROM recent_activity LIMIT 20;

-- Performance metrics
SELECT * FROM performance_summary 
WHERE period_end >= CURRENT_DATE - INTERVAL '7 days';
```

### n8n Monitoring:

1. **Execution History**: Monitor workflow success rates
2. **Error Logs**: Check for failed executions
3. **Performance**: Track execution times
4. **Resource Usage**: Monitor database queries

### Slack Notifications:

- **✅ Success Notifications**: Content published, clients onboarded
- **⚠️ Warning Alerts**: Rate limits approaching, approval needed
- **🚨 Error Alerts**: Failed executions, API issues

---

## 🔧 Configuration Management

### System Configuration (`system_config` table):

```sql
-- View current configuration
SELECT config_key, config_value, description 
FROM system_config 
ORDER BY config_key;

-- Update configuration
UPDATE system_config 
SET config_value = '10'
WHERE config_key = 'max_content_per_day';
```

### Brand Agent Configuration:

```sql
-- Add new brand manually (if needed)
INSERT INTO brand_agents (
  brand_id, brand_name, client_id, client_name, 
  industry, platforms, slack_channel, voice_description
) VALUES (
  'new-brand-001', 'NewBrand', 'client-001', 'Client Name',
  'Technology', '["linkedin", "twitter"]', 'newbrand-content',
  'Professional and innovative voice'
);
```

---

## 🎯 Client Onboarding Process

### For Each New Client:

1. **Slack Briefing** → Client posts requirements in `#new-clients`
2. **Automated Analysis** → AI analyzes and creates onboarding plan
3. **Brand Agent Creation** → Individual agents deployed per brand
4. **Platform Authentication** → Composio handles OAuth flows
5. **Content Strategy** → Research agents analyze competition
6. **First Content** → Video agents create initial content
7. **Review & Approval** → Client reviews before publishing
8. **Go Live** → Multi-platform publishing begins

### Typical Timeline:
- **Day 1**: Client briefing → Brand agent creation
- **Day 2-3**: Platform authentication → Content strategy
- **Day 4-5**: First content creation → Client review
- **Week 2**: Full automation active → Performance tracking

---

## 🚨 Troubleshooting

### Common Issues:

#### 1. Workflow Not Triggering
```bash
# Check webhook URLs
curl -X POST "https://your-domain.com/webhook/workflow-id" \
  -d '{"test": "data"}'

# Verify credentials
# Go to n8n Settings → Credentials → Test connection
```

#### 2. Database Connection Issues
```sql
-- Test database connection
SELECT NOW() as current_time;

-- Check table permissions
SELECT schemaname, tablename, tableowner 
FROM pg_tables 
WHERE schemaname = 'public';
```

#### 3. API Rate Limits
```javascript
// Check MCP usage
SELECT mcp_name, current_usage, monthly_quota
FROM mcp_configurations;

// Reset if needed (beginning of month)
UPDATE mcp_configurations 
SET current_usage = 0 
WHERE mcp_name = 'Composio Social Media';
```

#### 4. Slack Integration Issues
```bash
# Test Slack API
curl -X POST "https://slack.com/api/auth.test" \
  -H "Authorization: Bearer xoxb-your-slack-token"

# Check bot permissions
curl -X POST "https://slack.com/api/conversations.list" \
  -H "Authorization: Bearer xoxb-your-slack-token"
```

---

## 📈 Scaling & Performance

### Performance Optimization:

1. **Database Indexing** ✅ Already configured
2. **Workflow Parallelization** ✅ Sub-agents run in parallel
3. **Caching Strategy** ✅ Built into MCP integration
4. **Rate Limiting** ✅ Prevents API overuse

### Scaling for More Clients:

```sql
-- Monitor resource usage
SELECT 
  COUNT(*) as total_brands,
  AVG(daily_content_count) as avg_content_per_brand,
  SUM(daily_content_count) as total_daily_content
FROM brand_performance_overview;
```

### Resource Requirements:

| Clients | Brands | Daily Content | n8n Resources | Database |
|---------|--------|---------------|---------------|----------|
| 1-5 | 5-15 | 50-150 posts | 2GB RAM, 2 CPU | 10GB SSD |
| 5-20 | 15-60 | 150-600 posts | 4GB RAM, 4 CPU | 25GB SSD |
| 20-50 | 60-150 | 600-1500 posts | 8GB RAM, 8 CPU | 50GB SSD |

---

## 🎉 You're Ready to Launch!

### Next Steps:

1. **✅ Test FT News System** - Verify tech news → video pipeline
2. **✅ Onboard First Client** - Use the Slack-based onboarding
3. **✅ Monitor Performance** - Watch for 24-48 hours
4. **✅ Optimize Based on Usage** - Adjust configurations as needed
5. **✅ Scale Up** - Add more clients and brands

### Success Metrics:

- **Client Onboarding Time**: < 2 days from briefing to live
- **Content Approval Rate**: > 85% auto-approved
- **Platform Publishing Success**: > 95% successful posts
- **Agent Response Time**: < 30 seconds for coordination
- **Video Generation**: < 5 minutes from news to video

---

## 📞 Support & Maintenance

### Daily Checks:
- Monitor `#executive-command` for system status
- Review failed executions in n8n
- Check database performance metrics

### Weekly Tasks:
- Analyze client performance reports
- Update content strategies based on trends
- Review and approve new brand requests

### Monthly Tasks:
- MCP usage analysis and quota management
- System performance optimization
- Client success reviews and expansion planning

---

**🚀 Your multi-agent social media management system is now ready to revolutionize how you serve your development agency clients!** 

The system will automatically handle client onboarding, create brand-specific agents, generate content (including HeyGen videos for FT News), and manage multi-platform publishing - all coordinated through Slack and powered by advanced AI agents. 