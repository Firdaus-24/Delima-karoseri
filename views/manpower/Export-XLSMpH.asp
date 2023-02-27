<!--#include file="../../init.asp"-->
<% 
  if session("PP2D") = false then
    Response.Redirect("index.asp")
  end if

  agen = trim(request.QueryString("agen"))
  if len(agen) = 0 then 
    agen = trim(Request.Form("agen"))
  end if
  prodmp = trim(request.QueryString("prodmp"))
  if len(prodmp) = 0 then 
    prodmp = trim(Request.Form("prodmp"))
  end if
  tgla = trim(request.QueryString("tgla"))
  if len(tgla) = 0 then 
    tgla = trim(Request.Form("tgla"))
  end if
  tgle = trim(request.QueryString("tgle"))
  if len(tgle) = 0 then 
    tgle = trim(Request.Form("tgle"))
  end if
  
  if agen <> "" then
    filterAgen = "AND DLK_T_ManpowerH.MP_AgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if
  if prodmp <> "" then
    filterprodmp = "AND DLK_T_ManpowerH.MP_PDHID = '"& prodmp &"'"
  else
    filterprodmp = ""
  end if


  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_ManpowerH.MP_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_ManpowerH.MP_Date = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT dbo.DLK_T_ManPowerH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_ManPowerH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerH.MP_Updateid = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ManPowerH.MP_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_ManPowerH.MP_AktifYN = 'Y') "& filterAgen &""& filterprodmp &""& filtertgl &""

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = strquery

  set data = data_cmd.execute

  if agen <> "" then  
    labelAgen = "CABANG "& data("agenName")
  else
    labelAgen = ""
  end if
  if prodmp <> "" then  
    labelprodmp = "DENGAN NO. Prduksi "&  left(data("MP_PDHID"),2) &"-"& mid(data("MP_PDHID"),3,3) &"/"& mid(data("MP_PDHID"),6,4) &"/"& right(data("MP_PDHID"),4)  
  else
    labelprodmp = ""
  end if
  if tgla <> "" AND tgle <> "" then
    labelTgl = "PRIODE "& tgla &"' S/D '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    labelTgl = "PRIODE '"& tgla &"'"
  else 
    labelTgl = ""
  end if

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=ManPower "& labelAgen &" "& labelprodmp &" "& labelTgl&" .xls"
%>

<table widht="100%">
  <tr>
    <th colspan="6">MAN POWER</th>
  </tr>
  <tr>
    <td colspan="6" align="center"><%= labelAgen & labelprodmp & labelTgl%></td>
  </tr>
  <tr>
    <td colspan="6">&nbsp</td>
  </tr>
  <tr>
    <th style="background-color: #0000a0;color:#fff;">No</th>
    <th style="background-color: #0000a0;color:#fff;">ID</th>
    <th style="background-color: #0000a0;color:#fff;">No.Produksi</th>
    <th style="background-color: #0000a0;color:#fff;">Cabang</th>
    <th style="background-color: #0000a0;color:#fff;">Tanggal</th>
    <th style="background-color: #0000a0;color:#fff;">Update ID</th>
  </tr>
  <% 
  no = 0
  do while not data.eof
  no = no + 1

  data_cmd.commandTExt = "SELECT dbo.HRD_M_Karyawan.Kry_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_T_ManPowerD.* FROM dbo.DLK_T_ManPowerD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerD.MP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.HRD_M_Karyawan ON dbo.DLK_T_ManPowerD.MP_Nip = dbo.HRD_M_Karyawan.Kry_NIP WHERE LEFT(MP_ID,4) = '"& left(data("MP_ID"),4) &"' AND RIGHT(MP_ID,7)= '"& RIGHT(data("MP_ID"),7) &"'"
  set ddata = data_cmd.execute
  %>
  <tr>
    <td><%= no %></td>
    <th>
      <%= left(data("MP_ID"),2) %>-<%= mid(data("MP_ID"),3,2) %>/<%= mid(data("MP_ID"),5,4) %>/<%= right(data("MP_ID"),3)  %>
    </th>
    <th>
      <%= left(data("MP_PDHID"),2) %>-<%= mid(data("MP_PDHID"),3,3) %>/<%= mid(data("MP_PDHID"),6,4) %>/<%= right(data("MP_PDHID"),4)  %>
    </th>
    <td><%= data("AgenNAme")%></td>
    <td><%= Cdate(data("MP_Date")) %></td>
    <td><%= data("username")%></td>
  </tr>
    <% do while not ddata.eof %>
      <tr>
        <td></td>
        <td><%= ddata("MP_Nip") %></td>
        <td colspan="2"><%= ddata("Kry_Nama") %></td>
        <td><%= replace(formatcurrency(ddata("MP_Salary")),"$","") %></td>
        <td><%= ddata("username") %></td>
      </tr>
    <% 
    Response.flush
    ddata.movenext
    loop
    %>
  <% 
  Response.flush
  data.movenext
  loop
  %>
</table>