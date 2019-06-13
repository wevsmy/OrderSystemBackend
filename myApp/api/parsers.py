#!/usr/bin/env python
# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: parsers.py
@Time: 19-1-22 上午10:38
"""

from flask_restful import reqparse

user_post_parser = reqparse.RequestParser()

user_post_parser.add_argument(
    "login_id",
    type=str,
    required=True,
    help='Username is required!')

user_post_parser.add_argument(
    "password",
    type=str,
    required=True,
    help='Password is required!')
