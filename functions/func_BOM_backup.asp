<% 
   Sub tambahBOMH()
      agen = trim(Request.Form("agen"))
      tgl = trim(Request.Form("tgl"))
      tgla = trim(Request.Form("tgla"))
      tgle = trim(Request.Form("tgle"))
      produk = trim(Request.Form("produk"))
      hari = trim(Request.Form("hari"))
      bulan = trim(Request.Form("bulan"))
      keterangan = trim(Request.Form("keterangan"))
      prototype = trim(Request.Form("prototype"))

      set data_cmd =  Server.CreateObject ("ADODB.Command")
      data_cmd.ActiveConnection = mm_delima_string

      data_cmd.commandTExt = "SELECT * FROM DLK_T_BomH WHERE BMH_AgenID = '"& agen &"' AND BMH_Date = '"& tgl &"' AND BMH_PDID = '"& produk &"' AND BMH_Day = "& hari &" AND BMH_StartDate = '"& tgla &"' AND BMH_EndDate = '"& tgle &"'"

      set data = data_cmd.execute

      if data.eof then
         data_cmd.commandText = "exec sp_AddDLK_T_BOMH '"& agen &"', '"& tgl &"', '"& produk &"', '"& hari &"', '"& tgla &"', '"& tgle &"', '"& keterangan &"', '"& prototype &"'"
         ' response.write data_cmd.commandText & "<br>"
         set p = data_cmd.execute

         id = p("ID")

         data_cmd.commandTExt = "SELECT * FROM DLK_T_BOMD WHERE LEFT(BMD_ID,13) = '"& id &"'"
         set detail = data_cmd.execute

         if detail.eof then
            data_cmd.commandTExt = "SELECT BMH_PDID, BMH_AgenID FROM DLK_T_BomH WHERE BMH_ID = '"& id &"'"

            set ckheader = data_cmd.execute

            data_cmd.commandTExt = "SELECT dbo.DLK_M_ProductH.PDBrgID, dbo.DLK_M_ProductH.PDID, dbo.DLK_M_ProductH.PDAgenID, dbo.DLK_M_ProductH.PDAktifYN, dbo.DLK_M_ProductD.PDDItem, dbo.DLK_M_ProductD.PDDJenisSat, dbo.DLK_M_ProductD.PDDQtty FROM dbo.DLK_M_ProductH RIGHT OUTER JOIN dbo.DLK_M_ProductD ON dbo.DLK_M_ProductH.PDID = LEFT(dbo.DLK_M_ProductD.PDDPDID, 12) WHERE (dbo.DLK_M_ProductH.PDAktifYN = 'Y') AND (dbo.DLK_M_ProductH.PDAgenID = '"& ckheader("BMH_AgenID") &"') AND (dbo.DLK_M_ProductH.PDID = '"& ckheader("BMH_PDID") &"') "

            set ckproduk = data_cmd.execute

            do while not ckproduk.EOF
               if Cint(hari) <> 0 then
                  strHari = Cint(hari)
               else
                  strHari = 1
               end if
               
               strBulan = DateDiffWeekDays(Cdate(tgla), CDate(tgle))

               capacity = (Cint(ckproduk("PDDQtty")) * strHari) * strBulan
              
               data_cmd.commandTExt = "SELECT ('"& id &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(BMD_ID),'000'),3)))+1),3)) as iddetail FROM DLK_T_BOMD WHERE LEFT(BMD_ID,13) = '"& id &"'"

               set ckidBaru = data_cmd.execute

               call query ("INSERT INTO DLK_T_BomD (BMD_ID,BMD_Item,BMD_Qtysatuan,BMD_JenisSat) VALUES ('"& ckidBaru("iddetail") &"', '"& ckproduk("PDDItem") &"', "& capacity &", '"& ckproduk("PDDJenisSat")&"')")
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
         call alert("FORM B.O.M", "sudah terdaftar", "warning","bom_add.asp")
      else
         value = 0
      end if
    End Sub

%>