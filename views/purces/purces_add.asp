<!--#include file="../../init.asp"-->
<% 
    cabang = trim(Request.form("agenPotoMemo"))
    id = trim(Request.form("idmemo"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_Memo_H.MemoID, dbo.DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, GLB_M_agen.AgenID, GLB_M_Agen.AgenName FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.Memoitem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_T_Memo_H ON LEFT(DLK_T_Memo_D.memoID,17) = DLK_T_Memo_H.memoID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID WHERE LEFT(dbo.DLK_T_Memo_D.memoID,17) = '"& id &"' AND dbo.DLK_T_Memo_H.MemoID = '"& id &"' AND DLK_T_Memo_H.memoAktifYN = 'Y' AND DLK_T_Memo_H.memoApproveYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Prosess Purchase")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH PURCHES ORDER</h3>
        </div>
    </div>
    <form action="purces_exe.asp" method="post" id="formpur" onsubmit="validasiForm(this,event,'Purchase Order','warning')">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="memoId" class="col-form-label">No Memo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" id="memoId" name="memoId" class="form-control" value="<%= id %>" readonly>
                <input type="text" id="lmemoId" name="lmemoId" class="form-control" value="<%= left(data("memoID"),4) %>/<%=mid(data("memoId"),5,3) %>-<% call getAgen(mid(data("memoID"),8,3),"") %>/<%= mid(data("memoID"),11,4) %>/<%= right(data("memoID"),3) %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="agen" name="agen" required>
                    <option value="<%= data("AgenID") %>" selected ><%=data("AgenName") %></option>
                </select>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="vendor" name="vendor" required>
                    <option value="">Pilih</option>
                    <% do while not vendor.eof %>
                    <option value="<%= vendor("ven_ID") %>"><%= vendor("ven_Nama") %></option>
                    <% 
                    vendor.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" value="<%= date %>" onfocus="(this.type='date')" class="form-control" required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgljt" name="tgljt" class="form-control">
            </div>
        </div>
        <div class="row align-items-center">
            
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center mb-3">
                <a href="purcesDetail.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
    <div class="row">
        <div class="col-lg-12">
            <h5>DAFTAR BARANG YANG DI AJUKAN</h5>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <table class="table table-hover">
                <thead class="bg-secondary text-light" style="white-space: nowrap;">
                    <tr>
                        <th>Item</th>
                        <th>Specification</th>
                        <th>Quantty</th>
                        <th>Harga</th>
                        <th>Satuan Barang</th>
                    </tr>
                </thead>
                <tbody>
                    <% do while not data.eof %>
                    <tr>
                        <!-- 
                        <td class="text-center">
                            <input class="form-check-input ckpo" type="checkbox" value="" id="ckpo">
                        </td>
                            -->
                        <td>
                            <%= data("Brg_Nama")%>
                        </td>
                        <td>
                            <%= data("memospect")%>
                        </td>
                        <td>
                            <%= data("memoQtty") %>
                        </td>
                        <td>
                            <%= replace(formatCurrency(data("memoHarga")),"$","") %>
                        </td>
                        <td>
                            <% call getSatBerat(data("memosatuan")) %>
                        </td>
                        <!-- 
                        <td>
                            <input type="number" id="disc1" name="disc1" class="form-control " required>
                        </td>
                        <td>
                            <input type="number" id="disc2" name="disc2" class="form-control" required>
                        </td>
                            -->
                    </tr>
                    <% 
                    data.movenext
                    loop
                    data.movefirst
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <h5>DAFTAR VENDOR PENYEDIA</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light" style="white-space: nowrap;">
                    <tr>
                        <th>Nama</th>
                        <th>Specification</th>
                        <th>Harga</th>
                    </tr>
                </thead>
                <tbody>
                    <% do while not data.eof 
                        data_cmd.commandText = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_VendorD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_VendorD.Dven_BrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_Vendor ON LEFT(dbo.DLK_T_VendorD.Dven_Venid, 9) = dbo.DLK_M_Vendor.Ven_ID WHERE dbo.DLK_T_VendorD.Dven_BrgID = '"& data("memoitem") &"' AND DLK_M_Vendor.Ven_AktifYN = 'Y' GROUP BY dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_M_Barang.Brg_Nama ORDER BY dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Barang.Brg_Nama ASC"
                        set datavendor = data_cmd.execute
                    %>
                    <tr class="bg-success p-2 text-dark bg-opacity-25">
                        <td colspan="3">
                            <%= data("Brg_Nama")%>
                        </td>
                    </tr>
                    <% do while not datavendor.eof %>
                    <tr>
                        <td>
                            <%= datavendor("Ven_Nama")%>
                        </td>
                        <td>
                            <%= datavendor("Dven_Spesification")%>
                        </td>
                        <td>
                            <%= replace(formatCurrency(datavendor("Dven_Harga")),"$","") %>
                        </td>
                    </tr>
                    
                    <% 
                        datavendor.movenext
                        loop
                    data.movenext
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