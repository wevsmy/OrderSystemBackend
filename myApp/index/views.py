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
@Time: 19-1-5 下午6:12
"""

from myApp.index import index


@index.route("/")
def index():
    return "<h1>This is index debug</h1>"
