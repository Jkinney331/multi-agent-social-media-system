-- Multi-Agent Social Media Management System Database Schema
-- PostgreSQL Database Setup

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Brand agents configuration table
CREATE TABLE IF NOT EXISTS brand_agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(50) UNIQUE NOT NULL,
    brand_name VARCHAR(100) NOT NULL,
    workflow_id VARCHAR(100) NOT NULL,
    agent_type VARCHAR(50) NOT NULL DEFAULT 'content_creator',
    active BOOLEAN DEFAULT true,
    voice_id VARCHAR(100), -- ElevenLabs voice ID
    avatar_id VARCHAR(100), -- HeyGen avatar ID
    brand_voice_description TEXT,
    brand_guidelines TEXT,
    target_audience TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agent knowledge base with vector embeddings
CREATE TABLE IF NOT EXISTS agent_knowledge (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(50) NOT NULL,
    category VARCHAR(100) NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding VECTOR(1536), -- OpenAI embedding dimension
    confidence_score FLOAT DEFAULT 0.5,
    source_url TEXT,
    keywords TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand_agents(brand_id)
);

-- Generated content storage
CREATE TABLE IF NOT EXISTS generated_content (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id VARCHAR(100) UNIQUE NOT NULL,
    brand_id VARCHAR(50) NOT NULL,
    brand_name VARCHAR(100) NOT NULL,
    short_post TEXT,
    long_caption TEXT,
    video_script TEXT,
    hashtags JSONB,
    call_to_action TEXT,
    status VARCHAR(50) DEFAULT 'pending_review',
    approved_by VARCHAR(100),
    approved_at TIMESTAMP,
    rejected_by VARCHAR(100),
    rejected_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand_agents(brand_id)
);

-- Published content tracking
CREATE TABLE IF NOT EXISTS published_content (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id VARCHAR(100) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    success BOOLEAN NOT NULL,
    post_id VARCHAR(200),
    post_url TEXT,
    error_message TEXT,
    engagement_metrics JSONB,
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (content_id) REFERENCES generated_content(content_id)
);

-- Learning events for collective intelligence
CREATE TABLE IF NOT EXISTS learning_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id VARCHAR(50),
    event_type VARCHAR(50) NOT NULL,
    learning_data JSONB NOT NULL,
    processed BOOLEAN DEFAULT false,
    confidence_score FLOAT,
    source_user VARCHAR(100),
    source_channel VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand_agents(brand_id)
);

-- Agent communication logs
CREATE TABLE IF NOT EXISTS agent_communications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_agent VARCHAR(50) NOT NULL,
    receiver_agent VARCHAR(50),
    message_type VARCHAR(50) NOT NULL,
    message_content TEXT NOT NULL,
    thread_id VARCHAR(100),
    slack_ts VARCHAR(50),
    status VARCHAR(50) DEFAULT 'sent',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agent meetings and coordination
CREATE TABLE IF NOT EXISTS agent_meetings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    meeting_id VARCHAR(100) UNIQUE NOT NULL,
    meeting_type VARCHAR(50) NOT NULL,
    meeting_date TIMESTAMP NOT NULL,
    performance_summary TEXT,
    learning_insights TEXT,
    recommendations TEXT,
    priority_adjustments TEXT,
    action_items JSONB,
    full_transcript TEXT,
    attendees TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Action items from meetings
CREATE TABLE IF NOT EXISTS action_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    action_id VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium',
    assigned_to VARCHAR(100),
    due_date TIMESTAMP,
    meeting_id VARCHAR(100),
    status VARCHAR(50) DEFAULT 'pending',
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (meeting_id) REFERENCES agent_meetings(meeting_id)
);

-- Agent status tracking
CREATE TABLE IF NOT EXISTS agent_status (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    status VARCHAR(50) NOT NULL,
    last_execution TIMESTAMP,
    execution_count INTEGER DEFAULT 0,
    error_count INTEGER DEFAULT 0,
    last_error TEXT,
    performance_metrics JSONB,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_id) REFERENCES brand_agents(id)
);

