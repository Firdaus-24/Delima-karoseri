<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Approvepbarang.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT SUM(dbo.DLK_T_Memo_D.memoHarga * dbo.DLK_T_Memo_D.memoQtty) As tharga FROM dbo.DLK_T_Memo_H INNER JOIN dbo.DLK_T_Memo_D ON dbo.DLK_T_Memo_H.memoID = LEFT(dbo.DLK_T_Memo_D.memoID, 17) WHERE (dbo.DLK_T_Memo_H.memoID = '"& id &"')"
    
    set ddata = data_cmd.execute

    call header("Pencairan Dana") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>APPROVE DANA PERMINTAAN BARANG</h3>
        </div>
    </div>
    <form action="approvepbarang.asp?id=<%= id %>" method="post" id="formApprove">
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
                        <input type="date" id="tgl" class="form-control" name="tgl" autocomplete="off" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-3">
                        <label for="dana" class="col-form-label">Approve Dana</label>
                    </div>
                    <div class="col-sm-3 mb-3">
                        <input type="number" id="dana" class="form-control" name="dana" autocomplete="off" required>
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
                            <textarea class="form-control" id="keterangan" name="keterangan" style="height: 100px" autocomplete="off" maxlength="50" required></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="index.asp" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>    
    </form>
</div>

<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahAppPermintaan()
        if value = 1 then
            call alert("PENCAIRAN DANA PERMINTAAN BARANG", "berhasil di tambahkan", "success","approvepbarang.asp?id="&id) 
        elseif value = 2 then
            call alert("PENCAIRAN DANA PERMINTAAN BARANG", "sudah terdaftar", "warning","approvepbarang.asp?id="&id)
        else
            value = 0
        end if
    end if
    call footer() 
%>