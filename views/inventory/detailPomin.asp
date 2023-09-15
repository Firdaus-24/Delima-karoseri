<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama,  DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_TypeBarang.T_Nama, DLK_M_SatuanBarang.sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_Memo_D.memosatuan = DLK_M_Satuanbarang.sat_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_Nama ASC"

    set dataD = data_cmd.execute

    call header("Detail Barang Kurang") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL BARANG KURANG</h3>
        </div>  
    </div> 
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= left(dataH("memoID"),4) %>/<%=mid(dataH("memoId"),5,3) %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %></h3>
        </div>  
    </div> 
    <div class="row">
        <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(dataH("memoTgl")) %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="agen" class="col-form-label">Cabang / Agen</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="agen" class="form-control" name="agen" value="<%= dataH("agenNAme") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="divisi" class="col-form-label">Divisi</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="divisi" class="form-control" name="divisi" value="<%= dataH("divNama") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="departement" class="col-form-label">Departement</label>
        </div>
        <div class="col-sm-4">
            <input type="text" id="departement" class="form-control" name="departement" value="<%= dataH("depnama") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="kebutuhan" class="form-control" name="kebutuhan" value="<%= datah("K_name") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" value="<%= dataH("memoKeterangan") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <% if session("INV6D") = true then%>
            <div class="me-auto p-2">
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlspoMin.asp?id=<%=id%>')" class="btn btn-secondary">Export</button>
            </div>
            <% end if %>
            <div class="p-2">
                <a href="POmin.asp" class="btn btn-danger">Kembali</a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">Kategori</th>
                        <th scope="col">Jenis</th>
                        <th scope="col">Barang</th>
                        <th scope="col">Pesan</th>
                        <th scope="col">PO</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Type</th>
                        <th scope="col">Keterangan</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    no = 0
                    do while not dataD.eof
                    no = no + 1

                    ' cek data po 
                    data_cmd.commandText = "SELECT OPD_QtySatuan FROM DLK_T_OrPemD LEFT OUTER JOIN DLK_T_OrPemH ON LEFT(DLK_T_OrPemD.OPD_OPHID,13) = DLK_T_OrPemH.OPH_ID WHERE DLK_T_OrPemH.OPH_MemoID = '"& id &"' AND OPD_Item = '"& dataD("memoItem") &"' AND OPH_AktifYN = 'Y'"
                    ' response.write data_cmd.commandText & "<br>"
                    set datapo = data_cmd.execute
                    
                    if not datapo.eof then
                        qtypo = datapo("OPD_Qtysatuan")
                    else
                        qtypo = 0
                    end if

                    if dataD("memoQtty") > qtypo then
                        classbg = "class='bg-danger text-light'"
                    else
                        classbg = ""
                    end if

                    %>
                        <tr <%= classbg %>>
                            <th scope="row"><%= no %></th>
                            <td ><%= dataD("kategorinama") %></td>
                            <td ><%= dataD("Jenisnama") %></td>
                            <td><%= dataD("Brg_Nama") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><%= qtypo %></td>
                            <td><%= dataD("Sat_nama") %></td>
                            <td>
                                <%= dataD("T_nama") %>
                            </td>
                            <td>
                                <%= dataD("memoKeterangan") %>
                            </td>
                        </tr>
                    <% 
                    Response.flush
                    dataD.movenext
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