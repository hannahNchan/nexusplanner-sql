# Nexux Planner - Database Restoration Guide

## Files Description

- `nexuxplanner-backup-20260211-231947.sql` - Complete database dump (schema + data)
- `nexuxplanner-schema-20260211-231955.sql` - Database schema only (tables, indexes, constraints)
- `nexuxplanner-data-20260211-231959.sql` - Data only for public schema tables
- `nexuxplanner-catalogs-20260211-232006.sql` - Catalog tables data (issue_types, priorities, point_systems, point_values, epic_phases)
- `nexuxplanner-catalogs-complete-20260211-232710.sql` - Complete catalog tables with explicit column inserts
- `nexuxplanner-auth-storage-20260211-232010.sql` - Authentication and storage schema
- `nexuxplanner-rls-policies-20260211-232015.sql` - Row Level Security policies

## Quick Restoration (Recommended)

Use this method to restore everything at once.

### Prerequisites

- PostgreSQL 15.x installed
- Supabase instance running
- Database name: `postgres`
- User: `postgres`

### Step 1: Clean Database

```bash
psql -U postgres -d postgres -c "DROP SCHEMA IF EXISTS public CASCADE;"
psql -U postgres -d postgres -c "CREATE SCHEMA public;"
psql -U postgres -d postgres -c "GRANT ALL ON SCHEMA public TO postgres;"
psql -U postgres -d postgres -c "GRANT ALL ON SCHEMA public TO public;"
```

### Step 2: Restore Complete Backup

```bash
psql -U postgres -d postgres < nexuxplanner-backup-20260211-231947.sql
```

This file contains everything: schema, data, auth, storage, and RLS policies.

## Manual Restoration (Step by Step)

Use this method if you need more control over the restoration process.

### Step 1: Restore Schema

```bash
psql -U postgres -d postgres < nexuxplanner-schema-20260211-231955.sql
```

### Step 2: Restore Authentication and Storage

```bash
psql -U postgres -d postgres < nexuxplanner-auth-storage-20260211-232010.sql
```

### Step 3: Restore Catalog Data

```bash
psql -U postgres -d postgres < nexuxplanner-catalogs-complete-20260211-232710.sql
```

### Step 4: Restore Application Data

```bash
psql -U postgres -d postgres < nexuxplanner-data-20260211-231959.sql
```

### Step 5: Restore RLS Policies

```bash
psql -U postgres -d postgres < nexuxplanner-rls-policies-20260211-232015.sql
```

## Docker Supabase Restoration

If using Supabase with Docker:

### Step 1: Find PostgreSQL Container

```bash
docker ps | grep postgres
```

### Step 2: Restore Complete Backup

```bash
docker exec -i <postgres_container_id> psql -U postgres -d postgres < nexuxplanner-backup-20260211-231947.sql
```

Or restore step by step:

```bash
docker exec -i <postgres_container_id> psql -U postgres -d postgres < nexuxplanner-schema-20260211-231955.sql
docker exec -i <postgres_container_id> psql -U postgres -d postgres < nexuxplanner-auth-storage-20260211-232010.sql
docker exec -i <postgres_container_id> psql -U postgres -d postgres < nexuxplanner-catalogs-complete-20260211-232710.sql
docker exec -i <postgres_container_id> psql -U postgres -d postgres < nexuxplanner-data-20260211-231959.sql
docker exec -i <postgres_container_id> psql -U postgres -d postgres < nexuxplanner-rls-policies-20260211-232015.sql
```

## Verification

After restoration, verify the database:

```bash
psql -U postgres -d postgres -c "\dt public.*"
psql -U postgres -d postgres -c "SELECT COUNT(*) FROM public.projects;"
psql -U postgres -d postgres -c "SELECT COUNT(*) FROM public.tasks;"
psql -U postgres -d postgres -c "SELECT COUNT(*) FROM auth.users;"
```

## Catalog Tables Restoration Only

If you only need to restore catalog data (issue types, priorities, point systems, etc.):

```bash
psql -U postgres -d postgres < nexuxplanner-catalogs-complete-20260211-232710.sql
```

This includes:
- issue_types
- priorities
- point_systems
- point_values
- epic_phases

## Troubleshooting

### Error: Role does not exist

```bash
psql -U postgres -d postgres -c "CREATE ROLE supabase_admin WITH LOGIN SUPERUSER;"
```

### Error: Database does not exist

```bash
psql -U postgres -c "CREATE DATABASE postgres;"
```

### Error: Permission denied

Ensure you're using the correct PostgreSQL user with sufficient privileges:

```bash
psql -U postgres
```

### Clear existing data before restoration

```bash
psql -U postgres -d postgres -c "DROP SCHEMA IF EXISTS public CASCADE;"
psql -U postgres -d postgres -c "DROP SCHEMA IF EXISTS auth CASCADE;"
psql -U postgres -d postgres -c "DROP SCHEMA IF EXISTS storage CASCADE;"
psql -U postgres -d postgres -c "CREATE SCHEMA public;"
psql -U postgres -d postgres -c "CREATE SCHEMA auth;"
psql -U postgres -d postgres -c "CREATE SCHEMA storage;"
```

## Notes

- Backup date: 2026-02-11 23:19-23:27 CST
- Database version: PostgreSQL 15.8
- Supabase version: 15.8.1.085
- Total tables: 18 (public schema)
- Auth schema: Users, sessions, and authentication data
- Storage schema: File metadata (files not included)

## Production Deployment

For production environments:

1. Use the complete backup file for fastest restoration
2. Verify all RLS policies are active after restoration
3. Test authentication flow
4. Verify file upload functionality (storage buckets)
5. Check all foreign key constraints
6. Validate all triggers and functions

## Development Setup

For development environments, you may want to restore only schema and catalogs:

```bash
psql -U postgres -d postgres < nexuxplanner-schema-20260211-231955.sql
psql -U postgres -d postgres < nexuxplanner-catalogs-complete-20260211-232710.sql
```

This gives you the structure and reference data without production user data.
