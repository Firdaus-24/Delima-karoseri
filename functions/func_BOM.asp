<% 
   Sub tambahBOMH()
      agen = trim(Request.Form("agen"))
      tgl = trim(Request.Form("tgl"))
      produk = trim(Request.Form("produk"))
      hari = trim(Request.Form("hari"))
      bulan = trim(Request.Form("bulan"))
      keterangan = trim(Request.Form("keterangan"))

      set data_cmd =  Server.CreateObject ("ADODB.Command")
      data_cmd.ActiveConnection = mm_delima_string

      data_cmd.commandTExt = "SELECT * FROM DLK_T_BomH WHERE BMH_AgenID = '"& agen &"' AND BMH_Date = '"& tgl &"' AND BMH_PDID = '"& produk &"' AND BMH_Day = "& hari &" AND BMH_Month = "& bulan &""

      set data = data_cmd.execute

      if data.eof then
         data_cmd.commandText = "exec sp_AddDLK_T_BOMH '"& agen &"', '"& tgl &"', '"& produk &"', '"& hari &"', '"& bulan &"', '"& keterangan &"'"
         ' response.write data_cmd.commandText & "<br>"
         set p = data_cmd.execute

         id = p("ID")

         data_cmd.commandTExt = "SELECT * FROM DLK_T_BOMD WHERE LEFT(BMD_ID,13) = '"& id &"'"
         set detail = data_cmd.execute

         if detail.eof then
            data_cmd.commandTExt = "SELECT BMH_PDID, BMH_AgenID FROM DLK_T_BomH WHERE BMH_ID = '"& id &"'"

            set ckheader = data_cmd.execute

            data_cmd.commandTExt = "SELECT dbo.DLK_T_ProductH.PDBrgID, dbo.DLK_T_ProductH.PDID, dbo.DLK_T_ProductH.PDAgenID, dbo.DLK_T_ProductH.PDAktifYN, dbo.DLK_T_ProductD.PDDItem, dbo.DLK_T_ProductD.PDDSpect, dbo.DLK_T_ProductD.PDDJenisSat, dbo.DLK_T_ProductD.PDDQtty FROM dbo.DLK_T_ProductH RIGHT OUTER JOIN dbo.DLK_T_ProductD ON dbo.DLK_T_ProductH.PDID = LEFT(dbo.DLK_T_ProductD.PDDPDID, 12) WHERE (dbo.DLK_T_ProductH.PDAktifYN = 'Y') AND (dbo.DLK_T_ProductH.PDAgenID = '"& ckheader("BMH_AgenID") &"') AND (dbo.DLK_T_ProductH.PDID = '"& ckheader("BMH_PDID") &"') "

            set ckproduk = data_cmd.execute

            do while not ckproduk.EOF
               capacity = (Cint(ckproduk("PDDQtty")) * Cint(hari)) * Cint(bulan)
               data_cmd.commandTExt = "SELECT ('"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(BMD_ID),'000'),3)))+1),3)) as iddetail FROM DLK_T_BOMD WHERE LEFT(BMD_ID,13) = '"& id &"'"

               set ckidBaru = data_cmd.execute

               call query("INSERT INTO DLK_T_BomD (BMD_ID,BMD_Item,BMD_Qtysatuan,BMD_JenisSat) VALUES ('"& ckidBaru("iddetail") &"', '"& ckproduk("PDDItem") &"', '"& capacity &"', '"& ckproduk("PDDJenisSat")&"')")
            response.flush
            ckproduk.movenext
            loop
         end if

         value = 1 'case untuk insert data
      else
         value = 2 'case jika gagal insert 
      end if

      if value = 1 then
         call alert("FORM B.O.M", "berhasil ditambahkan", "success","bomd_add.asp?id="&id) 
      elseif value = 2 then
         call alert("FORM B.O.M", "sudah terdaftar", "warning","bomd_add.asp?id="&id)
      else
         value = 0
      end if
    End Sub

%>