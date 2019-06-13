#!/usr/bin/env python
# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: __init__.py.py
@Time: 19-1-26 上午9:48
"""

from flask_security.utils import encrypt_password

from myApp import app, store_datastore
from myApp.models import *


def insertCarousel():
    "插入轮播图数据"
    print("开始插入轮播图数据...")
    DataPath = os.path.join(app.root_path, "static/data/carouselList.json")
    with open(DataPath, encoding="utf-8") as f:
        DataDict = json.load(f)
        for one in DataDict["data"]["carouselList"]:
            store = Carousel(id=one["carouselId"],
                             name=one["carouselName"],
                             imagePath=one["carouselImgUrl"],
                             publicMsg=one["publicMsg"],
                             )
            db.session.add(store)
            db.session.commit()
    print("o98k!")


def insertActives():
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
    print("开始插入优惠卷类型数据...")
    DataDict = {
        1: "满减",
        2: "新店优惠",
        3: "折扣商品",
        4: "满返代金券",
        5: "新用户",
        6: "减配送费",
        7: "领代金券",
        8: "赠送商品",
    }
    for key, val in DataDict.items():
        actives = Actives(id=key, text=val)
        db.session.add(actives)
        db.session.commit()
    print("o98k!")


def insertSrore():
    "插入商家数据"
    print("开始插入商家数据...")
    # 创建角色表
    user_role = Role(name="user", description="普通商家用户")
    super_user_role = Role(name="superuser", description="超级管理员")
    db.session.add(user_role)
    db.session.add(super_user_role)
    db.session.commit()

    # 超级管理员用户
    root_user = store_datastore.create_user(
        id=1,
        storeName="超级管理员",
        publicMsg="💣这是超级管理员字段勿动💣",
        email="root",
        password=encrypt_password("root"),
        roles=[user_role, super_user_role]
    )
    db.session.add(root_user)
    db.session.commit()

    DataPath = os.path.join(app.root_path, "static/data/storeList.json")
    with open(DataPath, encoding="utf-8") as f:
        DataDict = json.load(f)
        for one in DataDict["data"]["storeList"]:
            store = store_datastore.create_user(
                id=one["storeId"],
                storeName=one["storeName"],
                imagePath=one["storeImgUrl"],
                publicMsg=one["publicMsg"],
                email="store{}".format(one["storeId"]),
                password=encrypt_password("store{}".format(one["storeId"])),
                roles=[user_role, ]
            )
            db.session.add(store)
            for coupon_one in one["actives"]:
                coupon = Coupon(coupon_name="测试卷",
                                coupon_num=100,
                                coupon_content=coupon_one["acticeText"],
                                store_id=one["storeId"],
                                actives_id=coupon_one["activeId"],
                                )
                db.session.add(coupon)
        db.session.commit()
    print("o98k!")


def insertSroreFoodList():
    "插入商家菜品数据"
    print("开始插入商家菜品数据...")
    DataPath = os.path.join(app.root_path, "static/data/storeFoodList.json")
    with open(DataPath, encoding="utf-8") as f:
        DataDict = json.load(f)
        stores = Store.query.filter_by().all()
        for store in stores:
            if store.id != 1:
                for one in DataDict["data"]["storeFood"]:
                    # 插入类别数据
                    category_id = int(one["titleId"][5:])

                    category = Category.query.filter_by(id=category_id).first()
                    if category is None:
                        category_name = one["title"]
                        category = Category(id=category_id, category_name=category_name)
                        db.session.add(category)
                        db.session.commit()

                    for item in one["items"]:
                        dish = Dish(dish_name=item["name"],
                                    dish_price=item["price"],
                                    dish_description="这是菜",
                                    imagePath=item["foodImgUrl"],
                                    store_id=store.id,
                                    category_id=category_id,
                                    )
                        db.session.add(dish)
                        db.session.commit()
    print("o98k!")


def Insert():
    "插入测试数据"
    insertCarousel()
    insertActives()
    insertSrore()
    insertSroreFoodList()


if __name__ == '__main__':
    # insertCategories()
    insertSroreFoodList()
    pass
