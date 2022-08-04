<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Approvepbarang.asp"-->

<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_AppPermintaan WHERE appID = '"& id &"'"

    set data = data_cmd.execute

    ' tpermintaan
    data_cmd.commandText = "SELECT SUM(dbo.DLK_T_Memo_D.memoHarga * dbo.DLK_T_Memo_D.memoQtty) As tharga FROM dbo.DLK_T_Memo_H INNER JOIN dbo.DLK_T_Memo_D ON dbo.DLK_T_Memo_H.memoID = LEFT(dbo.DLK_T_Memo_D.memoID, 17) WHERE (dbo.DLK_T_Memo_H.memoID = '"& data("appMemoID") &"') AND DLK_T_Memo_H.memoAktifYN = 'Y' AND DLK_T_Memo_D.memoAktifYn = 'Y'"
    
    set ddata = data_cmd.execute

    call header("Update Anggaran")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>FORM UPDATE ANGGARAN MEMO PERMINTAAN</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
        <form action="dapp_u.asp?id=<%= id %>" method="post" id="formApprove">
            <div class="row">
                <div class="col-lg-12 mb-3">
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="no" class="col-form-label">Nomor Order</label>
                        </div>
                        <div class="col-sm-3 mb-3">
                            <input type="text" id="no" class="form-control" name="no" autocomplete="off" value="<%= id %>" readonly>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="tgl" class="col-form-label">Tanggal</label>
                        </div>
                        <div class="col-sm-3 mb-3">
                            <input type="text" id="tgl" class="form-control" name="tgl" autocomplete="off" onfocus="(this.type='date')" value="<%= data("appTgl") %>" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="dana" class="col-form-label">Approve Dana</label>
                        </div>
                        <div class="col-sm-3 mb-3">
                            <input type="text" id="dana" class="form-control" name="dana" autocomplete="off" value="<%= replace(formatCurrency(data("appDana")),"$","") %>" required>
                        </div>
                        <div class="col-sm-2">
                            <label for="ajuan" class="col-form-label">Dana Yang Diajukan</label>
                        </div>
                        <div class="col-sm-4 mb-3">
                            <input type="text" id="ajuan" class="form-control" name="ajuan" autocomplete="off" value="<%= replace(formatCurrency(ddata("tharga")),"$","") %>" readonly>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="keterangan" class="col-form-label">Keterangan</label>
                        </div>
                        <div class="col-sm-9 mb-3">
                            <div class="form-floating">
                                <textarea class="form-control" id="keterangan" name="keterangan" style="height: 100px" autocomplete="off" maxlength="50" required><%= data("appKeterangan") %></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12 text-center">
                    <a href="dapppermintaan.asp" class="btn btn-danger">Kembali</a>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </div>    
        </form>
        </div>
    </div>
</div>

<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call updateAppPermintaan()
        if value = 1 then
            call alert("PENCAIRAN DANA PERMINTAAN BARANG", "berhasil dirubah", "success","dapppermintaan.asp") 
        elseif value = 2 then
            call alert("PENCAIRAN DANA PERMINTAAN BARANG", "tidak terdaftar", "warning","dapppermintaan.asp")
        else
            value = 0
        end if
    end if
    call footer()
%>