<% 
sub header(e)
    server.Execute("../../header.asp")
    response.write "<title>"& e &"</title>"
end sub

sub footer()
    server.execute("../../footer.asp")
end sub

%>