<%
sub alert(strong,message,bg,file)
     response.write "<script>swal({title: '"& strong &"',text: '"& message &"',icon: '"& bg &"',button: 'kembali',}).then(function() {window.location = '"& file &"'}); </script>"
end sub 
%>