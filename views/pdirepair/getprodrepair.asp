<!--#include file="../../init.asp"-->
<%
  cabang = trim(Request.Form("cabang"))

  set data_cmd = Server.CreateObject("ADODB.COmmand")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT PDR_ID FROM DLK_T_ProduksiRepair where PDR_AgenID = '"& cabang &"' AND PDR_AktifYN = 'Y' AND NOT EXISTS (SELECT PDIR_PDRID FROM DLK_T_PDIRepairH WHERE PDIR_PDRID = DLK_T_ProduksiRepair.PDR_ID AND PDIR_AktifYN = 'Y')"
  set data = data_cmd.execute
%>
    <option value="">Pilih</option>
    <% do while not data.eof %>
      <option value="<%= data("PDR_ID") %>"><%=LEFT(data("PDR_ID"),3) &"-"& MID(data("PDR_ID"),4,2) &"/"& RIGHT(data("PDR_ID"),3) %></option>
    <% 
    Response.flush
    data.movenext
    loop
    %>

