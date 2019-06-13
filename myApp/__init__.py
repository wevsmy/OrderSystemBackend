#!/usr/bin/env python
# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: __init__.py
@Time: 19-1-5 下午6:09
"""

from flask import Flask, url_for
from flask_admin import Admin, AdminIndexView
from flask_admin import helpers as admin_helpers
from flask_babelex import Babel
from flask_security import Security, SQLAlchemyUserDatastore

from config import configs
from myApp.models import db, Store, Role

app = Flask(__name__)
from myApp.admin.views import AddViews

store_datastore = SQLAlchemyUserDatastore(db, Store, Role)


def create_app(config_name="default"):
    app.config.from_object(configs[config_name])
    configs[config_name].init_app(app)
    db.init_app(app)

    # 注册蓝图
    from myApp.index import index as index_blueprint
    app.register_blueprint(index_blueprint)

    from myApp.api import api as api_blueprint
    app.register_blueprint(api_blueprint, url_prefix='/api')

    babel = Babel(app)

    # Setup Flask-Security
    security = Security(app, store_datastore)

    admin = Admin(
        app,
        name="系统后台",
        base_template="my_master.html",
        template_mode="bootstrap3",
        index_view=AdminIndexView(
            name='导航栏',
            template='admin/index.html',
            url='/admin'
        )
    )

    # 添加管理視圖
    AddViews(admin)

    # flask-security views.
    @security.context_processor
    def security_context_processor():
        return dict(
            admin_base_template=admin.base_template,
            admin_view=admin.index_view,
            h=admin_helpers,
            get_url=url_for
        )

    return app
