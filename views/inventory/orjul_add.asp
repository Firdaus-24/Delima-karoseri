<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orjul.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    ' agen
    data_cmd.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set agen = data_cmd.execute
    ' customer
    data_cmd.commandText = "SELECT custNama, custID FROM DLK_M_customer WHERE custAktifYN = 'Y' ORDER BY custNama ASC"
    set customer = data_cmd.execute

    ' get barang
    data_cmd.commandText = "SELECT Brg_ID, Brg_Nama FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' ORDER BY Brg_Nama ASC"
    set getBarang = data_cmd.execute

    call header("Prosess Orderjual")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH ORDER JUAL</h3>
        </div>
    </div>
    <form action="orjul_add.asp" method="post" id="formorjul">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="agen" name="agen" autofocusrequired>
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
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgl" name="tgl" class="form-control" required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="customer" class="col-form-label">customer</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="customer" name="customer" required>
                    <option value="">Pilih</option>
                    <% do while not customer.eof %>
                    <option value="<%= customer("custID") %>"><%= customer("custNama") %></option>
                    <% 
                    customer.movenext
                    loop
                    %>
                </select>
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
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="metpem" name="metpem" required>
                    <option value="">Pilih</option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control">
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
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
            </div>
        </div>

        <!-- detail barang -->
        <div class="row mb-3 mt-4">
            <div class="col-lg text-center mb-2 mt-2">
                <h5 style="background-color:blue;display:inline-block;padding:10px;color:white;border-radius:10px;letter-spacing: 5px;">DETAIL BARANG</h5>
            </div>
        </div>

        <div class="row dpurce">
        <div class="col-lg-12 mb-3 mt-3">
            <div class="row">
                <div class="col-sm-2">
                    <label for="itempo" class="col-form-label">Jenis Barang</label>
                </div>
                <div class="col-sm-10 mb-3">
                    <select class="form-select" aria-label="Default select example" name="itempo" id="itempo" required> 
                        <option value="">Pilih</option>
                        <% do while not getbarang.eof %>
                        <option value="<%= getbarang("Brg_ID") %>"><%= getbarang("Brg_nama") %></option>
                        <%  
                        getbarang.movenext
                        loop
                        getbarang.movefirst 
                        %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="qttypo" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="number" id="qttypo" class="form-control" name="qttypo" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="hargapo" class="col-form-label">Harga</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="number" id="hargapo" class="form-control" name="hargapo" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
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
                <div class="col-sm-2">
                    <label for="disc1" class="col-form-label">Disc1</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="number" id="disc1" class="form-control" name="disc1">
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <label for="disc2" class="col-form-label">Disc2</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="number" id="disc2" class="form-control" name="disc2">
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
        call tambahOrjul()
        if value = 1 then
            call alert("ORDER PENJUALAN", "berhasil di tambahkan", "success","outgoing.asp") 
        elseif value = 2 then
            call alert("ORDER PENJUALAN", "sudah terdaftar", "warning","outgoing.asp")
        else
            value = 0
        end if
    end if
    call footer()
%>