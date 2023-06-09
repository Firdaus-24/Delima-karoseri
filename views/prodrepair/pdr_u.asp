<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_prodrepair.asp"-->
<% 
  if session("PP5B") = false then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  call header("Update Produksi Repair")

  ' dataheader
  data_cmd.commandText = "SELECT dbo.DLK_T_ProduksiRepair.*, dbo.DLK_M_Brand.BrandName, dbo.GLB_M_Agen.AgenName FROM   dbo.DLK_T_ProduksiRepair LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ProduksiRepair.PDR_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_ProduksiRepair.PDR_BrandID = dbo.DLK_M_Brand.BrandID WHERE (dbo.DLK_T_ProduksiRepair.PDR_AktifYN = 'Y') AND (dbo.DLK_T_ProduksiRepair.PDR_ID = '"& id &"')"
  set data = data_cmd.execute

  ' agen / cabang
  data_cmd.commandTExt = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM   dbo.DLK_T_IncRepairH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_IncRepairH.IRH_AgenID = dbo.GLB_M_Agen.AgenID GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, dbo.DLK_T_IncRepairH.IRH_AktifYN HAVING (dbo.DLK_T_IncRepairH.IRH_AktifYN = 'Y') ORDER BY AgenNAme ASC"

  set agen = data_cmd.execute

%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>FORM UPDATE PRODUKSI REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%=LEFT(data("PDR_ID"),3) &"-"& MID(data("PDR_ID"),4,2) &"/"& RIGHT(data("PDR_ID"),3) %></h3>
    </div>
  </div>
  <form action="pdr_u.asp?id=<%=data("PDR_ID")%>" method="post" onsubmit="validasiForm(this,event,'APA ANDA YAKIN??','warning')">
  <input type="hidden" id="id" name="id" class="form-control" value="<%= data("PDR_ID") %>" required>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="cabangpdru" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="cabangpdru" name="cabang" required>
        <option value="<%=data("PDR_Agenid")%>"><%=data("agenname")%></option>
        <% do while not agen.eof %>
        <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
        <% 
        agen.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("PDR_Date")) %>" onfocus="(this.type='date')" required>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="startdate" class="col-form-label">Start Date</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="startdate" name="startdate" class="form-control" value="<%= Cdate(data("PDR_startDate")) %>" onfocus="(this.type='date')" required>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="enddate" class="col-form-label">End Date</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="enddate" name="enddate" class="form-control" value="<%= Cdate(data("PDR_EndDate")) %>" onfocus="(this.type='date')" required>
    </div>
  </div>
  <div class="row align-items-center">
     <div class="col-lg-2 mb-3">
        <label for="irhidrepair" class="col-form-label">No.Incomming Unit</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" name="irhidrepair" id="irhidrepairupdate" required> 
        <option value="<%=data("PDR_IRHID")%>"><%= LEFT(data("PDR_IRHID"),4) &"-"& mid(data("PDR_IRHID"),5,3) &"/"& mid(data("PDR_IRHID"),8,4) &"/"& right(data("PDR_IRHID"),2) %></option>
       
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="brandpdr" class="col-form-label">Brand</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="hidden" id="tfkidpdru" name="tfkid" class="form-control" autocomplete="off" value="<%=data("PDR_TFKID")%>" required readonly>
      <input type="hidden" id="brandidpdru" name="brand" class="form-control" autocomplete="off" value="<%=data("PDR_BrandID")%>" required readonly>
      <input type="text" id="brandnamepdru" name="brandname" class="form-control" autocomplete="off" value="<%=data("BrandName")%>" required readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="typepdr" class="col-form-label">Type</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="typepdru" name="typepdr" class="form-control" autocomplete="off" value="<%=data("PDR_Type")%>"  required readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="nopolpdr" class="col-form-label">No.polisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="nopolpdru" name="nopol" class="form-control" autocomplete="off" value="<%=data("PDR_Nopol")%>" required readonly>
    </div>
  </div>  
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="nomesin" class="col-form-label">No.Mesin</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="nomesinpdru" name="nomesin" class="form-control" autocomplete="off" value="<%=data("PDR_NOmesin")%>" required readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="rangkapdr" class="col-form-label">No.Rangka</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="rangkapdru" name="rangka" class="form-control" autocomplete="off" value="<%=data("PDR_NoRangka")%>" required readonly>
    </div>
  </div>  
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="warna" class="col-form-label">Color</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="warnapdru" name="warna" class="form-control" autocomplete="off" value="<%=data("PDR_color")%>" required readonly>
    </div>
  </div>  
  <div class="row">
    <div class="col-lg-12 text-center">
      <a href="./" type="button" class="btn btn-danger">Kembali</a>
      <button type="submit" class="btn btn-primary">Update</button>
    </div>
  </div>
  </form>
  <hr style="border-top: 1px dotted red;">
   <footer style="font-size: 10px; text-align: center;">
      <p style="margin:0;padding:0;"> 		
         PT.DELIMA KAROSERI INDONESIA
      </p>
      <p style="text-transform: capitalize; color: #000;margin:0;padding:0;">User Login : <%= session("username") %>  | Cabang : <%= session("cabang") %> | <a href="<%=url%>logout.asp" target="_self">Logout</a></p>
      <p style="margin:0;padding:0;">Copyright MuhamadFirdausIT Division©2022-2023S.O.No.Bns.Wo.Instv</p>
      <p style="margin:0;padding:0;"> V.1 Mobile Responsive 2022 | V.2 On Progres 2023</p>
   </footer>
</div>  
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call Update()
  end if
  call footer()
%>