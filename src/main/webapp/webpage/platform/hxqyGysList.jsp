<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>核心企业--供应商管理--供应商列表</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/online/style.css" rel="stylesheet" type="text/css">
	<script>
		$(function(){
			if($("#gys-state").attr("val") != undefined && $("#gys-state").attr("val") != null && $("#gys-state").attr("val") != ""){
      			$("#gys-state option[value="+ $("#gys-state").attr("val") +"]")[0].selected = true;
      		}
		});
	</script>
</head>
<body class="gray-bg">
	<div class="rong_nav">
		<ul>
			<li><a href="${ctx}/coreSupplierCtrl/invitation-gys?coreEnterpriseId.id=${fns:getUser().core.id}" class="nav_b">邀请供应商</a></li>
	       	<li><a href="${ctx}/coreSupplierCtrl/hxqyGys-list?coreEnterpriseId.id=${fns:getUser().core.id}" class="nav_a">供应商列表</a></li>
	   	</ul>
	</div>
	<div class="wrapper wrapper-content" style="padding: 0;">
		<div class="ibox" style="margin-bottom: 0;">
			<div class="ibox-title">
				<h5><a href="${ctx}/coreSupplierCtrl/hxqyGys-list?coreEnterpriseId.id=${fns:getUser().core.id}">供应商列表</a></h5>
				<span>&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;供应商列表</span>
				<div class="ibox-tools">
					<a class="collapse-link">
						<i class="fa fa-chevron-up"></i>
					</a>
					<a class="close-link">
						<i class="fa fa-times"></i>
					</a>
				</div>
			</div>
    		<div class="ibox-content">
				<sys:message content="${message}"/>
	
				<!-- 查询条件 -->
				<div class="row">
					<form:form style="padding-left: 15px; margin-bottom: 5px;" id="searchForm" modelAttribute="core_supplier" action="${ctx}/coreSupplierCtrl/hxqyGys-list?coreEnterpriseId.id=${fns:getUser().core.id}" method="post" class="form-inline">
						<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
						<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
						<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
						<div class="form-group">
							<input name="supplierEnterpriseId.name" value="${core_supplier.supplierEnterpriseId.name}" placeholder="供应商名称" class="input-sm form-control" />
							<input style="margin-left: 10px;" name="supplierEnterpriseId.agencyName" value="${core_supplier.supplierEnterpriseId.agencyName}" placeholder="操作员姓名" class="input-sm form-control" />
							<input style="margin-left: 10px;" name="supplierEnterpriseId.agencyPhone" value="${core_supplier.supplierEnterpriseId.agencyPhone}" placeholder="手机号" class="input-sm form-control" />
						</div>
						<div class="form-group" style="display: block; margin-top: 10px;">
							<input name="supplierEnterpriseId.agencyEmail" value="${core_supplier.supplierEnterpriseId.agencyEmail}" placeholder="邮箱" class="input-sm form-control" />
							<select style="margin-left: 10px; padding:0 12px;" id="gys-state" name="supplierEnterpriseId.state" val="${core_supplier.supplierEnterpriseId.state}" class="input-sm form-control input-s-sm inline">
                      			<option value="">认证状态</option>
                      			<option value="0">待提交资料</option>
                      			<option value="1">待平台审核</option>
                      			<option value="2">平台审核不通过</option>
                      			<option value="3">待签约</option>
                      			<option value="4">已签约待银行授信</option>
                    		</select>
						</div>
					</form:form>
			        <div class="col-sm-12" style="margin-top: 10px; margin-bottom: 10px;">
			        	<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
			        	<button style="margin-left: 10px;" class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="reset()" ><i class="fa fa-refresh"></i> 重置</button>
      					<span style="margin-left: 20px; font-size: 1.2em; line-height: 40px;">待提交供应商${waitSubmit}个，待审核的有${waitExamine}个，待签约的有${waitContract}个，已签约的有${haveContract}个</span>
					</div>
					<div class="col-sm-12">
						<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
							<thead>
								<tr>
									<th><input type="checkbox" class="i-checks"></th>
									<th>供应商名称</th>
									<th>操作员姓名</th>
									<th>手机号</th>
									<th>邮箱</th>
									<th>认证状态</th>
									<th>注册时间</th>
									<th>总额度（元）</th>
									<th>可用额度（元）</th>
									<th>利率（%）</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${page.list}" var="core_supplier">
									<tr>
										<td><input type="checkbox" id="${core_supplier.supplierEnterpriseId.id}" class="i-checks"></td>
										<td>${core_supplier.supplierEnterpriseId.name}</td>
										<td>${core_supplier.supplierEnterpriseId.agencyName}</td>
										<td>${core_supplier.supplierEnterpriseId.agencyPhone}</td>
										<td>${core_supplier.supplierEnterpriseId.agencyEmail}</td>
										<td>
											<c:if test="${core_supplier.supplierEnterpriseId.state == '0'}">
												待提交资料
											</c:if>
											<c:if test="${core_supplier.supplierEnterpriseId.state == '1'}">
												待平台审核
											</c:if>
											<c:if test="${core_supplier.supplierEnterpriseId.state == '2'}">
												平台审核不通过
											</c:if>
											<c:if test="${core_supplier.supplierEnterpriseId.state == '3'}">
												待签约
											</c:if>
											<c:if test="${core_supplier.supplierEnterpriseId.state == '4'}">
												已签约待银行授信
											</c:if>
											<c:if test="${core_supplier.supplierEnterpriseId.state == '5'}">
												授信通过
											</c:if>
											<c:if test="${core_supplier.supplierEnterpriseId.state == '6'}">
												银行授信不通过
											</c:if>
										</td>
										<td><fmt:formatDate value="${core_supplier.registerTime}" type="both"/></td>
										<td><fmt:formatNumber type="currency" currencySymbol="￥" value="${core_supplier.supplierEnterpriseId.paramsId.allQuota}" /></td>
										<td><fmt:formatNumber type="currency" currencySymbol="￥" value="${core_supplier.supplierEnterpriseId.paramsId.availableQuota}" /></td>
										<td>${core_supplier.supplierEnterpriseId.paramsId.interestRate}</td>
										<td>
			                            	<a href="${ctx}/gys/gys-info?id=${core_supplier.supplierEnterpriseId.id}" style="color: #ffffff;" class="btn btn-primary btn-xs">详情</a>
					                    </td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<!-- 分页代码 -->
						<table:page page="${page}"></table:page>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script>
		document.onreadystatechange = subSomething;//当页面加载状态改变的时候执行这个方法. 
		function subSomething() 
		{ 
			if(document.readyState == "complete") //当页面加载状态
			{
				setTimeout(function(){
					$(".pace-progress").css("top", "52px");
				}, 200);
				parent.setIframeHeight($(".wrapper").height() + 55);
			}
		} 
	</script>
</body>
</html>