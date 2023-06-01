<!--#include file="../../init.asp"-->
<% 
  cabang = trim(Request.form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT OJH_ID FROM DLK_T_OrjulH WHERE OJH_Agenid = '"& cabang &"' AND OJH_AktifYN = 'Y' AND NOT EXISTS(SELECT IPH_OJHID FROM MKT_T_InvJulNewH WHERE IPH_OJHID = OJH_ID AND IPH_AktifYN = 'Y') ORDER BY OJH_ID ASC"

  set data = data_cmd.execute

%>
  <select class="form-select" aria-label="Default select example" name="orjulid" id="orjulid" onchange="getValuePO(this.value)" required> 
    <option value="">Pilih</option>
    <% do while not data.eof  %>
      <option value="<%= data("OJH_ID") %>"><%= left(data("OJH_ID"),2) %>-<%= mid(data("OJH_ID"),3,3) %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4) %></option>
    <% 
    response.flush
    data.movenext
    loop
    %>
  </select>
