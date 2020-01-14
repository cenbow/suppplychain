package com.jeeplus.modules.esign.util;

import com.alibaba.fastjson.JSONObject;
import com.jeeplus.modules.esign.bean.AccessToken;
import com.jeeplus.modules.esign.bean.EsignResultDto;
import com.jeeplus.modules.esign.bean.FaceUrlDto;
import com.jeeplus.modules.esign.bean.UserEsignFaceDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


/**
 * @author lohas
 */

public class EsignUtil {

    private static final Logger logger = LoggerFactory.getLogger(EsignUtil.class);

    //todo 上线前改成生产的地址以及密钥
    private static final String BASE_URL = "https://smlopenapi.esign.cn";
    private static final String APPID = "4438793080";
    private static final String APPSECRET = "46748dcae0a380f46e75e0e9b7b284e3";

    private static final String GET_TOKEN_URL = "/v1/oauth2/access_token?appId=APPID&secret=APPSECRET&grantType=client_credentials";
    /**
     * 存储token和过期时间
     */
    private static volatile AccessToken at;

    /**
     * 获取token
     */
    private static void getToken(){
        try{
            String url = BASE_URL+GET_TOKEN_URL.replace("APPID",APPID).replace("APPSECRET",APPSECRET);
            JSONObject jsonStr=new JSONObject();
            JSONObject jsonResult = OKHttpUtils.getRequest(url, jsonStr);
            JSONObject json = jsonResult.getJSONObject("data");
            String token = json.getString("token");
            String expireIn = json.getString("expiresIn");
            //创建token，并存储起来
            at = new AccessToken(token,expireIn);
        }catch (Exception e){
            logger.error("获取e签宝accesstoken失败"+e.getMessage());
        }
    }

    /**
     * 向外暴露的获取token的方法
     * @return
     */
    public static String getAccessToken(){
        if(at == null||at.isExpired()){
            getToken();
        }
        return at.getAccessToken();
    }

    public static FaceUrlDto getFaceUrl(UserEsignFaceDto userEsignFaceDto){
        String token=getAccessToken();
        String s = JSONObject.toJSONString(userEsignFaceDto);
        JSONObject jsonObject = JSONObject.parseObject(s);
        HashMap map=new HashMap<String,String>();
        map.put("X-Tsign-Open-App-Id",APPID);
        map.put("X-Tsign-Open-Token",token);
        JSONObject jsonResult = OKHttpUtils.postJsonAddHeader(BASE_URL + "/v2/identity/auth/web/" + userEsignFaceDto.getAccountId() + "/orgIdentityUrl", map, jsonObject);
        EsignResultDto esignResultDto = JSONObject.parseObject(jsonResult.toJSONString(), EsignResultDto.class);
        FaceUrlDto faceUrlDto = JSONObject.parseObject(esignResultDto.getData(), FaceUrlDto.class);
        return faceUrlDto;
    }

    public static void main(String[] args) {
        String accessToken = getAccessToken();
        System.out.println(accessToken);
        System.out.println(getAccessToken());
    }
}
