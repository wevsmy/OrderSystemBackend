#!/usr/bin/env python
# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: test_basics.py
@Time: 19-1-17 上午11:13
"""
import json
import os
import unittest

import requests
from flask import current_app
from urllib3.util import parse_url

from myApp import create_app, app, db


class BasicsTestCase(unittest.TestCase):
    def setUp(self):
        self.app = create_app("testing")
        self.app_context = self.app.app_context()
        self.app_context.push()
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()
        self.app_context.pop()

    def test_app_exists(self):
        self.assertFalse(current_app is None)

    def test_app_is_testing(self):
        self.assertFalse(current_app.config["TESTING"])

    def test_add_user_data(self):
        from myApp.static.data import insertActives
        insertActives()
        pass


if __name__ == '__main__':
    pass
