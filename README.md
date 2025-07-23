# Multi-Agent Social Media Management System for n8n

An intelligent, AI-powered social media management platform that uses collaborative agents to create, review, and publish content across multiple brands and platforms autonomously.

## 🚀 Overview

This system orchestrates content creation and distribution across five brands (Humanity Rocks, MyReflection, FT-News, Teaching Mom AI, Infinite-Ideas) using a **hierarchical agent structure** with a Parent Social Media Manager coordinating specialized sub-agents. Each agent communicates through Slack channels, enabling both human oversight and inter-agent collaboration.

### Key Features

- **🤖 AI Agent Collaboration**: Multiple specialized agents work together through Slack
- **📊 Intelligent Content Creation**: GPT-4 powered content generation with brand-specific voice
- **🔄 Feedback Learning System**: Continuous improvement through human feedback loops
- **📱 Multi-Platform Publishing**: Automated distribution to Twitter, LinkedIn, Instagram, TikTok, Facebook
- **🎯 Brand-Specific Targeting**: Customized content for each brand's audience and voice
- **📈 Performance Analytics**: Comprehensive tracking and optimization
- **🗣️ Voice & Video Generation**: ElevenLabs and HeyGen integration for multimedia content

## 🏗️ System Architecture

### Core Workflows

1. **Parent Social Media Manager** - Central orchestrator that coordinates all brand agents
2. **Brand Agent - AI Content Creator** - Individual agents for each brand's content creation
3. **Agent Communication Hub** - Handles inter-agent communication through Slack
4. **Feedback Processing Pipeline** - Manages content review and learning from feedback
5. **Agent Meeting Workflow** - Daily coordination meetings and performance analysis
6. **Multi-Platform Publisher** - Distributes approved content across social media platforms

### Agent Hierarchy

```
Parent Social Media Manager
├── Humanity Rocks Agent (Community & Social Good)
├── MyReflection Agent (Personal Development)
├── FT-News Agent (Technology & Business)
├── Teaching Mom AI Agent (AI Education for Families)
└── Infinite-Ideas Agent (Creativity & Innovation)
```

## 📋 Prerequisites

### Required Services
- **n8n** (self-hosted or cloud)
- **PostgreSQL** with vector extension
- **Slack Workspace**
- **OpenAI API** (GPT-4 access)

### Optional Services
- **ElevenLabs** (voice synthesis)
- **HeyGen** (video generation)
- **Pinecone** (vector database)

### Social Media Platform APIs
- Twitter API v2
- LinkedIn API
- Facebook/Instagram Graph API
- TikTok API

## 🛠️ Quick Start

### 1. Clone and Setup Database

```bash
# Setup PostgreSQL database
psql -U postgres -c "CREATE DATABASE social_media_agents;"
psql -U postgres -d social_media_agents -f database_setup.sql
```

### 2. Install and Configure n8n

```bash
# Using Docker
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=localhost \
  -e DB_POSTGRESDB_DATABASE=social_media_agents \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### 3. Configure Slack App

1. Create Slack app at [api.slack.com/apps](https://api.slack.com/apps)
2. Configure OAuth scopes and event subscriptions
3. Create required channels: `#social-media-manager`, `#agent-coordination`, `#content-review`, `#agent-meetings`, `#publishing-results`

### 4. Import Workflows

Import the 6 core workflows into your n8n instance in the specified order (see SETUP_GUIDE.md for details).

### 5. Configure Credentials

Set up credentials in n8n for:
- OpenAI API
- Slack Bot Token
- PostgreSQL
- Social media platform APIs

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md).

## 🎯 Usage

### Slack Commands

The system responds to specific commands in Slack:

```bash
# Agent coordination commands
AGENT_MEETING: daily_sync
AGENT_TASK: create content for humanity-rocks about community service
AGENT_LEARN: user feedback about post engagement
AGENT_STATUS: show performance metrics
AGENT_COLLABORATE: coordinate cross-brand campaign

# Content review actions
✅ Approve & Publish
📝 Request Changes  
❌ Reject
```

### Automated Workflows

- **Every 2 hours**: Parent Social Media Manager runs and delegates content creation
- **Daily at 9 AM**: Agent Meeting Workflow conducts performance review
- **Real-time**: Content review and feedback processing
- **On-demand**: Agent communication and collaboration

### Manual Triggers

- Trigger specific brand agents for immediate content creation
- Initiate agent meetings for strategy discussions
- Force content publishing to specific platforms

