<!--#include file="../../init.asp"-->
<% 
  jenisUnit = trim(Request.Form("jenisUnit"))

  if jenisUnit = 1 then
    strquery = "SELECT OJH_ID, CustNama FROM DLK_T_OrjulH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_OrjulH.OJH_Custid = DLK_M_Customer.custID WHERE OJH_AktifYN = 'Y' AND NOT EXISTS(SELECT TFK_OJHORHID FROM DLK_T_UnitCustomerH WHERE TFK_OJHORHID = OJH_ID AND TFK_AktifYN = 'Y') ORDER BY OJH_ID ASC"
  elseIf jenisUnit = 2 then
    strquery = "SELECT ORH_ID, CustNama FROM MKT_T_OrjulREpairH LEFT OUTER JOIN DLK_M_Customer ON MKT_T_OrjulRepairH.ORH_Custid = DLK_M_Customer.custID WHERE ORH_AktifYN = 'Y' AND NOT EXISTS(SELECT TFK_OJHORHID FROM DLK_T_UnitCustomerH WHERE TFK_OJHORHID = ORH_ID AND TFK_AktifYN = 'Y') ORDER BY ORH_ID ASC"
  else
    strquery = ""
  end if

  set data_cmd = Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = strquery
  set data = data_cmd.execute


  if jenisUnit = 1 then
%>

  <option value="">Pilih</option>
  <% do while not data.eof %>
    <option value="<%= data("OJH_ID") %>">
      <%= left(data("OJH_ID"),2) &"-"& mid(data("OJH_ID"),3,3) &"/"& mid(data("OJH_ID"),6,4) &"/"& right(data("OJH_ID"),4)  %>
    </option>
  <% 
  response.flush
  data.movenext
  loop
  %>

<%  elseIf jenisUnit = 2 then %>
  <option value="">Pilih</option>
  <% do while not data.eof %>
    <option value="<%= data("ORH_ID") %>">
      <%= left(data("ORH_ID"),2) &"-"& mid(data("ORH_ID"),3,3) &"/"& mid(data("ORH_ID"),6,4) &"/"& right(data("ORH_ID"),4)  %>
    </option>
  <% 
  response.flush
  data.movenext
  loop
  %>
<% else %>
  <% Response.Status = "404 File Not Found" %>
<% end if %>