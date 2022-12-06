<!--#include file="../../init.asp"-->
<% 
   id = Request.QueryString("id")
   trans1 = trim(Request.QueryString("trans1"))
   trans2 = trim(Request.QueryString("trans2"))

   if trans1 <> "" then 
      str = "DLK_T_MaterialReceiptD1"
      value = trans1
   elseIf trans2 <> "" then
      str = "DLK_T_MaterialReceiptD2"
      value = trans2
   else
      str = "" 
      value = ""
   end if

   call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   if str = "" then
      call alert("PERMINTAAN DITOLAK!!", "", "error","index.asp")
   else 
      call query("DELETE FROM "& str &" WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& value &"'")
      call alert("DETAIL MATERIAL DECEIPT ", "berhasil dihapus", "success","income_u.asp?id="&id) 
   end if
call footer() 
%>