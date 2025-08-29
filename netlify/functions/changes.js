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
    const since = parseInt(event.queryStringParameters?.since || '0')
    const result = await dbService.getChanges(since)
    
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify(result)
    }
  } catch (error) {
    console.error('Error in changes function:', error)
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: 'Failed to get changes', details: error.message })
    }
  }
}

module.exports = { handler }