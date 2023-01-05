<!--#include file="../../init.asp"-->
<% 
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "content-disposition", "filename=Master Vendor "& Request.QueryString("id")&".xls"

    id = trim(Request.querystring("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_M_Vendor.*, ISNULL(GL_M_Bank.Bank_Name,'') as bank FROM DLK_M_Vendor LEFT OUTER JOIN GL_M_Bank ON DLK_M_Vendor.Ven_BankID = GL_M_Bank.Bank_ID WHERE Ven_ID = '"& id &"' AND Ven_AktifYN = 'Y'"
    set data = data_cmd.execute

    ' cek type transaksi
    if data("Ven_TypeTransaksi") = "1" then
        strtype = "CBD"
    elseIF data("Ven_TypeTransaksi") = "2" then
        strtype = "COD"
    elseIF data("Ven_TypeTransaksi") = "3" then
        strtype = "TOP"
    else
        strtype = ""
    end if

    if data("ven_Payterm") <> "" then
        top = data("ven_payTerm")
    else 
        top = 0
    end if

    ' getdata detail
    data_cmd.commandText = "SELECT DLK_T_VendorD.*, DLK_M_Barang.Brg_Nama, DLK_M_JenisBarang.JenisNama, DLK_M_Kategori.KategoriNama FROM DLK_T_VendorD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_VendorD.Dven_BrgID = DLK_M_Barang.Brg_ID INNER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE LEFT(Dven_Venid,9) = '"& data("Ven_ID") &"'"

    set barang = data_cmd.execute

    call header("Media Print")
%>
<table class="tbl1">
    <tr>
        <th colspan="4">DETAIL BARANG VENDOR</th>
    </tr>
    <tr>
        <th colspan="4"><%= data("Ven_ID") %></th>
    </tr>
    <tr>
        <th colspan="4">&nbsp</th>
    </tr>
    <tr>
        <th style="text-align:left">Nama</th>
        <td style="text-align:left"><%= ": "&data("Ven_Nama") %></td>
        <th style="text-align:left">Phone</th>
        <td style="text-align:left"><%= ": "&data("Ven_Phone") %></td>
    </tr>
    <tr>
        <th style="text-align:left">Email</th>
        <td style="text-align:left"><%= ": "&data("Ven_Email") %></td>
        <th style="text-align:left">TypeTransaksi</th>
        <td style="text-align:left"><%= ": "&strtype &" | "& top%></td>
    </tr>
    <tr>
        <th style="text-align:left">Bank</th>
        <td style="text-align:left"><%= ": "&data("bank") %></td>
        <th style="text-align:left">No Rekening</th>
        <td style="text-align:left"><%= ": "&data("Ven_Norek") %></td>
    </tr>
    <tr>
        <th style="text-align:left">Provinsi</th>
        <td style="text-align:left"><%= ": "&data("Ven_provinsi") %></td>
        <th style="text-align:left">Kota</th>
        <td style="text-align:left"><%= ": "&data("Ven_Kota") %></td>
    </tr>
    <tr>
        <th style="text-align:left">Alamat</th>
        <td style="text-align:left"><%= ": "&data("Ven_Alamat") %></td>
    </tr>
    <tr>
        <td>&nbsp</td>
    </tr>
</table>
<table id="tbl2">
    <thead>
    <tr>
        <th style="text-align:center">Kode</th>
        <th style="text-align:center">Nama</th>
        <th style="text-align:center">Spesification</th>
        <th style="text-align:center">Harga</th>
    </tr>
    </thead>
    <tbody>
    <%  
        do while not barang.eof 
        %>
        <tr>
            <td align="left"><%= barang("KategoriNama") &"-"& barang("JenisNama") %></td>
            <td align="left">
                <%= barang("Brg_Nama") %>
            </td align="left">
            <td align="left"><%= barang("Dven_Spesification") %></td>
            <td align="right"><%= replace(formatCurrency(barang("Dven_Harga")),"$","") %></td>
        </tr>
        <% 
        barang.movenext
        loop
        %>
    </tbody>
</table>
<% call footer() %>