<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Faktur.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID FROM dbo.DLK_T_OrPemH WHERE OPH_AktifYN = 'Y' AND NOT EXISTS(SELECT IPH_OPHID FROM DLK_T_InvPemH WHERE IPH_AktifYN = 'Y' AND IPH_OPHID = OPH_ID) ORDER BY dbo.DLK_T_OrPemH.OPH_ID DESC"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Faktur Hutang")

    ' agen / cabang
    data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"

    set agen = data_cmd.execute
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <form action="faktur_add.asp" method="post" id="formfaktur">
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="ophid" class="col-form-label">No P.O</label>
            </div>
            <div class="col-lg-4 mb-3">
                 <select class="form-select" aria-label="Default select example" id="ophid" name="ophid" required>
                    <option value="">Pilih</option>
                    <% do while not data.eof %>
                    <option value="<%= data("OPH_ID") %>"><%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %></option>
                    <% 
                    data.movenext
                    loop
                    %>
                </select>
            </div>
            <!-- 
            <div class="col-lg-2 mb-3">
                <label for="produksi" class="col-form-label">Produksi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="produksi" id="N" value="N">
                    <label class="form-check-label" for="N">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="produksi" id="Y" value="Y">
                    <label class="form-check-label" for="Y">No</label>
                </div>
            </div>
             -->
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="agen" name="agen" required>
                    <option value="">Pilih</option>
                    <% do while not agen.eof %>
                    <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
                    <% 
                    agen.movenext
                    loop
                    %>
                </select>
            </div>
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
                <input type="text" id="tgljt" name="tgljt" class="form-control" onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
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