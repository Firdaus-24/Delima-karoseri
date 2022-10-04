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
                    <label for="tgl" class="col-form-label">Tanggal</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Date() %>" onfocus="(this.type='date')" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="divisi" class="col-form-label">Divisi</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <select class="form-select" aria-label="Default select example" name="divisi" id="pbdivisi" required> 
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
            <div class="row mb-3">
                <div class="col-sm-3">
                    <label for="deputuhan" class="col-form-label">Departement</label>
                </div>
                <div class="col-sm-9  deplama">
                    <select class="form-select" aria-label="Default select example" name="ldep" id="ldep" > 
                        <option value="" readonly disabled>Pilih Divisi dahulu</option>
                    </select>
                </div>
                <div class="col-sm-9  depbaru">
                    <!-- kontent departement -->
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="keterangan" class="col-form-label">Keterangan</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" required>
                </div>
            </div>
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
end if
call footer() 
%>