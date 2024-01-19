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

 Date: 19/01/2024 00:44:35
*/


-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS "public"."payment";
CREATE TABLE "public"."payment" (
  "id" int4 NOT NULL,
  "payment_uid" uuid NOT NULL,
  "price" int4 NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of payment
-- ----------------------------
INSERT INTO "public"."payment" VALUES (1, '049161bb-badd-44a8-4d90-87c9a82b0778', 1, 'PAID');
INSERT INTO "public"."payment" VALUES (52, '049161bb-badd-44a8-4d90-87c9a82b1278', 3, 'PAID');
INSERT INTO "public"."payment" VALUES (53, '049161bb-badd-44a8-4d90-87c9a82b1448', 4, 'PAID');
INSERT INTO "public"."payment" VALUES (152, '049161bb-badd-44a8-4d90-87c9a82b1888', 888, 'CANCELED');
INSERT INTO "public"."payment" VALUES (202, '049161bb-badd-44a8-4d90-87c9a82b1110', 110, 'CANCELED');
INSERT INTO "public"."payment" VALUES (102, '049161bb-badd-44a8-4d90-87c9a82b1777', 777, 'CANCELED');
INSERT INTO "public"."payment" VALUES (252, '049161bb-badd-44a8-4d90-87c9a82b1888', 110, 'CANCELED');
INSERT INTO "public"."payment" VALUES (2, '049161bb-badd-44a8-4d90-87c9a82b1779', 2, 'PAID');
INSERT INTO "public"."payment" VALUES (302, '049161bb-badd-44a8-4d90-87c9a82b1417', 110, 'CANCELED');
INSERT INTO "public"."payment" VALUES (5, '049161bb-badd-44a8-4d90-87c9a82b1000', 0, 'CANCELED');
INSERT INTO "public"."payment" VALUES (3, '049161bb-badd-44a8-4d90-87c9a82b1951', 951, 'CANCELED');
INSERT INTO "public"."payment" VALUES (6, '049161bb-badd-44a8-4d90-87c9a82b1001', 0, 'CANCELED');
INSERT INTO "public"."payment" VALUES (4, '049161bb-badd-44a8-4d90-87c9a82b1952', 952, 'CANCELED');

-- ----------------------------
-- Checks structure for table payment
-- ----------------------------
ALTER TABLE "public"."payment" ADD CONSTRAINT "payment_status_check" CHECK (status::text = ANY (ARRAY['PAID'::character varying, 'CANCELED'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table payment
-- ----------------------------
ALTER TABLE "public"."payment" ADD CONSTRAINT "payment_pkey" PRIMARY KEY ("id");
