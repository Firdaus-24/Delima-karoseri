<% 
sub tambahbomH()
   barang = trim(Request.Form("barang"))
   cabang = trim(Request.Form("cabang"))
   sasisid = trim(Request.Form("sasisid"))
   tgl = trim(Request.Form("tgl"))
   approve = trim(Request.Form("approve"))
   tsalary = replace(replace(replace(trim(Request.Form("tsalary")),".",""),",",""),"-","")
   keterangan = trim(Request.Form("keterangan"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_bomH WHERE BMBrgID = '"& barang &"' AND BMAgenID = '"& cabang &"' AND BMSasisID = '"& sasisid &"' AND BMmanpower = "& mpbom &" AND BMtotalsalary = '"& tsalary &"' "
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   if data.eof then
      data_cmd.commandText = "exec SP_AddDLK_M_bomH '"& barang &"', '"& tgl &"', '"& cabang &"', '"& approve &"', '"& sasisid &"', '"& keterangan &"', '"& tsalary &"'"

      set p = data_cmd.execute

      id = p("ID")
      call alert("MATER B.O.M", "berhasil di tambahkan", "success","bomd_add.asp?id="&id) 
   else
      call alert("MATER B.O.M", "sudah terdaftar", "warning", "bom_add.asp")
   end if
end sub

sub tambahbomD()
   bmid = trim(Request.Form("bmid"))
   ckproduckd = trim(Request.Form("ckproduckd"))
   qtty = trim(Request.Form("qtty"))
   satuan = trim(Request.Form("satuan"))
   nol = "000"

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_BOMD WHERE BMDItem = '"& ckproduckd &"' AND LEFT(BMDBMID,12) = '"& bmid &"'"
   set data = data_cmd.execute

   if data.eof then
      data_cmd.commandTExt = "SELECT (COUNT(BMDBMID)) + 1 AS urut FROM DLK_M_BOMD WHERE left(BMDBMID,12) = '"& bmid &"'"
      ' response.write data_cmd.commandText & "<br>"
      set p = data_cmd.execute

      iddetail = bmid & right(nol & p("urut"),3)

      call query("INSERT INTO DLK_M_BOMD (BMDBMID, BMDItem, BMDQtty, BMDjenissat) VALUES ( '"& iddetail &"','"& ckproduckd &"', "& qtty &",'"& satuan &"')")

      call alert("RINCIAN DETAIL B.O.M", "berhasil di tambahkan", "success","bomd_add.asp?id="&bmid) 
   else
      call alert("RINCIAN DETAIL B.O.M", "sudah terdaftar", "warning","bomd_add.asp?id="&bmid)
   end if

end sub

sub updatebomH()
   bmid = trim(Request.Form("bmid"))
   barang = trim(Request.Form("brgbomu"))
   sasisid = trim(Request.Form("sasisidbomu"))
   approve = trim(Request.Form("approve"))
   tsalary = replace(replace(replace(trim(Request.Form("salarybomu")),".",""),",",""),"-","")
   keterangan = trim(Request.Form("keterangan"))

   data_cmd.commandText = "SELECT * FROM DLK_M_bomH WHERE BMid = '"& bmid &"'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   if not data.eof then
      call query("UPDATE DLK_M_BOMH SET BMBrgID = '"& barang &"', BMTotalsalary = '"& tsalary &"', BMSasisID = '"& sasisid &"', BMApproveYN = '"& approve &"', BMKeterangan = '"& keterangan &"' WHERE BMID = '"& bmid &"' ")
      
      call alert("HEADER MATER B.O.M", "berhasil di update", "success", Request.ServerVariables("HTTP_REFERER")) 
   else
      call alert("HEADER MATER B.O.M", "tidak terdaftar", "warning", "./")
   end if

end sub

sub updatebomD()
   bmid = trim(Request.Form("bmid"))
   ckproduckd = trim(Request.Form("ckproduckd"))
   qtty = trim(Request.Form("qtty"))
   satuan = trim(Request.Form("satuan"))
   nol = "000"

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_BOMD WHERE LEFT(bmDbmID,12) = '"& bmid &"' AND bmDItem = '"& ckproduckd &"'"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute
   
   if data.eof then
      data_cmd.commandText = "SELECT TOP 1 (right(bmDbmID,3)) + 1 AS urut FROM DLK_M_BOMD WHERE LEFT(bmDbmID,12) = '"& bmid &"' ORDER BY bmDbmID DESC"

      set p = data_cmd.execute

      if p.eof then
         data_cmd.commandTExt = "SELECT (COUNT(bmDbmID)) + 1 AS urut FROM DLK_M_BOMD WHERE LEFT(bmDbmID,12) = '"& bmid &"'"

         set a = data_cmd.execute

         iddetail = bmid & right(nol & a("urut"),3)

         call query("INSERT INTO DLK_M_BOMD (bmDbmID, bmDItem, bmDQtty, bmDJenisSat) VALUES ('"& iddetail &"','"& ckproduckd &"', "& qtty &", '"& satuan &"') ")
      else
         iddetail = bmid & right(nol & p("urut"),3)

         call query("INSERT INTO DLK_M_BOMD (bmDbmID, bmDItem, bmDQtty, bmDJenisSat) VALUES ('"& iddetail &"','"& ckproduckd &"', "& qtty &", '"& satuan &"') ")
      end if
      call alert("DETAIL BARANG B.O.M", "berhasil ditambahkan", "success","bom_u.asp?id="&bmid) 
   else
      call alert("DETAIL BARANG B.O.M", "sudah terdaftar", "warning","bom_u.asp?id="&bmid)
   end if
end sub
%>