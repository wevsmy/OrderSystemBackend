import base64
import json
import time

import requests
from Crypto.Cipher import AES

from myApp import configs

wx = configs["wxConfig"]


class WXBizDataCrypt:
    def __init__(self, appId, sessionKey):
        self.appId = appId
        self.sessionKey = sessionKey

    def decrypt(self, encryptedData, iv):
        # base64 decode
        sessionKey = base64.b64decode(self.sessionKey)
        encryptedData = base64.b64decode(encryptedData)
        iv = base64.b64decode(iv)

        cipher = AES.new(sessionKey, AES.MODE_CBC, iv)

        decrypted = json.loads(self._unpad(cipher.decrypt(encryptedData)))

        if decrypted['watermark']['appid'] != self.appId:
            raise Exception('Invalid Buffer')

        return decrypted

    def _unpad(self, s):
        return s[:-ord(s[len(s) - 1:])]


# 获取微信access_token
def GetWxAccess_token():
    # 判断缓存的access_token 是否快过期
    if time.time() - wx.tokenDict["now_time"] < 1 * 60:
        return wx.tokenDict["access_token"]
    else:
        url = "https://api.weixin.qq.com/cgi-bin/token"
        kv = {"appid": wx.appId, "secret": wx.appSecret, "grant_type": "client_credential"}
        data = requests.get(url, params=kv, timeout=300)
        if data.status_code == 200:
            jsonDict = json.loads(data.text)
            wx.tokenDict["access_token"] = jsonDict["access_token"]
            wx.tokenDict["expires_in"] = jsonDict["expires_in"]
            wx.tokenDict["now_time"] = time.time()
            return wx.tokenDict["access_token"]
        else:
            return wx.tokenDict["access_token"]
