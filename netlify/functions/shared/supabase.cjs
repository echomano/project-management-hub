const { createClient } = require('@supabase/supabase-js')

// Supabase configuration
const supabaseUrl = process.env.SUPABASE_URL
const supabaseKey = process.env.SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.warn('Missing Supabase environment variables. Using fallback in-memory storage.')
}

// Create Supabase client
const supabase = supabaseUrl && supabaseKey ? createClient(supabaseUrl, supabaseKey) : null

// Default project ID (we'll use one project for simplicity)
const DEFAULT_PROJECT_ID = '550e8400-e29b-41d4-a716-446655440000'

// Database service functions
const dbService = {
  // Get all project data
  async getProjectData() {
    if (!supabase) {
      // Fallback to in-memory data if Supabase not configured
      const { projectData } = require('./dataStore.cjs')
      return projectData
    }

    try {
      // Get project info
      const { data: project } = await supabase
        .from('projects')
        .select('*')
        .eq('id', DEFAULT_PROJECT_ID)
        .single()

      if (!project) {
        throw new Error('Project not found')
      }

      // Get all related data
      const [
        { data: prerequisites },
        { data: assetCategories },
        { data: phases },
        { data: milestones },
        { data: calls },
        { data: changeLog }
      ] = await Promise.all([
        supabase.from('prerequisites').select('*').eq('project_id', DEFAULT_PROJECT_ID).order('id'),
        supabase.from('asset_categories').select('*, asset_items(*)').eq('project_id', DEFAULT_PROJECT_ID).order('id'),
        supabase.from('project_phases').select('*, tasks(*)').eq('project_id', DEFAULT_PROJECT_ID).order('id'),
        supabase.from('milestones').select('*').eq('project_id', DEFAULT_PROJECT_ID).order('id'),
        supabase.from('calls').select('*').eq('project_id', DEFAULT_PROJECT_ID).order('id'),
        supabase.from('change_log').select('*').eq('project_id', DEFAULT_PROJECT_ID).order('timestamp', { ascending: false }).limit(50)
      ])

      // Transform data to match frontend format
      return {
        title: project.title,
        period: project.period,
        prerequisites: prerequisites || [],
        assetCategories: assetCategories?.map(cat => ({
          ...cat,
          items: cat.asset_items || []
        })) || [],
        phases: phases?.map(phase => ({
          ...phase,
          name: phase.name,
          tasks: phase.tasks || []
        })) || [],
        milestones: milestones || [],
        calls: calls || [],
        changeLog: changeLog?.map(log => ({
          id: log.id,
          user: log.user_name,
          action: log.action,
          details: log.details,
          timestamp: log.timestamp
        })) || []
      }
    } catch (error) {
      console.error('Database error:', error)
      // Fallback to in-memory data on error
      const { projectData } = require('./dataStore.cjs')
      return projectData
    }
  },

  // Update project data
  async updateProjectData(updates, userName) {
    if (!supabase) {
      // Fallback to in-memory update
      const { projectData, logChange } = require('./dataStore.cjs')
      Object.assign(projectData, updates)
      logChange(userName, 'UPDATE', 'Updated project data')
      return { success: true, timestamp: Date.now() }
    }

    try {
      // Update project basic info if provided
      if (updates.title || updates.period) {
        await supabase
          .from('projects')
          .update({
            title: updates.title,
            period: updates.period
          })
          .eq('id', DEFAULT_PROJECT_ID)
      }

      // Log the change
      await supabase
        .from('change_log')
        .insert({
          project_id: DEFAULT_PROJECT_ID,
          user_name: userName,
          action: 'UPDATE',
          details: 'Updated project data'
        })

      return { success: true, timestamp: Date.now() }
    } catch (error) {
      console.error('Database update error:', error)
      throw error
    }
  },

  // Register user session
  async registerUser(userName) {
    if (!supabase) {
      // Fallback to in-memory
      const { connectedUsers } = require('./dataStore.cjs')
      connectedUsers.add(userName)
      setTimeout(() => connectedUsers.delete(userName), 5 * 60 * 1000)
      return { success: true }
    }

    try {
      await supabase
        .from('connected_users')
        .upsert({
          project_id: DEFAULT_PROJECT_ID,
          user_name: userName,
          last_seen: new Date().toISOString()
        })

      return { success: true }
    } catch (error) {
      console.error('User registration error:', error)
      return { success: false, error: error.message }
    }
  },

  // Get connected users
  async getConnectedUsers() {
    if (!supabase) {
      // Fallback to in-memory
      const { connectedUsers } = require('./dataStore.cjs')
      return { users: Array.from(connectedUsers) }
    }

    try {
      // Get users active in last 5 minutes
      const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000).toISOString()
      
      const { data: users } = await supabase
        .from('connected_users')
        .select('user_name')
        .eq('project_id', DEFAULT_PROJECT_ID)
        .gte('last_seen', fiveMinutesAgo)

      return { users: users?.map(u => u.user_name) || [] }
    } catch (error) {
      console.error('Get users error:', error)
      return { users: [] }
    }
  },

  // Get recent changes
  async getChanges(since = 0) {
    if (!supabase) {
      // Fallback to in-memory
      const { projectData, lastUpdate } = require('./dataStore.cjs')
      const sinceDate = new Date(since)
      return {
        changes: projectData.changeLog.filter(change => 
          new Date(change.timestamp).getTime() > since
        ),
        lastUpdate
      }
    }

    try {
      const sinceDate = new Date(since).toISOString()
      
      const { data: changes } = await supabase
        .from('change_log')
        .select('*')
        .eq('project_id', DEFAULT_PROJECT_ID)
        .gte('timestamp', sinceDate)
        .order('timestamp', { ascending: false })

      return {
        changes: changes?.map(log => ({
          id: log.id,
          user: log.user_name,
          action: log.action,
          details: log.details,
          timestamp: log.timestamp
        })) || [],
        lastUpdate: Date.now()
      }
    } catch (error) {
      console.error('Get changes error:', error)
      return { changes: [], lastUpdate: Date.now() }
    }
  }
}

module.exports = {
  supabase,
  dbService,
  DEFAULT_PROJECT_ID
}