更新时间2017年11月26日

1.使用说明
cordova plugin add https://github.com/waliu/cordova-Alipay-chenyu.git --variable APP_ID=【你的appKey】
2.调用说明
cordova.plugins.MyAlipay.coolMethod(orderStr,
      (msg) => {
        
      },
      (msg) => {
        alert('失败');
      }
 );
 参数说明：orderStr
 是支付宝 签名字符串 详细看支付宝 https://docs.open.alipay.com/204/105296/
 返回参数
