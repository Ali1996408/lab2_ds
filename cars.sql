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

 Date: 19/01/2024 00:44:21
*/


-- ----------------------------
-- Table structure for cars
-- ----------------------------
DROP TABLE IF EXISTS "public"."cars";
CREATE TABLE "public"."cars" (
  "id" int4 NOT NULL,
  "availability" bool NOT NULL,
  "brand" varchar(80) COLLATE "pg_catalog"."default" NOT NULL,
  "car_uid" uuid NOT NULL,
  "model" varchar(80) COLLATE "pg_catalog"."default" NOT NULL,
  "power" int4,
  "price" int4 NOT NULL,
  "registration_number" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(20) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of cars
-- ----------------------------
INSERT INTO "public"."cars" VALUES (1, 'f', '1', '049161bb-badd-44a8-4d90-87c9a82b0178', '1', 1, 1, '1', 'SUV');
INSERT INTO "public"."cars" VALUES (2, 'f', '2', '049161bb-badd-44a8-4d90-87c9a82b0179', '2', 2, 2, '2', 'SUV');
INSERT INTO "public"."cars" VALUES (3, 'f', '3', '049161bb-badd-44a8-4d90-87c9a82b0180', '3', 3, 3, '3', 'SUV');
INSERT INTO "public"."cars" VALUES (4, 'f', '4', '049161bb-badd-44a8-4d90-87c9a82b0181', '4', 4, 4, '4', 'MINIVAN');
INSERT INTO "public"."cars" VALUES (5, 'f', '5', '049161bb-badd-44a8-4d90-87c9a82b0182', '5', 5, 5, '5', 'ROADSTER');
INSERT INTO "public"."cars" VALUES (6, 'f', '6', '049161bb-badd-44a8-4d90-87c9a82b0183', '6', 6, 6, '6', 'SEDAN');

-- ----------------------------
-- Uniques structure for table cars
-- ----------------------------
ALTER TABLE "public"."cars" ADD CONSTRAINT "uk_24l7j0iex1pa2xa69ivj7a97l" UNIQUE ("car_uid");

-- ----------------------------
-- Checks structure for table cars
-- ----------------------------
ALTER TABLE "public"."cars" ADD CONSTRAINT "cars_type_check" CHECK (type::text = ANY (ARRAY['SEDAN'::character varying, 'SUV'::character varying, 'MINIVAN'::character varying, 'ROADSTER'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table cars
-- ----------------------------
ALTER TABLE "public"."cars" ADD CONSTRAINT "cars_pkey" PRIMARY KEY ("id");
