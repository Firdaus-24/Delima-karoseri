<!--#include file="../init.asp"-->
<%    
  cabang = trim(Request.form("cabang"))
  typeRadioPdr = trim(Request.form("typeRadioPdr"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  if typeRadioPdr = "P" then
    data_cmd.commandText = "SELECT dbo.DLK_T_ProduksiD.PDD_ID AS produksi FROM  dbo.DLK_T_ProduksiH RIGHT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_ProduksiH.PDH_ID = LEFT(dbo.DLK_T_ProduksiD.PDD_ID, 13) WHERE (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve2 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve1 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_AgenID = '"& cabang &"') AND NOT EXISTS(SELECT MO_PDDPDRID FROM DLK_T_MaterialOutH WHERE MO_PDDPDRID = DLK_T_ProduksiD.PDD_ID AND MO_AktifYN = 'Y') order by dbo.DLK_T_ProduksiD.PDD_ID"
    set data = data_cmd.execute
  elseIf typeRadioPdr = "R" then
    data_cmd.commandText = "SELECT PDR_ID AS produksi FROM DLK_T_ProduksiRepair where PDR_AktifYN = 'Y' AND PDR_AgenID = '"& cabang &"' AND NOT EXISTS(SELECT MO_PDDPDRID FROM DLK_T_MaterialOutH WHERE MO_PDDPDRID = DLK_T_ProduksiRepair.PDR_ID AND MO_AktifYN = 'Y')"
    set data = data_cmd.execute
  end if

  if typeRadioPdr = "P" then
%>
    <select class="form-select" aria-label="Default select example" id="pddid" name="pddid" required>
      <option value="">Pilih</option>
      <%do while not data.eof %>
      <option value="<%= data("produksi") %>"><%= left(data("produksi"),2) %>-<%= mid(data("produksi"),3,3) %>/<%= mid(data("produksi"),6,4) %>/<%= mid(data("produksi"),10,4) %>/<%= right(data("produksi"),3) %></option>
      <% 
      response.flush
      data.movenext
      loop
      %>
    </select>
  <%
  elseIf typeRadioPdr = "R" then
  %>
    <select class="form-select" aria-label="Default select example" id="pddid" name="pddid" required>
      <option value="">Pilih</option>
      <%do while not data.eof %>
      <option value="<%= data("produksi") %>"><%=LEFT(data("produksi"),3) &"-"& MID(data("produksi"),4,2) &"/"& RIGHT(data("produksi"),3) %></option>
      <% 
      response.flush
      data.movenext
      loop
      %>
    </select>
  <%end if%>