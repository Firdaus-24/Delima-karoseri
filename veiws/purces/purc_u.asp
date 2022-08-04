<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID, dbo.DLK_T_OrPemH.OPH_AgenID, dbo.DLK_T_OrPemH.OPH_Date, dbo.DLK_T_OrPemH.OPH_venID, dbo.DLK_T_OrPemH.OPH_JTDate, dbo.DLK_T_OrPemH.OPH_Keterangan,dbo.DLK_T_OrPemH.OPH_DiskonAll, dbo.DLK_T_OrPemH.OPH_PPn, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_OrPemH.OPH_MetPem, dbo.DLK_T_OrPemH.OPH_appID, dbo.DLK_T_OrPemD.OPD_OPHID,dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemD.OPD_QtySatuan, dbo.DLK_T_OrPemD.OPD_Disc1, dbo.DLK_T_OrPemD.OPD_JenisSat, dbo.DLK_T_OrPemD.OPD_Harga, dbo.DLK_T_OrPemD.OPD_Disc2, dbo.DLK_T_OrPemD.OPD_AktifYN FROM dbo.DLK_T_OrPemH INNER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = dbo.DLK_T_OrPemD.OPD_OPHID where DLK_T_OrPemH.OPH_ID = '"& id &"' AND DLK_T_OrPemH.OPH_AktifYN = 'Y' AND DLK_T_OrPemD.OPD_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    ' agen
    data_cmd.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set agen = data_cmd.execute
    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Prosess Purches")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM UPDATE PURCHES ORDER</h3>
        </div>
    </div>
    <form action="purc_u.asp?id=<%= id %>" method="post" id="formpur1">
        <input type="hidden" id="id" name="id" value="<%= data("OPH_ID") %>" readonly>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="agen" name="agen" required>
                    <option value="<%= data("OPH_AgenID") %>"><% call getAgen(data("OPH_AgenID"),"p") %></option>
                    <% do while not agen.eof %>
                    <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
                    <% 
                    agen.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= data("OPH_Date") %>" onfocus="(this.type='date')" required>
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
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("OPH_JTDAte") <> "1900-01-01"  then%> value="<%= data("OPH_JTDate") %>" <% end if %> onfocus="(this.type='date')">
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
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("OPH_ppn") %>">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OPH_Keterangan") %>">
            </div>
        </div>

        <!-- detail barang -->
        <div class="row mb-3 mt-4">
            <div class="col-lg text-center mb-2 mt-2">
                <h5 style="background-color:blue;display:inline-block;padding:10px;color:white;border-radius:10px;letter-spacing: 5px;">DETAIL BARANG</h5>
            </div>
        </div>
        <% do while not data.eof %>
        <div class="row dpurce">
        <div class="col-lg-12 mb-3 mt-3">
            <div class="row">
                <div class="col-sm-2">
                    <label for="itempo" class="col-form-label">Jenis Barang</label>
                </div>
                <div class="col-sm-10 mb-3">
                    <input type="hidden" id="olditempo" class="form-control" name="olditempo" autocomplete="off" maxlength="30" value="<%= data("OPD_Item") %>" required>
                    <input type="text" id="itempo" class="form-control" name="itempo" autocomplete="off" maxlength="30" value="<%= data("OPD_Item") %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="qttypo" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="hidden" id="oldqttypo" class="form-control" name="oldqttypo" value="<%= data("OPD_qtysatuan") %>" required>
                    <input type="number" id="qttypo" class="form-control" name="qttypo" value="<%= data("OPD_qtysatuan") %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="hargapo" class="col-form-label">Harga</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="hidden" id="oldhargapo" class="form-control" name="oldhargapo" value="<%= data("OPD_Harga") %>" required>
                    <input type="number" id="hargapo" class="form-control" name="hargapo" value="<%= data("OPD_Harga") %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="satuan" class="col-form-label">Satuan Barang</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="hidden" id="oldsatuanpo" class="form-control" name="oldsatuanpo" value="<%= data("OPD_Jenissat") %>" required>
                    
                    <select class="form-select" aria-label="Default select example" name="satuanpo" id="satuanpo" required> 
                        <option value="<%= data("OPD_Jenissat") %>"><% call getSatBerat(data("OPD_Jenissat")) %></option>
                        <% do while not psatuan.eof %>
                        <option value="<%= psatuan("sat_ID") %>"><%= psatuan("sat_nama") %></option>
                        <%  
                        psatuan.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="disc1" class="col-form-label">Disc1</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="hidden" id="olddisc1" class="form-control" name="olddisc1" value="<%= data("OPD_Disc1") %>">
                    <input type="number" id="disc1" class="form-control" name="disc1" value="<%= data("OPD_Disc1") %>">
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="disc2" class="col-form-label">Disc2</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="hidden" id="olddisc2" class="form-control" name="olddisc2" value="<%= data("OPD_Disc2") %>">
                    <input type="number" id="disc2" class="form-control" name="disc2" value="<%= data("OPD_Disc2") %>">
                </div>
            </div>
            <div class="row">
                <div class="col-lg">
                    <hr>
                </div>
            </div>
        </div>
        </div>
        <% 
        data.movenext
        loop
        %>
        <!-- button add barang -->
        <div class="row mb-3">
            <div class="col-sm-12">
                <button type="button" class="btn btn-secondary justify-content-sm-start additempo" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-plus-lg"></i> item</button>
                <button type="button" class="btn btn-secondary justify-content-sm-end minitempo" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-dash"></i> item</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="purcesDetail.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call updatePurce()
        if value = 1 then
            call alert("PURCHES ORDER", "berhasil di update", "success","purcesDetail.asp") 
        elseif value = 2 then
            call alert("PURCHES ORDER", "tidak terdaftar", "warning","purcesDetail.asp")
        else
            value = 0
        end if
    end if
    call footer()
%>