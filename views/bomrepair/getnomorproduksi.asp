<!--#include file="../../init.asp"-->
<%
  cabang = trim(Request.Form("cabang"))

  set data_cmd = Server.CreateObject("ADODB.COMMAND")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT PDR_ID FROM DLK_T_ProduksiRepair WHERE PDR_AgenID = '"& cabang &"' AND PDR_AktifYN = 'Y' AND NOT EXISTS(SELECT DLK_T_BOMRepairH.BmrPDRID FROM DLK_T_BOMRepairH WHERE DLK_T_BOMRepairH.BmrPDRID = DLK_T_ProduksiRepair.PDR_ID AND DLK_T_BOMRepairH.BmrAktifYN = 'Y') ORDER BY DLK_T_ProduksiRepair.PDR_ID"
  set data = data_cmd.execute

%>

<option value="">Pilih</option>
<%do while not data.eof%>
  <option value="<%=data("PDR_ID")%>"><%=LEFT(data("PDR_ID"),3) &"-"& MID(data("PDR_ID"),4,2) &"/"& RIGHT(data("PDR_ID"),3) %></option>
<%
  Response.flush
  data.movenext
  loop
%>
