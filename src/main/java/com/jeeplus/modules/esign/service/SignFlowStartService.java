package com.jeeplus.modules.esign.service;

import com.jeeplus.modules.esign.bean.ServerResponse;
import com.jeeplus.modules.esign.exception.DefineException;

public interface SignFlowStartService {

    ServerResponse signFlowStart(String flowId) throws DefineException;

}
