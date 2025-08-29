// Temporary in-memory storage (will be replaced with Supabase)
let projectData = {
  title: 'Collaborative Project Management Hub',
  period: 'September 1 - October 25, 2025',
  prerequisites: [
    { 
      id: 1, 
      item: 'Contract signed and executed', 
      completed: false, 
      updatedBy: 'System', 
      updatedAt: new Date().toISOString(),
      comments: ''
    },
    { 
      id: 2, 
      item: 'Domain access credentials received', 
      completed: false, 
      updatedBy: 'System', 
      updatedAt: new Date().toISOString(),
      comments: ''
    },
    { 
      id: 3, 
      item: 'Hosting provider details confirmed', 
      completed: false, 
      updatedBy: 'System', 
      updatedAt: new Date().toISOString(),
      comments: ''
    }
  ],
  assetCategories: [
    {
      id: 1,
      name: 'Brand Assets',
      updatedBy: 'System',
      updatedAt: new Date().toISOString(),
      comments: '',
      items: [
        { id: 1, item: 'Logo files (SVG, PNG, high-res)', completed: false, updatedBy: 'System', updatedAt: new Date().toISOString(), comments: '' },
        { id: 2, item: 'Brand guidelines document', completed: false, updatedBy: 'System', updatedAt: new Date().toISOString(), comments: '' }
      ]
    }
  ],
  phases: [
    {
      id: 1,
      name: 'Phase 1: Discovery & Planning',
      period: 'Sept 1-15, 2025',
      updatedBy: 'System',
      updatedAt: new Date().toISOString(),
      comments: '',
      tasks: [
        { id: 1, task: 'Initial consultation call', assignee: 'Project Manager', dueDate: 'Sept 3, 2025', status: 'not-started', updatedBy: 'System', updatedAt: new Date().toISOString(), comments: '' },
        { id: 2, task: 'Requirements gathering', assignee: 'Business Analyst', dueDate: 'Sept 10, 2025', status: 'pending', updatedBy: 'System', updatedAt: new Date().toISOString(), comments: '' }
      ]
    }
  ],
  milestones: [
    { 
      id: 1, 
      title: 'Project Kickoff', 
      description: 'Project officially started with all stakeholders aligned', 
      completed: false,
      updatedBy: 'System',
      updatedAt: new Date().toISOString(),
      comments: ''
    },
    { 
      id: 2, 
      title: 'Requirements Finalized', 
      description: 'All project requirements documented and approved', 
      completed: false,
      updatedBy: 'System',
      updatedAt: new Date().toISOString(),
      comments: ''
    }
  ],
  calls: [
    { 
      id: 1, 
      title: 'Project Kickoff Call', 
      status: 'Scheduled', 
      description: 'Initial project discussion and requirement clarification', 
      date: 'Sept 1, 2025 2:00 PM EST', 
      attendees: 'Client & Project Team',
      updatedBy: 'System',
      updatedAt: new Date().toISOString(),
      comments: ''
    }
  ],
  changeLog: []
}

let connectedUsers = new Set()
let lastUpdate = Date.now()

// Simple change logging
function logChange(user, action, details) {
  projectData.changeLog.unshift({
    id: Date.now(),
    user,
    action,
    details,
    timestamp: new Date().toISOString()
  })
  
  // Keep only last 50 changes
  if (projectData.changeLog.length > 50) {
    projectData.changeLog = projectData.changeLog.slice(0, 50)
  }
  
  lastUpdate = Date.now()
}

module.exports = {
  projectData,
  connectedUsers,
  lastUpdate,
  logChange,
  setLastUpdate: (timestamp) => { lastUpdate = timestamp }
}