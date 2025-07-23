-- Enhanced Multi-Agent Social Media Management System Database Schema
-- PostgreSQL Database Setup for Development Agency
-- Supports multiple clients, brands, and dynamic agent deployment

-- Enable UUID extension and vector support
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- =======================
-- CLIENT MANAGEMENT TABLES
-- =======================

-- Clients table - stores development agency clients
CREATE TABLE IF NOT EXISTS clients (
    client_id VARCHAR(50) PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    company_name VARCHAR(100),
    industry VARCHAR(50) NOT NULL,
    brands JSONB NOT NULL, -- Array of brand names
    platforms JSONB NOT NULL, -- Array of platform names
    budget VARCHAR(50),
    timeline VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    onboarding_plan TEXT,
    status VARCHAR(20) DEFAULT 'pending_setup',
    subscription_tier VARCHAR(20) DEFAULT 'standard',
    billing_info JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Client contacts for multiple stakeholders per client
CREATE TABLE IF NOT EXISTS client_contacts (
    contact_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id VARCHAR(50) REFERENCES clients(client_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(50), -- Primary Contact, Marketing Manager, CEO, etc.
    phone VARCHAR(20),
    slack_user_id VARCHAR(50),
    notification_preferences JSONB,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================
-- BRAND AGENT TABLES
-- =======================

-- Enhanced brand agents table
CREATE TABLE IF NOT EXISTS brand_agents (
    brand_id VARCHAR(100) PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    client_id VARCHAR(50) REFERENCES clients(client_id) ON DELETE CASCADE,
    client_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50) NOT NULL,
    platforms JSONB NOT NULL, -- Array of platform names
    slack_channel VARCHAR(100) NOT NULL,
    
    -- Brand Configuration
    voice_description TEXT,
    target_audience TEXT,
    content_pillars JSONB, -- Array of content themes
    posting_schedule JSONB, -- Platform-specific posting frequency
    visual_guidelines TEXT,
    hashtag_strategy JSONB, -- Array of hashtags
    kpis JSONB, -- Array of KPI metrics
    
    -- Agent Configuration
    workflow_ids JSONB, -- References to n8n workflow IDs
    sub_agents JSONB, -- Configuration for sub-agents
    ai_model_preferences JSONB, -- Preferred AI models per task
    
    -- Credentials and API Keys (encrypted)
    credentials JSONB, -- Platform API keys, tokens
    voice_id VARCHAR(100), -- ElevenLabs voice ID
    avatar_id VARCHAR(100), -- HeyGen avatar ID
    
    -- Agent Status
    status VARCHAR(20) DEFAULT 'pending_deployment',
    performance_metrics JSONB,
    last_active TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sub-agent configurations and specializations
CREATE TABLE IF NOT EXISTS sub_agents (
    sub_agent_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    agent_type VARCHAR(50) NOT NULL, -- research, video_creator, publisher, etc.
    specialization VARCHAR(100), -- tech_news, fashion_content, b2b_marketing, etc.
    configuration JSONB NOT NULL, -- Agent-specific settings
    ai_model VARCHAR(50), -- Preferred AI model
    tools_available JSONB, -- Array of available tools/MCPs
    status VARCHAR(20) DEFAULT 'active',
    performance_stats JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================
-- CONTENT MANAGEMENT TABLES
-- =======================

-- Generated content with enhanced tracking
CREATE TABLE IF NOT EXISTS generated_content (
    content_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    client_id VARCHAR(50) REFERENCES clients(client_id) ON DELETE CASCADE,
    
    -- Content Details
    content_type VARCHAR(50) NOT NULL, -- text, image, video, carousel, story
    title VARCHAR(200),
    short_post TEXT,
    long_caption TEXT,
    hashtags JSONB,
    
    -- Video/Media Content
    video_script TEXT,
    video_url VARCHAR(500),
    thumbnail_url VARCHAR(500),
    image_urls JSONB, -- Array of image URLs
    audio_url VARCHAR(500),
    
    -- AI Generation Details
    ai_model_used VARCHAR(50),
    generation_prompt TEXT,
    generation_time_ms INTEGER,
    generation_cost DECIMAL(10,4),
    
    -- Platform Targeting
    target_platforms JSONB NOT NULL, -- Array of platforms
    platform_variations JSONB, -- Platform-specific content versions
    optimal_posting_times JSONB,
    
    -- Content Workflow
    status VARCHAR(20) DEFAULT 'draft', -- draft, pending_review, approved, published, rejected
    confidence_score DECIMAL(3,2),
    sub_agent_created VARCHAR(50), -- Which sub-agent created this
    coordination_id VARCHAR(100), -- Links to agent coordination
    
    -- Review Process
    reviewed_by VARCHAR(100),
    approved_by VARCHAR(100),
    feedback TEXT,
    revision_count INTEGER DEFAULT 0,
    
    -- Performance Tracking
    engagement_prediction JSONB,
    actual_performance JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Content approval workflow
CREATE TABLE IF NOT EXISTS content_approvals (
    approval_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES generated_content(content_id) ON DELETE CASCADE,
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    client_id VARCHAR(50) REFERENCES clients(client_id) ON DELETE CASCADE,
    
    approval_type VARCHAR(20) NOT NULL, -- human, auto, ai_review
    reviewer_type VARCHAR(20), -- client, account_manager, ai_agent
    reviewer_id VARCHAR(100),
    
    decision VARCHAR(20) NOT NULL, -- approved, rejected, needs_revision
    feedback TEXT,
    feedback_category VARCHAR(50), -- content_quality, brand_voice, compliance
    revision_requests JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================
-- PUBLISHING & PLATFORM TABLES
-- =======================

-- Published content tracking across platforms
CREATE TABLE IF NOT EXISTS published_content (
    publication_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES generated_content(content_id) ON DELETE CASCADE,
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    
    platform VARCHAR(50) NOT NULL,
    platform_post_id VARCHAR(200), -- External platform post ID
    post_url VARCHAR(500),
    
    -- Publishing Details
    published_at TIMESTAMP,
    scheduled_for TIMESTAMP,
    publishing_status VARCHAR(20) DEFAULT 'scheduled', -- scheduled, published, failed, deleted
    
    -- Platform-specific data
    platform_content_version TEXT, -- Content adapted for this platform
    platform_hashtags JSONB,
    platform_engagement JSONB,
    
    -- Error handling
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Platform credentials and configuration
CREATE TABLE IF NOT EXISTS platform_credentials (
    credential_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    client_id VARCHAR(50) REFERENCES clients(client_id) ON DELETE CASCADE,
    
    platform VARCHAR(50) NOT NULL,
    credential_type VARCHAR(50), -- oauth, api_key, username_password
    credentials JSONB NOT NULL, -- Encrypted credentials
    
    -- Account Details
    platform_account_id VARCHAR(200),
    account_name VARCHAR(100),
    account_url VARCHAR(300),
    follower_count INTEGER,
    
    status VARCHAR(20) DEFAULT 'active', -- active, expired, revoked, pending
    expires_at TIMESTAMP,
    last_validated TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(brand_id, platform)
);

-- =======================
-- EXECUTIVE & COORDINATION TABLES
-- =======================

-- Executive directives from the parent social media manager
CREATE TABLE IF NOT EXISTS executive_directives (
    directive_id VARCHAR(100) PRIMARY KEY,
    
    -- Targeting
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    brand_name VARCHAR(100) NOT NULL,
    client_name VARCHAR(100),
    
    -- Directive Details
    executive_priority VARCHAR(20) NOT NULL, -- low, medium, high, urgent
    directive_type VARCHAR(50), -- strategic_execution, content_focus, platform_optimization
    
    strategic_focus JSONB NOT NULL, -- Strategic guidance and focus areas
    immediate_actions JSONB, -- Array of immediate action items
    performance_targets JSONB, -- KPI targets and metrics
    
    -- Market Intelligence
    market_trends JSONB, -- Current market trends data
    competitor_analysis JSONB,
    content_opportunities JSONB,
    
    -- Execution Tracking
    status VARCHAR(20) DEFAULT 'deployed', -- deployed, acknowledged, in_progress, completed
    acknowledged_by VARCHAR(100),
    acknowledged_at TIMESTAMP,
    completion_rate DECIMAL(3,2),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);

-- Brand agent coordination sessions
CREATE TABLE IF NOT EXISTS brand_agent_coordination (
    coordination_id VARCHAR(100) PRIMARY KEY,
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    brand_name VARCHAR(100) NOT NULL,
    
    -- Task Details
    task_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    trigger_source VARCHAR(50), -- executive_directive, slack_message, scheduled, api
    
    -- Sub-Agent Results
    sub_agents_used JSONB NOT NULL, -- Array of sub-agent types used
    research_results JSONB,
    video_results JSONB,
    publisher_results JSONB,
    
    -- Coordination Status
    execution_ready BOOLEAN DEFAULT FALSE,
    next_actions JSONB,
    completion_percentage DECIMAL(3,2) DEFAULT 0.00,
    
    -- Performance Tracking
    total_processing_time_ms INTEGER,
    coordination_cost DECIMAL(10,4),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- =======================
-- LEARNING & ANALYTICS TABLES
-- =======================

-- Learning events for AI improvement
CREATE TABLE IF NOT EXISTS learning_events (
    event_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    
    event_type VARCHAR(50) NOT NULL, -- feedback_positive, feedback_negative, performance_data
    event_category VARCHAR(50), -- content_quality, engagement, brand_voice
    
    learning_data JSONB NOT NULL, -- The actual learning data
    confidence_score DECIMAL(3,2),
    impact_assessment VARCHAR(50), -- high, medium, low
    
    -- Source Information
    source_type VARCHAR(50), -- human_feedback, performance_metrics, ai_analysis
    source_content_id UUID,
    source_user VARCHAR(100),
    
    -- Application Status
    applied_to_model BOOLEAN DEFAULT FALSE,
    applied_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance metrics aggregation
CREATE TABLE IF NOT EXISTS performance_metrics (
    metric_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(100) REFERENCES brand_agents(brand_id) ON DELETE CASCADE,
    client_id VARCHAR(50) REFERENCES clients(client_id) ON DELETE CASCADE,
    
    -- Metric Details
    metric_type VARCHAR(50) NOT NULL, -- engagement_rate, reach, conversion, cost_per_action
    platform VARCHAR(50),
    time_period VARCHAR(20), -- daily, weekly, monthly
    
    -- Values
    metric_value DECIMAL(15,4) NOT NULL,
    metric_target DECIMAL(15,4),
    previous_value DECIMAL(15,4),
    
    -- Context
    content_count INTEGER,
    total_spend DECIMAL(10,2),
    
    -- Metadata
    calculation_method VARCHAR(100),
    data_source VARCHAR(50), -- platform_api, manual_entry, calculated
    
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================
-- SPECIALIZED TABLES (FT NEWS)
-- =======================

-- FT News specific video content
CREATE TABLE IF NOT EXISTS ft_news_videos (
    video_id VARCHAR(100) PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    
    -- Content Details
    script JSONB, -- Full script breakdown
    video_url VARCHAR(500),
    thumbnail_url VARCHAR(500),
    
    -- Source Information
    story_source VARCHAR(100), -- TechCrunch, The Verge, etc.
    original_article_url VARCHAR(500),
    relevance_score DECIMAL(3,2),
    trending_score DECIMAL(3,2),
    
    -- Production Details
    ai_models_used JSONB, -- Array of AI models used in production
    generation_cost DECIMAL(10,4),
    production_time_ms INTEGER,
    
    -- Review & Publishing
    status VARCHAR(20) DEFAULT 'pending_review',
    reviewed_by VARCHAR(100),
    published_platforms JSONB,
    
    -- Performance
    views_total INTEGER DEFAULT 0,
    engagement_metrics JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP
);

-- News sources and their performance
CREATE TABLE IF NOT EXISTS news_sources (
    source_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    source_name VARCHAR(100) NOT NULL,
    source_url VARCHAR(300),
    rss_url VARCHAR(300),
    api_endpoint VARCHAR(300),
    
    category VARCHAR(50), -- startup_tech, consumer_tech, deep_tech
    reliability_score DECIMAL(3,2) DEFAULT 5.00,
    update_frequency INTEGER, -- Hours between updates
    
    -- Performance Tracking
    articles_processed INTEGER DEFAULT 0,
    successful_videos INTEGER DEFAULT 0,
    avg_relevance_score DECIMAL(3,2),
    
    status VARCHAR(20) DEFAULT 'active',
    last_checked TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================
-- SYSTEM CONFIGURATION TABLES
-- =======================

-- MCP server configurations
CREATE TABLE IF NOT EXISTS mcp_configurations (
    mcp_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mcp_name VARCHAR(100) NOT NULL,
    mcp_type VARCHAR(50), -- composio, zapier, custom
    
    -- Connection Details
    server_url VARCHAR(300),
    api_key_encrypted TEXT,
    authentication_method VARCHAR(50),
    
    -- Available Tools
    available_tools JSONB NOT NULL, -- Array of available tool names
    tool_categories JSONB, -- Categorized tools
    
    -- Usage Tracking
    total_calls INTEGER DEFAULT 0,
    successful_calls INTEGER DEFAULT 0,
    monthly_quota INTEGER,
    current_usage INTEGER DEFAULT 0,
    
    status VARCHAR(20) DEFAULT 'active',
    last_health_check TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- System-wide configuration
CREATE TABLE IF NOT EXISTS system_config (
    config_key VARCHAR(100) PRIMARY KEY,
    config_value JSONB NOT NULL,
    config_type VARCHAR(50), -- string, number, boolean, object, array
    description TEXT,
    is_encrypted BOOLEAN DEFAULT FALSE,
    
    -- Access Control
    access_level VARCHAR(20) DEFAULT 'admin', -- public, user, admin, system
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================
-- INDEXES FOR PERFORMANCE
-- =======================

-- Client and Brand indexes
CREATE INDEX IF NOT EXISTS idx_clients_status ON clients(status);
CREATE INDEX IF NOT EXISTS idx_clients_industry ON clients(industry);
CREATE INDEX IF NOT EXISTS idx_brand_agents_client ON brand_agents(client_id);
CREATE INDEX IF NOT EXISTS idx_brand_agents_status ON brand_agents(status);

-- Content indexes
CREATE INDEX IF NOT EXISTS idx_content_brand ON generated_content(brand_id);
CREATE INDEX IF NOT EXISTS idx_content_status ON generated_content(status);
CREATE INDEX IF NOT EXISTS idx_content_created ON generated_content(created_at);
CREATE INDEX IF NOT EXISTS idx_content_type ON generated_content(content_type);

-- Publishing indexes
CREATE INDEX IF NOT EXISTS idx_published_platform ON published_content(platform);
CREATE INDEX IF NOT EXISTS idx_published_status ON published_content(publishing_status);
CREATE INDEX IF NOT EXISTS idx_published_scheduled ON published_content(scheduled_for);

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_metrics_brand ON performance_metrics(brand_id);
CREATE INDEX IF NOT EXISTS idx_metrics_period ON performance_metrics(period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_metrics_type ON performance_metrics(metric_type);

-- Coordination indexes
CREATE INDEX IF NOT EXISTS idx_coordination_brand ON brand_agent_coordination(brand_id);
CREATE INDEX IF NOT EXISTS idx_coordination_status ON brand_agent_coordination(execution_ready);
CREATE INDEX IF NOT EXISTS idx_directives_brand ON executive_directives(brand_id);
CREATE INDEX IF NOT EXISTS idx_directives_priority ON executive_directives(executive_priority);

-- =======================
-- INITIAL CONFIGURATION DATA
-- =======================

-- Insert default system configurations
INSERT INTO system_config (config_key, config_value, config_type, description) VALUES
('ai_models_available', '["gpt-4", "claude-3-sonnet", "gemini-pro", "dall-e-3"]', 'array', 'Available AI models for content generation'),
('supported_platforms', '["instagram", "facebook", "linkedin", "twitter", "youtube", "tiktok", "reddit", "discord", "telegram"]', 'array', 'Supported social media platforms'),
('default_posting_schedule', '{"daily": 1, "optimal_times": ["09:00", "13:00", "17:00"]}', 'object', 'Default posting schedule for new brands'),
('video_generation_tools', '["heygen", "veo-3", "elevenlabs", "dall-e-3"]', 'array', 'Available video generation tools'),
('mcp_servers_enabled', '["composio", "zapier"]', 'array', 'Enabled MCP servers'),
('max_content_per_day', '5', 'number', 'Maximum content items per brand per day'),
('approval_required', 'true', 'boolean', 'Whether content requires approval before publishing'),
('auto_publish_threshold', '0.85', 'number', 'Confidence threshold for auto-publishing')
ON CONFLICT (config_key) DO NOTHING;

-- Insert default MCP configurations
INSERT INTO mcp_configurations (mcp_name, mcp_type, available_tools, tool_categories, monthly_quota) VALUES
('Composio Social Media', 'composio', 
 '["LINKEDIN_CREATE_LINKED_IN_POST", "TWITTER_CREATION_OF_A_POST", "REDDIT_CREATE_REDDIT_POST", "INSTAGRAM_CREATE_POST"]',
 '{"social_media": ["linkedin", "twitter", "reddit", "instagram"], "content": ["post_creation", "scheduling"]}',
 10000),
('Zapier Integration Hub', 'zapier',
 '["google_sheets_append", "slack_send_message", "gmail_send_email", "calendar_create_event"]',
 '{"productivity": ["sheets", "email", "calendar"], "communication": ["slack"]}',
 300)
ON CONFLICT DO NOTHING;

-- =======================
-- VIEWS FOR COMMON QUERIES
-- =======================

-- Brand performance overview
CREATE OR REPLACE VIEW brand_performance_overview AS
SELECT 
    ba.brand_id,
    ba.brand_name,
    ba.client_name,
    ba.status as brand_status,
    COUNT(gc.content_id) as total_content,
    COUNT(CASE WHEN gc.status = 'published' THEN 1 END) as published_content,
    COUNT(CASE WHEN gc.status = 'approved' THEN 1 END) as approved_content,
    AVG(gc.confidence_score) as avg_confidence,
    COUNT(DISTINCT pc.platform) as active_platforms,
    ba.last_active
FROM brand_agents ba
LEFT JOIN generated_content gc ON ba.brand_id = gc.brand_id
LEFT JOIN published_content pc ON gc.content_id = pc.content_id
GROUP BY ba.brand_id, ba.brand_name, ba.client_name, ba.status, ba.last_active;

-- Client dashboard view
CREATE OR REPLACE VIEW client_dashboard AS
SELECT 
    c.client_id,
    c.client_name,
    c.industry,
    c.status as client_status,
    COUNT(ba.brand_id) as total_brands,
    COUNT(CASE WHEN ba.status = 'active' THEN 1 END) as active_brands,
    SUM(CASE WHEN gc.created_at >= CURRENT_DATE THEN 1 ELSE 0 END) as daily_content,
    c.created_at as onboarded_at
FROM clients c
LEFT JOIN brand_agents ba ON c.client_id = ba.client_id
LEFT JOIN generated_content gc ON ba.brand_id = gc.brand_id
GROUP BY c.client_id, c.client_name, c.industry, c.status, c.created_at;

-- Recent activity feed
CREATE OR REPLACE VIEW recent_activity AS
SELECT 
    'content_generated' as activity_type,
    gc.brand_id,
    ba.brand_name,
    ba.client_name,
    gc.content_type as activity_detail,
    gc.created_at as activity_time
FROM generated_content gc
JOIN brand_agents ba ON gc.brand_id = ba.brand_id
WHERE gc.created_at >= CURRENT_DATE - INTERVAL '7 days'

UNION ALL

SELECT 
    'content_published' as activity_type,
    pc.brand_id,
    ba.brand_name,
    ba.client_name,
    pc.platform as activity_detail,
    pc.published_at as activity_time
FROM published_content pc
JOIN brand_agents ba ON pc.brand_id = ba.brand_id
WHERE pc.published_at >= CURRENT_DATE - INTERVAL '7 days'

ORDER BY activity_time DESC;

-- Performance metrics summary
CREATE OR REPLACE VIEW performance_summary AS
SELECT 
    pm.brand_id,
    ba.brand_name,
    ba.client_name,
    pm.platform,
    pm.metric_type,
    pm.metric_value,
    pm.metric_target,
    pm.period_start,
    pm.period_end,
    CASE 
        WHEN pm.metric_target > 0 THEN (pm.metric_value / pm.metric_target) * 100
        ELSE NULL
    END as target_achievement_percentage
FROM performance_metrics pm
JOIN brand_agents ba ON pm.brand_id = ba.brand_id
WHERE pm.period_end >= CURRENT_DATE - INTERVAL '30 days';

COMMENT ON DATABASE IS 'Enhanced Multi-Agent Social Media Management System for Development Agency'; 