<!--#include file="../../init.asp"-->
<% 
id = trim(Request.Form("id"))
revisi = trim(Request.Form("revisi"))

call query("UPDATE DLK_T_PreDevInspectionH SET PDI_Revisi = "& revisi &" WHERE PDI_ID = '"& id &"'")

%>