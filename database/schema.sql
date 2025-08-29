-- Collaborative Project Management Hub Database Schema
-- Supabase PostgreSQL Tables

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Projects table (main project info)
CREATE TABLE IF NOT EXISTS projects (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL DEFAULT 'Collaborative Project Management Hub',
    period TEXT NOT NULL DEFAULT 'September 1 - October 25, 2025',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Prerequisites table
CREATE TABLE IF NOT EXISTS prerequisites (
    id SERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    item TEXT NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    updated_by TEXT DEFAULT 'System',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comments TEXT DEFAULT ''
);

-- Asset categories table
CREATE TABLE IF NOT EXISTS asset_categories (
    id SERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    updated_by TEXT DEFAULT 'System',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comments TEXT DEFAULT ''
);

-- Asset items table
CREATE TABLE IF NOT EXISTS asset_items (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES asset_categories(id) ON DELETE CASCADE,
    item TEXT NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    updated_by TEXT DEFAULT 'System',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comments TEXT DEFAULT ''
);

-- Project phases table
CREATE TABLE IF NOT EXISTS project_phases (
    id SERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    period TEXT NOT NULL,
    updated_by TEXT DEFAULT 'System',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comments TEXT DEFAULT ''
);

-- Tasks table
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    phase_id INTEGER REFERENCES project_phases(id) ON DELETE CASCADE,
    task TEXT NOT NULL,
    assignee TEXT DEFAULT 'Unassigned',
    due_date TEXT DEFAULT 'TBD',
    status TEXT DEFAULT 'not-started' CHECK (status IN ('not-started', 'pending', 'progress', 'completed', 'blocked')),
    updated_by TEXT DEFAULT 'System',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comments TEXT DEFAULT ''
);

-- Milestones table
CREATE TABLE IF NOT EXISTS milestones (
    id SERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT DEFAULT '',
    completed BOOLEAN DEFAULT FALSE,
    updated_by TEXT DEFAULT 'System',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comments TEXT DEFAULT ''
);

-- Calls and discussions table
CREATE TABLE IF NOT EXISTS calls (
    id SERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    status TEXT DEFAULT 'Scheduled',
    description TEXT DEFAULT '',
    date TEXT DEFAULT 'TBD',
    attendees TEXT DEFAULT 'TBD',
    updated_by TEXT DEFAULT 'System',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    comments TEXT DEFAULT ''
);

-- Change log table
CREATE TABLE IF NOT EXISTS change_log (
    id SERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    action TEXT NOT NULL,
    details TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Connected users table (for real-time collaboration)
CREATE TABLE IF NOT EXISTS connected_users (
    id SERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(project_id, user_name)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_prerequisites_project_id ON prerequisites(project_id);
CREATE INDEX IF NOT EXISTS idx_asset_categories_project_id ON asset_categories(project_id);
CREATE INDEX IF NOT EXISTS idx_asset_items_category_id ON asset_items(category_id);
CREATE INDEX IF NOT EXISTS idx_project_phases_project_id ON project_phases(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_phase_id ON tasks(phase_id);
CREATE INDEX IF NOT EXISTS idx_milestones_project_id ON milestones(project_id);
CREATE INDEX IF NOT EXISTS idx_calls_project_id ON calls(project_id);
CREATE INDEX IF NOT EXISTS idx_change_log_project_id ON change_log(project_id);
CREATE INDEX IF NOT EXISTS idx_change_log_timestamp ON change_log(timestamp);
CREATE INDEX IF NOT EXISTS idx_connected_users_project_id ON connected_users(project_id);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for auto-updating timestamps
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_prerequisites_updated_at BEFORE UPDATE ON prerequisites FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_asset_categories_updated_at BEFORE UPDATE ON asset_categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_asset_items_updated_at BEFORE UPDATE ON asset_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_project_phases_updated_at BEFORE UPDATE ON project_phases FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_milestones_updated_at BEFORE UPDATE ON milestones FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_calls_updated_at BEFORE UPDATE ON calls FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();