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

  call header("Media Print")
%>
<link href="../../public/css/incunit.css" rel="stylesheet" />

<body onload="window.print()"> 
  <div class="rowIncrd gambar">
    <div class="col ">
      <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
    </div>
  </div>
  <div class='labelHeaderIncr'>
    <span><h3>INCOMMING UNIT INSPECTION</h3></span>
    <span><h3><%= LEFT(data("IRH_ID"),4) &"-"& mid(data("IRH_ID"),5,3) &"/"& mid(data("IRH_ID"),8,4) &"/"& right(data("IRH_ID"),2) %></h3></span>
  </div>
  <div class='rowIncrd'>
    <span>Tanggal</span>
    <span>: <%= Cdate(data("IRH_Date")) %></span>
    <span>Cabang</span>
    <span>: <%= data("agenname") %></span>
  </div>
  <div class="rowIncrd">
    <span>
      No.Penerimaan Unit
    </span>
    <span>
      : <%= LEFT(data("IRH_TFKID"),11) &"/"& MID(data("IRH_TFKID"),12,4) &"/"& MID(data("IRH_TFKID"),16,2) &"/"& right(data("IRH_TFKID"),3) %>
    </span>
    <span>
      Customer
    </span>
    <span>
      : <%= data("custnama") %>
    </span>
  </div>
  <div class="rowIncrd">
    <span>
      Keterangan
    </span>
    <span>
      : <%= data("IRH_Keterangan") %>
    </span>
  </div>
  <div style="margin-top:10px">
    <span>
      GENERAL PICTURE
    </span>
  </div>
  <div class="imgwrapper" >
    <div>
      <%if data("IRH_Img1") <> "" then%><img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG1") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>" width="50" height="70"> <% end if%> Image 1
    </div>
    <div>
      <%if data("IRH_Img2") <> "" then%><img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG2") %>.jpg" class="rounded" alt="<%= data("IRH_Img2") %>" width="50" height="70"> <% end if%> Image 2
    </div>
    <div>
      <%if data("IRH_Img3") <> "" then%><img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG3") %>.jpg" class="rounded" alt="<%= data("IRH_Img3") %>" width="50" height="70"> <% end if%> Image 3
    </div>
    <div>
      <%if data("IRH_Img4") <> "" then%><img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG4") %>.jpg" class="rounded" alt="<%= data("IRH_Img4") %>" width="50" height="70"> <% end if%> Image 4
    </div>
    <div>
      <%if data("IRH_Img5") <> "" then%><img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG5") %>.jpg" class="rounded" alt="<%= data("IRH_Img5") %>" width="50" height="70"> <% end if%> Image 5
    </div>
  </div>


  <table class="tableIncrd">
    <tr>
      <th>No</th>
      <th>Image</th>
      <th>Descripsi</th>
      <th>Remarks</th>
      <th>Update Name</th>
    </tr>
    <% 
    no = 0
    do while not ddata.eof 
    no = no + 1
    %>
      <tr>
        <td>
          <%= no  %>
        </td>
        <td>
          <% if ddata("IRD_Img") <> "" then %>
            <img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= ddata("IRD_Img") %>.jpg" width="40" style="padding:5px;">
          <%end if%>
        </td>
        <td>
          <%= ddata("IRD_Description") %>
        </td>
        <td>
          <%= ddata("IRD_Remarks")%>
        </td>
        <td>
          <%= ddata("username")%>
        </td>
      </tr>
    <% 
    response.flush
    ddata.movenext
    loop
    %>
  </table>
</body>
<% call footer()%>