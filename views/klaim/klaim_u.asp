<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_delBarang.asp"-->
<% 
    if session("INV3B") = false then
        Response.Redirect("../index.asp")
    end if

    id = trim(Request.QueryString("id")) 

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    ' get master data
    data_cmd.CommandText = "SELECT dbo.DLK_T_DelBarang.DB_Acc2, dbo.DLK_M_WebLogin.UserName, DLK_M_WebLogin_1.UserName AS acc2, dbo.DLK_T_DelBarang.DB_Acc1, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_DelBarang.DB_IPDIPHID, dbo.DLK_T_DelBarang.DB_QtySatuan, dbo.DLK_T_DelBarang.DB_JenisSat, dbo.DLK_M_Barang.Brg_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_DelBarang.DB_ID, dbo.DLK_T_DelBarang.DB_Date, dbo.DLK_T_DelBarang.DB_Keterangan, dbo.DLK_T_DelBarang.DB_AktifYN, dbo.DLK_T_DelBarang.DB_AgenID, dbo.DLK_T_DelBarang.DB_Item FROM dbo.GLB_M_Agen RIGHT OUTER JOIN dbo.DLK_T_DelBarang ON dbo.GLB_M_Agen.AgenID = dbo.DLK_T_DelBarang.DB_AgenID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_DelBarang.DB_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_WebLogin AS DLK_M_WebLogin_1 ON dbo.DLK_T_DelBarang.DB_Acc2 = DLK_M_WebLogin_1.UserID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_DelBarang.DB_Acc1 = dbo.DLK_M_WebLogin.UserID WHERE (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') AND (dbo.DLK_T_DelBarang.DB_ID = '"& id &"')"
    set data = data_cmd.execute
    ' get cabang
    data_cmd.CommandText = "SELECT AgenID, AgenName FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"

    set cabang = data_cmd.execute
    ' getsatuan
    data_cmd.CommandText = "SELECT dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_InvPemD.IPD_JenisSat FROM dbo.DLK_M_SatuanBarang INNER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_InvPemD.IPD_JenisSat GROUP BY dbo.DLK_M_SatuanBarang.Sat_ID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_InvPemD.IPD_JenisSat ORDER BY Sat_Nama ASC"

    set satuan = data_cmd.execute

    ' get user
    data_cmd.CommandText = "SELECT userID, username FROM DLK_M_WebLogin WHERE userAktifYN = 'Y' ORDER BY userName ASC"

    set users = data_cmd.execute

    ' set stok
    ' get pembelian 
    data_cmd.commandTExt = "SELECT ISNULL(SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan),0) AS jbeli, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_IphID FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) GROUP BY dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_IphID HAVING (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("DB_AgenID") &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = '"& data("DB_Item") &"')"
    ' response.write data_cmd.commandText & "<br>"
    set jbeli = data_cmd.execute

    ' get penjualan 
    data_cmd.commandTExt = "SELECT ISNULL(SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan),0) AS jjual, dbo.DLK_T_InvJulD.IJD_IJHID, dbo.DLK_T_InvJulD.IJD_Item FROM dbo.DLK_T_InvJulH RIGHT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulH.IJH_ID = LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) GROUP BY dbo.DLK_T_InvJulD.IJD_IPDIPHID, dbo.DLK_T_InvJulH.IJH_agenID, dbo.DLK_T_InvJulH.IJH_AktifYN, dbo.DLK_T_InvJulD.IJD_IJHID, dbo.DLK_T_InvJulD.IJD_Item HAVING (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulH.IJH_agenID = '"& data("DB_AgenID") &"') AND (dbo.DLK_T_InvJulD.IJD_Item = '"& data("DB_Item") &"')"
    ' response.write data_cmd.commandText & "<br>"
    set jjual = data_cmd.execute

    if not jjual.eof then
        jual = Cint(jjual("jjual"))
    else 
        jual = 0
    end if

    ' get klaim barang
    data_cmd.commandTExt = "SELECT DB_Item, ISNULL(SUM(DB_QtySatuan),0) AS jklaim FROM dbo.DLK_T_DelBarang GROUP BY DB_AgenID, DB_Item, DB_AktifYN HAVING (DB_AktifYN = 'Y') AND (DB_AgenID = '"& data("DB_AgenID") &"') AND (DB_Item = '"& data("DB_Item") &"')"

    set jklaim = data_cmd.execute

    if not jklaim.eof then
        klaim = Cint(jklaim("jklaim"))
    else
        klaim = 0
    end if

    tstok = Cint(jbeli("jbeli")) - jual - klaim

    call header("Form Update Barang Rusak")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>FORM UPDATE BARANG RUSAK</h3>
        </div>
    </div>
    <form action="klaim_u.asp?id=<%= id %>" method="post" id="formDelBarang">
        <div class="row">
            <div class="col-sm-2">
                <label for="cabang">Cabang</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="cbgDelBarang" name="cabang" required>
                    <option value="<%= data("DB_agenID") %>"><%= data("AgenName") %></option>
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
                <input type="text" class="form-control" id="tgl" name="tgl" value="<%= Cdate(data("DB_Date")) %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="brg">Barang</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" class="form-control" id="delbrg" name="lbrg" autocomplete="off" value="<%= data("Brg_Nama") %>" required >
                <input type="hidden" class="form-control" id="delbrgid" name="brg" autocomplete="off" value="<%= data("DB_Item") %>" required >
            </div>
            <div class="col-sm-2">
                <label for="qty">Quantity</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="number" autocomplete="off" class="form-control" id="qty" name="qty" value="<%= data("DB_Qtysatuan") %>" required>
                <input type="hidden" autocomplete="off" class="form-control" id="qtystokdelbrg" name="qtystokdelbrg" value="<%= tstok %>" required>
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
                    <option value="<%= data("DB_JenisSat") %>"><%= data("Sat_Nama") %></option>
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
                <input type="text" class="form-control" id="ket" name="ket" autocomplete="off" maxlength="50" value="<%= data("DB_KEterangan") %>" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="acc1">acc 1</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="acc1" name="acc1" required>
                    <option value="<%= data("DB_ACc1") %>"><%= data("username") %></option>
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
                    <option value="<%= data("DB_Acc2") %>"><%= data("acc2") %></option>
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
        call updateDelbarang()
    end if
    call footer()
%>
