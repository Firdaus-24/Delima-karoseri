<%
sub alert(strong,message,bg,file)
    ' response.write "<script>swal({title: '"& strong &"',text: '"& message &"',icon: '"& bg &"',button: 'kembali',});</script>"
     response.write "<script>swal({title: '"& strong &"',text: '"& message &"',icon: '"& bg &"',button: 'kembali',}).then(function() {window.location = '"& file &"'}); </script>"
end sub 
' sub alertUpdate(strong,message,bg)
'     response.write "<script>swal({title: '"& strong &"',text: '"& message &"',icon: '"& bg &"',button: 'kembali',}).then(function() {window.location = 'index.asp';}); </script>"
' end sub 
%>