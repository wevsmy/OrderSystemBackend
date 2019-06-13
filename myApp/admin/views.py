# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: views.py
@Time: 2019/3/16 14:26
"""

import collections
import uuid

from flask import url_for, render_template, redirect, request
from flask_admin import form
from flask_admin.contrib.fileadmin import FileAdmin
from flask_admin.contrib.sqla import ModelView
from flask_security import current_user
from jinja2 import Markup
from sqlalchemy import func

from myApp import app
from myApp.models import *

file_path = os.path.join(app.root_path, "static/")


# 创建超级管理员认证模型视图类
class AuthModelView(ModelView):

    def is_accessible(self):
        if not current_user.is_active or not current_user.is_authenticated:
            return False

        if current_user.has_role('superuser'):
            return True

        return False

    def _handle_view(self, name, **kwargs):
        if not self.is_accessible():
            if current_user.is_authenticated:
                return Markup(render_template("other/403.html"))
            else:
                return redirect(url_for('security.login', next=request.url))


# 创建商家管理员认证模型视图类
class AuthUserModelView(AuthModelView):
    def is_accessible(self):
        if current_user.is_authenticated:
            return True
        return False

    def get_query(self):
        if current_user.has_role('superuser'):
            return self.session.query(self.model)

        if self.model == Store:
            return self.session.query(self.model).filter(self.model.id == current_user.id)

        return self.session.query(self.model).filter(self.model.store_id == current_user.id)

    def get_count_query(self):
        if current_user.has_role('superuser'):
            return self.session.query(func.count('*')).select_from(self.model)

        if self.model == Store:
            return self.session.query(func.count('*')).filter(self.model.id == current_user.id)

        return self.session.query(func.count('*')).filter(self.model.store_id == current_user.id)


# 只有管理员有权限
class CarouselView(AuthModelView):
    """轮播图管理视图"""

    # 设置缩略图的
    def _list_thumbnail(view, context, model, name):
        if not model.imagePath:
            return ''

        return Markup('<img src="%s">' % url_for('static',
                                                 filename=form.thumbgen_filename(model.imagePath)))

    def is_accessible(self):
        if not current_user.is_active or not current_user.is_authenticated:
            return False

        if current_user.has_role('superuser'):
            return True

        return False

    column_labels = {
        "id": "序号",
        "name": "名称",
        "link": "跳转连接",
        "imagePath": "图片",
        "publicMsg": "图片介绍",
    }
    # 控制列显示
    column_list = ("id", "name", "imagePath", "publicMsg")

    # 格式化列表的显示
    column_formatters = {
        'imagePath': _list_thumbnail
    }
    # 扩展列表显示的头像为60*60像素
    form_extra_fields = {
        'imagePath': form.ImageUploadField("图片",
                                           base_path=file_path,
                                           relative_path='uploadFile/',
                                           thumbnail_size=(60, 60, True))
    }

    def __init__(self, **kwargs):
        super(CarouselView, self).__init__(Carousel, db.session, name="轮播图管理", **kwargs)


class StoreView(AuthUserModelView):
    """商家管理视图"""

    # 设置缩略图的
    def _list_thumbnail(view, context, model, name):
        if not model.imagePath:
            return ""
        return Markup('<img src="%s">' % url_for('static',
                                                 filename=form.thumbgen_filename(model.imagePath)))

    def _list_dishs(view, context, model, name):
        if not model.dishs:
            return ""
        dataList = []
        dishs = Dish.query.filter_by(store_id=model.id).all()
        for dish in dishs:
            category_name = None
            category = Category.query.filter_by(id=dish.category_id).first()
            if category is not None:
                category_name = category.category_name
            tempDict = collections.OrderedDict()
            tempDict["菜品ID"] = "👉{}👈".format(dish.id)
            tempDict["菜品名称"] = "{}🤤".format(dish.dish_name)
            tempDict["菜品单价"] = "{}💲".format(dish.dish_price)
            tempDict["菜品类别ID"] = "🤛{}🤜".format(dish.category_id)
            tempDict["菜品类别名称"] = "{}🤩".format(category_name)
            dataList.append(tempDict)
        return Markup(render_template("other/button_modals.html",
                                      modal=str(uuid.uuid4()),
                                      title="🏪{}🔗{}".format(model.id, view.column_labels[name]),
                                      dataList=dataList,
                                      ))

    def _list_coupons(view, context, model, name):
        if not model.coupons:
            return ""
        dataList = []
        coupons = Coupon.query.filter_by(store_id=model.id).all()
        for coupon in coupons:
            actives_text = None
            actives = Actives.query.filter_by(id=coupon.actives_id).first()
            if actives is not None:
                actives_text = actives.text
            tempDict = collections.OrderedDict()
            tempDict["优惠券ID"] = "{}".format(coupon.id)
            tempDict["优惠券内容"] = "{}".format(coupon.coupon_content)
            tempDict["优惠券类别ID"] = "{}".format(coupon.actives_id)
            tempDict["优惠券类别"] = "{}".format(actives_text)
            dataList.append(tempDict)
        return Markup(render_template("other/button_modals.html",
                                      modal=str(uuid.uuid4()),
                                      title="🏪{}🔗{}".format(model.id, view.column_labels[name]),
                                      dataList=dataList,
                                      ))

    def _list_qrCode(view, context, model, name):
        if model.has_role('superuser'):
            return ""

        return Markup(render_template("other/img_code.html",
                                      modal=str(uuid.uuid4()),
                                      title="🏪{}🔗{}".format(model.id, view.column_labels[name]),
                                      click="click{}".format(model.id),
                                      storeId=str(model.id),
                                      ))

    can_create = False
    # 不允许删除
    can_delete = False

    column_labels = {
        "id": "序号",
        "storeName": "商家名",
        "imagePath": "商家图片",
        "publicMsg": "商家公告",
        "qrCode": "小程序码",
        "dishs": "关联菜品",
        "coupons": "关联优惠券",
        "orders": "关联订单",
        "email": "登录邮箱",
        "password": "密码",
        "active": "在线状态",
        "confirmed_at": "注册时间",
        "roles": "关联角色",
    }
    column_list = ("id", "storeName", "imagePath", "publicMsg", "dishs", "coupons", "qrCode")

    # 格式化列表的显示
    column_formatters = {
        "imagePath": _list_thumbnail,
        "dishs": _list_dishs,
        "coupons": _list_coupons,
        "qrCode": _list_qrCode,
    }
    # 扩展列表显示的头像为60*60像素
    form_extra_fields = {
        'imagePath': form.ImageUploadField("图片",
                                           base_path=file_path,
                                           relative_path='uploadFile/',
                                           thumbnail_size=(60, 60, True)),
    }

    def __init__(self, **kwargs):
        super(StoreView, self).__init__(Store, db.session, name="商家管理", **kwargs)


class DishView(AuthUserModelView):
    """菜品管理视图"""

    # 设置缩略图的
    def _list_thumbnail(view, context, model, name):
        if not model.imagePath:
            return ''

        return Markup('<img src="%s">' % url_for('static',
                                                 filename=form.thumbgen_filename(model.imagePath)))

    # 设置菜品价格显示的
    def _list_dish_price(view, context, model, name):
        if not model.dish_price:
            return ""
        return "{}💲".format(model.dish_price)

    # 设置关联商家显示的
    def _list_store(view, context, model, name):
        store = Store.query.filter_by(id=model.store_id).first()
        if store is not None:
            storeName = store.storeName
            return "{},{}".format(model.store_id, storeName)
        return model.store_id

    # 设置关联菜品类别显示的
    def _list_category(view, context, model, name):
        category = Category.query.filter_by(id=model.category_id).first()
        if category is not None:
            category_name = category.category_name
            return "{},{}".format(model.category_id, category_name)
        return model.category_id

    column_labels = {
        "id": "序号",
        "dish_name": "菜名",
        "dish_price": "价格",
        "dish_description": "菜品介绍",
        "imagePath": "菜品图片",
        "store_id": "关联商家ID",
        "category_id": "关联菜品类别ID",
        "onSale": "付款状态",
    }
    column_list = ("id", "dish_name", "dish_price", "dish_description", "imagePath", "store_id", "category_id")
    # 筛选器
    column_filters = ["category_id", ]
    # 格式化列表的显示
    column_formatters = {
        "dish_price": _list_dish_price,
        "imagePath": _list_thumbnail,
        "store_id": _list_store,
        "category_id": _list_category,
    }

    # 扩展列表显示的图片为60*60像素
    form_extra_fields = {
        'imagePath': form.ImageUploadField("图片",
                                           base_path=file_path,
                                           relative_path='uploadFile/',
                                           thumbnail_size=(60, 60, True))
    }

    def __init__(self, **kwargs):
        super(DishView, self).__init__(Dish, db.session, name="菜品管理", **kwargs)


class CategoryView(AuthModelView):
    """菜品类别管理视图"""
    column_labels = {
        "id": "序号",
        "category_name": "菜品类别名称",
        "dishs": "关联菜品",
    }
    column_list = ("id", "category_name",)

    # column_filters = ["store_id", "category_id"]

    def __init__(self, **kwargs):
        super(CategoryView, self).__init__(Category, db.session, name="菜品类别管理", **kwargs)


class CouponView(AuthUserModelView):
    """优惠券管理视图"""

    # 设置关联商家显示的
    def _list_store(view, context, model, name):
        store = Store.query.filter_by(id=model.store_id).first()
        if store is not None:
            storeName = store.storeName
            return "{},{}".format(model.store_id, storeName)
        return model.store_id

    # 设置关联优惠券类型显示的
    def _list_actives(view, context, model, name):
        actives = Actives.query.filter_by(id=model.actives_id).first()
        if actives is not None:
            text = actives.text
            return "{},{}".format(model.actives_id, text)
        return model.actives_id

    column_labels = {
        "id": "序号",
        "coupon_name": "名称",
        "coupon_num": "总数量",
        "coupon_content": "内容",
        "beginTime": "生效时间",
        "endTime": "失效时间",
        "store_id": "关联商家id,name",
        "actives_id": "关联优惠券类型id,text",
    }
    column_list = (
        "id", "coupon_name", "coupon_num", "coupon_content", "beginTime", "endTime", "store_id", "actives_id")
    # 格式化列表的显示
    column_formatters = {
        'store_id': _list_store,
        'actives_id': _list_actives,
    }

    # column_filters = ["store_id", "category_id"]

    def __init__(self, **kwargs):
        super(CouponView, self).__init__(Coupon, db.session, name="优惠卷管理", **kwargs)


class ActivesView(AuthModelView):
    """优惠券类型管理视图"""
    column_labels = {
        "id": "序号",
        "text": "优惠卷类型",
        "coupons": "关联的优惠券",
    }

    can_create = False
    can_delete = False
    # 控制列显示
    column_list = ("id", "text")

    # # 允许编辑的列
    # column_editable_list=()

    # column_filters = ["store_id", "category_id"]

    def __init__(self, **kwargs):
        super(ActivesView, self).__init__(Actives, db.session, name="优惠卷类别管理", **kwargs)


class UserView(AuthModelView):
    """用户管理视图"""

    # 设置缩略图的
    def _list_thumbnail(view, context, model, name):
        if not model.avatarUrl:
            return ''
        return Markup('<img src="%s" alt = "%s" width = "50px" height = "50px">' % (model.avatarUrl, model.nickName))

    # 设置性别显示的
    def _list_gender(view, context, model, name):
        if model.gender == 0:
            return Markup('<text style="font-size:30px" alt="未知">👽</text>')
        elif model.gender == 1:
            return Markup('<text style="font-size:30px" alt="男">🚹</text>')
        elif model.gender == 2:
            return Markup('<text style="font-size:30px" alt="女">🚺</text>')
        else:
            return ""

    column_labels = {
        "id": "序号",
        "login_id": "登录ID",
        "password_hash": "密码HASH",
        "openid": "微信ID",
        "session_key": "微信KEY",
        "gender": "性别",
        "province": "省份",
        "country": "国家",
        "avatarUrl": "头像",
        "nickName": "微信昵称",
        "city": "城市",
        "language": "语言",
        "orders": "关联订单",
    }

    can_delete = False
    # 控制列显示
    column_list = ("id", "openid", "nickName", "avatarUrl", "gender", "country", "city", "province", "language")
    # # 允许编辑的列
    # column_editable_list = ("nickName", "avatarUrl", "gender")
    # 格式化列表的显示
    column_formatters = {
        'avatarUrl': _list_thumbnail,
        'gender': _list_gender,
    }

    def __init__(self, **kwargs):
        super(UserView, self).__init__(User, db.session, name="用户管理", **kwargs)


class OrderView(AuthUserModelView):
    """订单管理视图"""

    def _list_dishs(view, context, model, name):
        if not model.dishs:
            return ""
        dataList = []
        for dish in model.dishs:
            jsonDataList = json.loads(model.order_json)
            for i in jsonDataList:
                if i["foodId"] == dish.id:
                    category_name = None
                    category = Category.query.filter_by(id=dish.category_id).first()
                    if category is not None:
                        category_name = category.category_name
                    tempDict = collections.OrderedDict()
                    tempDict["菜品ID"] = "👉{}👈".format(dish.id)
                    tempDict["菜品名称"] = "{}🤤".format(dish.dish_name)
                    tempDict["菜品单价"] = "{}💲".format(dish.dish_price)
                    tempDict["购买数量"] = "{}📦".format(i["count"])
                    tempDict["菜品类别ID"] = "🤛{}🤜".format(dish.category_id)
                    tempDict["菜品类别名称"] = "{}🤩".format(category_name)
                    dataList.append(tempDict)
        return Markup(render_template("other/button_modals.html",
                                      modal=str(uuid.uuid4()),
                                      title="🏪{}🔗{}".format(model.id, view.column_labels[name]),
                                      dataList=dataList,
                                      ))

    def _list_users(view, context, model, name):
        if not model.user_id:
            return ""
        dataList = []
        user = User.query.filter_by(id=model.user_id).first()
        tempDict = collections.OrderedDict()
        tempDict["用户ID"] = "👉{}👈".format(user.id)
        tempDict["用户名称"] = "{}🤤".format(user.nickName)
        dataList.append(tempDict)
        return Markup(render_template("other/button_modals.html",
                                      modal=str(uuid.uuid4()),
                                      title="🏪{}🔗{}".format(model.id, view.column_labels[name]),
                                      dataList=dataList,
                                      ))

    # can_create = False
    # can_edit = False
    can_delete = False
    column_labels = {
        "id": "序号",
        "user_id": "关联用户",
        "store_id": "关联商家",
        "dishs": "关联菜品",
        "order_id": "订单编号",
        "order_amount": "订单总金额",
        "order_json": "Json信息",
        "user_content": "用户备注",
        "create_time": "下单时间",
        "payStatus": "支付状态",
    }
    column_list = ("id", "order_id", "create_time", "order_amount", "payStatus", "user_content", "user_id", "dishs")
    # 格式化列表的显示
    column_formatters = {
        "dishs": _list_dishs,
        "user_id": _list_users,
    }

    def __init__(self, **kwargs):
        super(OrderView, self).__init__(Order, db.session, name="订单管理", **kwargs)


class RoleView(AuthModelView):
    """角色管理视图"""

    column_labels = {
        "id": "序号",
        "name": "角色名称",
        "description": "角色描述",
    }

    def __init__(self, **kwargs):
        super(RoleView, self).__init__(Role, db.session, name="角色管理", **kwargs)


# 文件管理视图类
# 只有管理员可以访问
class StaticFileAdmin(FileAdmin):

    def is_accessible(self):
        if not current_user.is_active or not current_user.is_authenticated:
            return False

        if current_user.has_role('superuser'):
            return True

        return False

    def _handle_view(self, name, **kwargs):
        if not self.is_accessible():
            if current_user.is_authenticated:
                return Markup(render_template("other/403.html"))
            else:
                return redirect(url_for('security.login', next=request.url))

    def __init__(self, **kwargs):
        super(StaticFileAdmin, self).__init__(os.path.join(app.root_path, "static/"), '/static/',
                                              name="静态文件", **kwargs)


def AddViews(admin):
    # 添加管理视图
    admin.add_view(CarouselView())
    admin.add_view(StoreView())
    admin.add_view(DishView())
    admin.add_view(CategoryView())
    admin.add_view(CouponView())
    admin.add_view(ActivesView())
    admin.add_view(UserView())
    admin.add_view(OrderView())
    admin.add_view(RoleView())
    admin.add_view(StaticFileAdmin())
