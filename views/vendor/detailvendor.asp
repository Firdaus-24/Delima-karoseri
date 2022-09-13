<!--#include file="../../init.asp"-->
<% 
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

    call header("Detail Barang Vendor")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg text-center">
            <h3>DETAIL BARANG VENDOR</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-1">
            <label for="nama" class="col-form-label">Nama</label>
        </div>
        <div class="col-lg-5 mb-3">
            <input type="text" id="nama" class="form-control" value="<%= ": "&data("Ven_Nama") %>"  style="background:transparent;border:none;" readonly>
        </div>
        <div class="col-lg-1">
            <label for="Phone" class="col-form-label">Phone</label>
        </div>
        <div class="col-lg-5 mb-3">
            <input type="text" id="Phone" class="form-control" value="<%= ": "&data("Ven_Phone") %>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-1">
            <label for="Alamat" class="col-form-label">Alamat</label>
        </div>
        <div class="col-lg-5 mb-3">
            <input type="text" id="Alamat" class="form-control" value="<%= ": "&data("Ven_Alamat") %>" style="background:transparent;border:none;" readonly>
        </div>
        <div class="col-lg-1">
            <label for="Email" class="col-form-label">Email</label>
        </div>
        <div class="col-lg-5 mb-3">
            <input type="text" id="Email" class="form-control" value="<%= ": "& data("Ven_Email") %>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-1">
            <label for="TOP" class="col-form-label">TOP</label>
        </div>
        <div class="col-lg-5 mb-3">
            <input type="text" id="TOP" class="form-control" value="<%= ": "&data("Ven_TOP") &" Hari"%>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-secondary" onClick="window.open('export-xlsvendor.asp?id=<%=id%>')" >Export</button>
            </div>
            <div class="p-2">
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </div>                
    <div class="row">
        <div class="col-sm-12">
            <table class="table" >
                <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Nama</th>
                        <th scope="col">Spesification</th>
                        <th scope="col">Harga</th>
                    </tr>
                </thead>
                <tbody>
                    <%  
                    do while not ddata.eof 
                    %>
                    <tr>
                        <th scope="row"><%= ddata("Dven_Venid") %></th>
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
        </div>
    </div>
</div>
<% 
    call footer()
%>