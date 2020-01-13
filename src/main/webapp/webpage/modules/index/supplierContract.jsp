<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<html>
<head>
    <title>供应商--等待签约</title>
    <meta name="decorator" content="default"/>
    <link href="${ctxStatic}/online/style.css" rel="stylesheet" type="text/css"/>
    <script src="${ctxStatic}/online/lgt-web.js"></script>
    <style>
        .chuangxin_logout{
            float:right;
            width:168px;
            height:45px;
            line-height:45px;
            text-align:center;
            font-size:18px;
            color:#ffffff !important;
            background: #ff1b2c;
            border-radius:8px;
            margin-left:25px;
            display:inline;
        }


    </style>
    <script>
        $(function () {
            //处理状态
            if (!$.isEmpty($("#orgState").val())) {
                if ($("#orgState").val() == "2") {
                    location.href = "${ctx}/logout";
                }
                if (($("#orgState").val() == "0" || $("#orgState").val() == "1") && !$.isEmpty($("#userId").val())) {
                    location.href = "${ctx}/sys/register/to-supplierSubmitData?id=" + $("#userId").val();
                    ;
                }
                if ($("#orgState").val() != "0" && $("#orgState").val() != "1" && $("#orgState").val() != "2" && $("#orgState").val() != "3") {
                    location.href = "${ctx}/logout";
                }
            }

            if ($.isEmpty($("#orgId").val())) {
                location.href = "${ctx}/logout";
            }

            if (!$.isEmpty($("#message").val())) {
                layer.msg($("#message").val(), {shift: 6});

                if ($("#message").val() == "签约成功！") {
                    setTimeout(function () {
                        location.href = "${ctx}/login";
                    }, 2000);
                } else if (!$.isEmpty($("#userId").val())) {
                    location.href = "${ctx}/sys/register/to-supplierContract?id=" + $("#userId").val();
                }
            }
        });

        //切换
        function successful(obj, index) {
            $("#a0 li").attr("class", "successfulB");
            $(obj).attr("class", "successfulA");
            $(".successful_xie_con").hide();
            $("#a0" + index).show();
        }

        //签约
        function contract() {
            if (!$("#mycheckbox").is(':checked')) {
                layer.msg('请先勾选同意以上平台协议！', {shift: 6});
                return;
            }
            $("#layui-layer-shade100002").show();
            $("#layui-layer100002").show();
            sendContractCode();
        }

        //发送授权码
        function sendContractCode() {
            if (!$.isEmpty($("#mobile").val())) {
                $("#shouquan-phone").text($("#mobile").val());
                $.ajax({
                    async: true,
                    cache: true,
                    url: "${ctx}/sys/register/get-mobile-code?mobile=" + $("#mobile").val(),
                    data: {},
                    type: "get",
                    dataType: "text",
                    success: function (data, status, xhr) {
                        if (data == "000") {
                            layer.msg("验证码已发送，请注意查收短信");
                        } else if (data == "003") {
                            layer.msg("图形验证码错误");
                        } else if (data == "004") {
                            layer.msg("用户名不存在");
                        } else if (data == "005") {
                            layer.msg("手机号码不一致");
                        } else if (data == "006") {
                            layer.msg("手机号码已存在");
                        } else if (data == "007") {
                            layer.msg("手机号码或验证均不能为空");
                        } else {
                            layer.msg(data);
                        }
                    },
                    error: function (xhr, status, error) {
                        layer.msg(status);
                    }
                });
            } else {
                layer.msg("授权手机号不存在，无法授权！");
            }
        }

        //授权确定
        function sure() {
            if ($.isEmpty($("#verify_code").val())) {
                $("#error_verify_code").text("请输入签约授权码！");
                setTimeout(function () {
                    $("#error_verify_code").text("");
                }, 2000);
                return;
            }
            $("#validateCode").val($("#verify_code").val());
            $("#mgmtform").submit();
        }

    </script>
</head>
<body>
<div class="header">
    <div class="header_con" style="width: 1150px;">
        <div class="logo1">
            <span style="border-left: 0px; font-weight: 600; letter-spacing: 2px; font-size: 25px;">创信供应链金融</span>
            <span style="margin-left: 15px;">供应商注册</span>
        </div>
    </div>
</div>