## 🧠 AI Agent Capabilities

### Parent Social Media Manager
- Analyzes social media trends
- Delegates tasks to brand agents
- Coordinates cross-brand campaigns
- Monitors overall system performance

### Brand Agents
- **Humanity Rocks**: Creates content about community impact and kindness
- **MyReflection**: Develops personal growth and mindfulness content
- **FT-News**: Produces technology and business analysis
- **Teaching Mom AI**: Makes AI accessible for families
- **Infinite-Ideas**: Generates creative and innovative content

### Learning System
- Processes human feedback on content quality
- Adapts content style based on engagement metrics
- Shares learnings across all agents
- Continuously improves content generation

## 📊 Content Generation Process

1. **Strategy Phase**: Parent agent analyzes trends and sets priorities
2. **Creation Phase**: Brand agents generate content using AI and brand knowledge
3. **Review Phase**: Content is reviewed in Slack with human feedback
4. **Learning Phase**: Feedback is processed and incorporated into future content
5. **Publishing Phase**: Approved content is distributed across platforms
6. **Analytics Phase**: Performance metrics are collected and analyzed

## 🔧 Database Schema

The system uses PostgreSQL with the following key tables:

- `brand_agents` - Agent configurations and settings
- `agent_knowledge` - Brand-specific knowledge base with vector embeddings
- `generated_content` - All created content with approval status
- `published_content` - Publishing results across platforms
- `learning_events` - Feedback and learning data
- `agent_communications` - Inter-agent message logs
- `agent_meetings` - Meeting records and action items

## 🚀 Advanced Features

### Vector Embeddings
- Uses OpenAI embeddings for semantic content search
- Enables intelligent content recommendations
- Supports knowledge retrieval for context-aware generation

### Voice and Video Generation
- ElevenLabs integration for brand-specific voice synthesis
- HeyGen integration for avatar-based video content
- Automated multimedia content creation

### Performance Analytics
- Real-time monitoring of content performance
- Engagement tracking across platforms
- Success rate analysis and optimization recommendations

## 🔒 Security & Privacy

- All API keys stored securely in n8n credentials
- Database access restricted with user permissions
- Slack bot permissions limited to required scopes
- HTTPS enforcement for all webhook endpoints
- Regular credential rotation recommended

## 📈 Monitoring & Maintenance

### Key Metrics
- Content approval rates by brand
- Publishing success rates by platform
- Agent response times
- Learning event frequency
- Engagement performance

### Maintenance Tasks
- Weekly review of agent learning events
- Monthly update of brand knowledge base
- Quarterly credential rotation
- Regular database performance optimization

## 🤝 Contributing

This system is designed to be extensible. You can:

1. **Add new brands**: Create new entries in `brand_agents` table and deploy brand-specific workflows
2. **Integrate new platforms**: Extend the Multi-Platform Publisher with additional social media APIs
3. **Enhance AI capabilities**: Improve prompts and add new AI models
4. **Expand learning system**: Add new feedback mechanisms and learning algorithms

## 📚 Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Complete installation and configuration guide
- **[database_setup.sql](database_setup.sql)** - PostgreSQL database schema
- **Workflow Documentation** - Available in n8n workflow descriptions

## 🆘 Support

### Common Issues
- **Database Connection**: Verify PostgreSQL is running and credentials are correct
- **Slack Integration**: Check bot permissions and webhook URLs
- **OpenAI API**: Verify API key and model access
- **Workflow Execution**: Monitor n8n execution logs for errors

### Troubleshooting
See the troubleshooting section in [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed problem resolution.

## 📄 License

This project is provided as-is for educational and development purposes. Please ensure compliance with all third-party service terms of use.

## 🎯 Roadmap

### Upcoming Features
- **Enhanced Analytics Dashboard**: Real-time performance visualization
- **Content A/B Testing**: Automated testing of content variations
- **Sentiment Analysis**: AI-powered content sentiment optimization
- **Cross-Platform Analytics**: Unified metrics across all platforms
- **Advanced Learning Models**: More sophisticated feedback processing

### Integration Opportunities
- **CRM Integration**: Connect with customer relationship management systems
- **Email Marketing**: Extend to email campaign automation
- **Content Calendar**: Visual content planning and scheduling
- **Brand Asset Management**: Automated logo and image integration

---

**Ready to revolutionize your social media management?** Follow the setup guide and let your AI agents take your content strategy to the next level! 🚀 