<!--#include file="../../init.asp"-->
<% 
  if session("MQ2D") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=Kedatanagan Unit Customer "& left(id,11) &"/"& MID(id,12,4) &"/"& right(id,2)&" .xls"

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' data header
  data_cmd.commandText = "SELECT DLK_T_UnitCustomerH.*,  DLK_M_Customer.custNama, DLK_M_Weblogin.username FROM DLK_T_UnitCustomerH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_UnitCustomerH.TFK_Custid = DLK_M_Customer.custid LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_UnitCustomerH.TFK_UpdateID = DLK_M_WebLogin.userid WHERE TFK_ID = '"& id &"' AND TFK_AktifYN = 'Y'"

  set data = data_cmd.execute

  ' data detail1
  data_cmd.commandText = "SELECT dbo.DLK_T_UnitCustomerD1.*, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_Brand.BrandName FROM dbo.DLK_T_UnitCustomerD1 LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_Merk = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_UnitCustomerD1.TFK_UpdateID = dbo.DLK_M_WebLogin.UserID WHERE LEFT(TFK_ID,17) = '"& data("TFK_ID") &"'"
  ' response.write data_cmd.commandtext & "<br>"
  set ddata = data_cmd.execute

  call header("Detail Serah Terima")
%>
<table width="100" >
  <tr>
    <th colspan="7" style="text-align:center;">
      DETAIL KEDATANGAN UNIT
    </th>
  </tr>
  <tr>
    <th colspan="7" style="text-align:center;">
      <%= LEFT(data("TFK_ID"),11) &"/"& MID(data("TFK_ID"),12,4) &"/"& Right(data("TFK_ID"),2) %>
    </th>
  </tr>
  <tr>
    <td colspan="2">
      Sales Order
    </td>
    <td colspan="2">
      : <%= left(data("TFK_OJHID") ,2)%>-<%=  mid(data("TFK_OJHID") ,3,3)%>/<%= mid(data("TFK_OJHID") ,6,4) %>/<%= right(data("TFK_OJHID"),4) %>
    </td>
    <td colspan="2">
      Customer
    </td>
    <td colspan="2">
      : <%= data("CustNama") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Penerima
    </td>
    <td colspan="2">
      : <%= data("TFK_Penerima") %>
    </td>
    <td colspan="2">
      Tanggal
    </td>
    <td colspan="2">
      : <%= data("TFK_Date") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Penyerah
    </td>
    <td colspan="2">
      : <%= data("TFK_Penyerah") %>
    </td>
    <td colspan="2">
      Keterangan
    </td>
    <td colspan="2">
      : <%= data("TFK_Keterangan") %>
    </td>
  </tr>
  <tr>
    <td colspan="7">
      &nbsp
    </td>
  </tr>
  <tr>
    <th style="background-color: #0000ff;color:#fff;">Tanggal Kedangan</th>
    <th style="background-color: #0000ff;color:#fff;">Merk</th>
    <th style="background-color: #0000ff;color:#fff;">Type</th>
    <th style="background-color: #0000ff;color:#fff;">No.Polisi</th>
    <th style="background-color: #0000ff;color:#fff;">No.Rangka</th>
    <th style="background-color: #0000ff;color:#fff;">No.Mesin</th>
    <th style="background-color: #0000ff;color:#fff;">Color</th>
  </tr>
  <% do while not ddata.eof 
  ' cek detail data d3 
  data_cmd.commandText = "SELECT dbo.DLK_T_UnitCustomerD2.TFK_Keterangan, dbo.DLK_M_ItemKendaraan.FK_Nama, dbo.DLK_T_UnitCustomerD2.TFK_ID FROM dbo.DLK_T_UnitCustomerD2 LEFT OUTER JOIN dbo.DLK_M_ItemKendaraan ON dbo.DLK_T_UnitCustomerD2.TFK_FKID = dbo.DLK_M_ItemKendaraan.FK_Id WHERE TFK_ID = '"& ddata("TFK_ID") &"' ORDER BY TFK_FKID ASC"
  set ddata3 = data_cmd.execute
  %>
  <tr>
    <td>
      <%= Cdate(ddata("TFK_Date")) %>
    </td>
    <td>
      <%= ddata("BrandName") %>
    </td>
    <td>
      <%= ddata("TFK_Type") %>
    </td>
    <td>
    <%= ddata("TFK_nopol") %>
    </td>
    <td>
      <%= ddata("TFK_norangka") %>
    </td>
    <td>
      <%= ddata("TFK_Nomesin") %>
    </td>
    <td>
      <%= ddata("TFK_Color") %>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="background-color:#ffea00;"> 
      Detail Alat
    </td>
    <td colspan="5" style="background-color:#ffea00;"> 
      Keterangan
    </td>
  </tr>
  <% do while not ddata3.eof %> 
  <tr>
    <td colspan="2">
      <%= ddata3("FK_Nama")  %>
    </td>
    <td colspan="5">
      <% if ddata3("TFK_Keterangan") = ""  then %>
        <p style="text-align:center;">-</p>
      <% else %>
        <%= ddata3("TFK_Keterangan")  %>
      <% end if %>
    </td>
  </tr>
  <% 
  response.flush
  ddata3.movenext
  loop
  response.flush
  ddata.movenext
  loop
  %>
</table>