<form name="mgmtform" id="mgmtform" class="form-horizontal" enctype="multipart/form-data"
      action="${ctx}/sys/register/having-supplierContract" accept-charset="UTF-8" method="post">
    <input type="hidden" id="message" value="${message}"/>
    <input type="hidden" id="orgId" name="supplierEnterpriseId.id" value="${supplier_user.supplierEnterpriseId.id}"/>
    <input type="hidden" id="orgState" value="${supplier_user.supplierEnterpriseId.state}"/>
    <input type="hidden" id="userId" name="userId.id" value="${supplier_user.userId.id}"/>
    <input type="hidden" id="validateCode" name="validateCode" value=""/>
    <input type="hidden" id="mobile" name="supplierEnterpriseId.agencyPhone"
           value="${supplier_user.supplierEnterpriseId.agencyPhone}"/>
    <div class="successful clear">
        <div class="title_nav3">
            <span>1  注册账号</span>
            <span>2  提交资料</span>
            <span><font color="#ffffff">3 在线签约</font></span>
        </div>
        <div class="successful_xie">
            <div class="successful_xie_nav">
                <ul id="a0">
                    <li class="successfulA" onclick="successful(this,0)">用户注册服务协议</li>
                    <li class="successfulB" style="width: 155px; display: none;" onclick="successful(this,1)">
                        CFCA数字证书服务协议
                    </li>
                    <li class="successfulB" style="margin-left: 5px;display: none;" onclick="successful(this,2)">
                        安心签平台服务协议
                    </li>
                    <li class="successfulB" style="margin-left: 5px;display: none;" onclick="successful(this,3)">
                        安心签平台隐私条款
                    </li>
                </ul>
            </div>
            <div class="successful_xie_con" id="a00">
                <div class="hetong">
                    <div class="hetong_title">用户注册服务协议</div>
                    <div class="hetong_nei">
                        欢迎使用【创信供应链平台】（以下简称“平台”或“本平台”）服务。为了保障用户的权益，请用户确认使用平台服务前，已经详细阅读了本协议的所有内容。对于责任限制等特别重要条款，本文将用粗体标注，请予以重点关注。<br/>

                        第一章 总则<br/>

                        1.用户在平台注册并确认本协议的行为，表示用户已阅读、理解并同意本协议之所有内容。<br/>
                        2.鉴于网络服务的特殊性，本协议可由平台随时更新，且无需另行通知。用户在使用平台服务时，应关注并遵守其所适用的相关条款。 <br/>
                        3.用户在使用平台服务之前，应仔细阅读本协议。如用户不同意本协议及/或平台随时对其的修改，用户可以主动取消平台服务；用户一旦使用平台服务，即视为用户已了解并完全同意本协议各项内容，包括本平台对本协议随时所做的任何修改，并成为平台用户。
                        <br/>
                        4.平台拥有本协议在法律许可范围内的最终解释权。 <br/>

                        第二章 定义 <br/>

                        如无特别说明，下列用语在本协议中的含义为：<br/>
                        5.平台：指提供多样化创新金融服务的、旨在促进产业链上下游和谐发展的【创信供应链平台】。 <br/>
                        6.平台用户：指加入平台的机构或个人用户。<br/>
                        7.见证机构：指平台认可的合作银行。<br/>
                        8.资金提供方：指根据国家法律法规可以开展融资业务的银行和非银行金融机构、商业保理公司、金融综合服务平台上的投资人等。 <br/>

                        第三章 平台提供的服务<br/>

                        9.平台服务是由本平台向自然人或企业用户提供的服务，具体服务内容主要包括：融资申请服务、数据交互服务、信用评估服务、融资顾问服务、协助结算账户变更服务等，具体详情以本平台当时提供的服务内容为准。<br/>
                        10.本平台作为用户信息的收集方，不涉及用户的交易内容及其交易资金管理服务。用户的交易约定内容和风险应由约定双方各自承担。<br/>

                        第四章 平台收费<br/>

                        11.用户如申请通过本平台进行融资的，需向平台支付平台服务费，平台服务费的具体费用标准及收费方式以用户在申请融资时签署的《创信供应链平台服务协议》为准。<br/>

                        第五章 声明与承诺<br/>

                        12.用户通过本平台申请融资前，应向本平台提交必要的自然人身份信息或者企业名称、企业工商注册号、办公地址、企业人民银行征信信息、企业法人姓名、身份证明、企业开户行及账号等信息，或本平台认为必要的其他信息，并对提交的信息的准确性、真实性与完整性负责。平台有权根据用户具体情况予以拒绝发布或临时撤销。<br/>
                        13.用户确认：用户以网络页面点击确认通过平台申请融资的行为即视为对资金提供方发出要约，未经本平台的同意，用户不得随意撤销该等要约。<br/>
                        14.在使用“平台”服务前，用户确认并同意以下事项： <br/>
                        1)用户是具有法律规定的完全民事权利能力和民事行为能力，能够独立承担民事责任的自然人、法人或其他组织，且本协议内容不受用户所属地区的排斥。不具备前述条件的，用户应立即终止注册或停止使用本网站提供的服务。平台仅向符合完全民事权利能力与民事行为能力的自然人，或符合平台或平台关联实体相关规则的法人或其他组织提供服务。<br/>
                        2)用户同意，尽管平台会尝试提醒用户关于此类操作或告知用户后续处理方式，平台并不对任何由于用户提供资料有误而导致无法通知用户相关信息的情况负责。<br/>
                        3)平台协议项下任何权利或义务，都不得在未经平台同意的情况下被出售或转移到第三方自然人或法人。 <br/>
                        4)任何用户与平台之间的电子邮件形式的沟通都被视为有效沟通。 <br/>

                        15.用户同意并保证不得利用本平台服务从事侵害他人权益或违法之行为，若有违反者应负所有法律责任。上述行为包括但不限于：<br/>
                        1)冒用他人名义使用本平台服务。 <br/>
                        2)涉嫌洗钱、套现或进行非法集资活动的。<br/>
                        3)从事任何可能含有电脑病毒或是可能侵害本平台服务系統、资料等行为。<br/>
                        4)侵犯本平台的商业利益，包括但不限于发布非经本平台许可的商业广告。 <br/>
                        5)其他本平台有正当理由认为不适当之行为。 <br/>

                        本平台在有合理理由怀疑用户进行了本条规定的违约行为时，有权对用户的账户进行调查。如果调查结果证实用户的账户确实存在上述违约行为，本平台有权锁定用户的账户并终止与用户的合作。用户理解并同意本平台不会就账户的冻结以及锁定提供任何赔偿或者补偿。<br/>

                        第六章 不可抗力及服务中断 <br/>

                        16.本平台需要定期或不定期地对提供平台服务系统及其相关的设备进行检修或者维护，如因此类情况而造成网络服务（包括收费服务）在合理时间内的中断，本平台无需为此承担任何责任。本平台保留不经事先通知为维修保养、升级或其它目的暂停本服务任何部分的权利。<br/>

                        第七章 信息收集与披露 <br/>

                        17.平台将严格履行相关法规，确保用户的资料安全。<br/>
                        18.用户同意本平台有权出于为用户提供综合化或专业化服务的目的视情况向其他任何用户认为必要的业务合作机构披露用户资料、保密信息及本协议等。本平台承诺将要求相关合作机构对用户资料、保密信息及本协议等承担保密义务。<br/>
                        19.本平台有权按照用户在平台上的行为自动追踪关于用户的某些资料。在不透露用户个人的隐私资料的前提下，本平台有权对整个用户数据库进行分析并对用户数据库进行商业上的利用。 <br/>
                        20.在本平台提供的交易活动中，用户承诺对所取得的相关交易相对人信息只用于与交易相关的合法、合理用途。用户无权要求本平台提供其他用户的个人资料，除非符合以下任一条件： <br/>
                        a)用户已向法院起诉其他用户的在本平台活动中的违约行为且法院已受理立案； <br/>
                        b)其他有碍于用户收回融资本息或其他合法权益的情形。 <br/>

                        第八章 责任范围及责任限制<br/>

                        21.平台仅是用户发布信息的渠道，平台不保证平台用户上传信息的真实性、充分性、可靠性、准确性、完整性和有效性，平台用户依赖于其独立判断进行交易，并对其做出的判断承担全部责任。<br/>
                        22.平台不对平台用户能否达成融资交易出具任何承诺或保证，亦不对已达成的融资交易的任何风险出具任何承诺或保证。<br/>
                        23.本平台仅承担本协议明确约定的直接责任。除本协议另有规定外，在任何情况下，本平台对本协议所承担的违约赔偿责任总额不超过向用户收取的当次平台服务费用总额。<br/>

                        第九章 商标、知识产权的保护<br/>

                        24.本平台或平台关联方拥有本平台网站内相应资料、技术及展现形式的知识产权。<br/>
                        25.未经许可，任何人不得擅自使用（包括但不限于：以非法的方式复制、传播、展示、镜像、上载、下载）、修改、传播本平台或平台关联方的知识产权。否则，本平台将依法追究法律责任。 <br/>

                        第十章 其他<br/>

                        26.通知方式： <br/>
                        1)拨打客服电话、向客服邮箱发送邮件、传真、EMS等方式均视为客户的有效通知。 <br/>
                        2)拨打客户电话、网站公告、平台站内信、手机短信，向客户指定邮箱发送邮件、传真、快递等方式均视为平台的有效通知。本平台不保证用户能够收到或者及时收到上述邮件（或传真或挂号邮件），且不对此承担任何后果，因此，在交易过程中用户应当及时登录到本网站查看和进行交易操作。因用户没有及时查看和对交易状态进行修改或确认或未能提交相关申请而导致的任何纠纷或损失，本平台不负任何责任。
                        <br/>
                        3)如果本协议条款中的部分条款被有管辖权的法院认定为违法，那么这些条款并不影响其他条款的有效性并将应用其他有效条款按最接近双方意图的可能而推定。 <br/>
                        4)本平台未行使或执行本协议任何权利或规定，不构成对前述权利或权益之放弃。 <br/>
                        5)如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。<br/>
                        27.平台依据本协议约定获得处理违法违规内容的权利，该权利不构成平台的义务或承诺，平台不能保证及时发现违法行为或进行相应处理。<br/>
                        28.在任何情况下，用户不应轻信借款、索要密码或其他涉及财产的网络信息。涉及财产操作的，请一定先核实对方身份，并请经常留意平台有关防范诈骗犯罪的提示。<br/>

                        第十一章 管辖<br/>

                        29.本协议经用户在线上确认勾选后生效。<br/>
                        30.本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。<br/>
                        31.因本协议引起的或与本协议有关的任何争议，尽最大诚意进行友好协商，如果双方不能协商一致，则该争议由平台所在地有管辖权的人民法院管辖。 <br/>

                        <div class="zhang"><span>甲方（签章）：上海创信供应链管理有限公司</span>
                            <!-- <img class="sealpicture" src="/images/zhang.png" /> --></div>
                        <div class="zhang"><span>乙方（签章）：${supplier_user.supplierEnterpriseId.name}</span>
                            <!-- <img class="sealpicture" src="/uploads/axsignaccount/sealpicture/22/YZQY20180914100203787381258700.png" /> -->
                        </div>
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="successful_xie_con" id="a01" style="display:none;">
                <div class="hetong">
                    <div class="hetong_title">CFCA数字证书服务协议</div>
                    <div class="hetong_nei">
                        <b>（本协议包含CFCA的免责条款，请认真阅读，尤其是粗体字内容）</b><br>
                        尊敬的网上用户：<br>
                        中金金融认证中心有限公司(即中国金融认证中心，简称“CFCA”)是经国家有关管理机关审批设立的电子认证服务机构，作为权威的第三方安全认证机构，通过数字证书注册机构（以下简称“RA”）向网上用户（以下简称“订户”）发放数字证书，为订户网上交易提供信息安全保障。<br>
                        订户在申请使用CFCA签发的数字证书之前，应先阅读并同意"CFCA数字证书服务协议"(以下简称"本协议")。本协议构成订户与中金金融认证中心有限公司之间的权利义务约定，若不同意本协议全部或部分条款，请勿申请使用CFCA数字证书。<b>订户一旦完成CFCA数字证书的下载或初次使用，即表明同意接受并愿意遵守本协议的所有条款。</b><br>
                        <b>一、 证书订户的权利和义务</b><br>
                        1、 <b>订户应遵循诚实、信用原则，在向RA申请数字证书时，应当提供其真实、完整、准确的信息和资料，并在这些信息、资料发生改变时及时通知原RA。如因订户故意或过失提供的资料不真实、不完整、不准确或资料改变后未及时通知CFCA或原RA，造成的损失由订户自己承担。</b><br>
                        2、 <b>在通过RA的审核、信息注册后，订户即可获得数字证书的下载凭证，订户应妥善保管下载凭证，亲自用该凭证从相关网站将数字证书下载在安全的容器里；订户也可以委托或授权他人通过其他安全的方式获得数字证书。</b>订户获得的下载凭证为一次性使用，有效期为14天。如果在14天内没有下载数字证书，订户需要到RA重新获得下载凭证。订户应对获得的数字证书信息进行确认，首次使用，视为确认生效。<br>
                        3、 订户须使用经合法途径获得的相关软件。<br>
                        4、 订户应合法使用CFCA发放的数字证书，并对使用数字证书的行为负责：<br>
                        ① 使用证书的行为应符合全部适用的法律法规；<br>
                        ② 使用证书的行为应符合订户真实意愿或者仅为了处理已获得授权的事务；<br>
                        ③ 使用证书的行为应符合本协议约定的使用范围和条件。<br>
                        5、 <b>订户应采取必要手段来保障证书的私钥和相关密码的安全存储、使用备份等。EV代码签名证书必须被保存在满足FIPS-140-2或相应级别的安全介质中；如初次使用智能密码钥匙时，应修改初始的缺省密码。订户如因故意或过失导致他人盗用、冒用数字证书私钥和密码时，订户应自行承担由此产生的责任。</b><br>
                        6、 <b>如订户使用的数字证书私钥和密码泄漏、丢失，或者订户不希望继续使用数字证书，或者订户主体不存在，订户或法定权利人应当立即到原RA申请废止该数字证书，相关手续遵循RA的规定。</b>CFCA收到RA的废止请求后，将在4小时之内废止该订户的数字证书。<br>
                        7、 <b>订户损害CFCA利益的，须向CFCA赔偿全部损失。这些情形包括但不限于：</b><br>
                        ① <b>订户在申请数字证书时没有提供真实、完整、准确信息，或在这些信息变更时未及时通知RA；</b><br>
                        ② <b>订户知道自己的私钥已经失密或者可能已经失密而未及时告知有关各方、并终止使用；</b><br>
                        ③ <b>订户有其他过错或未履行本协议的相关约定。 </b><br>
                        8、 订户有按期缴纳数字证书服务费的义务，费用标准请咨询RA。<br>
                        9、 CFCA有权因安全风险因素要求订户更换数字证书。订户在收到数字证书更换通知后，应在规定的期限内到原RA更换。<br>
                        10、 <b>订户申请代码签名证书后，一旦发现如下情况之一时，应当立即向CA申请吊销此证书：</b><br>
                        ① <b>有证据表明，此代码签名证书被用于签署可疑代码，包括但不限于病毒，木马，或者其他不恰当的程序。</b><br>
                        ② <b>证书中内容不再正确或不再准确。</b><br>
                        ③ <b>此证书私钥信息已被泄露、丢失，或者其他相关部分已被错误使用。</b><br>
                        11、 <b>证书一旦被吊销，订户将不能再使用该证书。</b><br>
                        12、 <b>订户明确了解，如果CFCA发现了订户证书的不当使用，或者订户证书被用于违法甚至犯罪行为，CFCA有权直接吊销订户证书。</b><br>
                        13、 订户在发现或怀疑由CFCA提供的认证服务造成订户的网上交易信息的泄漏和/或篡改时，应在3个月内向CFCA提出争议处理请求并通知有关各方。<br>
                        二、 <b>CFCA的服务、权利、义务、责任限制和免责</b><br>
                        1、
                        CFCA依法制定《电子认证业务规则》（简称CPS），并公布于CFCA网站（www.cfca.com.cn），明确CFCA数字证书的功能、使用证书各方的权利、义务以及CFCA的责任范围，本协议的相关条款源自CPS。<br>
                        2、
                        CFCA为订户提供7X24小时热线支持服务（4008809888）。为保证我们的服务质量，CFCA设立了投诉电话（010-83519756），CFCA将在1个工作日内对订户的意见和建议做出响应。<br>
                        3、 在订户通过安全工具使用数字证书对交易信息进行加密和签名的条件下，CFCA将保证交易信息的保密性、完整性、抗抵赖性。如果发生纠纷，CFCA将依据不同情形承担下述义务：<br>
                        ① 提供签发订户数字证书的CA证书；<br>
                        ② 提供订户数字证书在交易发生时，在或不在CFCA发布的数字证书废止列表内的证明；<br>
                        ③ 对数字证书、数字签名、时间戳的真实性、有效性进行技术确认。<br>
                        4、 <b>有下列情形之一的，CFCA有权撤销所签发的数字证书： </b><br>
                        ① <b>订户申请数字证书时，提供的资料不真实；</b><br>
                        ② <b>订户未履行本协议约定的义务；</b><br>
                        ③ <b>订户书面申请撤销数字证书；</b><br>
                        ④ <b>证书的安全性不能得到保证；</b><br>
                        ⑤ <b>法律、行政法规规定的其他情况。</b><br>
                        5、 <b>CFCA将对订户申请数字证书时提交的信息进行审核，提供证书生命周期內的相关服务，同时向相关方提供查询服务。CFCA及其注册机构均有义务保护订户隐私信息安全性。</b><br>
                        6、 <b>根据《电子签名法》的规定，如果订户依法使用CFCA提供的认证服务进行民事活动而遭受损失的，CFCA将给予相应赔偿，除非CFCA能够证明其提供的服务是按照《电子签名法》等相关法律法规和CFCA向主管部门备案的CPS实施的。以下损失不在赔偿之列：</b><br>
                        ① <b>任何直接或间接的利润或收入损失、信誉或商誉损害、任何商机或契机损失、失去项目、以及失去或无法使用任何数据、无法使用任何设备、无法使用任何软件；</b><br>
                        ② <b>由上述损失相应生成或附带引起的损失或损害。</b><br>
                        7、 <b>以下损失CFCA将不承担责任：</b><br>
                        ① <b>非因CFCA的行为而导致的损失；</b><br>
                        ② <b>因不可抗力而导致的损失，如罢工、战争、灾害、恶意代码病毒等。</b><br>
                        8、
                        <b>CFCA对企业订户申请的数字证书的赔偿上限为人民币伍拾万元整，即￥500,000.00元；对个人订户申请的数字证书的赔偿上限为人民币贰万元整，即￥20,000.00元。</b><br>
                        三、 其他<br>
                        1、 本协议中涉及“原RA”的条款若因原RA合并或撤销，即原RA不存在，则业务的受理与开展应到另行指定的RA进行。<br>
                        2、 建议订户经常浏览CFCA网站（www.cfca.com.cn），以便及时了解CFCA有关证书管理、CPS和本协议变更公示等方面的信息。<br>
                        3、 CFCA有权对本协议进行修订，修订后的本协议将公布于CFCA网站<b>（www.cfca.com.cn）</b>。如订户在本协议公布修订的1个月后继续使用CFCA提供的数字证书服务，即表明同意接受此等修订的约束。如果订户不予接受本协议中的约束，订户可以在上述期限内单方以书面形式向RA申请停止使用证书。<br>
                        4、
                        因依据CFCA的电子认证服务而发生的争议，双方应当先通过友好协商的方式解决（必要时CFCA将召集业内专家组成专家小组，详细流程参见CPS的相关条款），双方不能达成一致意见的，任何一方可以向北京仲裁委员会申请仲裁，按照该会的规则在（北京）进行仲裁，仲裁裁决是终局的，对任何一方均有约束力。<br>
                        5、 本协议在订户完成CFCA数字证书的下载或初次使用时即为生效。<br>
                        中金金融认证中心有限公司<br>
                        (中国金融认证中心)<br>
                        2015年8月4日
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="successful_xie_con" id="a02" style="display:none;">
                <div class="hetong">
                    <div class="hetong_title">安心签平台服务协议</div>
                    <div class="hetong_nei">
                        安心签平台服务（以下简称“本服务”）是由中国金融认证中心全资子公司上海创信供应链管理有限公司（以下简称“本公司”）向其注册用户提供的一种第三方电子缔约服务。本公司提供的安心签平台服务包括但不限于通过您持有的数字证书在安心签平台上对各类数据电文或电子缔约文件等进行电子签名和验签、对签名后的数据电文或电子缔约文件进行存储、提取和管理。<br/>
                        本公司采用的电子缔约技术符合中国法律及其相关法规，其形成的数据电文或电子缔约文件符合中国法律规定，与纸质文件具有同样的法律效力。采用本公司的安心签平台服务可以极大的提升个人事务和企业整体管理水平，实现缔约的线上签署、存储、提取、管理等功能。<br/>
                        一、接受<br/>
                        1.1本协议已对与您的权益有或可能具有重大关系的条款，及对本公司具有或可能具有免责或限制责任的条款予以标注。在您接受本服务之前，请确认您已充分阅读、理解并接受本协议的全部内容，一旦您使用本服务，即表示您同意遵循本协议之所有约定。<br/>
                        1.2您同意，本公司有权随时对本协议内容进行单方面的变更，并在本网站予以公布，无需另行单独通知您；若您在本协议内容变更后继续使用本服务，表示您已充分阅读、理解并接受修改后的协议内容，也将遵循修改后的协议内容使用本服务；若您不同意修改后的协议内容，您应停止使用本服务。<br/>
                        1.3
                        您同意接受本协议并使用此服务时，您是具有法律规定的完全民事权利能力和民事行为能力，能够独立承担民事责任的自然人（中华人民共和国境内（香港、澳门除外）的用户应年满18周岁），或者是在中国大陆地区合法开展经营活动或其他业务的法人或其他组织；本协议内容不受您所属国家或地区法律的排斥。不具备前述条件的，您应立即终止注册或停止使用本服务。您在使用本服务时，应自行判断对方是否是完全民事行为能力人并自行决定是否与对方进行数据电文或电子缔约文件的签署，且您应自行承担与此相关的所有风险。<br/>
                        1.4您同意您在本公司进行的所有电子缔约行为，您不可撤销的授权由本公司按照公布的安心签服务流程规则进行处理。您同意本公司一旦认为有必要修改安心签服务流程，无须单独另行通知您。<br/>
                        1.5您知悉并承认凡是在您账户下，数据电文或电子缔约文件签署各方已经完成电子签名的电子缔约文件，均具备法律效力。您将按照电子缔约文件内容，依法履行电子缔约文件相关义务，行使电子缔约文件相关权利。<br/>
                        1.6
                        您知悉并同意本公司是第三方电子缔约服务提供商，并不介入任何您和您的缔约对象之间的业务行为。本公司不能控制缔约对象履行其在数据电文或电子缔约文件下的各项义务的能力。本公司不能也不会控制缔约各方履行协议义务。本公司对您与您的缔约对象之间就缔约的内容和缔约执行情况等产生的任何纠纷不承担任何法律责任或者连带法律责任。<br/>
                        1.7您知悉并同意本公司对本服务具备完全自主的知识产权，对安心签平台或其相关内容采用任何复制或者反向工程手段皆是侵犯我公司权益的行为，我公司对此保留一切法律追诉的权利。<br/>
                        1.8您知悉并同意在使用本服务的过程中，本公司或者电子缔约关联方可能通过主动或者被动的方式获知相关信息。您同意本公司将按照公布的隐私政策声明进行处理。<br/>
                        1.9
                        您知悉并同意您在注册时填写的信息是您申请数字证书的重要依据，并充分保证该信息的真实性、准确性、完整性。一旦您勾选了同意的内容，即表示您认可遵守本公司公布的规定的相关义务。在您提出申请数字证书之后，本公司将根据您的注册信息制作您的数字证书。<br/>
                        1.10您知悉并同意您所专有并控制的数字证书是在安心签平台签署电子缔约文件的重要工具，且您认可您有义务对您所专有并控制的数字证书及安心签账户绑定的手机和邮箱进行妥善保管，牢记该数字证书的PIN码并承担保密义务，当您收到安心签账户绑定的手机和邮箱收到授权签署验证码时，确保签署请求由本人发起，且对验证码承担保密义务。同时，您确认已了解数字证书或安心签账户绑定的手机和邮箱的遗失可能对您或您的缔约对象带来不利的后果。因此，无论任何原因可能或已经危及您的数字证书安全，您应该立即通过安心签平台公布的联系方式和本公司取得联系。因数字证书未被您妥善保管或数字证书安全受到威胁而未被您及时告知本公司所引起的不利后果与本公司无关。<br/>
                        1.11您知悉并同意在您在使用本服务时，本公司将免费为您所产生的数据电文或电子缔约文件存储5年，存储的起始时间为创建数据电文或电子缔约文件的时间。期满后，本公司无必须义务为您或您的关联方永久保存各类数据电文或电子缔约文件。任何您或您的关联方未及时按照服务提示自行保存相关数据电文或电子缔约文件，本公司不承担您或者您的关联方因此而造成的任何损失。您可以根据自身需要，向本公司申请额外存储期限或申请提供超过存储期限合同找回服务。<br/>
                        1.12 本协议内容包括协议正文及所有安心签平台已经发布的各类规则、公告或通知。所有规则为协议不可分割的一部分，与协议正文具有同等法律效力。<br/>
                        1.13您知悉并同意互联网支付可能对您的利益存在风险，您同意完全承担可能造成的一切后果。<br/>
                        二、服务对象<br/>
                        2.1以安心签官方网站www.anxinsign.com及其所属网页内容为准。 <br/>
                        2.2本协议针对的对象是所有安心签平台的注册用户。<br/>
                        三、费用 <br/>
                        3.1本服务为付费服务，具体服务类型和价格，您可登陆安心签官方网站及其所属页面内容或咨询客服人员了解价格详情。<br/>
                        3.2您根据安心签平台付款要求向本公司支付所申请服务的费用后，方可享受相应服务内容。 <br/>
                        3.3 本公司有权根据实际情况单方调整服务价格标准和支付条件。 <br/>
                        3.4 您若已开通相应的平台服务，在该服务开通至期满续约之前，不受在此期间服务价格调整的影响。 <br/>
                        3.5 您若在服务期满前请求终止服务，服务费用不予退还。<br/>
                        四、服务起止日期<br/>
                        安心签平台服务起始日期为自本公司收到客户资料信息并审核通过的次日零点起计算（以北京时间为准）；本服务终止日期根据用户约定的服务期限而定。<br/>
                        五、用户的权利和义务<br/>
                        5.1 用户在使用安心签平台提供的相关服务时必须保证遵守中国有关法律法规的规定，不得利用安心签平台进行任何非法活动，遵守所有与使用安心签平台有关的协议、规定、程序和惯例。<br/>
                        5.2 用户需对其在安心签平台上的所有行为及注册时向本公司提供的任何形式的材料、信息的合法性、真实性、准确性、完整性以及由此产生的所有问题承担责任。<br/>
                        5.3 用户如因违反本协议规定的义务给本公司造成损失，必须负责相应赔偿。<br/>
                        六、安心签的权利和义务<br/>
                        6.1我公司将对您在注册时提交的任何形式的材料、信息，包括但不限于《安心签开户及管理授权书》、用户身份证明文件等进行严格审核，但并不对文件的真实性负责，不承担由此产生的法律责任。<br/>
                        6.2对于因不可抗力造成的服务中断或其他缺陷（包括但不限于自然灾害、社会事件以及因网站所具有的特殊性质而产生的包括黑客攻击、电信部门技术调整导致的影响、政府管制而造成的暂时性关闭在内的任何影响网络正常运营的因素），本公司不承担任何责任，但将尽力减少因此而给用户造成的损失和影响。
                        如因本公司原因，造成用户服务的不正常中断，用户有权向安心签平台申请顺延被中断的服务时间。本公司不承担用户的其他任何损失。<br/>
                        6.3 用户发生合同纠纷时，本公司将配合司法机关进行相关数据电文或电子缔约文件的鉴证鉴权。<br/>
                        七、服务终止<br/>
                        7.1 本公司有权在用户违反了本协议的任一条款的情形下拒绝用户的订购或终止、取消用户服务。<br/>
                        7.2 本公司有权根据本协议第一项、第四项、第五项相关说明终止服务。 <br/>
                        八、责任声明<br/>
                        8.1本公司对其网站上提供的信息及服务之有效性、准确性、正确性、可靠性、质量、稳定、完整和及时性等均不作承诺和保证。用户理解并接受任何信息资料的传输取决于用户自己并由其承担系统受损或资料丢失的所有风险和责任。<br/>
                        8.2
                        用户就使用安心签平台的第三方电子缔约服务与本公司签订了其他协议，若本协议内容与其他协议有冲突的，以其他协议内容为主。本协议任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。<br/>
                        8.3鉴于电子缔约的特殊形式，根据我国《电子签名法》规定，本服务不适用于涉及以下内容的数据电文或电子缔约文件：（a）涉及婚姻、收养、继承等人身关系的；（b）涉及土地、房屋等不动产权益转让的；（c）涉及停止供水、供热、供气、供电等公用事业服务的；（d）法律、行政法规规定的不适用电子文书的其他情形。本公司不因您签署涉及上述内容的数据电文或电子缔约文件而导致的效力瑕疵而承担任何责任。<br/>
                        九、争议的解决<br/>
                        本协议之效力、解释、变更、执行与争议解决均适用中华人民共和国法律，没有相关法律规定的，参照通用国际商业惯例和（或）行业惯例。因本协议产生之争议，应尽量友好协商解决。如协商不成，均应依照中华人民共和国法律予以处理。<br/>

                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="successful_xie_con" id="a03" style="display:none;">
                <div class="hetong">
                    <div class="hetong_title">安心签平台隐私条款</div>
                    <div class="hetong_nei">
                        <b>隐私声明</b><br/>
                        欢迎使用安心签平台！对于您的隐私，我们绝对尊重并予以保护，本隐私声明将告诉您，安心签平台（所涉域名为：www.anxinsign.com）收集资料与运用的方式以及我们的隐私保护政策。本站的隐私声明正在不断改进中，随着我站服务范围的扩大，我们会随时更新我们的隐私声明。<br/>
                        在同意安心签平台服务协议（以下简称“协议”）之时，您已经同意我们按照本隐私声明来使用和披露您的个人信息。本隐私声明的全部条款属于协议的一部分。<br/>
                        <b>未成年人的特别注意事项</b><br/>
                        如果您未满18周岁，您无权使用本公司服务，因此我们希望您不要向我们提供任何个人信息。<br/>
                        <b>数字证书、用户名和密码</b><br/>
                        当您注册成用户时，我们要求您选择一个用户名和密码。您可以通过（a）使用您专有的数字证书和PIN码（b）您的用户名和密码，两种方式登录平台。如果您丢失了数字证书或泄漏了PIN码/密码，您可能丢失了您的个人识别信息，并且可能出现对您不利的后果。因此，无论任何原因危及您的数字证书安全或PIN/密码安全，您应该立即通过安心签平台公布的联系方式和我们取得联系。<br/>
                        <b>注册信息</b><br/>
                        当您在注册为用户时，我们要求您填写注册信息。如果您是个人用户，注册信息包括您的真实姓名、证件类型、证件号码、电话号码、地址和电子邮件地址；如果您是企业用户，注册信息包括公司名称、证件类型、证件号、公司电话、公司地址、公司邮箱、法人代表真实姓名、经办人真实姓名、经办人的证件类型、经办人的证件号码、经办人的电话号码、经办人的地址和经办人的电子邮件地址。另外，您还被要求提供法人代表对经办人的注册和运营安心签平台账户的授权书原件。我们通过（a）比较您的注册信息和您专有的数字证书的信息来判断您的真实身份，作为是否为您提供服务的依据；（b）比较您的注册信息和您提交的相关证件复印件/原件来判断是否给您颁发有效的数字证书，并作为是否为您提供服务的依据；（c）在获得您本人同意的情况下，委托有合法资质的第三方机构对您的身份信息进行核实，作为是否为您提供服务的依据。<br/>
                        <b>银行账号</b><br/>
                        我们的一些服务需要付费，我们会合理获取您的银行账号信息。<br/>
                        <b>您的用户行为</b><br/>
                        为了提供并优化您需要的服务，我们会根据合理性、必要性原则收集您使用服务的相关信息，这类信息包括：在您使用安心签服务访问网页时，自动接收并记录的您的浏览器和计算机上的信息，包括您的IP地址、浏览器的类型、访问日期和时间、软硬件特征信息及您需求的网页记录等数据；如您下载或使用安心签客户端软件，或访问移动网页使用安心签服务时，我们可能会读取与您位置和移动设备相关的信息，包括设备型号、设备识别码、操作系统、分辨率、电信运营商等。<br/>
                        除上述信息外，我们还可能为了提供服务及改进服务质量的合理需要而收集您的其他信息，包括您与我们的客户服务团队联系时您提供的相关信息，您参与问卷调查时向我们发送的问卷答复信息。与此同时，为提高您使用安心签提供的服务的安全性，更准确地预防钓鱼网站欺诈和木马病毒，我们可能会通过了解一些您的网络使用习惯等手段来判断您账户的风险。<br/>
                        我们保证将采取严格的保密措施保护您的信息不被泄露，并仅将该信息用于上述目的。<br/>
                        <b>Cookie的使用</b><br/>
                        cookies是少量的数据，在您未拒绝接受cookies的情况下，cookies将被发送到您的浏览器，并储存在您的计算机硬盘中。我们使用cookies储存您访问我们平台的相关数据，在您访问或再次访问我们的平台时，我们能识别您的身份，并通过分析数据为您提供更好更多的服务。
                        <br/>
                        您有权选择接受或拒绝接受cookies。您可以通过修改浏览器的设置以拒绝接受cookies，但是我们需要提醒您，因为您拒绝接受cookies，您可能无法使用依赖于cookies的我们网站的部分功能。<br/>
                        <b>信息的披露和使用</b><br/>
                        我们不会向任何无关第三方提供、出售、出租、分享和交易用户信息，但为方便您使用安心签平台服务及安心签平台关联公司或其他组织的服务（以下称“其他服务”），您同意并授权安心签平台将您的用户信息传递给您同时接受其他服务的安心签平台关联公司或其他组织，或从为您提供其他服务的安心签平台关联公司或其他组织获取您的用户信息，法律禁止的除外。如您不同意该等信息共享，您可向本公司发送书面声明，本公司将尊重您的意愿及选择。<br/>
                        您同意我们可批露或使用您及（或）您的公司的用户信息以用于识别和（或）确认您的身份，或解决争议，或有助于确保网站安全、限制欺诈、非法或其他刑事犯罪活动，以执行我们的服务协议。<br/>
                        您同意我们可批露或使用您及（或）您的公司的用户信息以保护您的生命、财产之安全或为防止严重侵害他人之合法权益或为公共利益之需要。<br/>
                        您同意我们可批露或使用您及（或）您的公司的用户信息以改进我们的服务，并使我们的服务更能符合您的要求，从而使您在使用我们服务时得到更好的用户体验。<br/>
                        您同意我们利用您及（或）您的公司的用户信息与您联络，并向您提供您感兴趣的信息，如：服务到期提醒。<br/>
                        当我们被法律强制或依照政府或依权利人因识别涉嫌侵权行为人的要求而提供您的信息时，我们将善意地披露您的资料。<br/>
                        <b>信息的存储和交换</b><br/>
                        所收集的用户信息和资料将加密保存在安心签平台及（或）其关联公司的服务器上。<br/>
                        <b>外部链接</b><br/>
                        平台可能含有到其他网站的链接。我们对那些网站的隐私保护措施不负任何责任。我们可能在任何需要的时候增加商业伙伴或共用品牌的网站。<br/>
                        <b>安全</b><br/>
                        我们平台有相应的安全措施来确保我们掌握的信息不丢失，不被滥用和篡改。这些安全措施包括向其它服务器备份数据和对用户信息加密。尽管我们有这些安全措施，但请注意，在因特网上不存在“绝对安全的安全措施”。<br/>
                        <b>修改您的资料</b><br/>
                        您可以在安心签平台上修改或者更新您的登录密码、电话号码、地址和电子邮件地址（在成功登录之后）。若您为公司用户，变更法人代表、经办人时，我们需要您重新提交相应的证明文件复印件和授权书原件。<br/>
                        <b>联系我们</b><br/>
                        如果您对本隐私声明或安心签平台的隐私保护措施以及您在使用时有任何意见和建议，欢迎通过安心签平台公布的联系方式和我们联系。<br/>
                        <b>法律声明</b><br/>
                        若要访问和使用安心签平台服务，您必须不加修改地完全接受本协议中所包含的条款、条件和安心签平台即时刊登的通告，并且遵守有关互联网及/或本平台的相关法律、规定与规则。一旦您使用安心签平台服务，即表示您同意并接受了所有该等条款、条件及通告。<br/>
                        <b>版权和商标</b><br/>
                        安心签平台所有的版权权利均在全世界范围内受到法律保护，除非有其他的标注或在此等条款和规则中被允许使用，本网站上可阅读和可见的所有资料都受到知识产权法的保护。<br/>
                        安心签平台拥有的所有版权和商标未经书面同意，不得以任何非法手段侵犯。对于已经授权的版权或者商标用途，只能使用于授权时指定的范围。任何人不得利用工作之便获取版权和商标。<br/>
                        <b>保密条款</b><br/>
                        任何人均需严格遵守安全保密条款，保护各方商业秘密及相关权益，包括但不限于产品知识产权、策划方案、客户资料、协议合同、技术文档、程序文件、程序控件或源代码、各种账户密码。任何人不得泄漏他人的任何商业秘密，同时不得利用工作之便获取他人技术秘密。对于授权使用的技术，只能使用于授权时指定的范围，不得用于它途。<br/>

                        <br>
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div class="reg_yue clear">
                <input id="mycheckbox" type="checkbox" class="checkbix" style="margin: 0;"/>
                <label aria-label="" role="checkbox" for="mycheckbox" class="checkbix"><span class=""></span></label>
                <div style="margin-left: 0px; display: inline-block; margin-top: -40px;">我方已认真阅读并同意接受《用户注册服务协议》<span
                        style="display: none;">、《安心签平台服务协议》、《安心签平台隐私条款》</span></div>
            </div>
            <div class="successful_xie_bot clear">
                <a href="${ctx}/logout" class="chuangxin_logout" data-kid="503">关闭</a>
                <c:if test="${fn:contains(fns:getUser().roleNames, '供应商负责人')}">
                    <a href="javascript: void(0);" class="successful_a" id="sign" onclick="contract()" data-kid="503"
                       data-pcode="20180914195816982987838600">马上签约</a>
                </c:if>
                <c:if test="${not fn:contains(fns:getUser().roleNames, '供应商负责人')}">
                    <a href="javascript: void(0);" style="background-color: #a0a0a0;" class="successful_a" id="sign"
                       data-kid="503" data-pcode="20180914195816982987838600">无签约权限</a>
                </c:if>
            </div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>
