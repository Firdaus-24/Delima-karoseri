<!--#include file="../init.asp"-->
<% 
    cabang = trim(Request.form("cabang"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' filter po by memo
    data_cmd.commandText = "SELECT SUM(dbo.DLK_T_Memo_D.memoQtty) AS minta, dbo.DLK_T_Memo_H.memoID, DLK_T_Memo_H.memoTgl FROM dbo.DLK_T_Memo_D LEFT OUTER JOIN dbo.DLK_T_Memo_H ON LEFT(dbo.DLK_T_Memo_D.memoID, 17) = dbo.DLK_T_Memo_H.memoID WHERE (dbo.DLK_T_Memo_H.memoAgenID = '"& cabang &"') AND (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_Memo_H.memoApproveYN1 = 'Y') AND (dbo.DLK_T_Memo_H.memoApproveYN = 'Y') AND (dbo.DLK_T_Memo_H.memoPermintaan = 1 ) GROUP BY dbo.DLK_T_Memo_H.memoID, DLK_T_Memo_H.memoTgl ORDER BY DLK_T_Memo_H.memoTgl"
    ' response.write data_cmd.commandText & "<br>"
    set datamemo = data_cmd.execute
%>
    <select class="form-select" aria-label="Default select example" name="idmemo" id="idmemo" required>
    <option value="">Pilih</option>
    <% do while not datamemo.eof 
        data_cmd.commandText = "SELECT SUM(dbo.DLK_T_OrPemD.OPD_QtySatuan) AS po FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE (dbo.DLK_T_OrPemH.OPH_MemoID = '"& datamemo("memoID") &"') HAVING (SUM(dbo.DLK_T_OrPemD.OPD_QtySatuan) >= '"& datamemo("minta") &"')"
        ' response.write data_cmd.commandText & "<br>"
        set p = data_cmd.execute
        if p.eof then
    %>
            <option value="<%= datamemo("memoID") %>">
                <%= left(datamemo("memoID"),4) %>/<%=mid(datamemo("memoId"),5,3) %>-<% call getAgen(mid(datamemo("memoID"),8,3),"") %>/<%= mid(datamemo("memoID"),11,4) %>/<%= right(datamemo("memoID"),3) %>
            </option>
    <% 
        end if
    datamemo.movenext
    loop
    %>
    </select>
