<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_jbarang.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_OrJulH.*, dbo.GLB_M_Agen.AgenName, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrjulH.OJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_T_ProductH ON DLK_T_OrjulH.OJH_PDID = DLK_T_ProductH.PDID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_ProductH.PDbrgID = DLK_M_Barang.Brg_ID where DLK_T_OrJulH.OJH_ID = '"& id &"' AND DLK_T_OrJulH.OJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    if not data.eof then
        if data("OJH_PDID") <> "" then
            pdid = data("OJH_PDID")
            labelpd = data("OJH_PDID") &" | "& data("Brg_Nama")
        else
            pdid = ""
            labelpd = ""
        end if
    end if

    ' cek kebutuhan
    if data("OJH_Kebutuhan") = 0 then
        kebutuhan = "Produksi"
    elseif data("OJH_Kebutuhan") = 1 then
        kebutuhan = "Khusus"
    elseif data("OJH_Kebutuhan") = 2 then
        kebutuhan = "Umum"
    else
        kebutuhan = "Sendiri"
    end if


    ' produksi
    data_cmd.commandText = "SELECT PDBrgID, PDID, Brg_Nama FROM DLK_T_ProductH LEFT OUTER JOIN DLK_M_Barang ON DLK_T_ProductH.PDBrgID = DLK_M_Barang.Brg_ID WHERE PDAktifYN = 'Y' ORDER BY Brg_Nama ASC"
    set produksi = data_cmd.execute

    call header("Faktur Hutang")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>FORM TAMBAH FAKTUR PENJUALAN</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <form action="jbarang_add.asp?id=<%= id %>" method="post" id="formPenjualanH" onsubmit="validasiForm(this,event,'Outgoing Prosess','warning')">
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="ojhid" class="col-form-label">No Permintaan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="ojhid" name="ojhid" class="form-control" value="<%= data("OJH_ID") %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" class="form-control" name="agen" id="agen" value="<%= data("OJH_AgenID") %>" readonly>
                <input type="text" class="form-control" name="lagen" id="lagen" value="<% call getAgen(data("OJH_AgenID"),"p") %>" readonly>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
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
                <label for="produksi" class="col-form-label">No Produksi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="produksi" name="produksi" <% if data("OJH_PDID") <> "" then %> required <% end if %>>
                    <option value="<%= pdid %>"><%= labelpd %></option>
                    <% do while not produksi.eof %>
                    <option value="<%= produksi("PDID") %>"><%= produksi("PDID") &" | "& produksi("Brg_Nama") %></option>
                    <% 
                    produksi.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="kebutuhan" name="kebutuhan" required>
                    <option value="<%= data("OJH_Kebutuhan") %>"><%= kebutuhan %></option>
                    <option value="0">Produksi</option>
                    <option value="1">Khusus</option>
                    <option value="2">Umum</option>
                    <option value="3">Sendiri</option>
                </select>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="jbarang.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahPenjualan()
    end if
    call footer()
%>