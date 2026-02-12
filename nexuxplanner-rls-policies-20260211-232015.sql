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

