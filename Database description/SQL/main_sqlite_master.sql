UPDATE sqlite_master SET type = 'table', name = 'alembic_version', tbl_name = 'alembic_version', rootpage = 2, sql = 'CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
)';
UPDATE sqlite_master SET type = 'index', name = 'sqlite_autoindex_alembic_version_1', tbl_name = 'alembic_version', rootpage = 3, sql = null;
UPDATE sqlite_master SET type = 'table', name = 'actives', tbl_name = 'actives', rootpage = 4, sql = 'CREATE TABLE actives (
	id INTEGER NOT NULL, 
	text VARCHAR(32), 
	PRIMARY KEY (id)
)';
UPDATE sqlite_master SET type = 'table', name = 'carousel', tbl_name = 'carousel', rootpage = 5, sql = 'CREATE TABLE carousel (
	id INTEGER NOT NULL, 
	name VARCHAR(32), 
	link VARCHAR(255), 
	"imagePath" VARCHAR(255), 
	"publicMsg" VARCHAR(255), 
	PRIMARY KEY (id)
)';
UPDATE sqlite_master SET type = 'table', name = 'category', tbl_name = 'category', rootpage = 6, sql = 'CREATE TABLE category (
	id INTEGER NOT NULL, 
	category_name VARCHAR(32), 
	PRIMARY KEY (id)
)';
UPDATE sqlite_master SET type = 'table', name = 'role', tbl_name = 'role', rootpage = 7, sql = 'CREATE TABLE role (
	id INTEGER NOT NULL, 
	name VARCHAR(80), 
	description VARCHAR(255), 
	PRIMARY KEY (id), 
	UNIQUE (name)
)';
UPDATE sqlite_master SET type = 'index', name = 'sqlite_autoindex_role_1', tbl_name = 'role', rootpage = 8, sql = null;
UPDATE sqlite_master SET type = 'table', name = 'store', tbl_name = 'store', rootpage = 9, sql = 'CREATE TABLE store (
	id INTEGER NOT NULL, 
	"storeName" VARCHAR(32), 
	"imagePath" VARCHAR(255), 
	"publicMsg" VARCHAR(255), 
	"qrCode" BLOB, 
	email VARCHAR(255), 
	password VARCHAR(255), 
	active BOOLEAN, 
	confirmed_at DATETIME, 
	PRIMARY KEY (id), 
	UNIQUE (email), 
	CHECK (active IN (0, 1))
)';
UPDATE sqlite_master SET type = 'index', name = 'sqlite_autoindex_store_1', tbl_name = 'store', rootpage = 10, sql = null;
UPDATE sqlite_master SET type = 'table', name = 'user', tbl_name = 'user', rootpage = 13, sql = 'CREATE TABLE user (
	id INTEGER NOT NULL, 
	login_id VARCHAR(32), 
	password_hash VARCHAR(255), 
	openid VARCHAR(255), 
	session_key VARCHAR(255), 
	gender INTEGER, 
	province VARCHAR(255), 
	country VARCHAR(255), 
	"avatarUrl" VARCHAR(255), 
	"nickName" VARCHAR(32), 
	city VARCHAR(32), 
	language VARCHAR(32), 
	PRIMARY KEY (id)
)';
UPDATE sqlite_master SET type = 'table', name = 'coupon', tbl_name = 'coupon', rootpage = 14, sql = 'CREATE TABLE coupon (
	id INTEGER NOT NULL, 
	coupon_name VARCHAR(32), 
	coupon_num INTEGER, 
	coupon_content TEXT, 
	"beginTime" DATETIME, 
	"endTime" DATETIME, 
	store_id INTEGER, 
	actives_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(actives_id) REFERENCES actives (id), 
	FOREIGN KEY(store_id) REFERENCES store (id)
)';
UPDATE sqlite_master SET type = 'table', name = 'dish', tbl_name = 'dish', rootpage = 16, sql = 'CREATE TABLE dish (
	id INTEGER NOT NULL, 
	dish_name VARCHAR(32), 
	dish_price FLOAT, 
	dish_description VARCHAR(255), 
	"imagePath" VARCHAR(255), 
	store_id INTEGER, 
	category_id INTEGER, 
	"onSale" BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(category_id) REFERENCES category (id), 
	FOREIGN KEY(store_id) REFERENCES store (id), 
	CHECK ("onSale" IN (0, 1))
)';
UPDATE sqlite_master SET type = 'table', name = 'order', tbl_name = 'order', rootpage = 17, sql = 'CREATE TABLE "order" (
	id INTEGER NOT NULL, 
	user_id INTEGER, 
	store_id INTEGER, 
	order_id VARCHAR(255), 
	order_amount FLOAT, 
	order_json TEXT, 
	user_content VARCHAR(255), 
	create_time DATETIME, 
	"payStatus" BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(store_id) REFERENCES store (id), 
	FOREIGN KEY(user_id) REFERENCES user (id), 
	CHECK ("payStatus" IN (0, 1))
)';
UPDATE sqlite_master SET type = 'table', name = 'roles_stores', tbl_name = 'roles_stores', rootpage = 19, sql = 'CREATE TABLE roles_stores (
	store_id INTEGER, 
	role_id INTEGER, 
	FOREIGN KEY(role_id) REFERENCES role (id), 
	FOREIGN KEY(store_id) REFERENCES store (id)
)';
UPDATE sqlite_master SET type = 'table', name = 'dishOrder', tbl_name = 'dishOrder', rootpage = 20, sql = 'CREATE TABLE "dishOrder" (
	dish_id INTEGER, 
	order_id INTEGER, 
	FOREIGN KEY(dish_id) REFERENCES dish (id), 
	FOREIGN KEY(order_id) REFERENCES "order" (id)
)';