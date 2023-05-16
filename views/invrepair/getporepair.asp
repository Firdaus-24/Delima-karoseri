<!--#include file="../../init.asp"-->
<% 
  cabang = trim(Request.form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT ORH_ID FROM MKT_T_OrjulRepairH WHERE ORH_Agenid = '"& cabang &"' AND ORH_AktifYN = 'Y' AND NOT EXISTS(SELECT INV_orhID FROM MKT_T_InvRepairH WHERE INV_ORHID = ORH_ID AND INV_AktifYN = 'Y') ORDER BY ORH_ID ASC"

  set data = data_cmd.execute

%>
  <select class="form-select" aria-label="Default select example" name="orhid" id="orhid" onchange="getPoRepair(this.value)" required> 
    <option value="">Pilih</option>
    <% do while not data.eof  %>
      <option value="<%= data("ORH_ID") %>"><%= left(data("ORH_ID"),2) %>-<%= mid(data("ORH_ID"),3,3) %>/<%= mid(data("ORH_ID"),6,4) %>/<%= right(data("ORH_ID"),4) %></option>
    <% 
    response.flush
    data.movenext
    loop
    %>
  </select>
