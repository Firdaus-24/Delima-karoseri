<!--#include file="../../init.asp"-->
<% 
    ' Response.ContentType = "application/vnd.ms-excel"
    ' Response.AddHeader "content-disposition", "filename=Purchase Order "& Request.QueryString("id")&" .xls"

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_OrPemH.*, dbo.DLK_M_Vendor.Ven_alamat, dbo.DLK_M_Vendor.Ven_phone, dbo.DLK_M_Vendor.Ven_Email FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_OrPemH.OPH_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID WHERE dbo.DLK_T_OrPemH.OPH_ID = '"& id &"' AND dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y' " 

    set data = data_cmd.execute

    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_OrPemD.*, dbo.DLK_M_Barang.Brg_Id FROM dbo.DLK_T_OrPemD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_OrPemD.OPD_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_OrPemD.OPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE LEFT(dbo.DLK_T_OrPemD.OPD_OPHID,13) = '"& data("OPH_ID") &"' ORDER BY Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Purcase Order")
    
%>
<style>
    body{
        padding:10px;
    }
    .gambar{
        height: 100px;
        width: 100%;
    }
    .gambar img{
        width: 100%;
        height: 100px;
        object-fit: contain;
    }
    #cdetail > * > tr > *  {
        border: 1px solid black;
        padding:5px;
    }

    #cdetail{
        width:100%;
        font-size:12px;
        border-collapse: collapse;
    }
    #cdetail2 > * > tr > *  {
        border: 1px solid black;
        padding:5px;
    }

    #cdetail2{
        width:30%;
        font-size:12px;
        border-collapse: collapse;
        text-align: center;
        right:10px;
        position:absolute;
    }
</style>
    <div class="row gambar">
        <div class="col">
            <img src="<%= url %>/public/img/PT.png" alt="delimalogo">
        </div>
    </div>
    <table width="100%" style="font-size:12px">
        <tr>
            <td>
                &nbsp
            </td>
        </tr>
        <tr>
            <td>No</td>
            <td>
                : <%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %>
            </td>
            <td>Cabang</td>
            <td>
                : <%= data("agenName") %>
            </td>
        </tr>
        <tr>
            <td>No Memo</td>
            <td>
                : <%= left(data("OPH_memoID"),4) %>/<%=mid(data("OPH_memoId"),5,3) %>-<% call getAgen(mid(data("OPH_memoID"),8,3),"") %>/<%= mid(data("OPH_memoID"),11,4) %>/<%= right(data("OPH_memoID"),3) %>
            </td>
            <td>Tanggal</td>
            <td>
                : <%= Cdate(data("OPH_Date")) %>
            </td>
        </tr>
        <tr>
            <td>Vendor</td>
            <td>
                : <%= data("Ven_Nama") %>
            </td>
            <td>Tanggal Jatuh Tempo</td>
            <td>
                : <% if Cdate(data("OPH_JTDate")) <> Cdate("01/01/1900") then%><%= Cdate(data("OPH_JTDate")) %><% end if %>
            </td>
        </tr>
        <tr>
            <td>Phone</td>
            <td>
                : <%= data("Ven_Phone") %>
            </td>
            <td>Keterangan</td>
            <td>
                : <%= data("OPH_Keterangan") %>
            </td>
        </tr>
        <tr>
            <td>Email</td>
            <td>
                : <%= data("Ven_Email") %>
            </td>
        </tr>
        <tr>
            <td>&nbsp</td>
        </tr>
         <tr>
            <td colspan="7" style="text-align:center;margin-top:5px;margin-bottom:5px;">
                <h4>PURCHASE ORDER</h4>
            </td>
        </tr>
    </table>
    <table width="100%" style="font-size:12px" id="cdetail">
        <tr>
            <th scope="col">No</th>
            <th scope="col">Item</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Diskon1</th>
            <th scope="col">Diskon2</th>
            <th scope="col">Jumlah</th>
        </tr>
        <% 
        no = 0
        grantotal = 0
        do while not ddata.eof 
        no = no +1
        ' cek total harga 
        jml = ddata("OPD_QtySatuan") * ddata("OPD_Harga")
        ' cek diskon peritem
        if ddata("OPD_Disc1") <> 0 and ddata("OPD_Disc2") <> 0  then
            dis1 = (ddata("OPD_Disc1")/100) * ddata("OPD_Harga")
            dis2 = (ddata("OPD_Disc2")/100) * ddata("OPD_Harga")
        elseif ddata("OPD_Disc1") <> 0 then
            dis1 = (ddata("OPD_Disc1")/100) * ddata("OPD_Harga")
        elseIf ddata("OPD_Disc2") <> 0 then
            dis2 = (ddata("OPD_Disc2")/100) * ddata("OPD_Harga")
        else    
            dis1 = 0
            dis2 = 0
        end if
        ' total dikon peritem
        hargadiskon = ddata("OPD_Harga") - dis1 - dis2
        realharga = hargadiskon * ddata("OPD_QtySatuan")  

        grantotal = grantotal + realharga

        %>
            <tr>
                <td>
                    <%= no %>
                </td>
                <td>
                    <%= ddata("Brg_Nama") %>
                </td>
                <td>
                    <%= ddata("OPD_QtySatuan") %>
                </td>
                <td>
                    <% call getSatBerat(ddata("OPD_JenisSat")) %>
                </td>
                <td>
                    <%= replace(formatCurrency(ddata("OPD_Harga")),"$","") %>
                </td>
                <td>
                    <%= ddata("OPD_Disc1") %>%
                </td>
                <td>
                    <%= ddata("OPD_Disc2") %>%
                </td>
                <td>
                    <%= replace(formatCurrency(realharga),"$","") %>
                </td>
            </tr>
        <% 
        ddata.movenext
        loop
        ' cek diskonall
        if data("OPH_diskonall") <> 0 OR data("OPH_Diskonall") <> "" then
            diskonall = Round((data("OPH_Diskonall")/100) * grantotal)
        else
            diskonall = 0
        end if

        ' hitung ppn
        if data("OPH_ppn") <> 0 OR data("OPH_ppn") <> "" then
            ppn = Round((data("OPH_ppn")/100) * grantotal)
        else
            ppn = 0
        end if
        realgrantotal = (grantotal - diskonall) + ppn
        %>
        
        <tr>
            <th colspan="6">Diskon All</th>
            <th><%= data("OPH_Diskonall") %>%</th>
            <th><%= replace(formatCurrency(diskonall),"$","") %></th>
        </tr>
        <tr>
            <th colspan="6">ppn</th>
            <th><%= data("OPH_PPN") %>%</th>
            <th><%= replace(formatCurrency(ppn),"$","") %></th>
        </tr>
        <tr>
            <th colspan="7">Total Pembayaran</th>
            <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
        </tr>
    </table>
<% 
    call footer()
%>