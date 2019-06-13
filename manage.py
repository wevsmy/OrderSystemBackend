#!/usr/bin/env python
# coding:utf-8
"""
@Version: V1.0
@Author: willson
@License: Apache Licence
@Contact: willson.wu@goertek.com
@Site: goertek.com
@Software: PyCharm
@File: manage.py
@Time: 19-1-5 下午6:31
"""
import os

from flask_migrate import Migrate, MigrateCommand
from flask_script import Manager, Shell

from myApp import create_app, db
from myApp.static.data import Insert

app = create_app(os.getenv("FLASK_CONFIG") or "default")

manager = Manager(app)
migrate = Migrate(app, db)


def make_shell_context():
    "注册Shell上下文方便调试"
    return dict(app=app, db=db, insert=Insert)


@manager.command
def test():
    import unittest
    tests = unittest.TestLoader().discover("tests")
    unittest.TextTestRunner(verbosity=2).run(tests)


manager.add_command("shell", Shell(make_context=make_shell_context))
manager.add_command("db", MigrateCommand)

if __name__ == '__main__':
    manager.run()
