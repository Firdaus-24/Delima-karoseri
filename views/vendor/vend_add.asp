<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_vendor.asp"-->
<% 
    id = trim(Request.querystring("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_M_Vendor.*, GL_M_Bank.Bank_Name FROM DLK_M_Vendor LEFT OUTER JOIN GL_M_Bank ON DLK_M_Vendor.Ven_BankID = GL_M_Bank.Bank_ID WHERE Ven_ID = '"& id &"' AND Ven_AktifYN = 'Y'"
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
    data_cmd.commandText = "SELECT DLK_T_VendorD.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM DLK_T_VendorD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_VendorD.Dven_BrgID = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(Dven_Venid,9) = '"& data("Ven_ID") &"'"

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
            <h3>FORM TAMBAH VENDOR</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <label for="nama" class="col-form-label">Nama</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="nama" class="form-control" value="<%= ": "&data("Ven_Nama") %>"  style="background:transparent;border:none;" readonly>
        </div>
        <div class="col-lg-2">
            <label for="Phone" class="col-form-label">Phone</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="Phone" class="form-control" value="<%= ": "&data("Ven_Phone") %>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        
        <div class="col-lg-2">
            <label for="Email" class="col-form-label">Email</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="Email" class="form-control" value="<%= ": "& data("Ven_Email") %>" style="background:transparent;border:none;" readonly>
        </div>
        <div class="col-lg-2">
            <label for="TOP" class="col-form-label">Type Transaksi</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="TOP" class="form-control" value="<%= ": "&strtype &" | "& top%>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <label for="TOP" class="col-form-label">Bank</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="TOP" class="form-control" value="<%= ": "&data("Bank_Name") %>" style="background:transparent;border:none;" readonly>
        </div>
        <div class="col-lg-2">
            <label for="norek" class="col-form-label">No. Rekening</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="norek" class="form-control" value="<%= ": "&data("Ven_Norek") %>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <label for="provinsi" class="col-form-label">Provinsi</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="provinsi" class="form-control" value="<%= ": "&data("Ven_provinsi") %>" style="background:transparent;border:none;" readonly>
        </div>
        <div class="col-lg-2">
            <label for="Kota" class="col-form-label">Kota</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="Kota" class="form-control" value="<%= ": "&data("Ven_Kota") %>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <label for="Alamat" class="col-form-label">Detail Alamat</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="Alamat" class="form-control" value="<%= ": "&data("Ven_Alamat") %>" style="background:transparent;border:none;" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalDVendor">Tambah Rincian</button>
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
                        <th scope="col">Kode</th>
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
                            <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                        </td>
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
<!-- Modal -->
<div class="modal fade" id="modalDVendor" tabindex="-1" aria-labelledby="modalDVendorLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalDVendorLabel">Rincian Barang</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="vend_add.asp?id=<%= id %>" method="post">
            <input type="hidden" id="id" name="id" class="form-control" value="<%= data("Ven_ID") %>">
            <div class="modal-body">
                <div class="row g-3 align-items-center mb-3">
                    <div class="col-sm-4">
                        <label for="keybrgvendor" class="col-form-label">Cari Kategori</label>
                    </div>  
                    <div class="col-sm-8">
                        <input type="text" id="keybrgvendor" name="keybrgvendor" class="form-control" autocomplete="off">
                        <input type="hidden" id="venagenID" name="venagenID" class="form-control" value="<%= left(data("Ven_ID"),3) %>">
                    </div>
                </div>
                <div class="row g-3 align-items-center mb-3">
                    <div class="col-sm-4">
                        <label for="keybrgjnsvendor" class="col-form-label">Cari Jenis</label>
                    </div>  
                    <div class="col-sm-8">
                        <input type="text" id="keybrgjnsvendor" name="keybrgjnsvendor" class="form-control" autocomplete="off">
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 overflow-auto" style="height:15rem;">
                        <table class="table" >
                            <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                                <tr>
                                    <th scope="col">No</th>
                                    <th scope="col">Kode</th>
                                    <th scope="col">Nama</th>
                                    <th scope="col" class="text-center">Pilih</th>
                                </tr>
                            </thead>
                            <tbody class="contentBrgVen">
                                <%  
                                no = 0
                                do while not barang.eof 
                                no = no + 1
                                %>
                                <tr>
                                    <th scope="row"><%= no %></th>
                                    <td>
                                        <%= barang("kategoriNama") &"-"& barang("jenisNama") %>
                                    </td>
                                    <td><%= barang("Brg_Nama") %></td>
                                    <td class="text-center">    
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="ckdvendor" id="ckdvendor" value="<%= barang("Brg_ID") %>" required>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                barang.movenext
                                loop
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="row g-3 align-items-center mt-3 mb-3">
                    <div class="col-sm-4">
                        <label for="spesification" class="col-form-label">Spesification</label>
                    </div>
                    <div class="col-sm-8">
                        <input type="text" id="spesification" name="spesification" class="form-control"  autocomplete="off" required>
                    </div>
                </div>
                <div class="row g-3 align-items-center mb-3">
                    <div class="col-sm-4">
                        <label for="harga" class="col-form-label">Harga</label>
                    </div>
                    <div class="col-sm-8">
                        <input type="number" id="harga" name="harga" class="form-control" autocomplete="off" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
            </form>
        </div>
    </div>
</div>
<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahdetailVendor()
    end if
    call footer()
%>