<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

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
            <h3>FORM TAMBAH PURCHES ORDER</h3>
        </div>
    </div>
    <form action="purc_add.asp" method="post" id="formpur">
        <input type="hidden" id="appid" name="appid" value="<%= id %>">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-9 mb-3">
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
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-9 mb-3">
                <input type="date" id="tgl" name="tgl" class="form-control" required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-9 mb-3">
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
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-9 mb-3">
                <input type="date" id="tgljt" name="tgljt" class="form-control">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-9 mb-3">
                <select class="form-select" aria-label="Default select example" id="metpem" name="metpem" required>
                    <option value="">Pilih</option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
                </select>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-9 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-9 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-9 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50">
            </div>
        </div>
        <div class="row dpurce">
        <div class="col-lg-12 mb-3">
            <div class="row">
                <div class="col-sm-3">
                    <label for="itempo" class="col-form-label">Jenis Barang</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="itempo" class="form-control" name="itempo" autocomplete="off" maxlength="30" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="qttypo" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="number" id="qttypo" class="form-control" name="qttypo" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="hargapo" class="col-form-label">Harga</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="number" id="hargapo" class="form-control" name="hargapo" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="satuan" class="col-form-label">Satuan Barang</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <select class="form-select" aria-label="Default select example" name="satuanpo" id="satuanpo" required> 
                        <option value="">Pilih</option>
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
                <div class="col-sm-3">
                    <label for="dket" class="col-form-label">Keterangan</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <div class="form-floating">
                        <textarea class="form-control" placeholder="detail" id="dket" name="dket" autocomplete="off" maxlength="50"></textarea>
                        <label for="dket">Detail</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg">
                    <hr>
                </div>
            </div>
        </div>
    </div>
    <!-- button add barang -->
    <div class="row mb-3">
        <div class="col-sm-12">
            <button type="button" class="btn btn-secondary justify-content-sm-start additempo" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-plus-lg"></i> item</button>
            <button type="button" class="btn btn-secondary justify-content-sm-end minitempo" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-dash"></i> item</button>
        </div>
    </div>
        <!-- value get data
        <div class="value" style="display:none">
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valitem" name="valitem" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valqtty" name="valqtty" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valharga" name="valharga" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valsatuan" name="valsatuan" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valdisc1" name="valdisc1" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valdisc2" name="valdisc2" class="form-control">
                </div>
            </div>
        </div>
         -->
        <!-- end getdata -->
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>

            </div>
        </div>
    </form>
</div>  


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahPurce()
        if value = 1 then
            call alert("PURCHES ORDER", "berhasil di tambahkan", "success","index.asp") 
        elseif value = 2 then
            call alert("PURCHES ORDER", "sudah terdaftar", "warning","index.asp")
        else
            value = 0
        end if
    end if
    call footer()
%>