<!--#include file="../../init.asp"-->
<% 
    if session("PR2A") = false then
        Response.Redirect("index.asp")
    end if


    cabang = trim(Request.form("agenPotoMemo"))
    id = trim(Request.form("idmemo"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_Memo_H.MemoID, dbo.DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, GLB_M_agen.AgenID, GLB_M_Agen.AgenName, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_Kebutuhan.K_Name, DLK_M_Kebutuhan.K_ID FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.Memoitem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_T_Memo_H ON LEFT(DLK_T_Memo_D.memoID,17) = DLK_T_Memo_H.memoID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_kebutuhan.K_ID WHERE LEFT(dbo.DLK_T_Memo_D.memoID,17) = '"& id &"' AND dbo.DLK_T_Memo_H.MemoID = '"& id &"' AND DLK_T_Memo_H.memoAktifYN = 'Y' AND DLK_T_Memo_H.memoApproveYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' AND LEFT(Ven_ID,3) = '"& data("agenID") &"' ORDER BY ven_Nama ASC"
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
                <label for="acpdate" class="col-form-label">Tanggal Diterima</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="acpdate" name="acpdate" class="form-control" onfocus="(this.type='date')">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" id="topVendor" name="topVendor" class="form-control">
                <input type="text" id="tgljt" name="tgljt" class="form-control" onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="asuransi" class="col-form-label">Asuransi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="asuransi" name="asuransi" class="form-control" required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="lain" class="col-form-label">Lain</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="lain" name="lain" class="form-control" required>
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
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-3 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control">
            </div>
            <div class="col-lg-1 mb-3 p-0">
                <label class="col-form-label">%</label>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" id="kebutuhan" name="kebutuhan" class="form-control" maxlength="50" value="<%= data("K_id") %>" autocomplete="off">
                <input type="text" id="lkeb" name="lkeb" class="form-control" maxlength="50" value="<%= data("K_name") %>" autocomplete="off" readonly>
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
                        <th>Kode</th>
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
                        <th>
                            <%= data("KategoriNama") &"-"& data("jenisNama") %>
                        </th>
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
                        data_cmd.commandText = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_VendorD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_VendorD.Dven_BrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_Vendor ON LEFT(dbo.DLK_T_VendorD.Dven_Venid, 9) = dbo.DLK_M_Vendor.Ven_ID WHERE dbo.DLK_T_VendorD.Dven_BrgID = '"& data("memoitem") &"' AND DLK_M_Vendor.Ven_AktifYN = 'Y' GROUP BY dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_M_Barang.Brg_Nama ORDER BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_VendorD.Dven_Harga ASC"
                        set datavendor = data_cmd.execute
                    %>
                    <tr class="bg-success p-2 text-dark bg-opacity-25">
                        <td colspan="3">
                            <%= "<b>"&data("KategoriNama") &"-"& data("jenisNama") &"</b> | "& data("Brg_Nama") %>
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
<script>
    let newDate
    $("#vendor").change(function() {
        let id = $("#vendor").val()
        $.post( "./getTopVendor.asp", {id}, function( data ) {
            let str = Number(data)
            $("#topVendor").val(str)
            
            if($("#tgl").val() != "" && str != 0){
                let tgl = new Date($("#tgl").val())
                newDate = new Date(tgl.setDate(tgl.getDate() + str))
                let tgljt = ((newDate.getMonth() > 8) ? (newDate.getMonth() + 1) : ('0' + (newDate.getMonth() + 1))) + '/' + ((newDate.getDate() > 9) ? newDate.getDate() : ('0' + newDate.getDate())) + '/' + newDate.getFullYear()

                $("#tgljt").val( tgljt)
            }else{
                $("#tgljt").val('')
            }
        });
    })
    $("#tgl").change(function(){
        let top = Number($("#topVendor").val())
        if(top != 0){
            let tgl = new Date($("#tgl").val())
            newDate = new Date(tgl.setDate(tgl.getDate() + top))
            let tgljt = ((newDate.getMonth() > 8) ? (newDate.getMonth() + 1) : ('0' + (newDate.getMonth() + 1))) + '/' + ((newDate.getDate() > 9) ? newDate.getDate() : ('0' + newDate.getDate())) + '/' + newDate.getFullYear()
    
            $("#tgljt").val( tgljt)
        }else{
            $("#tgljt").val('')
        }
    })
</script>