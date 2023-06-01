<% 
Sub tambahfn
   tgl = Cdate(trim(Request.Form("tgl")))
   agen = trim(Request.Form("agen"))
   pdhid = trim(Request.Form("pdhid"))
   keterangan = trim(Request.Form("keterangan"))

   data_cmd.commandTExt = "SELECT * FROM DLK_T_ProdFInishH WHERE PFH_AgenID = '"& agen &"' AND PFH_PDHID = '"& pdhid &"' AND PFH_date = '"& tgl &"' AND PFH_AktifYN = 'Y'"

   set data = data_cmd.execute

   if data.eof then
      data_cmd.commandTExt = "exec sp_addDLK_T_ProdFinishH '"& agen &"', "& pdhid &",'"& tgl &"',  '"& keterangan &"', '"& session("userid") &"' "

      set p = data_cmd.execute

      id = p("ID")

      call alert("HEADER TRANSAKSI FINISHGOOD", "berhasil di tambahkan", "success","find_add.asp?id="&id)
   else
      call alert("HEADER TRANSAKSI FINISHGOOD", "sudah terdaftar", "error","fin_add.asp")
   end if
End Sub
%>