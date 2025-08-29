# 🚀 Supabase Database Setup Guide

## Step 1: Create Your Supabase Project

1. **Go to [supabase.com](https://supabase.com)**
2. **Sign up/Login** (GitHub login recommended)
3. **Create New Project**:
   - Click "New project"
   - Choose your organization
   - Name: `collaborative-project-hub` (or any name you prefer)
   - Database password: Generate a strong password (save it!)
   - Region: Choose closest to your users
   - Plan: Free tier (generous limits)

## Step 2: Get Your Connection Details

After project creation (takes ~2 minutes):

1. **Go to Project Settings** → **API**
2. **Copy these values**:
   - **Project URL**: `https://your-project.supabase.co`
   - **Anon/Public Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

## Step 3: Set Up Database Schema

1. **Go to SQL Editor** in your Supabase dashboard
2. **Create a new query**
3. **Copy and paste** the contents of `database/schema.sql`
4. **Click "Run"** to create all tables

## Step 4: Add Sample Data (Optional)

1. **In SQL Editor**, create another new query
2. **Copy and paste** the contents of `database/seed.sql`
3. **Click "Run"** to add sample data

## Step 5: Configure Environment Variables

### For Local Development:
1. **Copy** `.env.example` to `.env`
2. **Fill in your values**:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

### For Netlify Deployment:
1. **Netlify Dashboard** → Your Site → **Site Settings** → **Environment Variables**
2. **Add these variables**:
   - `SUPABASE_URL`: Your project URL
   - `SUPABASE_ANON_KEY`: Your anon key

## Step 6: Test the Integration

1. **Restart your local server**:
   ```bash
   ./netlify-start.sh
   ```

2. **Test the API**:
   ```bash
   curl http://localhost:3000/api/data
   ```

3. **Check for database data** (should show your project data from Supabase)

## 🎉 You're Done!

Your project now has:
- ✅ **Persistent PostgreSQL database** (Supabase)
- ✅ **Real-time capabilities** (built into Supabase)
- ✅ **Scalable infrastructure** (auto-scaling)
- ✅ **Free forever tier** (500MB DB, 2GB bandwidth)

## 🔄 Fallback Behavior

If Supabase isn't configured, the app automatically falls back to in-memory storage, so it works either way!

## 🆘 Troubleshooting

**Database connection issues?**
- Check your SUPABASE_URL and SUPABASE_ANON_KEY
- Verify they're set in environment variables
- Check Netlify function logs

**No data showing?**
- Run the seed.sql script in Supabase SQL Editor
- Check if tables were created with schema.sql
- Verify project ID in the database matches the code

**Need help?**
- Check Supabase documentation: https://supabase.com/docs
- Supabase has excellent tutorials and community support