<!--#include file="../../init.asp"-->
<% 
    id = Request.QueryString("id")
    db = Request.QueryString("db")
    strid = left(id,12)
    call header("UPLOAD DOCUMENT")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query ("UPDATE DLK_T_DelBarang SET "& db &" = '"& id &"' WHERE DB_Id = '"& strid &"'")
        call alert("DOCUMENT PENDUKUNG DENGAN ID "&strid&" ", "berhasil updload", "success","index.asp") 
call footer() 
%>