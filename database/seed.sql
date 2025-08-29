-- Seed data for Collaborative Project Management Hub
-- Insert initial project and sample data

-- Insert default project (there should be exactly one project)
INSERT INTO projects (id, title, period) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'Collaborative Project Management Hub', 'September 1 - October 25, 2025')
ON CONFLICT (id) DO UPDATE SET 
    title = EXCLUDED.title,
    period = EXCLUDED.period;

-- Set the project ID variable for subsequent inserts
-- Note: In Supabase, we'll use the fixed UUID above

-- Insert sample prerequisites
INSERT INTO prerequisites (project_id, item, completed, updated_by, comments) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Contract signed and executed', false, 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Domain access credentials received', false, 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Hosting provider details confirmed', false, 'System', '')
ON CONFLICT DO NOTHING;

-- Insert sample asset categories
INSERT INTO asset_categories (project_id, name, updated_by, comments) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Brand Assets', 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Technical Assets', 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Content Assets', 'System', '')
ON CONFLICT DO NOTHING;

-- Insert sample asset items
INSERT INTO asset_items (category_id, item, completed, updated_by, comments) VALUES
((SELECT id FROM asset_categories WHERE name = 'Brand Assets' LIMIT 1), 'Logo files (SVG, PNG, high-res)', false, 'System', ''),
((SELECT id FROM asset_categories WHERE name = 'Brand Assets' LIMIT 1), 'Brand guidelines document', false, 'System', ''),
((SELECT id FROM asset_categories WHERE name = 'Technical Assets' LIMIT 1), 'Development environment setup', false, 'System', ''),
((SELECT id FROM asset_categories WHERE name = 'Technical Assets' LIMIT 1), 'API documentation', false, 'System', ''),
((SELECT id FROM asset_categories WHERE name = 'Content Assets' LIMIT 1), 'Website copy and content', false, 'System', ''),
((SELECT id FROM asset_categories WHERE name = 'Content Assets' LIMIT 1), 'User documentation', false, 'System', '')
ON CONFLICT DO NOTHING;

-- Insert sample project phases
INSERT INTO project_phases (project_id, name, period, updated_by, comments) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Phase 1: Discovery & Planning', 'Sept 1-15, 2025', 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Phase 2: Design & Development', 'Sept 16-Oct 10, 2025', 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Phase 3: Testing & Launch', 'Oct 11-25, 2025', 'System', '')
ON CONFLICT DO NOTHING;

-- Insert sample tasks
INSERT INTO tasks (phase_id, task, assignee, due_date, status, updated_by, comments) VALUES
((SELECT id FROM project_phases WHERE name = 'Phase 1: Discovery & Planning' LIMIT 1), 'Initial consultation call', 'Project Manager', 'Sept 3, 2025', 'not-started', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 1: Discovery & Planning' LIMIT 1), 'Requirements gathering', 'Business Analyst', 'Sept 10, 2025', 'pending', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 1: Discovery & Planning' LIMIT 1), 'Project timeline finalization', 'Project Manager', 'Sept 15, 2025', 'not-started', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 2: Design & Development' LIMIT 1), 'UI/UX Design mockups', 'Designer', 'Sept 25, 2025', 'not-started', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 2: Design & Development' LIMIT 1), 'Frontend development', 'Frontend Developer', 'Oct 5, 2025', 'not-started', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 2: Design & Development' LIMIT 1), 'Backend API development', 'Backend Developer', 'Oct 8, 2025', 'not-started', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 3: Testing & Launch' LIMIT 1), 'Quality assurance testing', 'QA Engineer', 'Oct 18, 2025', 'not-started', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 3: Testing & Launch' LIMIT 1), 'Production deployment', 'DevOps Engineer', 'Oct 22, 2025', 'not-started', 'System', ''),
((SELECT id FROM project_phases WHERE name = 'Phase 3: Testing & Launch' LIMIT 1), 'Go-live and monitoring', 'Project Manager', 'Oct 25, 2025', 'not-started', 'System', '')
ON CONFLICT DO NOTHING;

-- Insert sample milestones
INSERT INTO milestones (project_id, title, description, completed, updated_by, comments) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Project Kickoff', 'Project officially started with all stakeholders aligned', false, 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Requirements Finalized', 'All project requirements documented and approved', false, 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Design Approval', 'UI/UX designs reviewed and approved by stakeholders', false, 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Development Complete', 'All development work finished and code reviewed', false, 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Testing Complete', 'All testing phases completed and bugs resolved', false, 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Project Launch', 'Project successfully launched and live', false, 'System', '')
ON CONFLICT DO NOTHING;

-- Insert sample calls
INSERT INTO calls (project_id, title, status, description, date, attendees, updated_by, comments) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Project Kickoff Call', 'Scheduled', 'Initial project discussion and requirement clarification', 'Sept 1, 2025 2:00 PM EST', 'Client & Project Team', 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Weekly Status Meeting', 'Recurring', 'Weekly project status updates and blockers discussion', 'Every Friday 3:00 PM EST', 'Project Team', 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Design Review Meeting', 'Scheduled', 'Review and approval of UI/UX designs', 'Sept 20, 2025 1:00 PM EST', 'Client, Designer, Project Manager', 'System', ''),
('550e8400-e29b-41d4-a716-446655440000', 'Pre-launch Review', 'Scheduled', 'Final review before project launch', 'Oct 24, 2025 10:00 AM EST', 'All Stakeholders', 'System', '')
ON CONFLICT DO NOTHING;