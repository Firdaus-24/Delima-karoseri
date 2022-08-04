<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_permintaanb.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string

    ' get data master header
    data.commandText = "SELECT * FROM DLK_T_Memo_H WHERE memoID = '"& id &"' AND memoAktifYN = 'Y'"
    set mdata = data.execute

    ' get agen / cabang
    data.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE agenAktifYN = 'Y' ORDER BY AgenName ASC"
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
            <h3>FORM UPDATE PERMINTAAN BARANG</h3>
        </div>
    </div>
    <form action="pb_u.asp?id=<%= id %>" method="post" id="formpbarang">
    <input type="hidden" id="id" class="form-control" name="id" value="<%= mdata("memoId") %>">
    <div class="row">
         <div class="col-lg-12">
            <div class="row">
                <div class="col-sm-3">
                    <label for="tgl" class="col-form-label">Tanggal PO</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="text" id="tgl" class="form-control" name="tgl" value="<%= mdata("memoTgl") %>" onfocus="(this.type='date')"  required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="divisi" class="col-form-label">Divisi</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <select class="form-select" aria-label="Default select example" name="divisi" id="divisi" required> 
                        <option value="<%= mdata("memoDivID") %>"><% call getDivisi(mdata("memoDivID")) %></option>
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
                    <select class="form-select" aria-label="Default select example" name="agen" id="agen" required> 
                        <option value="<%= mdata("memoAgenID") %>"><% call getAgen(mdata("memoAgenID"),"p") %></option>
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
                    <label for="kebutuhan" class="col-form-label">Kebutuhan untuk</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <select class="form-select" aria-label="Default select example" name="kebutuhan" id="kebutuhan" required> 
                        <option value="<%= mdata("memoKebID") %>"><% call getKebutuhan(mdata("memoKebID"),"P") %></option>
                        <% do while not pkebutuhan.eof %>
                        <option value="<%= pkebutuhan("kebID") %>"><%= pkebutuhan("kebnama") %></option>
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
    <% 
     ' get data detail
    data.commandText = "SELECT dbo.DLK_T_Memo_D.memoID, dbo.DLK_T_Memo_D.memoItem, dbo.DLK_T_Memo_D.memoSpect, dbo.DLK_T_Memo_D.memoQtty, dbo.DLK_T_Memo_D.memoSatuan, dbo.DLK_T_Memo_D.memoHarga, dbo.DLK_T_Memo_D.memoKeterangan, dbo.DLK_T_Memo_D.memoAktifYN, dbo.DLK_T_Memo_H.memoID AS Expr1 FROM dbo.DLK_T_Memo_H INNER JOIN dbo.DLK_T_Memo_D ON dbo.DLK_T_Memo_H.memoID = LEFT(dbo.DLK_T_Memo_D.memoID, 17) WHERE (dbo.DLK_T_Memo_H.memoID = '"& mdata("memoId") &"') AND dbo.DLK_T_Memo_D.memoAktifYN = 'Y' ORDER BY memoItem ASC"
    set ddata = data.execute

    do while not ddata.eof
    %>
    <div class="row dpermintaan">
        <input type="hidden" id="did" class="form-control" name="did" autocomplete="off" maxlength="30" value="<%= ddata("memoId") %>">
        <div class="col-lg-12 mb-3">
            <div class="row">
                <div class="col-sm-3">
                    <label for="brg" class="col-form-label">Jenis Barang</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="brg" class="form-control" name="brg" autocomplete="off" maxlength="30" value="<%= ddata("memoItem") %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="spect" class="col-form-label">Sepesification</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <input type="text" id="spect" class="form-control" name="spect" autocomplete="off" maxlength="50" value="<%= ddata("memospect") %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="qtty" class="col-form-label">Quantity</label>
                </div>
                <div class="col-sm-3 mb-3">
                    <input type="number" id="qtty" class="form-control" name="qtty" value="<%= ddata("memoQtty") %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="harga" class="col-form-label">Harga Satuan</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <input type="number" id="pbharga" class="form-control" name="harga" value="<%= ddata("memoHarga") %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <label for="satuan" class="col-form-label">Satuan Barang</label>
                </div>
                <div class="col-sm-4 mb-3">
                    <select class="form-select" aria-label="Default select example" name="satuan" id="satuan" required> 
                        <option value="<%= ddata("memoSatuan") %>"><% call getSatBerat(ddata("memoSatuan")) %></option>
                        <% do while not psatuan.eof %>
                        <option value="<%= psatuan("sat_ID") %>"><%= psatuan("sat_nama") %></option>
                        <%  
                        psatuan.movenext
                        loop
                        psatuan.movefirst
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
                        <textarea class="form-control" placeholder="detail" id="ket" name="ket" autocomplete="off" maxlength="50"><%= ddata("memoKeterangan") %></textarea>
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
    <% 
    ddata.movenext
    loop
    %>
    <!-- button add barang -->
    <div class="row mb-3">
        <div class="col-sm-12 mb-3">
            <button type="button" class="btn btn-secondary justify-content-sm-start addBrg" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-plus-lg"></i> item</button>
            <button type="button" class="btn btn-secondary justify-content-sm-end minBrg" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;"><i class="bi bi-dash"></i> item</button>
        </div>
    </div>
    <!-- end button -->
    <div class="row">
        <div class="col-lg-12 text-center">
            <a href="detailpb.asp?id=<%= id %>" class="btn btn-danger">Kembali</a>
            <button type="submit" class="btn btn-primary">UPDATE</button>
        </div>
    </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call updateUPbarang()
    if value = 1 then
        call alert("PERMINTAAN BARANG", "berhasil di update", "success","p_barang.asp") 
    elseif value = 2 then
        call alert("PERMINTAAN BARANG", "tidak terdaftar", "warning","p_barang.asp")
    else
        value = 0
    end if
end if
call footer() 
%>