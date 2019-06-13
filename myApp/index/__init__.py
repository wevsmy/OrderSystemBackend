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
@Time: 19-1-5 下午6:10
"""

from flask import Blueprint

index = Blueprint("index", __name__)

from myApp.index import views

from flask import current_app

import os
from flask import send_from_directory


@index.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(current_app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')
