# 毕设 点餐系统后台

## 初始化数据库
- 数据库初始化
`python manage.py db init`
- 生成数据迁移文件
`python manage.py db migrate`
- 根据迁移文件更新数据库
`python manage.py db upgrade`
- 插入测试数据
`python manage.py shell` && `insert()`


运行
`python manage.py runserver`
or
`python manage.py runserver -h 0.0.0.0 -p 5002 -d`