-- Content performance analytics
CREATE TABLE IF NOT EXISTS content_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id VARCHAR(100) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    views INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    engagement_rate FLOAT DEFAULT 0,
    reach INTEGER DEFAULT 0,
    collected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (content_id) REFERENCES generated_content(content_id)
);

-- Indexes for performance optimization
CREATE INDEX IF NOT EXISTS idx_brand_agents_brand_id ON brand_agents(brand_id);
CREATE INDEX IF NOT EXISTS idx_agent_knowledge_brand_id ON agent_knowledge(brand_id);
CREATE INDEX IF NOT EXISTS idx_agent_knowledge_embedding ON agent_knowledge USING ivfflat (embedding vector_cosine_ops);
CREATE INDEX IF NOT EXISTS idx_generated_content_brand_id ON generated_content(brand_id);
CREATE INDEX IF NOT EXISTS idx_generated_content_status ON generated_content(status);
CREATE INDEX IF NOT EXISTS idx_generated_content_created_at ON generated_content(created_at);
CREATE INDEX IF NOT EXISTS idx_published_content_content_id ON published_content(content_id);
CREATE INDEX IF NOT EXISTS idx_published_content_platform ON published_content(platform);
CREATE INDEX IF NOT EXISTS idx_learning_events_brand_id ON learning_events(brand_id);
CREATE INDEX IF NOT EXISTS idx_learning_events_event_type ON learning_events(event_type);
CREATE INDEX IF NOT EXISTS idx_learning_events_created_at ON learning_events(created_at);
CREATE INDEX IF NOT EXISTS idx_agent_communications_sender ON agent_communications(sender_agent);
CREATE INDEX IF NOT EXISTS idx_agent_communications_thread_id ON agent_communications(thread_id);
CREATE INDEX IF NOT EXISTS idx_action_items_status ON action_items(status);
CREATE INDEX IF NOT EXISTS idx_action_items_due_date ON action_items(due_date);
CREATE INDEX IF NOT EXISTS idx_content_analytics_content_id ON content_analytics(content_id);

-- Insert initial brand agent configurations
INSERT INTO brand_agents (brand_id, brand_name, workflow_id, agent_type, brand_voice_description, target_audience) VALUES
('humanity-rocks', 'Humanity Rocks', 'brand-agent-humanity-rocks', 'content_creator', 
 'Inspirational and uplifting voice focused on human kindness and community impact. Use warm, encouraging tone.',
 'People interested in positive social change, community builders, activists'),
 
('myreflection', 'MyReflection', 'brand-agent-myreflection', 'content_creator',
 'Thoughtful and introspective voice encouraging personal growth and self-awareness. Use contemplative, supportive tone.',
 'Individuals on personal development journey, mindfulness practitioners, life coaches'),
 
('ft-news', 'FT-News', 'brand-agent-ft-news', 'content_creator',
 'Professional and analytical voice delivering technology and business insights. Use authoritative, informative tone.',
 'Business professionals, tech enthusiasts, entrepreneurs, investors'),
 
('teaching-mom-ai', 'Teaching Mom AI', 'brand-agent-teaching-mom-ai', 'content_creator',
 'Friendly and educational voice making AI accessible for families. Use approachable, patient tone.',
 'Parents, educators, families interested in technology, homeschooling communities'),
 
('infinite-ideas', 'Infinite-Ideas', 'brand-agent-infinite-ideas', 'content_creator',
 'Creative and innovative voice inspiring new thinking and breakthrough ideas. Use energetic, imaginative tone.',
 'Creative professionals, entrepreneurs, innovators, idea seekers')
ON CONFLICT (brand_id) DO NOTHING;

