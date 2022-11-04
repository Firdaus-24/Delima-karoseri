<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_delBarang.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    ' get cabang
    data_cmd.CommandText = "SELECT AgenID, AgenName FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"

    set cabang = data_cmd.execute
    ' getsatuan
    data_cmd.CommandText = "SELECT dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_InvPemD.IPD_JenisSat FROM dbo.DLK_M_SatuanBarang INNER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_InvPemD.IPD_JenisSat GROUP BY dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_InvPemD.IPD_JenisSat ORDER BY Sat_Nama ASC"

    set satuan = data_cmd.execute

    ' get user
    data_cmd.CommandText = "SELECT userID, username FROM DLK_M_WebLogin WHERE userAktifYN = 'Y' ORDER BY userName ASC"

    set users = data_cmd.execute

    call header("Form Barang Rusak")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>FORM BARANG RUSAK</h3>
        </div>
    </div>
    <form action="klaim_add.asp" method="post" id="formDelBarang">
        <div class="row">
            <div class="col-sm-2">
                <label for="cabang">Cabang</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="cbgDelBarang" name="cabang" required>
                    <option value="">Pilih</option>
                    <% do while not cabang.eof %>
                    <option value="<%= cabang("AgenID") %>"><%= cabang("AgenName") %></option>
                    <% 
                    cabang.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-sm-2">
                <label for="tgl">Tanggal</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" class="form-control" id="tgl" name="tgl" value="<%= Cdate(date) %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="brg">Barang</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" class="form-control" id="delbrg" name="lbrg" autocomplete="off" required >
                <input type="hidden" class="form-control" id="delbrgid" name="brg" autocomplete="off" required >
            </div>
            <div class="col-sm-2">
                <label for="qty">Quantity</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="number" autocomplete="off" class="form-control" id="qty" name="qty" required>
                <input type="hidden" autocomplete="off" class="form-control" id="qtystokdelbrg" name="qtystokdelbrg" required>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 TblDelBarang" >
            
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="satuan">satuan</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="satuan" name="satuan" required>
                    <option value="">Pilih</option>
                    <% do while not satuan.eof %>
                    <option value="<%= satuan("sat_id") %>"><%= satuan("sat_Nama") %></option>
                    <% 
                    satuan.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-sm-2">
                <label for="ket">keterangan</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" class="form-control" id="ket" name="ket" autocomplete="off" maxlength="50" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="acc1">acc 1</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="acc1" name="acc1" required>
                    <option value="">Pilih</option>
                    <% do while not users.eof %>
                    <option value="<%= users("userid") %>"><%= users("userName") %></option>
                    <% 
                    users.movenext
                    loop
                    users.movefirst
                    %>
                </select>
            </div>
            <div class="col-sm-2">
                <label for="acc2">acc 2</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="acc2" name="acc2" required>
                    <option value="">Pilih</option>
                    <% do while not users.eof %>
                    <option value="<%= users("userid") %>"><%= users("userName") %></option>
                    <% 
                    users.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12 mb-3 mt-3 text-center">
                <button type="button" class="btn btn-danger" onclick="window.location.href='index.asp'">Kembali</button>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>  
        </div>
    </form>
</div>  

<% 
    If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
        call tambahDelbarang()
    end if
    call footer()
%>
