<%@page import="javax.xml.bind.DatatypeConverter"%>
<%@ page contentType="text/html; charset=euc-kr" language="java" %>

<%@ page import="java.util.*"%>
<%@ page import="javax.crypto.spec.DESKeySpec"%>
<%@ page import="javax.crypto.SecretKeyFactory"%>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="javax.crypto.SecretKey"%>


<%
boolean Makeflag=false;
String flag = request.getParameter("Makeflag");
if(null!=flag) {
Makeflag = true;
}
String licenseID = "8204";
String isDemo = "";
String customerID = "8204";
String customerName = "";
String hostname = "";
String ip = "";
String cpuNumber = "";
String expiredate = "";
String licenseString = "";
String retval = "";
String licenseKind = "";
String websquareSoft = "";
String coverted = "";

if(Makeflag){
licenseKind=request.getParameter("licenseKind");
isDemo=request.getParameter("licenseType");
customerName=request.getParameter("customerName");
hostname=request.getParameter("hostName");
ip=request.getParameter("serverIp");
cpuNumber=request.getParameter("cpuCount");
expiredate=request.getParameter("expiredate");

if("proworks".equals(licenseKind)){
licenseString = licenseID + ":" + isDemo + ":" + customerID + ":" + customerName + ":" + expiredate + ":" + hostname + ":" + ip + ":" + cpuNumber;
licenseString += ":7:SVMS:TMS:EGMS:Operational Framework:SIMS:SMS:SVMS AGENT";
System.out.println("licenseString : " + licenseString);
} else {
   websquareSoft = request.getParameter("websquareSoft");
   licenseString = licenseID + ":" + customerID + ":" + customerName + ":" + isDemo + ":" + hostname + ":" + ip + ":" + websquareSoft + ":" + expiredate + ":" + cpuNumber;
   licenseString += ":true:4:platform:push:studio:hybrid platform";
   System.out.println("licenseString  : " + licenseString);
}
StringBuffer sb = new StringBuffer();
for (int i = 0; i < 20; i++) {	
	int num = (int)(Math.random() * 43);
sb.append( (char) ('0' + (int)(Math.random() * 43)) ); // 아스키코드 난수 
}
String licenseKeyId = sb.toString();
System.out.println("licenseKeyId : " + licenseKeyId);
String mySecretKeyBASE64 = "";
byte[] key = licenseKeyId.getBytes();//byte로 저장
byte[] originKey = new byte[20];

if (key.length < 20) {
System.arraycopy(key, 0, originKey, 0, key.length);
} else {
System.arraycopy(key, 0, originKey, 0, 20);
}

SecretKeyFactory skf = SecretKeyFactory.getInstance("DES");
SecretKey myKey = skf.generateSecret(new DESKeySpec(originKey));

Cipher cipher = Cipher.getInstance("DES");
cipher.init(Cipher.ENCRYPT_MODE, myKey);
byte[] cleartext = licenseString.getBytes();
byte[] ciphertext = cipher.doFinal(cleartext);

BASE64Encoder encoder = new BASE64Encoder();
String encodedLicense = encoder.encodeBuffer(ciphertext);
String encodedLicenseKey = encoder.encodeBuffer(originKey);
retval = encodedLicense.substring(0, 5) + encodedLicenseKey + encodedLicense.substring(5);

System.out.println("retval : " + retval);
System.out.println("encodedLicense : " + encodedLicense);
System.out.println("encodedLicenseKey : " + encodedLicenseKey);

System.out.println("============복호화============");
String splitLicenseKey = retval.substring(5,34);
StringBuilder splitLicense = new StringBuilder();
splitLicense.append(retval.substring(0,5).trim());
splitLicense.append(retval.substring(34).trim());

System.out.println("splitLicenseKey : " + splitLicenseKey);

BASE64Decoder decoder = new BASE64Decoder();

byte[] deco = decoder.decodeBuffer(splitLicense);
byte[] decoKey = decoder.decodeBuffer(splitLicenseKey);
//decoder.decodeBuffer(splitLicense);

SecretKeyFactory deskf = SecretKeyFactory.getInstance("DES");
SecretKey demyKey = skf.generateSecret(new DESKeySpec(decoKey));

Cipher decipher = Cipher.getInstance("DES");
decipher.init(Cipher.DECRYPT_MODE, demyKey);

byte[] decoLicense = decoder.decodeBuffer(splitLicense.toString());
byte[] n = decipher.doFinal(decoLicense);

coverted = new String(n);
System.out.println("coverted : " + coverted);

/* 
BASE64Decoder decoder = new BASE64Decoder();
String decodeLicense = decoder.decodeBuffer()(ciptext);
System.out.println("decodeLicense : " + decodeLicense); */

//byte[] decoded = DatatypeConverter.parseBase64Binary(decodedLicense);
}
%>
<html>
<head><title> License 생성기 </title>
<script lang="javascript">
function fn_licenseType_Change() {
var select = document.getElementById("licenseType");
var option_value = select.options[select.selectedIndex].value;
if(option_value=="1"){
document.getElementById("expiredate").value="20991231";
} else {
document.getElementById("expiredate").value="";
}
}

