const { dbService } = require('./shared/supabase.cjs')

const handler = async (event, context) => {
  // Enable CORS
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
  }

  // Handle preflight requests
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers,
      body: ''
    }
  }

  try {
    if (event.httpMethod === 'GET') {
      const projectData = await dbService.getProjectData()
      return {
        statusCode: 200,
        headers,
        body: JSON.stringify(projectData)
      }
    }

    if (event.httpMethod === 'POST') {
      const { data, user } = JSON.parse(event.body)
      
      const result = await dbService.updateProjectData(data, user || 'Anonymous')
      
      return {
        statusCode: 200,
        headers,
        body: JSON.stringify(result)
      }
    }

    return {
      statusCode: 405,
      headers,
      body: JSON.stringify({ error: 'Method not allowed' })
    }

  } catch (error) {
    console.error('Error in data function:', error)
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: 'Internal server error', details: error.message })
    }
  }
}

module.exports = { handler }