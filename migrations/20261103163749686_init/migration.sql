CREATE TABLE "_api_keys" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"key_hash" text NOT NULL,
	"key_prefix" text NOT NULL,
	"role" text NOT NULL,
	"created_by" uuid,
	"expires_at" timestamp with time zone,
	"revoked_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "_api_keys_key_hash_unique" UNIQUE("key_hash")
);
--> statement-breakpoint
CREATE TABLE "_audit_log" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"actor_id" uuid,
	"actor_role" text NOT NULL,
	"action" text NOT NULL,
	"entity_name" text NOT NULL,
	"document_id" uuid NOT NULL,
	"locale" text,
	"changed_fields" jsonb NOT NULL,
	"version_id" uuid
);
--> statement-breakpoint
CREATE TABLE "_auth_token" (
	"auth_request_id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"code_hash" text NOT NULL,
	"email" text NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"attempts" integer DEFAULT 0 NOT NULL,
	"used_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "_file" (
	"_entity" text DEFAULT '_file' NOT NULL,
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"published_at" timestamp with time zone,
	"pending_draft_version_id" uuid,
	"published_version_id" uuid,
	"filename" text NOT NULL,
	"mimeType" text NOT NULL,
	"size" double precision,
	"tags" jsonb,
	"url" text NOT NULL,
	"hash" text NOT NULL,
	"private" boolean DEFAULT false NOT NULL,
	CONSTRAINT "_file_hash_unique" UNIQUE("hash")
);
--> statement-breakpoint
CREATE TABLE "_image" (
	"_entity" text DEFAULT '_image' NOT NULL,
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"published_at" timestamp with time zone,
	"pending_draft_version_id" uuid,
	"published_version_id" uuid,
	"filename" text NOT NULL,
	"mimeType" text NOT NULL,
	"size" double precision,
	"width" double precision,
	"height" double precision,
	"alt" text,
	"tags" jsonb,
	"url" text NOT NULL,
	"hash" text NOT NULL,
	"private" boolean DEFAULT false NOT NULL,
	CONSTRAINT "_image_hash_unique" UNIQUE("hash")
);
--> statement-breakpoint
CREATE TABLE "_sessions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "_slug" (
	"value" text PRIMARY KEY NOT NULL
);
--> statement-breakpoint
CREATE TABLE "_user" (
	"_entity" text DEFAULT '_user' NOT NULL,
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"published_at" timestamp with time zone,
	"pending_draft_version_id" uuid,
	"published_version_id" uuid,
	"email" text NOT NULL,
	"name" text,
	"role" text NOT NULL,
	CONSTRAINT "_user_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "_versions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"entity_name" text NOT NULL,
	"document_id" uuid NOT NULL,
	"data" jsonb NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"created_by" uuid
);
--> statement-breakpoint
CREATE TABLE "_video" (
	"_entity" text DEFAULT '_video' NOT NULL,
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"published_at" timestamp with time zone,
	"pending_draft_version_id" uuid,
	"published_version_id" uuid,
	"filename" text NOT NULL,
	"mimeType" text NOT NULL,
	"size" double precision,
	"width" double precision,
	"height" double precision,
	"tags" jsonb,
	"url" text NOT NULL,
	"hash" text NOT NULL,
	"private" boolean DEFAULT false NOT NULL,
	CONSTRAINT "_video_hash_unique" UNIQUE("hash")
);
--> statement-breakpoint
CREATE TABLE "product_page" (
	"_entity" text DEFAULT 'product_page' NOT NULL,
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	"published_at" timestamp with time zone,
	"pending_draft_version_id" uuid,
	"published_version_id" uuid,
	"product" jsonb NOT NULL,
	"title" text NOT NULL,
	"path" text NOT NULL
);
--> statement-breakpoint
ALTER TABLE "_file" ADD CONSTRAINT "_file_pending_draft_version_id__versions_id_fk" FOREIGN KEY ("pending_draft_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "_file" ADD CONSTRAINT "_file_published_version_id__versions_id_fk" FOREIGN KEY ("published_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "_image" ADD CONSTRAINT "_image_pending_draft_version_id__versions_id_fk" FOREIGN KEY ("pending_draft_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "_image" ADD CONSTRAINT "_image_published_version_id__versions_id_fk" FOREIGN KEY ("published_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "_user" ADD CONSTRAINT "_user_pending_draft_version_id__versions_id_fk" FOREIGN KEY ("pending_draft_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "_user" ADD CONSTRAINT "_user_published_version_id__versions_id_fk" FOREIGN KEY ("published_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "_video" ADD CONSTRAINT "_video_pending_draft_version_id__versions_id_fk" FOREIGN KEY ("pending_draft_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "_video" ADD CONSTRAINT "_video_published_version_id__versions_id_fk" FOREIGN KEY ("published_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_page" ADD CONSTRAINT "product_page_pending_draft_version_id__versions_id_fk" FOREIGN KEY ("pending_draft_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_page" ADD CONSTRAINT "product_page_published_version_id__versions_id_fk" FOREIGN KEY ("published_version_id") REFERENCES "public"."_versions"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_page" ADD CONSTRAINT "product_page_path__slug_value_fk" FOREIGN KEY ("path") REFERENCES "public"."_slug"("value") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "_audit_log_entity_name_document_id_created_at_index" ON "_audit_log" USING btree ("entity_name","document_id","created_at");--> statement-breakpoint
CREATE INDEX "_audit_log_created_at_index" ON "_audit_log" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "_versions_entity_name_document_id_created_at_index" ON "_versions" USING btree ("entity_name","document_id","created_at");
