--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: generate_task_id(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_task_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_project_key TEXT;
  v_next_sequence INT;
BEGIN
  -- Solo generar si no tiene task_id_display
  IF NEW.task_id_display IS NULL AND NEW.project_id IS NOT NULL THEN
    -- Obtener project_key y incrementar task_sequence
    UPDATE projects 
    SET task_sequence = task_sequence + 1
    WHERE id = NEW.project_id
    RETURNING project_key, task_sequence INTO v_project_key, v_next_sequence;
    
    -- Generar el task_id_display
    NEW.task_id_display := v_project_key || '-' || v_next_sequence;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.generate_task_id() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: boards; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.boards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.boards OWNER TO supabase_admin;

--
-- Name: column_order; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.column_order (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    board_id uuid,
    column_ids jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    project_id uuid
);


ALTER TABLE public.column_order OWNER TO supabase_admin;

--
-- Name: columns; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.columns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    board_id uuid,
    name text NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    project_id uuid
);


ALTER TABLE public.columns OWNER TO supabase_admin;

--
-- Name: editor_notes; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.editor_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    board_id uuid NOT NULL,
    content jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_manual_save boolean DEFAULT false,
    is_snapshot boolean DEFAULT false
);


ALTER TABLE public.editor_notes OWNER TO supabase_admin;

--
-- Name: epic_dependencies; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.epic_dependencies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    epic_id uuid NOT NULL,
    depends_on_epic_id uuid NOT NULL,
    dependency_type text DEFAULT 'finish-to-start'::text NOT NULL,
    lag_days integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT epic_dependencies_dependency_type_check CHECK ((dependency_type = ANY (ARRAY['finish-to-start'::text, 'start-to-start'::text, 'finish-to-finish'::text, 'start-to-finish'::text]))),
    CONSTRAINT epic_dependencies_no_self_reference CHECK ((epic_id <> depends_on_epic_id))
);


ALTER TABLE public.epic_dependencies OWNER TO supabase_admin;

--
-- Name: epic_phases; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.epic_phases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    color text,
    "position" integer NOT NULL
);


ALTER TABLE public.epic_phases OWNER TO supabase_admin;

--
-- Name: epic_tasks; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.epic_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    epic_id uuid NOT NULL,
    task_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.epic_tasks OWNER TO supabase_admin;

--
-- Name: epics; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.epics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    owner_id uuid,
    phase_id uuid,
    estimated_effort text,
    epic_id_display text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    project_id uuid,
    start_date date,
    end_date date,
    color text
);


ALTER TABLE public.epics OWNER TO supabase_admin;

--
-- Name: issue_types; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.issue_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    icon text,
    color text,
    "position" integer NOT NULL
);


ALTER TABLE public.issue_types OWNER TO supabase_admin;

--
-- Name: point_systems; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.point_systems (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    is_default boolean DEFAULT false
);


ALTER TABLE public.point_systems OWNER TO supabase_admin;

--
-- Name: point_values; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.point_values (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    system_id uuid NOT NULL,
    value text NOT NULL,
    numeric_value integer,
    "position" integer NOT NULL
);


ALTER TABLE public.point_values OWNER TO supabase_admin;

--
-- Name: priorities; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.priorities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    level integer NOT NULL,
    color text,
    "position" integer NOT NULL
);


ALTER TABLE public.priorities OWNER TO supabase_admin;

--
-- Name: project_members; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.project_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role text DEFAULT 'member'::text NOT NULL,
    added_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.project_members OWNER TO supabase_admin;

--
-- Name: project_tags; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.project_tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    tag text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.project_tags OWNER TO supabase_admin;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.projects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    title text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    project_key character varying DEFAULT 'TEMP'::character varying NOT NULL,
    task_sequence integer DEFAULT 0 NOT NULL,
    epic_sequence integer DEFAULT 0 NOT NULL,
    allow_board_task_creation boolean DEFAULT false
);


ALTER TABLE public.projects OWNER TO supabase_admin;

--
-- Name: sprints; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.sprints (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    name text NOT NULL,
    goal text,
    status text DEFAULT 'future'::text NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT sprints_status_check CHECK ((status = ANY (ARRAY['future'::text, 'active'::text, 'closed'::text])))
);


ALTER TABLE public.sprints OWNER TO supabase_admin;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    column_id uuid,
    title text NOT NULL,
    description text,
    "position" integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    issue_type_id uuid,
    priority_id uuid,
    story_points text,
    assignee_id uuid,
    parent_task_id uuid,
    task_id_display character varying,
    in_backlog boolean DEFAULT false NOT NULL,
    project_id uuid,
    github_link text,
    epic_id uuid,
    sprint_id uuid,
    subtitle text
);


