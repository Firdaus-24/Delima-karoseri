<!--#include file="../../init.asp"-->
<% 
   call header("image")
   id = trim(Request.QueryString("id"))
   img = trim(Request.QueryString("img"))

   strimg = id + img

   if img = 1 then
      strquery = "UPDATE DLK_M_BOMH SET BMImg1 = '"& strimg &"' WHERE BMID = '"& id &"'"
   elseIf img = 2 then
      strquery = "UPDATE DLK_M_BOMH SET BMImg2 = '"& strimg &"' WHERE BMID = '"& id &"'"
   elseIf img = 3 then
      strquery = "UPDATE DLK_M_BOMH SET BMImg3 = '"& strimg &"' WHERE BMID = '"& id &"'"
   else
      Response.Redirect("index.asp")
   end if

   call query(strquery)

   call alert("DRAWING B.O.M", "berhasil diupload", "success","index.asp") 

   call footer()
%>