/*
 Navicat Premium Data Transfer

 Source Server         : 小微
 Source Server Type    : SQLite
 Source Server Version : 3021000
 Source Schema         : main

 Target Server Type    : SQLite
 Target Server Version : 3021000
 File Encoding         : 65001

 Date: 11/04/2019 23:19:27
*/

PRAGMA foreign_keys = false;

-- ----------------------------
-- Table structure for actives
-- ----------------------------
DROP TABLE IF EXISTS "actives";
CREATE TABLE "actives" (
  "id" INTEGER NOT NULL,
  "text" VARCHAR(32),
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Records of actives
-- ----------------------------
INSERT INTO "actives" VALUES (1, '满减');
INSERT INTO "actives" VALUES (2, '新店优惠');
INSERT INTO "actives" VALUES (3, '折扣商品');
INSERT INTO "actives" VALUES (4, '满返代金券');
INSERT INTO "actives" VALUES (5, '新用户');
INSERT INTO "actives" VALUES (6, '减配送费');
INSERT INTO "actives" VALUES (7, '领代金券');
INSERT INTO "actives" VALUES (8, '赠送商品');

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS "alembic_version";
CREATE TABLE "alembic_version" (
  "version_num" VARCHAR(32) NOT NULL,
  CONSTRAINT "alembic_version_pkc" PRIMARY KEY ("version_num")
);

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO "alembic_version" VALUES ('b29100851207');

-- ----------------------------
-- Table structure for carousel
-- ----------------------------
DROP TABLE IF EXISTS "carousel";
CREATE TABLE "carousel" (
  "id" INTEGER NOT NULL,
  "name" VARCHAR(32),
  "link" VARCHAR(255),
  "imagePath" VARCHAR(255),
  "publicMsg" VARCHAR(255),
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Records of carousel
-- ----------------------------
INSERT INTO "carousel" VALUES (2, '竹林香米线', NULL, 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', '这是一碗蓝朋友剥好的小龙虾');
INSERT INTO "carousel" VALUES (3, '干锅牛蛙', NULL, 'uploadFile/006fVSiZgy1fsp0pmgy9sj30u00u0jza.jpg', '这是一碗蓝朋友剥好的小龙虾');
INSERT INTO "carousel" VALUES (4, '黄焖鸡米饭', NULL, 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', '这是一碗蓝朋友剥好的小龙虾');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS "category";
CREATE TABLE "category" (
  "id" INTEGER NOT NULL,
  "category_name" VARCHAR(32),
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO "category" VALUES (1, '热销🔥');
INSERT INTO "category" VALUES (2, '大菜🐷');
INSERT INTO "category" VALUES (3, '小菜🍽');
INSERT INTO "category" VALUES (4, '饮料🍹');
INSERT INTO "category" VALUES (5, '主食🍚');
INSERT INTO "category" VALUES (6, '凉菜🥙');
INSERT INTO "category" VALUES (7, '凉拌菜🥗');
INSERT INTO "category" VALUES (8, '黄焖鸡🐣');
INSERT INTO "category" VALUES (9, '糕点🧀');
INSERT INTO "category" VALUES (10, '零食甜点🍭');
INSERT INTO "category" VALUES (11, '鲜花🌸');

-- ----------------------------
-- Table structure for coupon
-- ----------------------------
DROP TABLE IF EXISTS "coupon";
CREATE TABLE "coupon" (
  "id" INTEGER NOT NULL,
  "coupon_name" VARCHAR(32),
  "coupon_num" INTEGER,
  "coupon_content" TEXT,
  "beginTime" DATETIME,
  "endTime" DATETIME,
  "store_id" INTEGER,
  "actives_id" INTEGER,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("actives_id") REFERENCES "actives" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ("store_id") REFERENCES "store" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- ----------------------------
-- Records of coupon
-- ----------------------------
INSERT INTO "coupon" VALUES (1, '测试卷', 100, '满20减19；满200减199；满1000减999；', NULL, NULL, 2, 1);
INSERT INTO "coupon" VALUES (2, '测试卷', 100, '本店新用户立减1元', NULL, NULL, 2, 2);
INSERT INTO "coupon" VALUES (3, '测试卷', 100, '折扣商品9折起', NULL, NULL, 2, 3);
INSERT INTO "coupon" VALUES (4, '测试卷', 100, '满20减19；满200减199；满1000减999；', NULL, NULL, 3, 1);
INSERT INTO "coupon" VALUES (5, '测试卷', 100, '本店新用户立减1元', NULL, NULL, 3, 2);
INSERT INTO "coupon" VALUES (6, '测试卷', 100, '折扣商品9折起', NULL, NULL, 3, 3);
INSERT INTO "coupon" VALUES (7, '测试卷', 100, '满20减19；满200减199；满1000减999；', NULL, NULL, 4, 1);
INSERT INTO "coupon" VALUES (8, '测试卷', 100, '本店新用户立减1元', NULL, NULL, 4, 2);
INSERT INTO "coupon" VALUES (9, '测试卷', 100, '折扣商品9折起', NULL, NULL, 4, 3);
INSERT INTO "coupon" VALUES (10, '测试卷', 100, '满20减19；满200减199；满1000减999；', NULL, NULL, 5, 1);
INSERT INTO "coupon" VALUES (11, '测试卷', 100, '本店新用户立减1元', NULL, NULL, 5, 2);
INSERT INTO "coupon" VALUES (12, '测试卷', 100, '折扣商品9折起', NULL, NULL, 5, 3);
INSERT INTO "coupon" VALUES (13, '测试卷', 100, '满20减19；满200减199；满1000减999；', NULL, NULL, 6, 1);
INSERT INTO "coupon" VALUES (14, '测试卷', 100, '本店新用户立减1元', NULL, NULL, 6, 2);
INSERT INTO "coupon" VALUES (15, '测试卷', 100, '折扣商品9折起', NULL, NULL, 6, 3);
INSERT INTO "coupon" VALUES (16, '测试卷', 100, '满20减19；满200减199；满1000减999；', NULL, NULL, 7, 1);
INSERT INTO "coupon" VALUES (17, '测试卷', 100, '本店新用户立减1元', NULL, NULL, 7, 2);
INSERT INTO "coupon" VALUES (18, '测试卷', 100, '折扣商品9折起', NULL, NULL, 7, 3);

-- ----------------------------
-- Table structure for dish
-- ----------------------------
DROP TABLE IF EXISTS "dish";
CREATE TABLE "dish" (
  "id" INTEGER NOT NULL,
  "dish_name" VARCHAR(32),
  "dish_price" FLOAT,
  "dish_description" VARCHAR(255),
  "imagePath" VARCHAR(255),
  "store_id" INTEGER,
  "category_id" INTEGER,
  "onSale" BOOLEAN,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("category_id") REFERENCES "category" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ("store_id") REFERENCES "store" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
   ("onSale" IN (0, 1))
);

-- ----------------------------
-- Records of dish
-- ----------------------------
INSERT INTO "dish" VALUES (1, '糖醋里脊', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pqj7pnj30ja0jbdju.jpg', 2, 1, NULL);
INSERT INTO "dish" VALUES (2, '回锅肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 1, NULL);
INSERT INTO "dish" VALUES (3, '东坡肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 1, NULL);
INSERT INTO "dish" VALUES (4, '水煮牛肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 2, NULL);
INSERT INTO "dish" VALUES (5, '红烧肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 2, NULL);
INSERT INTO "dish" VALUES (6, '清蒸鱼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 2, NULL);
INSERT INTO "dish" VALUES (7, '鱼香肉丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 3, NULL);
INSERT INTO "dish" VALUES (8, '土豆丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 3, NULL);
INSERT INTO "dish" VALUES (9, '拍黄瓜', 23.0, '这是菜', 'uploadFile/HTB1cnIlBntYBeNjy1Xdq6xXyVXay.jpg', 2, 3, NULL);
INSERT INTO "dish" VALUES (10, '可乐', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pia570j30u00u0wjl.jpg', 2, 4, NULL);
INSERT INTO "dish" VALUES (11, '雪碧', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', 2, 4, NULL);
INSERT INTO "dish" VALUES (12, '美年达', 3.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 4, NULL);
INSERT INTO "dish" VALUES (13, '馒头', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', 2, 5, NULL);
INSERT INTO "dish" VALUES (14, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 5, NULL);
INSERT INTO "dish" VALUES (15, '煎饼', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0prtcq1j30u011itjq.jpg', 2, 5, NULL);
INSERT INTO "dish" VALUES (16, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 6, NULL);
INSERT INTO "dish" VALUES (17, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 6, NULL);
INSERT INTO "dish" VALUES (18, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 6, NULL);
INSERT INTO "dish" VALUES (19, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 7, NULL);
INSERT INTO "dish" VALUES (20, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 7, NULL);
INSERT INTO "dish" VALUES (21, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 7, NULL);
INSERT INTO "dish" VALUES (22, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 8, NULL);
INSERT INTO "dish" VALUES (23, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 8, NULL);
INSERT INTO "dish" VALUES (24, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 8, NULL);
INSERT INTO "dish" VALUES (25, '桂花糕', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 2, 9, NULL);
INSERT INTO "dish" VALUES (26, '小羊糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsslnd5csaj30tp0w4107.jpg', 2, 9, NULL);
INSERT INTO "dish" VALUES (27, '❄雪花糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fst0ycqnycj30u00u1acp.jpg', 2, 9, NULL);
INSERT INTO "dish" VALUES (28, '鼠片', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 2, 10, NULL);
INSERT INTO "dish" VALUES (29, '辣条', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsskxmaf46j30rm0rmgto.jpg', 2, 10, NULL);
INSERT INTO "dish" VALUES (30, '豆干', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 2, 10, NULL);
INSERT INTO "dish" VALUES (31, '红玫瑰🌹', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 2, 11, NULL);
INSERT INTO "dish" VALUES (32, '粉玫瑰🌷', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 11, NULL);
INSERT INTO "dish" VALUES (33, '白玫瑰🌼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 2, 11, NULL);
INSERT INTO "dish" VALUES (34, '糖醋里脊', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pqj7pnj30ja0jbdju.jpg', 3, 1, NULL);
INSERT INTO "dish" VALUES (35, '回锅肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 1, NULL);
INSERT INTO "dish" VALUES (36, '东坡肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 1, NULL);
INSERT INTO "dish" VALUES (37, '水煮牛肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 2, NULL);
INSERT INTO "dish" VALUES (38, '红烧肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 2, NULL);
INSERT INTO "dish" VALUES (39, '清蒸鱼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 2, NULL);
INSERT INTO "dish" VALUES (40, '鱼香肉丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 3, NULL);
INSERT INTO "dish" VALUES (41, '土豆丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 3, NULL);
INSERT INTO "dish" VALUES (42, '拍黄瓜', 23.0, '这是菜', 'uploadFile/HTB1cnIlBntYBeNjy1Xdq6xXyVXay.jpg', 3, 3, NULL);
INSERT INTO "dish" VALUES (43, '可乐', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pia570j30u00u0wjl.jpg', 3, 4, NULL);
INSERT INTO "dish" VALUES (44, '雪碧', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', 3, 4, NULL);
INSERT INTO "dish" VALUES (45, '美年达', 3.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 4, NULL);
INSERT INTO "dish" VALUES (46, '馒头', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', 3, 5, NULL);
INSERT INTO "dish" VALUES (47, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 5, NULL);
INSERT INTO "dish" VALUES (48, '煎饼', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0prtcq1j30u011itjq.jpg', 3, 5, NULL);
INSERT INTO "dish" VALUES (49, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 6, NULL);
INSERT INTO "dish" VALUES (50, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 6, NULL);
INSERT INTO "dish" VALUES (51, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 6, NULL);
INSERT INTO "dish" VALUES (52, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 7, NULL);
INSERT INTO "dish" VALUES (53, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 7, NULL);
INSERT INTO "dish" VALUES (54, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 7, NULL);
INSERT INTO "dish" VALUES (55, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 8, NULL);
INSERT INTO "dish" VALUES (56, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 8, NULL);
INSERT INTO "dish" VALUES (57, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 8, NULL);
INSERT INTO "dish" VALUES (58, '桂花糕', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 3, 9, NULL);
INSERT INTO "dish" VALUES (59, '小羊糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsslnd5csaj30tp0w4107.jpg', 3, 9, NULL);
INSERT INTO "dish" VALUES (60, '❄雪花糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fst0ycqnycj30u00u1acp.jpg', 3, 9, NULL);
INSERT INTO "dish" VALUES (61, '鼠片', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 3, 10, NULL);
INSERT INTO "dish" VALUES (62, '辣条', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsskxmaf46j30rm0rmgto.jpg', 3, 10, NULL);
INSERT INTO "dish" VALUES (63, '豆干', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 3, 10, NULL);
INSERT INTO "dish" VALUES (64, '红玫瑰🌹', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 3, 11, NULL);
INSERT INTO "dish" VALUES (65, '粉玫瑰🌷', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 11, NULL);
INSERT INTO "dish" VALUES (66, '白玫瑰🌼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 3, 11, NULL);
INSERT INTO "dish" VALUES (67, '糖醋里脊', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pqj7pnj30ja0jbdju.jpg', 4, 1, NULL);
INSERT INTO "dish" VALUES (68, '回锅肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 1, NULL);
INSERT INTO "dish" VALUES (69, '东坡肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 1, NULL);
INSERT INTO "dish" VALUES (70, '水煮牛肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 2, NULL);
INSERT INTO "dish" VALUES (71, '红烧肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 2, NULL);
INSERT INTO "dish" VALUES (72, '清蒸鱼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 2, NULL);
INSERT INTO "dish" VALUES (73, '鱼香肉丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 3, NULL);
INSERT INTO "dish" VALUES (74, '土豆丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 3, NULL);
INSERT INTO "dish" VALUES (75, '拍黄瓜', 23.0, '这是菜', 'uploadFile/HTB1cnIlBntYBeNjy1Xdq6xXyVXay.jpg', 4, 3, NULL);
INSERT INTO "dish" VALUES (76, '可乐', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pia570j30u00u0wjl.jpg', 4, 4, NULL);
INSERT INTO "dish" VALUES (77, '雪碧', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', 4, 4, NULL);
INSERT INTO "dish" VALUES (78, '美年达', 3.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 4, NULL);
INSERT INTO "dish" VALUES (79, '馒头', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', 4, 5, NULL);
INSERT INTO "dish" VALUES (80, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 5, NULL);
INSERT INTO "dish" VALUES (81, '煎饼', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0prtcq1j30u011itjq.jpg', 4, 5, NULL);
INSERT INTO "dish" VALUES (82, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 6, NULL);
INSERT INTO "dish" VALUES (83, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 6, NULL);
INSERT INTO "dish" VALUES (84, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 6, NULL);
INSERT INTO "dish" VALUES (85, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 7, NULL);
INSERT INTO "dish" VALUES (86, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 7, NULL);
INSERT INTO "dish" VALUES (87, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 7, NULL);
INSERT INTO "dish" VALUES (88, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 8, NULL);
INSERT INTO "dish" VALUES (89, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 8, NULL);
INSERT INTO "dish" VALUES (90, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 8, NULL);
INSERT INTO "dish" VALUES (91, '桂花糕', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 4, 9, NULL);
INSERT INTO "dish" VALUES (92, '小羊糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsslnd5csaj30tp0w4107.jpg', 4, 9, NULL);
INSERT INTO "dish" VALUES (93, '❄雪花糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fst0ycqnycj30u00u1acp.jpg', 4, 9, NULL);
INSERT INTO "dish" VALUES (94, '鼠片', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 4, 10, NULL);
INSERT INTO "dish" VALUES (95, '辣条', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsskxmaf46j30rm0rmgto.jpg', 4, 10, NULL);
INSERT INTO "dish" VALUES (96, '豆干', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 4, 10, NULL);
INSERT INTO "dish" VALUES (97, '红玫瑰🌹', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 4, 11, NULL);
INSERT INTO "dish" VALUES (98, '粉玫瑰🌷', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 11, NULL);
INSERT INTO "dish" VALUES (99, '白玫瑰🌼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 4, 11, NULL);
INSERT INTO "dish" VALUES (100, '糖醋里脊', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pqj7pnj30ja0jbdju.jpg', 5, 1, NULL);
INSERT INTO "dish" VALUES (101, '回锅肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 1, NULL);
INSERT INTO "dish" VALUES (102, '东坡肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 1, NULL);
INSERT INTO "dish" VALUES (103, '水煮牛肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 2, NULL);
INSERT INTO "dish" VALUES (104, '红烧肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 2, NULL);
INSERT INTO "dish" VALUES (105, '清蒸鱼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 2, NULL);
INSERT INTO "dish" VALUES (106, '鱼香肉丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 3, NULL);
INSERT INTO "dish" VALUES (107, '土豆丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 3, NULL);
INSERT INTO "dish" VALUES (108, '拍黄瓜', 23.0, '这是菜', 'uploadFile/HTB1cnIlBntYBeNjy1Xdq6xXyVXay.jpg', 5, 3, NULL);
INSERT INTO "dish" VALUES (109, '可乐', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pia570j30u00u0wjl.jpg', 5, 4, NULL);
INSERT INTO "dish" VALUES (110, '雪碧', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', 5, 4, NULL);
INSERT INTO "dish" VALUES (111, '美年达', 3.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 4, NULL);
INSERT INTO "dish" VALUES (112, '馒头', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', 5, 5, NULL);
INSERT INTO "dish" VALUES (113, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 5, NULL);
INSERT INTO "dish" VALUES (114, '煎饼', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0prtcq1j30u011itjq.jpg', 5, 5, NULL);
INSERT INTO "dish" VALUES (115, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 6, NULL);
INSERT INTO "dish" VALUES (116, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 6, NULL);
INSERT INTO "dish" VALUES (117, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 6, NULL);
INSERT INTO "dish" VALUES (118, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 7, NULL);
INSERT INTO "dish" VALUES (119, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 7, NULL);
INSERT INTO "dish" VALUES (120, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 7, NULL);
INSERT INTO "dish" VALUES (121, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 8, NULL);
INSERT INTO "dish" VALUES (122, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 8, NULL);
INSERT INTO "dish" VALUES (123, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 8, NULL);
INSERT INTO "dish" VALUES (124, '桂花糕', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 5, 9, NULL);
INSERT INTO "dish" VALUES (125, '小羊糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsslnd5csaj30tp0w4107.jpg', 5, 9, NULL);
INSERT INTO "dish" VALUES (126, '❄雪花糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fst0ycqnycj30u00u1acp.jpg', 5, 9, NULL);
INSERT INTO "dish" VALUES (127, '鼠片', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 5, 10, NULL);
INSERT INTO "dish" VALUES (128, '辣条', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsskxmaf46j30rm0rmgto.jpg', 5, 10, NULL);
INSERT INTO "dish" VALUES (129, '豆干', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 5, 10, NULL);
INSERT INTO "dish" VALUES (130, '红玫瑰🌹', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 5, 11, NULL);
INSERT INTO "dish" VALUES (131, '粉玫瑰🌷', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 11, NULL);
INSERT INTO "dish" VALUES (132, '白玫瑰🌼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 5, 11, NULL);
INSERT INTO "dish" VALUES (133, '糖醋里脊', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pqj7pnj30ja0jbdju.jpg', 6, 1, NULL);
INSERT INTO "dish" VALUES (134, '回锅肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 1, NULL);
INSERT INTO "dish" VALUES (135, '东坡肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 1, NULL);
INSERT INTO "dish" VALUES (136, '水煮牛肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 2, NULL);
INSERT INTO "dish" VALUES (137, '红烧肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 2, NULL);
INSERT INTO "dish" VALUES (138, '清蒸鱼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 2, NULL);
INSERT INTO "dish" VALUES (139, '鱼香肉丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 3, NULL);
INSERT INTO "dish" VALUES (140, '土豆丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 3, NULL);
INSERT INTO "dish" VALUES (141, '拍黄瓜', 23.0, '这是菜', 'uploadFile/HTB1cnIlBntYBeNjy1Xdq6xXyVXay.jpg', 6, 3, NULL);
INSERT INTO "dish" VALUES (142, '可乐', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pia570j30u00u0wjl.jpg', 6, 4, NULL);
INSERT INTO "dish" VALUES (143, '雪碧', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', 6, 4, NULL);
INSERT INTO "dish" VALUES (144, '美年达', 3.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 4, NULL);
INSERT INTO "dish" VALUES (145, '馒头', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', 6, 5, NULL);
INSERT INTO "dish" VALUES (146, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 5, NULL);
INSERT INTO "dish" VALUES (147, '煎饼', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0prtcq1j30u011itjq.jpg', 6, 5, NULL);
INSERT INTO "dish" VALUES (148, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 6, NULL);
INSERT INTO "dish" VALUES (149, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 6, NULL);
INSERT INTO "dish" VALUES (150, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 6, NULL);
INSERT INTO "dish" VALUES (151, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 7, NULL);
INSERT INTO "dish" VALUES (152, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 7, NULL);
INSERT INTO "dish" VALUES (153, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 7, NULL);
INSERT INTO "dish" VALUES (154, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 8, NULL);
INSERT INTO "dish" VALUES (155, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 8, NULL);
INSERT INTO "dish" VALUES (156, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 8, NULL);
INSERT INTO "dish" VALUES (157, '桂花糕', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 6, 9, NULL);
INSERT INTO "dish" VALUES (158, '小羊糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsslnd5csaj30tp0w4107.jpg', 6, 9, NULL);
INSERT INTO "dish" VALUES (159, '❄雪花糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fst0ycqnycj30u00u1acp.jpg', 6, 9, NULL);
INSERT INTO "dish" VALUES (160, '鼠片', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 6, 10, NULL);
INSERT INTO "dish" VALUES (161, '辣条', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsskxmaf46j30rm0rmgto.jpg', 6, 10, NULL);
INSERT INTO "dish" VALUES (162, '豆干', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 6, 10, NULL);
INSERT INTO "dish" VALUES (163, '红玫瑰🌹', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 6, 11, NULL);
INSERT INTO "dish" VALUES (164, '粉玫瑰🌷', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 11, NULL);
INSERT INTO "dish" VALUES (165, '白玫瑰🌼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 6, 11, NULL);
INSERT INTO "dish" VALUES (166, '糖醋里脊', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pqj7pnj30ja0jbdju.jpg', 7, 1, NULL);
INSERT INTO "dish" VALUES (167, '回锅肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 1, NULL);
INSERT INTO "dish" VALUES (168, '东坡肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 1, NULL);
INSERT INTO "dish" VALUES (169, '水煮牛肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 2, NULL);
INSERT INTO "dish" VALUES (170, '红烧肉', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 2, NULL);
INSERT INTO "dish" VALUES (171, '清蒸鱼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 2, NULL);
INSERT INTO "dish" VALUES (172, '鱼香肉丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 3, NULL);
INSERT INTO "dish" VALUES (173, '土豆丝', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 3, NULL);
INSERT INTO "dish" VALUES (174, '拍黄瓜', 23.0, '这是菜', 'uploadFile/HTB1cnIlBntYBeNjy1Xdq6xXyVXay.jpg', 7, 3, NULL);
INSERT INTO "dish" VALUES (175, '可乐', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0pia570j30u00u0wjl.jpg', 7, 4, NULL);
INSERT INTO "dish" VALUES (176, '雪碧', 3.0, '这是菜', 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', 7, 4, NULL);
INSERT INTO "dish" VALUES (177, '美年达', 3.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 4, NULL);
INSERT INTO "dish" VALUES (178, '馒头', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', 7, 5, NULL);
INSERT INTO "dish" VALUES (179, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 5, NULL);
INSERT INTO "dish" VALUES (180, '煎饼', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsp0prtcq1j30u011itjq.jpg', 7, 5, NULL);
INSERT INTO "dish" VALUES (181, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 6, NULL);
INSERT INTO "dish" VALUES (182, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 6, NULL);
INSERT INTO "dish" VALUES (183, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 6, NULL);
INSERT INTO "dish" VALUES (184, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 7, NULL);
INSERT INTO "dish" VALUES (185, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 7, NULL);
INSERT INTO "dish" VALUES (186, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 7, NULL);
INSERT INTO "dish" VALUES (187, '馒头', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 8, NULL);
INSERT INTO "dish" VALUES (188, '米饭', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 8, NULL);
INSERT INTO "dish" VALUES (189, '煎饼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 8, NULL);
INSERT INTO "dish" VALUES (190, '桂花糕', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 7, 9, NULL);
INSERT INTO "dish" VALUES (191, '小羊糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsslnd5csaj30tp0w4107.jpg', 7, 9, NULL);
INSERT INTO "dish" VALUES (192, '❄雪花糕', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fst0ycqnycj30u00u1acp.jpg', 7, 9, NULL);
INSERT INTO "dish" VALUES (193, '鼠片', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 7, 10, NULL);
INSERT INTO "dish" VALUES (194, '辣条', 23.0, '这是菜', 'uploadFile/006fVSiZgy1fsskxmaf46j30rm0rmgto.jpg', 7, 10, NULL);
INSERT INTO "dish" VALUES (195, '豆干', 23.0, '这是菜', 'uploadFile/HTB1CTARAVmWBuNjSspdq6zugXXaN.jpg', 7, 10, NULL);
INSERT INTO "dish" VALUES (196, '红玫瑰🌹', 23.0, '这是菜', 'uploadFile/HTB1jmWUBnlYBeNjSszcq6zwhFXaJ.jpg', 7, 11, NULL);
INSERT INTO "dish" VALUES (197, '粉玫瑰🌷', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 11, NULL);
INSERT INTO "dish" VALUES (198, '白玫瑰🌼', 23.0, '这是菜', 'uploadFile/HTB1dLwWAVmWBuNjSspdq6zugXXae.jpg', 7, 11, NULL);

-- ----------------------------
-- Table structure for dishOrder
-- ----------------------------
DROP TABLE IF EXISTS "dishOrder";
CREATE TABLE "dishOrder" (
  "dish_id" INTEGER,
  "order_id" INTEGER,
  FOREIGN KEY ("dish_id") REFERENCES "dish" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ("order_id") REFERENCES "order" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS "order";
CREATE TABLE "order" (
  "id" INTEGER NOT NULL,
  "user_id" INTEGER,
  "store_id" INTEGER,
  "order_id" VARCHAR(255),
  "order_amount" FLOAT,
  "order_json" TEXT,
  "user_content" VARCHAR(255),
  "create_time" DATETIME,
  "payStatus" BOOLEAN,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("store_id") REFERENCES "store" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
   ("payStatus" IN (0, 1))
);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS "role";
CREATE TABLE "role" (
  "id" INTEGER NOT NULL,
  "name" VARCHAR(80),
  "description" VARCHAR(255),
  PRIMARY KEY ("id"),
  UNIQUE ("name" ASC)
);

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO "role" VALUES (1, 'user', '普通商家用户');
INSERT INTO "role" VALUES (2, 'superuser', '超级管理员');

-- ----------------------------
-- Table structure for roles_stores
-- ----------------------------
DROP TABLE IF EXISTS "roles_stores";
CREATE TABLE "roles_stores" (
  "store_id" INTEGER,
  "role_id" INTEGER,
  FOREIGN KEY ("role_id") REFERENCES "role" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ("store_id") REFERENCES "store" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- ----------------------------
-- Records of roles_stores
-- ----------------------------
INSERT INTO "roles_stores" VALUES (1, 1);
INSERT INTO "roles_stores" VALUES (1, 2);
INSERT INTO "roles_stores" VALUES (2, 1);
INSERT INTO "roles_stores" VALUES (3, 1);
INSERT INTO "roles_stores" VALUES (4, 1);
INSERT INTO "roles_stores" VALUES (5, 1);
INSERT INTO "roles_stores" VALUES (6, 1);
INSERT INTO "roles_stores" VALUES (7, 1);

-- ----------------------------
-- Table structure for store
-- ----------------------------
DROP TABLE IF EXISTS "store";
CREATE TABLE "store" (
  "id" INTEGER NOT NULL,
  "storeName" VARCHAR(32),
  "imagePath" VARCHAR(255),
  "publicMsg" VARCHAR(255),
  "qrCode" BLOB,
  "email" VARCHAR(255),
  "password" VARCHAR(255),
  "active" BOOLEAN,
  "confirmed_at" DATETIME,
  PRIMARY KEY ("id"),
  UNIQUE ("email" ASC),
   (active IN (0, 1))
);

-- ----------------------------
-- Records of store
-- ----------------------------
INSERT INTO "store" VALUES (1, '超级管理员', NULL, '💣这是超级管理员字段勿动💣', NULL, 'root', '$pbkdf2-sha512$25000$kpLyfg.hdG5NCYEwprS29g$zAZAGFPiD97u2W45TaNdmroGUH3uEjx3ooOumfrclnnVUOYQ5a0gMQo0QDOa3IuvlrMPeJNddwcuel37DMX1LA', 1, '2019-04-03 14:05:26.837139');
INSERT INTO "store" VALUES (2, '竹林香米线', 'uploadFile/006fVSiZgy1fremmk8mmmj30u00twq8c.jpg', '这是一碗蓝朋友剥好的小龙虾', NULL, 'store2', '$pbkdf2-sha512$25000$p3QuxfgfQ2hNKcUYIyTk/A$NgSVFD2cuygQMW20raY9Y94PDxytiwtqWg/oOKcpb37VA0wvCS7qyRvC25LrZavJ3yse7ASVtKMy0Pe0DCownA', 1, '2019-04-03 14:05:26.837139');
INSERT INTO "store" VALUES (3, '干锅牛蛙', 'uploadFile/006fVSiZgy1fsp0pmgy9sj30u00u0jza.jpg', '这是一碗蓝朋友剥好的小龙虾', NULL, 'store3', '$pbkdf2-sha512$25000$UUqJEaI0prQ2Zqz1XitlzA$NjHXfAAK5MpHZpmhpLOWsqtsIMHA62u0Yq5iIfW/wSpxnoqgPK2youoFlbJ0YYhjYidpGhGd5ZhOMbYS21s.UQ', 1, '2019-04-03 14:05:26.837139');
INSERT INTO "store" VALUES (4, '黄焖鸡米饭', 'uploadFile/006fVSiZgy1fssio2es4dj30u00u0n34.jpg', '这是一碗蓝朋友剥好的小龙虾', NULL, 'store4', '$pbkdf2-sha512$25000$mLM2ZmztfY8RIkQIYex9Dw$yYiz3foS45SHLa.q8ADmE07p8.v7Yvno6uyo7WGDlIBlPOdGI.AzTPKlpMjna/zX.iX50YNz25T6c88gfSI7.g', 1, '2019-04-03 14:05:26.837139');
INSERT INTO "store" VALUES (5, '西祠虾涮', 'uploadFile/006fVSiZgy1fst0ynushyj30u00u041c.jpg', '这是一碗蓝朋友剥好的小龙虾', NULL, 'store5', '$pbkdf2-sha512$25000$/V/rHSOEsFZqLaVUqhUipA$2TzCVO9JegJWwj4grujPxyo8.RbKRAmh707j8c271O7H5M1DbqmmkGlYK257aI3J4ssDKfzcB4bfceO6XkszhQ', 1, '2019-04-03 14:05:26.837139');
INSERT INTO "store" VALUES (6, '肯德鸭', 'uploadFile/HTB1cnIlBntYBeNjy1Xdq6xXyVXay.jpg', '这是一碗蓝朋友剥好的小龙虾', NULL, 'store6', '$pbkdf2-sha512$25000$S8m5t7Z2rvU.h1BqrbW2Ng$/k/RAVIj/HyEPcr4o851HFWapWKN7h.h6mBM90CQveQk4uzeL5E1faRvf3L7mXWeamv09tnXv/.uimjK5VO4Kw', 1, '2019-04-03 14:05:26.837139');
INSERT INTO "store" VALUES (7, '叫只鸡', 'uploadFile/006fVSiZgy1fsp0pqj7pnj30ja0jbdju.jpg', '这是一碗蓝朋友剥好的小龙虾', NULL, 'store7', '$pbkdf2-sha512$25000$5HyvdY7xnhOC0Jqz9v6/Fw$26VFfQxuI32xVgo7wJnahufCwnNfI5JhMYhMomQ7y.oje1CJ0LOWdMZDkKbDvItX6DzMq/66saia29A0wZ0Jig', 1, '2019-04-03 14:05:26.837139');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS "user";
CREATE TABLE "user" (
  "id" INTEGER NOT NULL,
  "login_id" VARCHAR(32),
  "password_hash" VARCHAR(255),
  "openid" VARCHAR(255),
  "session_key" VARCHAR(255),
  "gender" INTEGER,
  "province" VARCHAR(255),
  "country" VARCHAR(255),
  "avatarUrl" VARCHAR(255),
  "nickName" VARCHAR(32),
  "city" VARCHAR(32),
  "language" VARCHAR(32),
  PRIMARY KEY ("id")
);

PRAGMA foreign_keys = true;
