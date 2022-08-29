<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Faktur.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_AgenID, dbo.DLK_T_OrPemH.OPH_Date, dbo.DLK_T_OrPemH.OPH_venID, dbo.DLK_T_OrPemH.OPH_JTDate, dbo.DLK_T_OrPemH.OPH_Keterangan,dbo.DLK_T_OrPemH.OPH_DiskonAll, dbo.DLK_T_OrPemH.OPH_PPn, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_OrPemH.OPH_MetPem, dbo.DLK_T_OrPemD.OPD_OPHID,dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_T_OrPemD.OPD_AktifYN, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrPemH INNER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = dbo.DLK_T_OrPemD.OPD_OPHID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrPemD.OPD_Item = DLK_M_Barang.Brg_ID where DLK_T_OrPemH.OPH_ID = '"& id &"' AND DLK_T_OrPemH.OPH_AktifYN = 'Y' AND DLK_T_OrPemD.OPD_AktifYN = 'Y'"

    set data = data_cmd.execute

   
    ' ' agen
    ' data_cmd.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    ' set agen = data_cmd.execute
    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Faktur Hutang")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <form action="faktur_add.asp?id=<%= id %>" method="post" id="formfaktur">
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="ophid" class="col-form-label">P.O ID</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="ophid" name="ophid" class="form-control" value="<%= data("OPH_ID") %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" class="form-control" name="agen" id="agen" value="<%= data("OPH_AgenID") %>" readonly>
                <input type="text" class="form-control" name="lagen" id="lagen" value="<% call getAgen(data("OPH_AgenID"),"p") %>" readonly>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("OPH_JTDAte") <> "1900-01-01"  then%> value="<%= data("OPH_JTDate") %>" <% end if %> onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="vendor" name="vendor" required>
                    <option value="<%= data("OPH_venid") %>"><% call getVendor(data("OPH_venid")) %></option>
                    <% do while not vendor.eof %>
                    <option value="<%= vendor("ven_ID") %>"><%= vendor("ven_Nama") %></option>
                    <% 
                    vendor.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("OPH_ppn") %>">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="metpem" name="metpem" required>
                    <option value="<%= data("OPH_MetPem") %>"><% call getmetpem(data("OPH_MetPem")) %></option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control" value="<%= data("OPH_Diskonall") %>">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OPH_Keterangan") %>" autocomplete="off">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="typebelanja" class="col-form-label">Type belanja</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="typebelanja" name="typebelanja" required>
                    <option value="">Pilih</option>
                    <option value="1">Harian</option>
                    <option value="2">Mingguan</option>
                    <option value="3">Tahunan</option>
                </select>
            </div>
        </div>
        
        
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="incomming.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahFaktur()
    end if
    call footer()
%>