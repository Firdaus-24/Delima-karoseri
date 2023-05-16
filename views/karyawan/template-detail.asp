<% 
  url = Request.ServerVariables("path_info")
  segments = split(url,"/")
  
  'read the last segment
  url = segments(ubound(segments))
  GetFileName = url

%>
<link rel="stylesheet" href="../../public/css/template-detail.css">
<div class="row"> 
  <div class="col-sm-12 mt-3 text-center">
    <h3>DETAIL KARYAWAN</h3>
  </div>  
</div>
<div class="row text-center tombol-template">
  <div class="col-lg-12"> 
    <div class="btn-group" role="group" aria-label="Basic example">
      <%if session("HR5E") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "detail.asp" then %>active <% end if %>" name="biografi" id="biografi" onCLick="window.location.href='detail.asp?nip=<%= nip %> '">Biografi</button>
      <%end if%>
      <%'if session("HM2") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "keluarga1.asp" then %>active <% end if %>" name="keluarga1" id="keluarga1" onCLick="window.location.href='keluarga1.asp?nip=<%= nip %>'">Keluarga1</button>
      <%'end if%>
      <%'if session("HM3") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "keluarga2.asp" then %>active <% end if %> " name="keluarga2" id="keluarga2" onCLick="window.location.href='keluarga2.asp?nip=<%= nip %>'">Keluarga2</button>
      <%'end if%>
      <%'if session("HM4") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "kesehatan.asp" then %>active <% end if %> " name="kesehatan" id="kesehatan" onCLick="window.location.href='Kesehatan.asp?nip=<%= nip %>'">Kesehatan</button>
      <%'end if%>
      <%'if session("HM5") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "pendidikan.asp" then %>active <% end if %>" name="pendidikan" id="pendidikan" onCLick="window.location.href='pendidikan.asp?nip=<%=nip%>'" >Pendidikan</button>
      <%'end if%>
      <%'if session("HM6") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "pekerjaan.asp" then %>active <% end if %>" name="Pekerjaan" id="Pekerjaan" onCLick="window.location.href='pekerjaan.asp?nip=<%= nip %>'">Pekerjaan</button>
      <%'end if%>
      <% 'if session("HA7")=true then %>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "penghasilan.asp" then %>active <% end if %>" name="Penghasilan" id="Penghasilan" onCLick="window.location.href='penghasilan.asp?nip=<%= nip %>'" >Penghasilan</button>
      <%' end if %>
      <%'if session("HM7") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "Catatan.asp" then %>active <% end if %>" name="Catatan" id="Catatan" onCLick="window.location.href='memo.asp?nip=<%= nip %>'">Catatan</button>
      <%'end if%>
      <%'if session("HM8") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "status.asp" then %>active <% end if %>" name="status" id="status" onCLick="window.location.href='status.asp?nip=<%= nip %>'">Status</button>
      <%'end if%>
      <%'if session("HM9") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "mutasi.asp" then %>active <% end if %>" name="mutasi" id="mutasi" onCLick="window.location.href='mutasi.asp?nip=<%= nip %>'">Mutasi</button>
      <%'end if%>
      <%'if session("HM10") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "cutiSakit.asp" then %>active <% end if %>" name="cutiSakit" id="cutiSakit" onCLick="window.location.href='cutiSakitIzin.asp?nip=<%= nip %>'">CutiIzinSakit</button>
      <%'end if%>
      <%'if session("HM11") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "absensi.asp" then %>active <% end if %>" name="absensi" id="absensi" onCLick="window.location.href='absensi.asp?nip=<%= nip %>'">Absensi</button>
      <%'end if%>
      <%'if session("HM12") = true then%>
        <button type="button" class="btn btn-sm btn-outline-danger <%if GetFileName = "perjanjian.asp" then %>active <% end if %>" name="perjanjian" id="perjanjian" onCLick="window.location.href='perjanjian.asp?nip=<%= nip %>'">Perjanjian</button>
      <%'end if%>
    </div>
  </div>
</div>
