<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, DLK_M_Departement.DepNama, GLB_M_Agen.AgenName, DLK_M_Divisi.DivNama FROM DLK_T_Memo_H LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepID = DLK_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_Memo_H.memoDivID = DLK_M_Divisi.divID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    ' cek kebutuhan
    if dataH("memoKebutuhan") = 0 then
        kebutuhan = "Produksi"
    elseif dataH("memoKebutuhan") = 1 then
        kebutuhan = "Khusus"
    elseif dataH("memoKebutuhan") = 2 then
        kebutuhan = "Umum"
    else
        kebutuhan = "Sendiri"
    end if
    ' nomor id
    ' left(dataH("memoID"),4)/ mid(dataH("memoId"),5,3)- getAgen(mid(dataH("memoID"),8,3),"")/ mid(dataH("memoID"),11,4)/ right(dataH("memoID"),3)
%>
<% call header("Detail Barang Kurang") %>
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
            <input type="text" id="kebutuhan" class="form-control" name="kebutuhan" value="<%= kebutuhan %>" readonly>
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
                        <th scope="col">Item</th>
                        <th scope="col">Spesification</th>
                        <th scope="col">Pesan</th>
                        <th scope="col">PO</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Keterangan</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY memoItem ASC"
                    ' response.write data_cmd.commandText
                    set dataD = data_cmd.execute

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
                        <tr>
                            <th scope="row"><%= no %></th>
                            <td <%= classbg %>><%= dataD("Brg_Nama") %></td>
                            <td><%= dataD("memoSpect") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><%= qtypo %></td>
                            <td><% call getSatBerat(dataD("memoSatuan")) %></td>
                            <td>
                                <%= dataD("memoKeterangan") %>
                            </td>
                        </tr>
                    <% 
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