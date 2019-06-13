#!/usr/bin/env python
# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: models.py
@Time: 19-1-16 下午5:50
"""
import json
import os
import random
import time
from datetime import datetime

from flask_security import UserMixin, RoleMixin
from flask_sqlalchemy import SQLAlchemy
from itsdangerous import (TimedJSONWebSignatureSerializer
                          as Serializer, BadSignature, SignatureExpired)
from passlib.apps import custom_app_context as pwd_context

from config import configs

db = SQLAlchemy()

appConfig = configs[os.getenv("FLASK_CONFIG") or "default"]


class User(db.Model):
    # 用户表(存储微信授权登陆的用户)
    __tablename__ = 'user'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    login_id = db.Column(db.String(32))
    password_hash = db.Column(db.String(255))

    # 微信小程序
    openid = db.Column(db.String(255))
    session_key = db.Column(db.String(255))

    # 微信小程序userInfo
    gender = db.Column(db.INT)
    province = db.Column(db.String(255))
    country = db.Column(db.String(255))
    avatarUrl = db.Column(db.String(255))
    nickName = db.Column(db.String(32))
    city = db.Column(db.String(32))
    language = db.Column(db.String(32))

    # 一对多,对应多个Order(订单表)
    orders = db.relationship('Order', backref='user', lazy=True)

    # 密码加密
    def hash_password(self, password):
        self.password_hash = pwd_context.encrypt(password)

    # 验证密码
    def verify_password(self, password):
        return pwd_context.verify(password, self.password_hash)

    # 获取Token
    def generate_auth_token(self, expiration=600):
        serializer = Serializer(appConfig.SECRET_KEY, expires_in=expiration)
        return serializer.dumps({'id': self.id})

    # 验证token,确认用户身份
    @staticmethod
    def verify_auth_token(token):
        serializer = Serializer(appConfig.SECRET_KEY)
        try:
            data = serializer.loads(token)
        except SignatureExpired:
            return None  # 有效token，但已过期
        except BadSignature:
            return None  # token无效
        user = User.query.filter_by(id=data["id"]).first()
        return user

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.nickName,
        }, ensure_ascii=False)


class Carousel(db.Model):
    # 轮播图表(小程序首页展示的轮播图列表)
    __tablename__ = 'carousel'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(32))
    link = db.Column(db.String(255))
    imagePath = db.Column(db.String(255))
    publicMsg = db.Column(db.String(255))

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.name,
        }, ensure_ascii=False)


roles_stores = db.Table(
    'roles_stores',
    db.Column('store_id', db.Integer(), db.ForeignKey('store.id')),
    db.Column('role_id', db.Integer(), db.ForeignKey('role.id'))
)


class Role(db.Model, RoleMixin):
    id = db.Column(db.Integer(), primary_key=True)
    # 角色名称
    name = db.Column(db.String(80), unique=True)
    # 角色描述
    description = db.Column(db.String(255))

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.name,
        }, ensure_ascii=False)


class Store(db.Model, UserMixin):
    # 商店表(小程序首页展示的商家列表)
    __tablename__ = 'store'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    storeName = db.Column(db.String(32))
    imagePath = db.Column(db.String(255))
    publicMsg = db.Column(db.String(255))

    # 一对多,对应多个Dish(菜品表)
    dishs = db.relationship('Dish', backref='store', lazy=True)
    # 一对多,对应多个Coupon(优惠券表)
    coupons = db.relationship('Coupon', backref='store', lazy=True)
    # 一对多,对应多个Order(订单表)
    orders = db.relationship('Order', backref='store', lazy=True)

    # 商家登录验证相关字段

    # 商家登录邮箱，唯一
    email = db.Column(db.String(255), unique=True)
    # 商家登录密码
    password = db.Column(db.String(255))
    active = db.Column(db.Boolean())
    confirmed_at = db.Column(db.DateTime(), default=datetime.now())
    # 一对多,对应多个Role(角色表)
    # roles = db.relationship('Role', secondary=roles_stores,
    #                         backref=db.backref('store', lazy='dynamic'))
    roles = db.relationship('Role', secondary=roles_stores, backref='store', lazy=True)

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.storeName,
        }, ensure_ascii=False)


# 菜品表与订单采用多对多的关系,定义辅助表
# 即一个菜品可以对应多个订单，一个订单也能对应多个菜品
dishOrder = db.Table(
    "dishOrder",
    db.Column("dish_id", db.Integer, db.ForeignKey("dish.id")),
    db.Column("order_id", db.Integer, db.ForeignKey("order.id"))
)


class Dish(db.Model):
    # 菜单表(菜品表)
    __tablename__ = 'dish'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    dish_name = db.Column(db.String(32))
    dish_price = db.Column(db.FLOAT)
    dish_description = db.Column(db.String(255))
    imagePath = db.Column(db.String(255))

    # 关联商家表id(这个菜是属于哪个商家的)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id'))
    # 关联菜品类别ID（这个菜是哪个类别的）
    category_id = db.Column(db.Integer, db.ForeignKey('category.id'))

    onSale = db.Column(db.Boolean)

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.dish_name,
        }, ensure_ascii=False)


class Category(db.Model):
    # 菜品类别表
    __tablename__ = 'category'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    category_name = db.Column(db.String(32))

    # 一对多,对应多个Dish(菜品表)
    dishs = db.relationship('Dish', backref='category', lazy=True)

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.category_name,
        }, ensure_ascii=False)


class Actives(db.Model):
    """
        优惠券类型
       * 1.满减
       * 2.新店优惠
       * 3.折扣商品
       * 4.满返代金券
       * 5.新用户
       * 6.减配送费
       * 7.领代金券
       * 8.赠送商品
    """
    __tablename__ = 'actives'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    text = db.Column(db.String(32))

    # 一对多,对应多个Coupon(优惠券表)
    coupons = db.relationship('Coupon', backref='actives', lazy=True)

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.text,
        }, ensure_ascii=False)


class Coupon(db.Model):
    # 优惠卷表
    # 优惠卷关联商家ID，关联优惠卷类型
    # 一个商家对应多个优惠卷
    # 一种优惠卷类型对多个优惠卷
    __tablename__ = "coupon"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    # 优惠卷名称
    coupon_name = db.Column(db.String(32))
    # 优惠卷总数量
    coupon_num = db.Column(db.Integer)
    # 优惠卷内容
    coupon_content = db.Column(db.TEXT)
    # 优惠卷生效时间
    beginTime = db.Column(db.DateTime)
    # 优惠卷失效时间
    endTime = db.Column(db.DateTime)

    # 关联商家表id(这个优惠卷是属于哪个商家的)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id'))
    # 关联优惠券类型表id(这个优惠券是属于哪个优惠卷类型的)
    actives_id = db.Column(db.Integer, db.ForeignKey('actives.id'))

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.coupon_content,
        }, ensure_ascii=False)


class Order(db.Model):
    # 用户订单表
    __tablename__ = "order"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    # 关联用户ID
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"))
    # 关联商家表id(这个订单是属于哪个商家的)
    store_id = db.Column(db.Integer, db.ForeignKey('store.id'))
    # 多对多,对应多个Dish(菜品表)
    dishs = db.relationship('Dish', secondary=dishOrder, backref=db.backref("orders", lazy="dynamic"))

    # 订单编号
    order_id = db.Column(db.String(255),
                         default="{}{:0>2d}".format(
                             time.strftime("%Y%m%d%H%M%S", time.localtime()),
                             random.randint(0, 99),
                         ))

    # 订单总金额
    order_amount = db.Column(db.FLOAT)
    # 订单的json信息
    order_json = db.Column(db.Text)
    # 用户备注
    user_content = db.Column(db.String(255), default="")
    # 订单创建时间
    create_time = db.Column(db.DateTime, default=datetime.now())
    # 订单支付状态
    payStatus = db.Column(db.Boolean, default=False)

    def __repr__(self):
        return json.dumps({
            "id": self.id,
            "name": self.order_id,
        }, ensure_ascii=False)
