<!--#include file="../../init.asp"-->
<%
    cabang = trim(Request.Form("cabang"))
    set data_cmd = Server.CreateObject("ADODB.COmmand")
    data_cmd.ActiveConnection = mm_delima_string   

    data_cmd.commandTExt = "SELECT IRH_ID FROM DLK_T_IncRepairH WHERE IRH_Agenid = '"& cabang &"' AND IRH_Aktifyn = 'Y' AND IRH_Approve1 = 'Y' AND IRH_Approve2 = 'Y' AND IRH_Approve3 = 'Y' AND NOT EXISTS(SELECT DLK_T_ProduksiRepair.PDR_IRHID FROM DLK_T_ProduksiRepair WHERE DLK_T_ProduksiRepair.PDR_IRHID = DLK_T_IncRepairH.IRH_ID AND DLK_T_ProduksiRepair.PDR_AktifYN = 'Y')  ORDER BY IRH_ID, IRH_Date ASC"
    set data = data_cmd.execute

  if not data.eof then
%>
    <option value="">Pilih</option>
<%  Do Until data.eof%>
      <option value="<%=data("IRH_ID")%>">
        <%= LEFT(data("IRH_ID"),4) &"-"& mid(data("IRH_ID"),5,3) &"/"& mid(data("IRH_ID"),8,4) &"/"& right(data("IRH_ID"),2) %>
      </option>
<%
    Response.flush
    data.movenext
    loop
  else
%>
    <option value="" readonly disabled>Data Tidak Terdaftar</option>
  <% end if%>