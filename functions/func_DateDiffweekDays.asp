<% 
Function DateDiffWeekDays(d1, d2)
   Dim dy: dy = 0
   Dim dys: dys = DateDiff("d", d1, d2)
   Dim isWeekDay: isWeekDay = False
   Dim wkd
   Dim wd: wd = 0

   For dy = 0 To dys
      wkd = Weekday(DateAdd("d", dy, d1))
      isWeekDay = Not (wkd = vbSunday Or wkd = vbSaturday)
      If isWeekDay Then wd = wd + 1
   Next
   DateDiffWeekDays = wd
End Function
%>