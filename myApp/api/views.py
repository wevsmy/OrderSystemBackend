#!/usr/bin/env python
# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: views.py
@Time: 19-1-17 下午3:01
"""

import requests
from flask import jsonify, g
from flask_httpauth import HTTPBasicAuth
from flask_restful import Resource, url_for, request, reqparse

from myApp import app
from myApp.api import apiRoute
from myApp.models import *

auth = HTTPBasicAuth()
wx = configs["wxConfig"]


# 判断是否有小图，返回小图
def setThumb(path):
    tempPath = os.path.join(app.root_path, "static", path)
    if os.path.exists(tempPath):
        return '%s_thumb%s' % (os.path.splitext(path))
    else:
        return path


# 授权失败
@auth.error_handler
def unauthorized():
    return jsonify({
        "code": 403,
        "msg": "Unauthorized Access!",
        "data": None
    }), 403, {"Location": url_for("api.Login", _method="POST", _external=True)}


# 授权功能
@auth.verify_password
def verify_password(username_or_token, password):
    # 首先尝试通过令牌进行身份验证
    user = User.verify_auth_token(username_or_token)
    if user:
        g.user = user
        return True

    # 尝试使用GET或POST的Params中的Token验证(项目中不推荐使用,不安全,现在练手使用)
    token = request.args.get("token")
    if token:
        user = User.verify_auth_token(token)
        if user:
            g.user = user
            return True

    # 尝试使用用户名/密码进行身份验证
    if request.method == "POST" and request.content_type == "application/json":
        u = request.json.get("login_id")
        p = request.json.get("password")
        user = User.query.filter_by(login_id=u).first()
        if user or user.verify_password(p):
            g.user = user
            return True

    return False


# 微信小程序认证接口
##################################################################################################################
@apiRoute.resource("/wx_login")
class API_wx_login(Resource):
    """微信小程序登录接口(获取openid),以及拿到最新的session_key"""

    def get(self):
        pass

    def post(self):
        res = request.json.get("res")
        errMsg = res["errMsg"]
        code = res["code"]
        url = "https://api.weixin.qq.com/sns/jscode2session"
        kv = {"appid": wx.appId, "secret": wx.appSecret, "js_code": code, "grant_type": "authorization_code"}
        data = requests.get(url, params=kv, timeout=300)

        if data.status_code == 200:
            j_data = json.loads(data.text)
            session_key = None
            if "session_key" in j_data:
                session_key = j_data["session_key"]
            if "openid" in j_data:
                openid = j_data["openid"]
                if openid is None:
                    return {"code": 201, "msg": "用户名或密码为空!", "data": None}, 201
                if User.query.filter_by(openid=openid).first() is None:
                    user = User(openid=openid, session_key=session_key)
                    db.session.add(user)
                    db.session.commit()
                    return {
                        "code": 200,
                        "msg": "sing up success!",
                        "data":
                            {
                                "openid": user.openid
                            }
                    }
                else:
                    user = User.query.filter_by(openid=openid).first()
                    user.session_key = session_key
                    db.session.commit()
                    return {
                        "code": 200,
                        "msg": "login success!",
                        "data":
                            {
                                "openid": user.openid
                            }
                    }
        return {"code": data.status_code, "msg": "error!", "data": None}, data.status_code


@apiRoute.resource("/userInfo")
class API_wx_userInfo(Resource):
    """微信小程序授权以后获取userInfo接口"""

    def get(self):
        pass

    def post(self):

        res = request.json.get("res")
        openid = request.json.get("openid")
        dataDict = {
            "code": 200,
            "msg": "userInfo success!",
            "data":
                {
                    "openid": openid
                }
        }
        print("openid", openid)
        if "rawData" in res and openid is not None:
            errMsg = res["errMsg"]
            rawData = res["rawData"]
            userInfo = res["userInfo"]
            signature = res["signature"]
            encryptedData = res["encryptedData"]
            iv = res["iv"]
            print("userInfo", type(userInfo), userInfo)
            # 存微信数据
            user = User.query.filter_by(openid=openid).first()
            if user is not None:
                user.gender = userInfo["gender"]
                user.province = userInfo["province"]
                user.country = userInfo["country"]
                user.avatarUrl = userInfo["avatarUrl"]
                user.nickName = userInfo["nickName"]
                user.city = userInfo["city"]
                user.language = userInfo["language"]
                db.session.commit()
                return dataDict

            # 主要解密 uuid
            # try:
            #     pc = WXBizDataCrypt(wx.appId, wx.sessionKey)
            #     d_data = pc.decrypt(encryptedData, iv)
            #     print("a", d_data, type(d_data))
            #     if "openId" in d_data:
            #         openId = d_data["openId"]
            #         print("openId", openId)
            #         dataDict["data"]["openId"] = openId
            #     if "unionid" in d_data:
            #         unionid = d_data["unionid"]
            # except Exception as e:
            #     print("数据解密", e)
        return {"code": 201, "msg": "res is none or openid is none!", "data": {"openid": None}}, 201


##################################################################################################################


# 微信小程序使用的接口
##################################################################################################################


@apiRoute.resource("/carousel")
class API_Carousel(Resource):
    """微信小程序首页轮播图接口"""

    def get(self):
        """获取首页轮播图列表
        @@@
        #### args
            None
        #### return
            json
            {
               "code": 200,
               "msg": "Get CarouselList Succeeded!",
               "data":
                {
                    "carouselList": [轮播图列表信息]
                }
            }
        @@@
        """
        # 取数据库中的所有轮播图列表处理并返回，用于小程序首页轮播图显示
        dataDict = {
            "code": 200,
            "msg": "Get carouselList Succeeded!",
            "data":
                {
                    "carouselList": []
                }
        }
        carouselList = []
        allData = db.session.query(Carousel).all()
        for one in allData:
            d = {
                "carouselId": one.id,
                "carouselName": one.name,
                "link": "../../pages/store/store?storeId={}".format(one.id),
                "imgUrl": "/static/{}".format(one.imagePath),
                "publicMsg": one.publicMsg
            }
            carouselList.append(d)
        dataDict["data"]["carouselList"] = carouselList
        return dataDict


@apiRoute.resource("/store")
class API_Store(Resource):
    """微信小程序首页商家信息接口"""

    def get(self):
        """获取附近的商家信息列表
        @@@
        #### args
            None
        #### return
            json
            {
               "code": 200,
               "msg": "Get StoreList Succeeded!",
               "data":
                {
                    "storeList": [商家列表信息]
                }
            }
        @@@
        """

        #    active  图标对应
        #     // 1.满减
        #     // 2.新店优惠
        #     // 3.折扣商品
        #     // 4.满返代金券
        #     // 5.新用户
        #     // 6.减配送费
        #     // 7.领代金券
        #     // 8.赠送商品

        # 取数据库中的所有商家列表处理并返回，用于小程序首页附近商家显示
        dataDict = {
            "code": 200,
            "msg": "Get StoreList Succeeded!",
            "data":
                {
                    "storeList": []
                }
        }
        storeList = []
        allData = db.session.query(Store).all()
        for one in allData:

            if len(one.roles) == 1 and one.roles[0].name == "user" and one.storeName is not None:
                d = {
                    "storeId": one.id,
                    "storeName": one.storeName,
                    "storeImgUrl": "/static/{}".format(setThumb(one.imagePath)),
                    "publicMsg": one.publicMsg,
                    "actives": [
                        {
                            "activeId": 1,
                            "acticeText": "满20减19；满200减199；满1000减999；"
                        },
                        {
                            "activeId": 2,
                            "acticeText": "本店新用户立减1元"
                        },
                        {
                            "activeId": 3,
                            "acticeText": "折扣商品9折起"
                        }
                    ]
                }
                storeList.append(d)
        dataDict["data"]["storeList"] = storeList
        return dataDict


@apiRoute.resource("/storeInfo")
class API_StoreInfo(Resource):
    """商家信息接口"""

    def post(self):
        """获取附近的商家信息列表
        @@@
        #### args
            json
            {
                "storeId":"1"
            }
        #### return
            json
            {
               "code": 200,
               "msg": "Get StoreList Succeeded!",
               "data":
                {
                    "storeInfo": {商家信息}
                }
            }
        @@@
        """

        storeId = request.json.get("storeId")
        store = Store.query.filter_by(id=storeId).first()

        storeInfo = {
            "storeId": store.id,
            "publicMsg": store.publicMsg,
            "storeName": store.storeName,
            "storeImgUrl": "/static/{}".format(setThumb(store.imagePath)),
            "actives": []
        }
        coupons = Coupon.query.filter_by(store_id=storeId).all()
        for coupon in coupons:
            tempDict = {
                "couponId": coupon.id,
                "coupon_content": coupon.coupon_content,
                "activeId": coupon.actives_id,
                "acticeText": coupon.coupon_content,
            }
            storeInfo["actives"].append(tempDict)
        dataDict = {
            "code": 200,
            "msg": "Get StoreList Succeeded!",
            "data":
                {
                    "storeInfo": storeInfo
                }
        }
        return dataDict


@apiRoute.resource("/storeFood")
class API_StoreFood(Resource):
    """商家Food信息接口"""

    def post(self):
        """获取商家菜品Food列表
        @@@
        #### args
            json
            {
                "storeId":"1"
            }
        #### return
            json
            {
               "code": 200,
               "msg": "Get StoreList Succeeded!",
               "data":
                {
                    "storeFood": [FoodList]
                }
            }
        @@@
        """

        # 判断列表中有没有这个id
        def func(list, id):
            for one in list:
                if one["category_id"] == id:
                    return True
            return False

        storeId = request.json.get("storeId")
        storeFood = []
        dishs = Dish.query.filter_by(store_id=storeId).all()
        for dish in dishs:
            category = Category.query.filter_by(id=dish.category_id).first()
            if category is not None:
                tempDict = {
                    "category_id": category.id,
                    "titleId": "title{}".format(category.id),
                    "title": category.category_name,
                    "foodCount": 0,
                    "items": [
                        {
                            "foodId": dish.id,
                            "foodImgUrl": "/static/{}".format(setThumb(dish.imagePath)),
                            "name": dish.dish_name,
                            "price": dish.dish_price,
                            "monthNum": 34,
                            "note": dish.dish_description,
                            "zan": 34,
                            "count": 0,
                            "classify": []
                        }
                    ]
                }
                if func(storeFood, category.id) == False:
                    storeFood.append(tempDict)
                else:
                    for one in storeFood:
                        if one["category_id"] == category.id:
                            one["items"].append(
                                {
                                    "foodId": dish.id,
                                    "foodImgUrl": "/static/{}".format(setThumb(dish.imagePath)),
                                    "name": dish.dish_name,
                                    "price": dish.dish_price,
                                    "monthNum": 34,
                                    "note": dish.dish_description,
                                    "zan": 34,
                                    "count": 0,
                                    "classify": []
                                }
                            )
                            break
        dataDict = {
            "code": 200,
            "msg": "Get storeFood Succeeded!",
            "data":
                {
                    "storeFood": storeFood
                }
        }
        return dataDict


@apiRoute.resource("/order")
class API_Order(Resource):
    """用户订单提交接口"""

    def __init__(self):
        self.reqparse = reqparse.RequestParser()
        self.reqparse.add_argument('openid',
                                   type=str,
                                   default="",
                                   location='args')

    def get(self):
        """用户查询订单
        @@@
        #### args
            json
            {
                "openid":"1",
            }
        #### return
            json
            {
               "code": 200,
               "msg": "get orderList Succeeded!",
               "data":
                {
                    "orderList": [orderList]
                }
            }
        @@@
        """
        args = self.reqparse.parse_args()
        openid = args["openid"]
        if openid == None:
            return {
                "code": 201,
                "msg": "openid is null",
                "data": {}}
        # 查询用户
        user = User.query.filter_by(openid=openid).first()
        if user is None:
            return {
                "code": 202,
                "msg": "User does not exist!",
                "data": {}}

        # 订单按照下单时间倒叙输出
        orders = db.session.query(Order).order_by(Order.create_time.desc()).filter_by(user_id=user.id).all()

        print(orders)
        orderList = []
        for order in orders:
            jsonDataList = json.loads(order.order_json)
            store = Store.query.filter_by(id=order.store_id).first()
            tempList = []
            order_dishs_info = ""
            for oneDish in order.dishs:
                for i in jsonDataList:
                    if i["foodId"] == oneDish.id:
                        tempDist = {
                            "id": oneDish.id,
                            "name": oneDish.dish_name,
                            "count": i["count"],
                        }
                        tempList.append(tempDist)
                        order_dishs_info = order_dishs_info + oneDish.dish_name + "+"
            tempDist = {
                "order_id": order.order_id,
                "store_id": order.store_id,
                "store_name": store.storeName,
                "store_img": "/static/{}".format(setThumb(store.imagePath)),
                "order_amount": order.order_amount,
                "order_time": order.create_time.strftime('%Y-%m-%d %H:%M:%S'),
                "order_dishs_info": order_dishs_info[:12] + "...",
                "user_content": order.user_content,
                "payStatus": order.payStatus,
                "dishs": tempList,
            }
            orderList.append(tempDist)

        dataDict = {
            "code": 200,
            "msg": "Get Order Succeeded!",
            "data":
                {
                    "orderList": orderList
                }
        }
        return dataDict

    def post(self):
        """用户提交订单
        @@@
        #### args
            json
            {
                "storeId":"1",
                "uuid":"1",
                "cart":[],
            }
        #### return
            json
            {
               "code": 200,
               "msg": "post StoreList Succeeded!",
               "data":
                {
                    "storeFood": [FoodList]
                }
            }
        @@@
        """
        storeId = request.json.get("storeId")
        if storeId is None:
            return {
                "code": 201,
                "msg": "storeId is null!",
                "data": {}}
        openid = request.json.get("openid")
        if openid is None:
            return {
                "code": 202,
                "msg": "openid is null!",
                "data": {}}
        foodList = request.json.get("foodList")
        if foodList is None:
            return {
                "code": 203,
                "msg": "foodList is null!",
                "data": {}}

        # 查询用户
        user = User.query.filter_by(openid=openid).first()
        if user is None:
            return {
                "code": 204,
                "msg": "User does not exist!",
                "data": {}}

        dish_list = []
        order_amount = 0
        for food in foodList:
            dish = Dish.query.filter_by(id=food["foodId"]).first()
            order_amount = order_amount + dish.dish_price * food["count"]
            dish_list.append(dish)

        # 添加订单
        order = Order(
            user_id=user.id,
            store_id=int(storeId),
            dishs=dish_list,
            order_json=json.dumps(foodList),
            order_amount=order_amount,
        )
        db.session.add(order)
        db.session.commit()

        dataDict = {
            "code": 200,
            "msg": "Post Order Succeeded!",
            "data": {}
        }
        return dataDict


##################################################################################################################


@apiRoute.resource("/signup", endpoint="Signup")
class API_Signup(Resource):
    """注册接口"""

    def post(self):
        """用户注册
        @@@
        #### args
            json
            {
                "login_id":"a",
                "password":"q"
            }
        #### return
            json
            {
               "code": 200,
               "msg": "registration success!",
               "data":
                {
                    "id": user_id,
                    "login_id": login_id
                }
            }
        @@@
        """
        login_id = request.json.get("login_id")
        password = request.json.get("password")
        if login_id is None or password is None:
            return {"code": 201, "msg": "用户名或密码为空!", "data": None}, 201
        if User.query.filter_by(login_id=login_id).first() is not None:
            return {"code": 201, "msg": "用户已存在!", "data": None}, 201
        user = User(login_id=login_id)
        user.hash_password(password)
        db.session.add(user)
        db.session.commit()
        return {
                   "code": 200,
                   "msg": "registration success!",
                   "data":
                       {
                           "id": user.user_id,
                           "username": user.login_id
                       }
               }, {"Location": url_for("api.Login", _method="POST", _external=True)}


@apiRoute.resource("/login", endpoint="Login")
class API_Login(Resource):
    """登录接口"""

    @auth.login_required
    def post(self):
        """用户登录
        @@@
        #### args
            json
            {
                "login_id":"a",
                "password":"q"
            }
        #### return
            json
            {
               "code": 200,
               "msg": "login successful!",
               "data":
                {
                    "id": user_id,
                    "login_id": login_id
                },
               "token": token
            }
        @@@
        """
        return {
                   "code": 200,
                   "msg": "login successful!",
                   "data":
                       {
                           "id": g.user.user_id,
                           "login_id": g.user.login_id
                       },
                   "token": g.user.generate_auth_token().decode("ascii")
               }, {"Location": url_for("api.User", id=g.user.user_id, _external=True)}


@apiRoute.resource("/token", endpoint="Token")
class API_Token(Resource):
    """刷新Token接口"""

    @auth.login_required
    def get(self):
        """刷新Token
        @@@
        #### args
            ?token=xxx
        #### return
            json
            {
               "code": 200,
               "msg": "Token refresh succeeded!",
               "data":
                {
                    "user_id": user_id,
                    "login_id": login_id
                },
               "token": token
            }
        @@@
        """
        return {
            "code": 200,
            "msg": "Token refresh succeeded!",
            "data":
                {
                    "user_id": g.user.user_id,
                    "login_id": g.user.login_id
                },
            "token": g.user.generate_auth_token().decode("ascii")
        }

    @auth.login_required
    def post(self):
        """刷新Token
        @@@
        #### args
            json
            {
                "user_id":"a",
                "password":"q"
            }
            or
            ?token=xxx
        #### return
            json
            {
               "code": 200,
               "msg": "Token refresh succeeded!",
               "data":
                {
                    "user_id": user_id,
                    "login_id": login_id
                },
               "token": token
            }
        @@@
        """
        return {
            "code": 200,
            "msg": "Token refresh succeeded!",
            "data":
                {
                    "user_id": g.user.user_id,
                    "login_id": g.user.login_id
                },
            "token": g.user.generate_auth_token().decode("ascii")
        }


@apiRoute.resource("/user/<int:id>", endpoint="User")
class API_User(Resource):
    """用户资源接口"""

    # @auth.login_required
    def get(self, id):
        """获取用户信息
        @@@
        #### args
            ?token=xxx
        #### return
            json
            {
               "code": 200,
               "msg": "用户<int:id>信息获取成功!",
               "data":
                {
                    user表中所有信息
                }
            }
        @@@
        """

        # userId = g.user.user_id
        userId = id
        if User.query.filter_by(user_id=userId).first() is None:
            return {"code": 404, "msg": "User does not exist!", "data": None}, 404

        print("sss:", request)

        print({
            "code": 200,
            "msg": "login successful!",
            "data":
                {
                    "id": id,
                    "login_id": id
                },
            "token": id
        }, {"Location": url_for("api.User", id=id, _external=True)})

        return "ssss"

    def post(self):
        pass


# 测试
##################################################################################################################
@apiRoute.resource("/test")
class test(Resource):

    def get(self):
        return "ss"

    def post(self):
        print("post")

        return {"data": "post"}
