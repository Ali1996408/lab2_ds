/*
 Navicat Premium Data Transfer

 Source Server         : pg-lab1
 Source Server Type    : PostgreSQL
 Source Server Version : 140010
 Source Host           : dpg-cl7pb9avokcc73aommmg-a.frankfurt-postgres.render.com:5432
 Source Catalog        : lab1_fsbs
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 140010
 File Encoding         : 65001

 Date: 19/01/2024 00:44:50
*/


-- ----------------------------
-- Table structure for rental
-- ----------------------------
DROP TABLE IF EXISTS "public"."rental";
CREATE TABLE "public"."rental" (
  "id" int4 NOT NULL,
  "car_uid" uuid NOT NULL,
  "date_from" date,
  "date_to" date,
  "payment_uid" uuid NOT NULL,
  "rental_uid" uuid NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "username" varchar(80) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of rental
-- ----------------------------
INSERT INTO "public"."rental" VALUES (1, '049161bb-badd-44a8-4d90-87c9a82b0124', '2023-12-19', '2023-12-20', '049161bb-badd-44a8-4d90-87c9a82b0125', '049161bb-badd-44a8-4d90-87c9a82b0126', 'FINISHED', '123');
INSERT INTO "public"."rental" VALUES (2, '049161bb-badd-44a8-4d90-87c9a82b0183', '2023-12-13', '2023-12-14', '049161bb-badd-44a8-4d90-87c9a82b1779', '049161bb-badd-44a8-4d90-87c9a82b0999', 'CANCELED', '999');
INSERT INTO "public"."rental" VALUES (3, '049161bb-badd-44a8-4d90-87c9a82b1110', '2023-12-20', '2023-12-28', '049161bb-badd-44a8-4d90-87c9a82b1110', '049161bb-badd-44a8-4d90-87c9a82b1110', 'CANCELED', '110');

-- ----------------------------
-- Uniques structure for table rental
-- ----------------------------
ALTER TABLE "public"."rental" ADD CONSTRAINT "uk_8kdr7rcg161riggih3x1sf0ir" UNIQUE ("rental_uid");

-- ----------------------------
-- Checks structure for table rental
-- ----------------------------
ALTER TABLE "public"."rental" ADD CONSTRAINT "rental_status_check" CHECK (status::text = ANY (ARRAY['IN_PROGRESS'::character varying, 'FINISHED'::character varying, 'CANCELED'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table rental
-- ----------------------------
ALTER TABLE "public"."rental" ADD CONSTRAINT "rental_pkey" PRIMARY KEY ("id");
