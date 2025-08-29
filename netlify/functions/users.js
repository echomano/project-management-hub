const { dbService } = require('./shared/supabase.cjs')

const handler = async (event, context) => {
  // Enable CORS
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET, OPTIONS'
  }

  // Handle preflight requests
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers,
      body: ''
    }
  }

  if (event.httpMethod !== 'GET') {
    return {
      statusCode: 405,
      headers,
      body: JSON.stringify({ error: 'Method not allowed' })
    }
  }

  try {
    const result = await dbService.getConnectedUsers()
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify(result)
    }
  } catch (error) {
    console.error('Error in users function:', error)
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: 'Failed to get users', details: error.message })
    }
  }
}

module.exports = { handler }