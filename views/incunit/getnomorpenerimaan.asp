<!--#include file="../../init.asp"-->
<% 
  cabang = trim(Request.form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string 

  data_cmd.commandTExt =   "SELECT dbo.DLK_T_UnitCustomerH.TFK_ID, dbo.DLK_M_Customer.custNama FROM dbo.DLK_T_UnitCustomerH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_UnitCustomerH.TFK_CustID = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_UnitCustomerH.TFK_ID = LEFT(dbo.DLK_T_UnitCustomerD1.TFK_ID, 17) GROUP BY dbo.DLK_T_UnitCustomerH.TFK_ID, dbo.DLK_M_Customer.custNama, dbo.DLK_T_UnitCustomerH.TFK_AktifYN, dbo.DLK_T_UnitCustomerH.TFK_Jenis, dbo.DLK_T_UnitCustomerH.TFK_OJHORHID HAVING (dbo.DLK_T_UnitCustomerH.TFK_AktifYN = 'Y') AND (dbo.DLK_T_UnitCustomerH.TFK_Jenis = 2) AND (SUBSTRING(dbo.DLK_T_UnitCustomerH.TFK_OJHORHID, 3, 3) = '"& cabang &"') AND (  COUNT(dbo.DLK_T_UnitCustomerD1.TFK_ID)  > (SELECT COUNT(IRH_TFKID) as trepair FROM DLK_T_IncRepairH WHERE IRH_AktifYN = 'Y' AND LEFT(IRH_TFKID,17) = dbo.DLK_T_UnitCustomerH.TFK_ID )) ORDER BY dbo.DLK_T_UnitCustomerH.TFK_ID, dbo.DLK_M_Customer.custNama "
  set data = data_cmd.execute
%>
   
<table class="table table-hover " width="100" style="margin:0;padding:0;">
  <thead style="position: sticky;top: 0;background-color:cyan;">  
    <tr>
      <th scope="col">No</th>
      <th scope="col">Merk</th>
      <th scope="col">Type</th>
      <th scope="col">No.Polisi</th>
      <th scope="col">No.Ranka</th>
      <th scope="col">Warna</th>
      <th scope="col">Pilih</th>
    </tr>
  </thead>
  <tbody>
    <%
      do while not data.eof 
    %>
    <tr>
      <th colspan="4">Document : <%= LEFT(data("TFK_ID"),11) &"/"& MID(data("TFK_ID"),12,4) &"/"& Right(data("TFK_ID"),2) %></th>
      <th colspan="3">Customer : <%= data("custnama") %></th>
    </tr>

      <%
      ' cek data detail
      data_cmd.commandTExt = "SELECT DLK_T_UnitCustomerD1.*, dbo.DLK_M_Brand.BrandName FROM DLK_T_UnitCustomerD1 LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_BrandID = dbo.DLK_M_Brand.BrandID WHERE LEFT(TFK_ID,17) = '"& data("TFK_ID") &"' AND NOT EXISTS(SELECT IRH_TFKID FROM DLK_T_IncRepairH WHERE IRH_TFKID = DLK_T_UnitCustomerD1.TFK_ID AND IRH_AktifYN = 'Y' ) ORDER BY TFK_ID, brandname ASC"
      set ddata = data_cmd.execute
      no = 0
      do while not ddata.eof
      no = no + 1
      %>
        <tr>
          <td><%= no %></td>
          <td><%= ddata("BrandName") %></td>
          <td><%= ddata("TFK_Type") %></td>
          <td><%= ddata("TFK_nopol") %></td>
          <td><%= ddata("TFK_norangka") %></td>
          <td><%= ddata("TFK_Color") %></td>
          <td class="text-center">
            <input class="form-check-input" type="radio" name="radio-incrheader" id="radio-incrheader" onclick="setTfkIdIncr('<%=ddata("TFK_id")%>', '<%= data("custnama") %>')">
          </td>
          
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
  </tbody>
</table>