</form>

<div class="reg_footer" style="height: 94px; line-height: 25px;">
    <span>咨询热线：000-0000000 9:00 -- 18:00（周一至周五）</span>
    <br>
    <span>版权所有 ©2018 上海创信供应链管理有限公司 沪ICP备 <a href="http://www.miitbeian.gov.cn" target="_blank">18038558</a>号</span>
</div>

<div class="layui-layer-shade" id="layui-layer-shade100002" times="100002"
     style="z-index:19991015; display: none; background-color:#000; opacity:0.8; filter:alpha(opacity=80);"></div>

<div class="layui-layer layui-layer-iframe  layer-anim" id="layui-layer100002" type="iframe" times="100002" showtime="0"
     contype="string" style="display: none; z-index: 19991016; width: 30%; height: 214px; top: 230px; left: 531.5px;">
    <div class="layui-layer-title" style="cursor: move;">签约手机授权码</div>
    <div class="layui-layer-content">
        <div class="popup_nei2 clear" style="height: 120px;">
            为了您的账户安全，请输入授权码<br>授权码已发送至手机号：<b id="shouquan-phone"></b>
            <br/>
            <input type="text" style="margin-top: 10px;" class="disclose_text1" id="verify_code" name="verify_code"
                   value="" placeholder="请输入授权码"/>
            <span class="disclose_r" id="error_verify_code" style="margin-top: 9px;"></span>
        </div>
        <div class="popup_bot clear">
            <a href="javascript:void(0);" onclick="sure()" class="popup_a">确定</a>
        </div>
        <div class="clear"></div>
    </div>
</div>

</body>
</html>