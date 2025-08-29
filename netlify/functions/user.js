const { dbService } = require('./shared/supabase.cjs')

const handler = async (event, context) => {
  // Enable CORS
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS'
  }

  // Handle preflight requests
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers,
      body: ''
    }
  }

  if (event.httpMethod !== 'POST') {
    return {
      statusCode: 405,
      headers,
      body: JSON.stringify({ error: 'Method not allowed' })
    }
  }

  try {
    const { userName } = JSON.parse(event.body)
    const result = await dbService.registerUser(userName)
    
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify(result)
    }
  } catch (error) {
    console.error('Error in user function:', error)
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: 'Failed to register user', details: error.message })
    }
  }
}

module.exports = { handler }