<!--#include file="../../init.asp"-->
<% 
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "content-disposition", "filename=Master Vendor "& Request.QueryString("id")&".xls"

    id = trim(Request.querystring("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_M_Vendor WHERE Ven_ID = '"& id &"' AND Ven_AktifYN = 'Y'"
    set data = data_cmd.execute

    ' getdata detail
    data_cmd.commandText = "SELECT DLK_T_VendorD.*, DLK_M_Barang.Brg_Nama FROM DLK_T_VendorD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_VendorD.Dven_BrgID = DLK_M_Barang.Brg_ID WHERE LEFT(Dven_Venid,9) = '"& data("Ven_ID") &"'"

    set ddata = data_cmd.execute

    ' get data barang
    data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_Barang.JenisID, DLK_M_Barang.KategoriID, DLK_M_JenisBarang.JenisNama, DLK_M_Kategori.KategoriNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE Brg_AktifYN = 'Y' AND LEFT(Brg_ID,3) = '"& left(data("Ven_ID"),3) &"' ORDER BY Brg_Nama ASC"
    set barang = data_cmd.execute

    call header("Media Print")
%>
<style>
    .tbl1 tr:nth-child(1){
        text-align: center;
    }
    #tbl2{
        border-collapse: collapse;
        border: 1px solid black;
    }
    #tbl2 > * > tr > *  {
        border: 1px solid black;
        padding:5px;
    }
</style>
<table class="tbl1">
    <tr>
        <th colspan="4">DETAIL BARANG VENDOR</th>
    </tr>
    <tr>
        <th>&nbsp</th>
    </tr>
    <tr>
        <th>ID</th>
        <td><%= ": "&data("Ven_ID") %></td>
    </tr>
    <tr>
        <th>Nama</th>
        <td><%= ": "&data("Ven_Nama") %></td>
    </tr>
    <tr>
        <th>Phone</th>
        <td><%= ": "&data("Ven_Phone") %></td>
    </tr>
    <tr>
        <th>Alamat</th>
        <td><%= ": "&data("Ven_Alamat") %></td>
    </tr>
    <tr>
        <th>Email</th>
        <td><%= ": "&data("Ven_Email") %></td>
    </tr>
    <tr>
        <th>TOP</th>
        <td><%= ": "&data("Ven_TOP") %></td>
    </tr>
    <tr>
        <td>&nbsp</td>
    </tr>
</table>
<table id="tbl2">
    <thead>
    <tr>
        <th>ID</th>
        <th>Nama</th>
        <th>Spesification</th>
        <th>Harga</th>
    </tr>
    </thead>
    <tbody>
    <%  
        do while not ddata.eof 
        %>
        <tr>
            <th><%= ddata("Dven_Venid") %></th>
            <td>
                <%= ddata("Brg_Nama") %>
            </td>
            <td><%= ddata("Dven_Spesification") %></td>
            <td><%= replace(formatCurrency(ddata("Dven_Harga")),"$","") %></td>
        </tr>
        <% 
        ddata.movenext
        loop
        %>
    </tbody>
</table>
<% call footer() %>