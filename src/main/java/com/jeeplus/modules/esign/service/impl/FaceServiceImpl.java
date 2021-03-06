package com.jeeplus.modules.esign.service.impl;

import com.jeeplus.modules.cyl.bean.Supplier_enterprise;
import com.jeeplus.modules.cyl.bean.Supplier_user;
import com.jeeplus.modules.cyl.dao.Supplier_enterpriseDao;
import com.jeeplus.modules.cyl.dao.Supplier_userDao;
import com.jeeplus.modules.esign.bean.*;
import com.jeeplus.modules.esign.comm.LocalCacheHelper;
import com.jeeplus.modules.esign.constant.CacheKeyConstant;
import com.jeeplus.modules.esign.dao.UserEsignDao;
import com.jeeplus.modules.esign.service.FaceService;
import com.jeeplus.modules.esign.util.EsignUtil;
import com.jeeplus.modules.esign.util.OKHttpUtils;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class FaceServiceImpl implements FaceService {
    private static final Logger logger = LoggerFactory.getLogger(FaceServiceImpl.class);

    @Autowired
    private Supplier_enterpriseDao supplier_enterprisedao;

    @Autowired
    private Supplier_userDao supplier_userDao;

    @Autowired
    private UserEsignDao userEsignDao;
    @Value("${BASE_URL}")
    private String BASE_URL;

    @Override
    public FaceUrlDto getFaceUrl() {
        String userId = UserUtils.getUser().getId();
        ContextInfo contextInfo = new ContextInfo();
        //异步回调接口
        contextInfo.setNotifyUrl(BASE_URL + "/face/faceResult");
        //重定向地址
        contextInfo.setRedirectUrl(BASE_URL + "/a/sys/register/to-supplierContract?id=" + UserUtils.getUser().getId());
        OrgEntity orgEntity = new OrgEntity();
        Supplier_user supplier_user = new Supplier_user();
        supplier_user.setUserId(UserUtils.getUser());
        List<Supplier_user> list = supplier_userDao.findList(supplier_user);
        Supplier_enterprise supplierEnterprise = list.get(0).getSupplierEnterpriseId();
        orgEntity.setCertNo(supplierEnterprise.getOrgCode());
        orgEntity.setName(supplierEnterprise.getName());
        orgEntity.setCertType("ORGANIZATION_USC_CODE");
        orgEntity.setLegalRepCertNo(supplierEnterprise.getLegalIdCard());
        orgEntity.setCertType("INDIVIDUAL_CH_IDCARD");
        orgEntity.setLegalRepName(supplierEnterprise.getLegalName());
        orgEntity.setOperatorType(supplierEnterprise.getAgencyIdCard().equals(supplierEnterprise.getLegalIdCard()) ? "1" : "2");

        UserEsignFaceDto userEsignFaceDto = new UserEsignFaceDto();
        UserEsign userEsignRe = getUserEsignByUserId(userId);
        userEsignFaceDto.setAgentAccountId(userEsignRe.getEsignId());
        contextInfo.setContextId(userEsignRe.getEsignId());

        UserEsign userEnter = getUserEsignByUserIdEnter(supplierEnterprise.getId(), "1");
        userEsignFaceDto.setAccountId(userEnter.getEsignId());

        userEsignFaceDto.setContextInfo(contextInfo);
        userEsignFaceDto.setOrgEntity(orgEntity);
        //直接更改状态3  演示用
        supplierEnterprise.setState("3");
        supplier_enterprisedao.update(supplierEnterprise);


        return EsignUtil.getFaceUrl(userEsignFaceDto);
    }

    private UserEsign getUserEsignByUserIdEnter(String userId, String type) {
        UserEsign userEsignRe = userEsignDao.getUserEsignByUserIdAndType(userId, type);
        return userEsignRe;
    }

    @Override
    @Transactional
    public Object faceResult(FaceResultDto faceResultDto) {
        logger.info("开始回调={}",faceResultDto.toString());
        UserEsign userEsign = new UserEsign();
        UserEsign userEsignRe = userEsignDao.getUserEsignByUserIdAndType(faceResultDto.getAccountId(), "1");
        userEsignRe.setRealNameStatus("4");
        if (faceResultDto.getSuccess()) {
            userEsignRe.setRealNameStatus("3");
            //企业更新审核状态为3
            UserEsign userEnter = getUserEsignByEsignId(faceResultDto.getAccountId());
            Supplier_enterprise supplierEnterprise = supplier_enterprisedao.getById(userEnter.getUserId());
            supplierEnterprise.setState("3");
            supplier_enterprisedao.update(supplierEnterprise);
            logger.info("更新企业状态={}",faceResultDto.getAccountId());
        }
        userEsignDao.upfateUserEsignByUserId(userEsignRe);
        logger.info("更新用户信息={}",faceResultDto.getAgentAccountId());
        return "false";
    }

    @Override
    public Object getAccessToken() {
        return LocalCacheHelper.get(CacheKeyConstant.TOKEN);
    }

    public UserEsign getUserEsignByUserId(String userId) {
        UserEsign userEsignRe = userEsignDao.getUserEsignByUserId(userId);
        return userEsignRe;
    }

    public UserEsign getUserEsignByEsignId(String esignId) {
        UserEsign userEsignRe = userEsignDao.getUserEsignByEsignId(esignId);
        return userEsignRe;
    }

    @Test
    public void test() {
        getFaceUrl();
    }
}
