<!--#include file="../../init.asp"-->
<% 
  cabang = trim(Request.Form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT PDH_ID FROM DLK_T_ProduksiH WHERE PDH_AgenID = '"& cabang &"' AND NOT EXISTS(SELECT BP_PDHID FROM DLK_T_BB_ProsesH WHERE BP_PDHID = DLK_T_ProduksiH.PDH_ID) AND PDH_AktifYN = 'Y' AND PDH_Approve1 = 'Y' AND PDH_Approve2 = 'Y' ORDER BY PDH_ID ASC"

  set data = data_cmd.execute
%>
  <select class="form-select" aria-label="Default select example" name="prodid" id="prodid" required> 
    <option value="">Pilih</option>
    <% do while not data.eof %>
      <option value="<%= data("PDH_ID") %>"> <%= left(data("PDH_ID"),2) %>-<%= mid(data("PDH_ID"),3,3) %>/<%= mid(data("PDH_ID"),6,4) %>/<%= right(data("PDH_ID"),4)  %></option>
    <% 
      Response.flush
      data.movenext
      loop
    %>
  </select>