function fn_selectKind() {
var select = document.getElementById("licenseKind");
var option_value = select.options[select.selectedIndex].value;
if(option_value=="websquare"){
document.getElementById("WebsquareSoft").style.display="";
} else {
document.getElementById("WebsquareSoft").style.display="none";
}
}

function fn_init() {
<%if("websquare".equals(licenseKind)){%>
document.getElementById("WebsquareSoft").style.display="";
<%}%>
}

</script>
</head>
<body onload="fn_init();">
라이센스 발급<br/>
<form name="LicenseForm" method="post" action="makeLicense.jsp">
<table>
<tr>
<td>License Kind</td>
<td>
<select id="licenseKind" name="licenseKind" onchange="fn_selectKind();">
<option value="proworks" <%if("proworks".equals(licenseKind)){%>selected<%}%>>PROWORKS</option>
<option value="websquare" <%if("websquare".equals(licenseKind)){%>selected<%}%>>WEBSQUARE</option>
</select>
</td>
</tr>
<tr>
<td colspan="2">
<div id="WebsquareSoft" style="display:none">
<table><tr><td width="115px">Soft Kind</td><td>
<select name="websquareSoft">
<option value="15" <%if("15".equals(websquareSoft)){%>selected<%}%>>push</option>
<option value="14" <%if("14".equals(websquareSoft)){%>selected<%}%>>hybrid platform</option>
<option value="13" <%if("13".equals(websquareSoft)){%>selected<%}%>>studio</option>
<option value="12" <%if("12".equals(websquareSoft)){%>selected<%}%>>platform</option>
</select>
</td></tr></table>
</div>
</td>
</tr>
<tr>
<td>License Type</td>
<td>
<select id="licenseType" name="licenseType" onchange="fn_licenseType_Change();">
<option value="0" <%if("0".equals(isDemo)){%>selected<%}%>>Demo License</option>
<option value="1" <%if("1".equals(isDemo)){%>selected<%}%>>Real License</option>
</select>
</td>
</tr>
<tr>
<td>Customer Name</td>
<td>
<input type="text" name="customerName" value="<%=customerName%>"/>
</td>
</tr>
<tr>
<td>Host Name</td>
<td>
<input type="text" name="hostName" value="<%=hostname%>"/>PassKey:"any"
</td>
</tr>
<tr>
<td>Server IP</td>
<td>
<input type="text" name="serverIp" value="<%=ip%>"/>PassKey:"0.0.0.0"||"127.0.0.1"
</td>
</tr>
<tr>
<td>CPU Count</td>
<td>
<input type="text" name="cpuCount" value="<%=cpuNumber%>"/>PassKey:999
</td>
</tr>
<tr>
<td>Expire Date</td>
<td>
<input type="text" id="expiredate" name="expiredate" value="<%=expiredate%>"/>YYYYMMDD
</td>
</tr>
<tr>
<td><input type="hidden" name="Makeflag" value="true"/></td>
<td>
<input type="submit" value="생성"/>
</td>
</tr>
<tr>
<td>License Key</td>
<td><textarea id="result" style="width:600px;height:100px;"><%=retval%></textarea></td>
</tr>
<tr>
<td>라이선스 내용</td>
<td><textarea id="decodeLicense" style="width:600px;height:50px;"><%=coverted%></textarea></td>
</tr>
</table>
</form>
</body>
</html>