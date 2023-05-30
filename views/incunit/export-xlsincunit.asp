<!--#include file="../../init.asp"-->
<% 
  if session("MQ4D") = false then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' header
  data_cmd.commandText = "SELECT DLK_T_IncRepairH.*, GLB_M_Agen.AgenName, DLK_M_Customer.custnama FROM DLK_T_IncRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_IncRepairH.IRH_AgenID = GLB_M_Agen.Agenid LEFT OUTER JOIN DLK_M_Customer ON LEFT(DLK_T_IncRepairH.IRH_TFKID,11) = DLK_M_Customer.custid WHERE DLK_T_IncRepairH.IRH_aktifYN = 'Y' AND IRH_ID = '"& id &"'"
  set data = data_cmd.execute

  ' detail
  data_cmd.commandTExt = "SELECT DLK_T_IncRepairD.*, DLK_M_Weblogin.username FROM DLK_T_IncRepairD LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_IncRepairD.IRD_Updateid = DLK_M_Weblogin.userid WHERE LEFT(IRD_IRHID,13) = '"& data("IRH_ID") &"' ORDER BY IRD_IRHID"
  set ddata = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=Material Receipt Produksi "& LEFT(data("IRH_ID"),4) &"-"& mid(data("IRH_ID"),5,3) &"/"& mid(data("IRH_ID"),8,4) &"/"& right(data("IRH_ID"),2)&" .xls"

%>
<style>
.td{
  border:1px solid black;
  border:collapse;
}
</style>

<table width="100" style="font-size:16px;font-family:arial">
  <tr>
    <th colspan="5" style="text-align:center;font-size:18px" >
      DETAIL INCOMMING UNIT INSPECTION
    </th>
  </tr>
  <tr>
    <th colspan="5" style="text-align:center;font-size:18px">
      <%= LEFT(data("IRH_ID"),4) &"-"& mid(data("IRH_ID"),5,3) &"/"& mid(data("IRH_ID"),8,4) &"/"& right(data("IRH_ID"),2) %>
    </th>
  </tr>
  <tr>
    <td align="left" class="td">
      Tanggal
    </td>
    <td align="left" class="td">
      : <%= Cdate(data("IRH_Date")) %>
    </td>
    <td align="left" class="td">
      Cabang
    </td>
    <td align="left" class="td" colspan="2">
      : <%= data("agenname") %>
    </td>
  </tr>
  <tr>
    <td align="left" class="td">
      No.Penerimaan Unit
    </td>
    <td align="left" class="td">
      : <%= LEFT(data("IRH_TFKID"),11) &"/"& MID(data("IRH_TFKID"),12,4) &"/"& MID(data("IRH_TFKID"),16,2) &"/"& right(data("IRH_TFKID"),3) %>
    </td>
    <td align="left" class="td">
      Customer
    </td>
    <td align="left" class="td" colspan="2">
      : <%= data("custnama") %>
    </td>
  </tr>
  <tr>
    <td align="left" class="td">
      Start Date
    </td>
    <td align="left" class="td">
      : <%= Cdate(data("IRH_Startdate")) %>
    </td>
    <td align="left" class="td">
      End Date
    </td>
    <td align="left" class="td" colspan="2">
      : <%= Cdate(data("IRH_Enddate")) %>
    </td>
  </tr>
  <tr>
    <td align="left" class="td">
      Keterangan
    </td>
    <td align="left" class="td" colspan="4">
      : <%= data("IRH_Keterangan") %>
    </td>
  </tr>
  <tr>
    <td align="center" colspan="5">
      GENERAL PICTURE
    </td>
  </tr>
  <tr rowspan="2" >
    <td class="td">
      <%if data("IRH_Img1") <> "" then%><img src="<%= url %>views/incunit/img/<%= data("IRH_IMG1") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>" width="30" height="50"> <% end if%>
    </td>
    <td class="td">
      <%if data("IRH_Img2") <> "" then%><img src="<%= url %>views/incunit/img/<%= data("IRH_IMG2") %>.jpg" class="rounded" alt="<%= data("IRH_Img2") %>" width="30" height="50"> <% end if%>
    </td>
    <td class="td">
      <%if data("IRH_Img3") <> "" then%><img src="<%= url %>views/incunit/img/<%= data("IRH_IMG3") %>.jpg" class="rounded" alt="<%= data("IRH_Img3") %>" width="30" height="50"> <% end if%>
    </td>
    <td class="td">
      <%if data("IRH_Img4") <> "" then%><img src="<%= url %>views/incunit/img/<%= data("IRH_IMG4") %>.jpg" class="rounded" alt="<%= data("IRH_Img4") %>" width="30" height="50"> <% end if%>
    </td>
    <td class="td">
      <%if data("IRH_Img5") <> "" then%><img src="<%= url %>views/incunit/img/<%= data("IRH_IMG5") %>.jpg" class="rounded" alt="<%= data("IRH_Img5") %>" width="30" height="50"> <% end if%>
    </td>
  </tr>
  <tr>
    <td colspan="5">&nbsp</td>
  </tr>
  <tr>
    <th class="td">No</th>
    <th class="td">Image</th>
    <th class="td">Descripsi</th>
    <th class="td">Remarks</th>
    <th class="td">Update Name</th>
  </tr>
  <% 
  no = 0
  do while not ddata.eof 
  no = no + 1
  %>
    <tr>
      <td class="td">
        <%= no  %>
      </td>
      <td class="td">
        <% if ddata("IRD_Img") <> "" then %>
          <img src="<%= url %>/views/incunit/img/<%= ddata("IRD_Img") %>.jpg" width="20" height="40">
        <%end if%>
      </td>
      <td class="td">
        <%= ddata("IRD_Description") %>
      </td>
      <td class="td">
        <%= ddata("IRD_Remarks")%>
      </td>
      <td class="td">
        <%= ddata("username")%>
      </td>
    </tr>
  <% 
  response.flush
  ddata.movenext
  loop
  %>
</table>
