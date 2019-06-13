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
@Time: 19-1-17 下午2:59
"""

import requests
from flask import Blueprint, request
from flask_docs import ApiDoc
from flask_restful import Api

from myApp import app
from myApp.api import WXBizDataCrypt

api = Blueprint("api", __name__)


@api.route('/wx_imgCode')
def imgCode():
    storeId = request.args.get("storeId")
    if storeId is not None:
        url = "https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token=" + WXBizDataCrypt.GetWxAccess_token()
        jsonDict = {
            "scene": storeId,
        }
        data = requests.post(url, json=jsonDict)
        response = app.make_response(data.content)
        response.headers['Content-Type'] = 'image/jpeg'
        return response, data.status_code
    return "storeId is none", 404


apiRoute = Api(api)

ApiDoc(app)

from myApp.api import views