ALTER TABLE public.tasks OWNER TO supabase_admin;

--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.user_profiles (
    id uuid NOT NULL,
    full_name text,
    job_title text,
    skills text[],
    organization text,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_profiles OWNER TO supabase_admin;

--
-- Name: boards boards_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: column_order column_order_board_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.column_order
    ADD CONSTRAINT column_order_board_id_key UNIQUE (board_id);


--
-- Name: column_order column_order_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.column_order
    ADD CONSTRAINT column_order_pkey PRIMARY KEY (id);


--
-- Name: column_order column_order_project_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.column_order
    ADD CONSTRAINT column_order_project_id_key UNIQUE (project_id);


--
-- Name: columns columns_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.columns
    ADD CONSTRAINT columns_pkey PRIMARY KEY (id);


--
-- Name: editor_notes editor_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.editor_notes
    ADD CONSTRAINT editor_notes_pkey PRIMARY KEY (id);


--
-- Name: epic_dependencies epic_dependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_dependencies
    ADD CONSTRAINT epic_dependencies_pkey PRIMARY KEY (id);


--
-- Name: epic_dependencies epic_dependencies_unique; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_dependencies
    ADD CONSTRAINT epic_dependencies_unique UNIQUE (epic_id, depends_on_epic_id);


--
-- Name: epic_phases epic_phases_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_phases
    ADD CONSTRAINT epic_phases_name_key UNIQUE (name);


--
-- Name: epic_phases epic_phases_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_phases
    ADD CONSTRAINT epic_phases_pkey PRIMARY KEY (id);


--
-- Name: epic_tasks epic_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_tasks
    ADD CONSTRAINT epic_tasks_pkey PRIMARY KEY (id);


--
-- Name: epics epics_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_pkey PRIMARY KEY (id);


--
-- Name: issue_types issue_types_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.issue_types
    ADD CONSTRAINT issue_types_name_key UNIQUE (name);


--
-- Name: issue_types issue_types_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.issue_types
    ADD CONSTRAINT issue_types_pkey PRIMARY KEY (id);


--
-- Name: point_systems point_systems_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.point_systems
    ADD CONSTRAINT point_systems_name_key UNIQUE (name);


--
-- Name: point_systems point_systems_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.point_systems
    ADD CONSTRAINT point_systems_pkey PRIMARY KEY (id);


--
-- Name: point_values point_values_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.point_values
    ADD CONSTRAINT point_values_pkey PRIMARY KEY (id);


--
-- Name: priorities priorities_name_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.priorities
    ADD CONSTRAINT priorities_name_key UNIQUE (name);


--
-- Name: priorities priorities_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.priorities
    ADD CONSTRAINT priorities_pkey PRIMARY KEY (id);


--
-- Name: project_members project_members_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_pkey PRIMARY KEY (id);


--
-- Name: project_members project_members_project_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_project_id_user_id_key UNIQUE (project_id, user_id);


--
-- Name: project_tags project_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.project_tags
    ADD CONSTRAINT project_tags_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_project_key_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_project_key_key UNIQUE (project_key);


--
-- Name: sprints sprints_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.sprints
    ADD CONSTRAINT sprints_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: idx_epic_dependencies_depends_on_epic_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_epic_dependencies_depends_on_epic_id ON public.epic_dependencies USING btree (depends_on_epic_id);


--
-- Name: idx_epic_dependencies_epic_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_epic_dependencies_epic_id ON public.epic_dependencies USING btree (epic_id);


--
-- Name: idx_project_members_project; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_project_members_project ON public.project_members USING btree (project_id);


--
-- Name: idx_project_members_user; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_project_members_user ON public.project_members USING btree (user_id);


--
-- Name: tasks trigger_generate_task_id; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER trigger_generate_task_id BEFORE INSERT ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.generate_task_id();


--
-- Name: boards boards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: column_order column_order_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.column_order
    ADD CONSTRAINT column_order_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: columns columns_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.columns
    ADD CONSTRAINT columns_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: columns columns_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.columns
    ADD CONSTRAINT columns_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: editor_notes editor_notes_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.editor_notes
    ADD CONSTRAINT editor_notes_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: epic_dependencies epic_dependencies_depends_on_epic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_dependencies
    ADD CONSTRAINT epic_dependencies_depends_on_epic_id_fkey FOREIGN KEY (depends_on_epic_id) REFERENCES public.epics(id) ON DELETE CASCADE;


--
-- Name: epic_dependencies epic_dependencies_epic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_dependencies
    ADD CONSTRAINT epic_dependencies_epic_id_fkey FOREIGN KEY (epic_id) REFERENCES public.epics(id) ON DELETE CASCADE;


--
-- Name: epic_tasks epic_tasks_epic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_tasks
    ADD CONSTRAINT epic_tasks_epic_id_fkey FOREIGN KEY (epic_id) REFERENCES public.epics(id);


--
-- Name: epic_tasks epic_tasks_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epic_tasks
    ADD CONSTRAINT epic_tasks_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: epics epics_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users(id);


--
-- Name: epics epics_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_phase_id_fkey FOREIGN KEY (phase_id) REFERENCES public.epic_phases(id);


--
-- Name: epics epics_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: epics epics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: point_values point_values_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.point_values
    ADD CONSTRAINT point_values_system_id_fkey FOREIGN KEY (system_id) REFERENCES public.point_systems(id);


--
-- Name: project_members project_members_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_added_by_fkey FOREIGN KEY (added_by) REFERENCES auth.users(id);


--
-- Name: project_members project_members_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_members project_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: project_tags project_tags_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.project_tags
    ADD CONSTRAINT project_tags_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects projects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: sprints sprints_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.sprints
    ADD CONSTRAINT sprints_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: tasks tasks_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES auth.users(id);


--
-- Name: tasks tasks_column_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_column_id_fkey FOREIGN KEY (column_id) REFERENCES public.columns(id);


--
-- Name: tasks tasks_epic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_epic_id_fkey FOREIGN KEY (epic_id) REFERENCES public.epics(id);


--
-- Name: tasks tasks_issue_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_issue_type_id_fkey FOREIGN KEY (issue_type_id) REFERENCES public.issue_types(id);


--
-- Name: tasks tasks_parent_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_parent_task_id_fkey FOREIGN KEY (parent_task_id) REFERENCES public.tasks(id);


--
-- Name: tasks tasks_priority_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_priority_id_fkey FOREIGN KEY (priority_id) REFERENCES public.priorities(id);


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: tasks tasks_sprint_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_sprint_id_fkey FOREIGN KEY (sprint_id) REFERENCES public.sprints(id);


--
-- Name: user_profiles user_profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_profiles Authenticated users can view all profiles; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Authenticated users can view all profiles" ON public.user_profiles FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: project_members Project owners can add members; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Project owners can add members" ON public.project_members FOR INSERT WITH CHECK ((project_id IN ( SELECT projects.id
   FROM public.projects
  WHERE (projects.user_id = auth.uid()))));


--
-- Name: project_members Project owners can remove members; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Project owners can remove members" ON public.project_members FOR DELETE USING ((project_id IN ( SELECT projects.id
   FROM public.projects
  WHERE (projects.user_id = auth.uid()))));


