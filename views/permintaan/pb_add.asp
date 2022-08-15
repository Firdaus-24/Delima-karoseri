<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_permintaanb.asp"-->
<% 
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string
    ' get barang
    data.commandText = "SELECT Brg_ID, Brg_Nama FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' ORDER BY Brg_Nama ASC"
    set getBarang = data.execute
    ' get agen / cabang
    data.commandText = "SELECT AgenName, AgenID FROM DLK_M_Barang LEFT OUTER JOIN GLB_M_Agen ON left(DLK_M_Barang.Brg_ID,3) = GLB_M_Agen.AgenID WHERE agenAktifYN = 'Y' AND DLK_M_Barang.Brg_AktifYN = 'Y' GROUP BY AgenName, AgenID ORDER BY AgenName ASC"
    set pcabang = data.execute    
    ' get kebutuhan
    data.commandText = "SELECT KebNama, KebID FROM DLK_M_Kebutuhan WHERE KebAktifYN = 'Y' ORDER BY KebNama ASC"
    set pkebutuhan = data.execute    
    ' get satuan
    data.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data.execute    
    ' get divisi
    data.commandText = "SELECT DivNama, DivID FROM DLK_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
    set pdivisi = data.execute    

    call header("From Permintaan Barang") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM PERMINTAAN BARANG</h3>
        </div>
    </div>
    <form action="pb_add.asp" method="post" id="formpbarang">
    <div class="row">
         <div class="col-lg-12">
            <div class="row">
                <div class="col-sm-3">
                    <label for="tgl" class="col-form-label">Tanggal PO</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="date" id="tgl" class="form-control" name="tgl" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="divisi" class="col-form-label">Divisi</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <select class="form-select" aria-label="Default select example" name="divisi" id="divisi" required> 
                        <option value="">Pilih</option>
                        <% do while not pdivisi.eof %>
                        <option value="<%= pdivisi("divId") %>"><%= pdivisi("divNama") %></option>
                        <%  
                        pdivisi.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="agen" class="col-form-label">Cabang / Agen</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <select class="form-select" aria-label="Default select example" name="agen" id="agenpb" required> 
                        <option value="">Pilih</option>
                        <% do while not pcabang.eof %>
                        <option value="<%= pcabang("agenID") %>"><%= pcabang("agenNAme") %></option>
                        <%  
                        pcabang.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="kebutuhan" class="col-form-label">Kebutuhan Untuk</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <select class="form-select" aria-label="Default select example" name="kebutuhan" id="kebutuhan" required> 
                        <option value="">Pilih</option>
                        <% do while not pkebutuhan.eof %>
                            <option value="<%= pkebutuhan("KebID") %>"><%= pkebutuhan("KebNama") %></option>
                        <% 
                        pkebutuhan.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
        </div>
    </div>
     <!-- detail barang -->
    <div class="row mb-3 mt-4">
            <div class="col-lg text-center mb-2 mt-2">
                <h5 style="background-color:blue;display:inline-block;padding:10px;color:white;border-radius:10px;letter-spacing: 5px;">DETAIL BARANG</h5>
            </div>
        </div>
    <div class="row dpermintaan">
        <div class="col-lg-12 mb-3">
            <div class="row">
                <div class="col-sm-3">
                    <label for="brg" class="col-form-label">Jenis Barang</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <div class="pbviewsal">
                        <select class="form-select" aria-label="Default select example" name="tbrg" id="tbrg"> 
                            <option value disabled selected>Pilih Cabang Dahulu</option>
                        </select>
                    </div>
                    <div class="pbviewhasil"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="spect" class="col-form-label">Sepesification</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="spect" class="form-control" name="spect" autocomplete="off" maxlength="50" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="qtty" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="harga" class="col-form-label">Harga Satuan</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="number" id="pbharga" class="form-control" name="harga" autocomplete="off" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="satuan" class="col-form-label">Satuan Barang</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <select class="form-select" aria-label="Default select example" name="satuan" id="satuan" required> 
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
                    <label for="ket" class="col-form-label">Keterangan</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <div class="form-floating">
                        <textarea class="form-control" placeholder="detail" id="ket" name="ket" autocomplete="off" maxlength="50"></textarea>
                        <label for="ket">Detail</label>
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
            <button type="button" class="btn btn-secondary justify-content-sm-start addBrg" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-plus-lg"></i> item</button>
            <button type="button" class="btn btn-secondary justify-content-sm-end minBrg" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-dash"></i> item</button>
        </div>
    </div>
    <!-- end button -->
    <div class="row">
        <div class="col-lg-12 text-center">
            <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Tambah</button>
        </div>
    </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahPbarang()
    if value = 1 then
        call alert("PERMINTAAN BARANG", "berhasil di tambahkan", "success","index.asp") 
    elseif value = 2 then
        call alert("PERMINTAAN BARANG", "sudah terdaftar", "warning","index.asp")
    else
        value = 0
    end if
end if
call footer() 
%>