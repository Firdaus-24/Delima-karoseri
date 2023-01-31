<!--#include file="../init.asp"-->
<% 
    agen = trim(Request.form("agen"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string    

    data_cmd.commandText = "SELECT dbo.DLK_M_BOMH.BMID, dbo.DLK_M_BOMH.BMBrgID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_BOMH.BMAktifYN FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMH.BMBrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_BOMH.BMID = LEFT(dbo.DLK_M_BOMD.BMDBMID, 12) WHERE (dbo.DLK_M_BOMD.BMDBMID IS NOT NULL) AND (dbo.DLK_M_BOMH.BMAgenID = '"& agen &"') GROUP BY dbo.DLK_M_BOMH.BMID, dbo.DLK_M_BOMH.BMBrgID, dbo.DLK_M_Barang.Brg_Nama,dbo.DLK_M_BOMH.BMAktifYN HAVING (dbo.DLK_M_BOMH.BMAktifYN = 'Y') ORDER BY Brg_Nama"

    set produk = data_cmd.execute

%>
    <select class="form-select" aria-label="Default select example" name="produk" id="produk" required> 
        <option value="">Pilih</option>
        <% do while not produk.eof %>
            <option value="<%= produk("BMID") %>"><%= produk("BMID")&" - "&produk("Brg_Nama") %></option>
        <% 
        produk.movenext
        loop
        %>
    </select>
