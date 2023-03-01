<!--#include file="../../init.asp"-->
<% 
  if session("PP2E") = false then
    Response.Redirect("../index.asp")
  end if
  
  id = trim(Request.QueryString("id"))
  timep = trim(Request.form("timep"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.HRD_M_Karyawan.Kry_NIP, dbo.HRD_M_Karyawan.Kry_Nama FROM dbo.HRD_M_Karyawan RIGHT OUTER JOIN dbo.DLK_T_ManPowerD ON dbo.HRD_M_Karyawan.Kry_NIP = dbo.DLK_T_ManPowerD.MP_Nip WHERE (dbo.DLK_T_ManPowerD.MP_ID = '"& id &"')"

  set karyawan = data_cmd.execute
  
  if timep <> "" then
    bulan = Cint(month(timep))
    tahun = year(timep)
    
    ' Menentukan tanggal pertama dari bulan yang ditampilkan
    firstDayOfMonth = DateSerial(tahun, bulan, 1)

    ' Menentukan jumlah hari dalam bulan yang ditampilkan
    numDaysInMonth = DateDiff("d", firstDayOfMonth, DateAdd("m", 1, firstDayOfMonth))

    ' Menentukan hari pertama dalam minggu yang ditampilkan
    firstDayOfWeek = Weekday(firstDayOfMonth, vbSunday)

  else
    bulan = ""
    tahun = ""
  '   jumlahHari = ""
  end if  

  call header("Day Time Work")
%>
<style>
  .calender{
    animation: open-animation 2s forwards;
  }
  @keyframes open-animation {
    from {
      transform: translateY(-50%);
    }
    to {
      transform: translateY(0);
    }
  }

  ul {list-style-type: none;}

  .month {
    padding: 70px 25px;
    width: 100%;
    background: #34495e;
    text-align: center;
  }

  .month ul {
    margin: 0;
    padding: 0;
  }

  .month ul li {
    color: white;
    font-size: 20px;
    text-transform: uppercase;
    letter-spacing: 3px;
  }

  .month .prev {
    float: left;
    padding-top: 10px;
  }

  .month .next {
    float: right;
    padding-top: 10px;
  }

  .weekdays {
    margin: 0;
    padding: 10px 0;
    background-color: #ddd;
  }

  .weekdays li {
    display: inline-block;
    width: 13.6%;
    color: #666;
    text-align: center;
  }

  .days {
    padding: 10px 0;
    background: #eee;
    margin: 0;
  }

  .days li {
    list-style-type: none;
    display: inline-block;
    width: 13.6%;
    text-align: center;
    margin-bottom: 5px;
    font-size:12px;
    color: #777;
  }

  .days li .active {
    padding: 5px;
    background: #34495e;
    color: white !important
  }

  .ckhari{
    cursor:pointer;
    padding:5px;
  }

  /* Hide the browser's default checkbox */
  .phari {
    position: absolute;
  }
  /* Basic styling */
  [type=checkbox] {
    width: 1.2rem;
    height: 1.2rem;
    color: dodgerblue;
    vertical-align: middle;
    -webkit-appearance: none;
    background: none;
    border: 0;
    outline: 0;
    flex-grow: 0;
    border-radius: 50%;
    background-color: #FFFFFF;
    transition: background 300ms;
    cursor: pointer;
  }


  /* Pseudo element for check styling */

  [type=checkbox]::before {
    content: "";
    color: transparent;
    display: block;
    width: inherit;
    height: inherit;
    border-radius: inherit;
    border: 0;
    background-color: transparent;
    background-size: contain;
    box-shadow: inset 0 0 0 1px #CCD3D8;
  }


  /* Checked */

  [type=checkbox]:checked {
    background-color: currentcolor;
  }

  [type=checkbox]:checked::before {
    box-shadow: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24'%3E %3Cpath d='M15.88 8.29L10 14.17l-1.88-1.88a.996.996 0 1 0-1.41 1.41l2.59 2.59c.39.39 1.02.39 1.41 0L17.3 9.7a.996.996 0 0 0 0-1.41c-.39-.39-1.03-.39-1.42 0z' fill='%23fff'/%3E %3C/svg%3E");
  }


  /* Disabled */

  [type=checkbox]:disabled {
    background-color: #CCD3D8;
    opacity: 0.84;
    cursor: not-allowed;
  }


  /* IE */
  [type=checkbox]::-ms-check {
    content: "";
    color: transparent;
    display: block;
    width: inherit;
    height: inherit;
    border-radius: inherit;
    border: 0;
    background-color: transparent;
    background-size: contain;
    box-shadow: inset 0 0 0 1px #CCD3D8;
  }

  [type=checkbox]:checked::-ms-check {
    box-shadow: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24'%3E %3Cpath d='M15.88 8.29L10 14.17l-1.88-1.88a.996.996 0 1 0-1.41 1.41l2.59 2.59c.39.39 1.02.39 1.41 0L17.3 9.7a.996.996 0 0 0 0-1.41c-.39-.39-1.03-.39-1.42 0z' fill='%23fff'/%3E %3C/svg%3E");
  }
  

  /* Add media queries for smaller screens */
  @media screen and (max-width:720px) {
    .weekdays li, .days li {width: 13.1%;}
  }

  @media screen and (max-width: 420px) {
    .weekdays li, .days li {width: 12.5%;}
    .days li .active {padding: 2px;}
  }

  @media screen and (max-width: 290px) {
    .weekdays li, .days li {width: 12.2%;}
  }
</style>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm text-center mt-3">
      <h3>SETTING HARI KERJA MAN POWER</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm text-center mb-3 labelId">
      <h3><%= left(id,2) %>-<%= mid(id,3,2) %>/<%= mid(id,5,2) %>/<%= mid(id,5,4) %>/<%= right(id,3)  %></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-1 mb-3">
      <label for="kry" class="form-label">Nama :</label>
    </div>
    <div class="col-sm-5">
      <input type="text" class="form-control" id="kry" name="kry" value="<%= karyawan("Kry_Nip") &" | "& karyawan("Kry_Nama")%>" readonly>
    </div>
  </div>
  <form action="index.asp?id=<%= id %>" method="post">
    <div class="row">
      <div class="col-sm-1">
        <label for="timep" class="form-label">Bulan tahun</label>
      </div>
      <div class="col-sm-5 mb-3">
        <input type="month" class="form-control" id="timep" name="timep">
      </div>
      <div class="col-sm-5 mb-3">
        <button type="submit" class="btn btn-primary">Refresh</button>
        <button type="button" onclick="window.location.href='../manpower/mpd_u.asp?id=<%= left(id,4)&right(id,7) %>'" class="btn btn-danger">Kembali</button>
      </div>
    </div>
  </form>
  <% if bulan <> "" then%>
  <div class="row">
    <div class="col-sm-12 calender">
      <div class="month">     
        <ul>
          <li>
            <%= MonthName(bulan) %><br>
            <span style="font-size:18px"><%= tahun %></span>
          </li>
        </ul>
      </div>
      <ul class="weekdays">
        <li>Minggu</li>
        <li>Senin</li>
        <li>Selasa</li>
        <li>Rabu</li>
        <li>Kamis</li>
        <li>Jumat</li>
        <li>Sabtu</li>
      </ul>
      <% 
      ' Menampilkan hari-hari dalam kalender
      hari = 1
      for week = 1 to 6
      %>
        <ul class='days'>
      <%
      for offset = 1 to 7
        if hari = day(now) AND bulan = month(now) AND tahun = year(now) then
          active = "class='active'"
        else
          active = ""
        end if

        if (week = 1 and offset < firstDayOfWeek) or (hari > numDaysInMonth) then%>
          <li>&nbsp;</li>
        <%else 
          number = "TW_" &right("00" + Cstr(hari), 2)
          ' get data query 
          data_cmd.commandText = "SELECT ("& trim(number) &") as tw FROM DLK_T_TWMP WHERE TW_MPID = '"& id &"' AND TW_Bulan= '"& trim(right("00" + Cstr(bulan),2)) &"' AND TW_Tahun = '"& tahun &"'"
          set data = data_cmd.execute
        %>
        <input type='checkbox' name='phari' id='phari<%= hari %>' class='phari' onclick="setHariDb('<%= hari %>','<%= id %>','<%= bulan %>','<%= tahun %>',)" <% if not data.eof then  %> <%  if data("tw") = 1 then %> checked <% end if  %>  <%  end if%>>
          <li class='ckhari'>
            <label for="phari<%= hari %>" <%= active %>  style="width:100%;"><%= hari %></label>
            <span class='checkmark'></span>
          </li>
        <% 
          hari = hari + 1
        end if
      next
      %>
        </ul>
      <% 
        if hari > numDaysInMonth then exit for
      next
      %>
    </div>
  </div>
  <% end if %>
</div>
<script>
  function setHariDb(e,i,b,t){ 
    let days = e
    let id = i
    let bulan = b
    let tahun = t
    
    $.ajax({
      method: "get",
      url: "p_tw.asp",
      data: { days,id, bulan, tahun }
    }).done(function(ms){console.log(ms)});
  }
</script>
<% call footer() %>