--
-- Name: user_profiles Users can insert own profile; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can insert own profile" ON public.user_profiles FOR INSERT WITH CHECK ((id = auth.uid()));


--
-- Name: epic_dependencies Users can manage epic dependencies; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can manage epic dependencies" ON public.epic_dependencies USING ((EXISTS ( SELECT 1
   FROM public.epics
  WHERE ((epics.id = epic_dependencies.epic_id) AND (epics.user_id = auth.uid())))));


--
-- Name: user_profiles Users can update own profile; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can update own profile" ON public.user_profiles FOR UPDATE USING ((id = auth.uid()));


--
-- Name: project_members Users can view members of their projects; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can view members of their projects" ON public.project_members FOR SELECT USING (((user_id = auth.uid()) OR (project_id IN ( SELECT projects.id
   FROM public.projects
  WHERE (projects.user_id = auth.uid())))));


--
-- Name: epic_dependencies; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.epic_dependencies ENABLE ROW LEVEL SECURITY;

--
-- Name: project_members; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;

--
-- Name: user_profiles; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION generate_task_id(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.generate_task_id() TO postgres;
GRANT ALL ON FUNCTION public.generate_task_id() TO anon;
GRANT ALL ON FUNCTION public.generate_task_id() TO authenticated;
GRANT ALL ON FUNCTION public.generate_task_id() TO service_role;


--
-- Name: TABLE boards; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.boards TO postgres;
GRANT ALL ON TABLE public.boards TO anon;
GRANT ALL ON TABLE public.boards TO authenticated;
GRANT ALL ON TABLE public.boards TO service_role;


--
-- Name: TABLE column_order; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.column_order TO postgres;
GRANT ALL ON TABLE public.column_order TO anon;
GRANT ALL ON TABLE public.column_order TO authenticated;
GRANT ALL ON TABLE public.column_order TO service_role;


--
-- Name: TABLE columns; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.columns TO postgres;
GRANT ALL ON TABLE public.columns TO anon;
GRANT ALL ON TABLE public.columns TO authenticated;
GRANT ALL ON TABLE public.columns TO service_role;


--
-- Name: TABLE editor_notes; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.editor_notes TO postgres;
GRANT ALL ON TABLE public.editor_notes TO anon;
GRANT ALL ON TABLE public.editor_notes TO authenticated;
GRANT ALL ON TABLE public.editor_notes TO service_role;


--
-- Name: TABLE epic_dependencies; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.epic_dependencies TO postgres;
GRANT ALL ON TABLE public.epic_dependencies TO anon;
GRANT ALL ON TABLE public.epic_dependencies TO authenticated;
GRANT ALL ON TABLE public.epic_dependencies TO service_role;


--
-- Name: TABLE epic_phases; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.epic_phases TO postgres;
GRANT ALL ON TABLE public.epic_phases TO anon;
GRANT ALL ON TABLE public.epic_phases TO authenticated;
GRANT ALL ON TABLE public.epic_phases TO service_role;


--
-- Name: TABLE epic_tasks; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.epic_tasks TO postgres;
GRANT ALL ON TABLE public.epic_tasks TO anon;
GRANT ALL ON TABLE public.epic_tasks TO authenticated;
GRANT ALL ON TABLE public.epic_tasks TO service_role;


--
-- Name: TABLE epics; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.epics TO postgres;
GRANT ALL ON TABLE public.epics TO anon;
GRANT ALL ON TABLE public.epics TO authenticated;
GRANT ALL ON TABLE public.epics TO service_role;


--
-- Name: TABLE issue_types; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.issue_types TO postgres;
GRANT ALL ON TABLE public.issue_types TO anon;
GRANT ALL ON TABLE public.issue_types TO authenticated;
GRANT ALL ON TABLE public.issue_types TO service_role;


--
-- Name: TABLE point_systems; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.point_systems TO postgres;
GRANT ALL ON TABLE public.point_systems TO anon;
GRANT ALL ON TABLE public.point_systems TO authenticated;
GRANT ALL ON TABLE public.point_systems TO service_role;


--
-- Name: TABLE point_values; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.point_values TO postgres;
GRANT ALL ON TABLE public.point_values TO anon;
GRANT ALL ON TABLE public.point_values TO authenticated;
GRANT ALL ON TABLE public.point_values TO service_role;


--
-- Name: TABLE priorities; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.priorities TO postgres;
GRANT ALL ON TABLE public.priorities TO anon;
GRANT ALL ON TABLE public.priorities TO authenticated;
GRANT ALL ON TABLE public.priorities TO service_role;


--
-- Name: TABLE project_members; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.project_members TO postgres;
GRANT ALL ON TABLE public.project_members TO anon;
GRANT ALL ON TABLE public.project_members TO authenticated;
GRANT ALL ON TABLE public.project_members TO service_role;


--
-- Name: TABLE project_tags; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.project_tags TO postgres;
GRANT ALL ON TABLE public.project_tags TO anon;
GRANT ALL ON TABLE public.project_tags TO authenticated;
GRANT ALL ON TABLE public.project_tags TO service_role;


--
-- Name: TABLE projects; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.projects TO postgres;
GRANT ALL ON TABLE public.projects TO anon;
GRANT ALL ON TABLE public.projects TO authenticated;
GRANT ALL ON TABLE public.projects TO service_role;


--
-- Name: TABLE sprints; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.sprints TO postgres;
GRANT ALL ON TABLE public.sprints TO anon;
GRANT ALL ON TABLE public.sprints TO authenticated;
GRANT ALL ON TABLE public.sprints TO service_role;


--
-- Name: TABLE tasks; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.tasks TO postgres;
GRANT ALL ON TABLE public.tasks TO anon;
GRANT ALL ON TABLE public.tasks TO authenticated;
GRANT ALL ON TABLE public.tasks TO service_role;


--
-- Name: TABLE user_profiles; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.user_profiles TO postgres;
GRANT ALL ON TABLE public.user_profiles TO anon;
GRANT ALL ON TABLE public.user_profiles TO authenticated;
GRANT ALL ON TABLE public.user_profiles TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- PostgreSQL database dump complete
--