-- Create functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers for updated_at columns
DROP TRIGGER IF EXISTS update_brand_agents_updated_at ON brand_agents;
CREATE TRIGGER update_brand_agents_updated_at BEFORE UPDATE ON brand_agents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_agent_knowledge_updated_at ON agent_knowledge;
CREATE TRIGGER update_agent_knowledge_updated_at BEFORE UPDATE ON agent_knowledge FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_generated_content_updated_at ON generated_content;
CREATE TRIGGER update_generated_content_updated_at BEFORE UPDATE ON generated_content FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_published_content_updated_at ON published_content;
CREATE TRIGGER update_published_content_updated_at BEFORE UPDATE ON published_content FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_agent_status_updated_at ON agent_status;
CREATE TRIGGER update_agent_status_updated_at BEFORE UPDATE ON agent_status FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Views for common queries
CREATE OR REPLACE VIEW v_brand_performance AS
SELECT 
    ba.brand_id,
    ba.brand_name,
    COUNT(gc.id) as total_content_generated,
    COUNT(CASE WHEN gc.status = 'approved' THEN 1 END) as approved_content,
    COUNT(CASE WHEN gc.status = 'rejected' THEN 1 END) as rejected_content,
    ROUND(AVG(CASE WHEN gc.status = 'approved' THEN 1.0 ELSE 0.0 END) * 100, 2) as approval_rate,
    COUNT(pc.id) as total_publications,
    COUNT(CASE WHEN pc.success = true THEN 1 END) as successful_publications
FROM brand_agents ba
LEFT JOIN generated_content gc ON ba.brand_id = gc.brand_id
LEFT JOIN published_content pc ON gc.content_id = pc.content_id
WHERE ba.active = true
GROUP BY ba.brand_id, ba.brand_name;

CREATE OR REPLACE VIEW v_recent_agent_activity AS
SELECT 
    ba.brand_name,
    gc.content_id,
    gc.status,
    gc.created_at,
    pc.platform,
    pc.success as published_successfully,
    le.event_type as latest_learning_event
FROM brand_agents ba
LEFT JOIN generated_content gc ON ba.brand_id = gc.brand_id
LEFT JOIN published_content pc ON gc.content_id = pc.content_id
LEFT JOIN learning_events le ON ba.brand_id = le.brand_id
WHERE gc.created_at >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY gc.created_at DESC;

-- Sample knowledge entries for each brand
INSERT INTO agent_knowledge (brand_id, category, title, content, confidence_score, keywords) VALUES
('humanity-rocks', 'brand_voice', 'Core Message', 
 'Focus on stories of human kindness, community support, and positive social impact. Highlight individuals and organizations making a difference.',
 0.9, ARRAY['kindness', 'community', 'impact', 'stories', 'positive']),
 
('myreflection', 'brand_voice', 'Content Style',
 'Encourage introspection and personal growth through thoughtful questions and gentle guidance. Share mindfulness practices and self-reflection techniques.',
 0.9, ARRAY['reflection', 'mindfulness', 'growth', 'questions', 'guidance']),
 
('ft-news', 'brand_voice', 'Editorial Focus',
 'Provide analysis of technology trends, business strategy, and market insights. Maintain professional tone with data-driven perspectives.',
 0.9, ARRAY['technology', 'business', 'analysis', 'trends', 'data']),
 
('teaching-mom-ai', 'brand_voice', 'Educational Approach',
 'Make AI concepts accessible to families through practical examples and simple explanations. Focus on benefits and addressing concerns.',
 0.9, ARRAY['AI', 'education', 'family', 'practical', 'simple']),
 
('infinite-ideas', 'brand_voice', 'Creative Energy',
 'Inspire creative thinking and innovation through thought-provoking content and idea generation techniques. Encourage experimentation.',
 0.9, ARRAY['creativity', 'innovation', 'ideas', 'inspiration', 'experimentation'])
ON CONFLICT DO NOTHING;

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO n8n_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO n8n_user; 