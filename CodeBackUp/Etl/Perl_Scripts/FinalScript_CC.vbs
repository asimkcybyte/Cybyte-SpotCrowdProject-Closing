On Error Resume Next

Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
Const adOpenStatic = 3
Const adLockOptimistic = 3
Dim mainStr,startStr,EndStr,tempStr
Dim Startpos,EndPos



'******************************************Extracts Source Code******************************************
Function ExtractSource(temp)
	Functional_url = temp
	Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")
	Call objHTTP.Open("GET", Functional_url, False)
	objHTTP.send
	SubUrlData = objHTTP.responseText
	ExtractSource = SubUrlData
End Function


'******************************************Replace Special Characters******************************************
Function RemoveSpecialChar(str)
	Dim sstr
	sstr = str
	sstr = Trim(Replace(sstr, Chr(9),""))
	sstr = Trim(Replace(sstr, Chr(10),""))
	sstr = Trim(Replace(sstr, Chr(12),""))
	sstr = Trim(Replace(sstr, Chr(13),""))
	'sstr = Trim(Replace(sstr, ",", " "))	'-------------->>>Enable this when you wanna Remove "," (i.e. comma) from the string
	RemoveSpecialChar = sstr
End Function


'******************************************Removes all HTML TAGS***********************************************
Function RemoveAllTags(strPostData)
	Dim lngPosStart
	Dim lngPosEnd
	Dim strPostText
	Dim lngLength
	Dim lngCtr
	Dim blnStopLoop
	Dim strTemp
	
	strPostText = strPostData
	
	lngPosEnd = 1
	blnStopLoop = 0
	While blnStopLoop = 0
		lngPosStart = InStr(lngPosEnd,strPostText,"<")
		If lngPosStart > 0 Then
			lngPosEnd = InStr(lngPosStart,strPostText,">")
			lngPosEnd = lngPosEnd +1
			lngLength = lngPosEnd - lngPosStart
			strTemp = Mid(strPostText,lngPosStart,lngLength)
			strPostText = Replace(strPostText,strTemp,"")
			lngPosEnd = 1
			lngPosStart = 0
			strTemp = ""
		Else
			blnStopLoop = 1
		End If
	Wend
	strPostText= Replace(strPostText,"amp;","")
	strPostText= Replace(strPostText,"&nbsp;","")
	strPostText= Replace(strPostText,"&bull","")
	strPostText= Replace(strPostText,";"," ")
	RemoveAllTags = strPostText
End Function


'*****************************************Get the required Block*****************************************
Public Function GetValue(byval MainString,byval StartString,byval EndString)
		Startpos = InStr(1,mainstring,Startstring)
		If Startpos> 0 Then
		    Startpos = Startpos + Len(Startstring)
			EndPos = InStr(Startpos,mainstring,endstring)
			EndPos = EndPos - Startpos  '- Len(Startstring)-1
				If EndPos > 0 Then
					GetValue = Replace(Mid(mainstring,Startpos,EndPos),Chr(34),Chr(34)& Chr(34))
				Else
				    GetValue = ""				    	
				End If
		Else
			GetValue= ""
		End If		
End Function


'*****************************************Writes into the Text/.csv File*****************************************
Function WriteInToFile(FinalString)
	Dim objTextFile
	Dim strFilePath
	Dim objFSO
	Dim Sql
	'Specify the File name with extention and path in variable "strFilePath"	
	strFilePath = trim("C:\Spot_Crowd_Project\scp_source\Crowdcube\AA_CrowdCube.csv")
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Const ForAppending = 8
	Set objTextFile = objFSO.OpenTextFile(strFilePath, ForAppending,True)
	objTextFile.WriteLine(FinalString)
	objTextFile.Close
	Set objTextFile = Nothing
	Set objFSO = Nothing 
End Function


'*****************************************Downloads the File from Internet*****************************************
Function HTTPDownload( myURL, myPath )
	Dim Success
	Success = True
    Dim i, objFile, objFSO, objHTTP, strFile, strMsg
    Const ForReading = 1, ForWriting = 2, ForAppending = 8
    Set objFSO = CreateObject( "Scripting.FileSystemObject" )
    If objFSO.FolderExists( myPath ) Then
        strFile = objFSO.BuildPath( myPath, Mid( myURL, InStrRev( myURL, "/" ) + 1 ) )
    ElseIf objFSO.FolderExists( Left( myPath, InStrRev( myPath, "\" ) - 1 ) ) Then
        strFile = myPath
    Else
        Success = False 'WScript.Echo "ERROR: Target folder not found."
        HTTPDownload = Success
        Exit Function
    End If
    Set objFile = objFSO.OpenTextFile( strFile, ForWriting, True )
    Set objHTTP = CreateObject( "WinHttp.WinHttpRequest.5.1" )
    objHTTP.Open "GET", myURL, False
    objHTTP.Send
    For i = 1 To LenB( objHTTP.ResponseBody )
        objFile.Write Chr( AscB( MidB( objHTTP.ResponseBody, i, 1 ) ) )
    Next
    objFile.Close( )
    HTTPDownload = Success
End Function


'****************************************MAKE ALL THE CHANGES FROM HERE*************************************
'****************************************MAKE ALL THE CHANGES FROM HERE*************************************
'****************************************MAKE ALL THE CHANGES FROM HERE*************************************
'****************************************MAKE ALL THE CHANGES FROM HERE*************************************
'****************************************MAKE ALL THE CHANGES FROM HERE*************************************
'****************************************MAKE ALL THE CHANGES FROM HERE*************************************


'******************************************Code for Main Catagory******************************************

dim cnt
mainStr = ExtractSource("http://www.crowdcube.com/investments")
	
startStr = "<div class="& chr(34) &"left-col"& chr(34) &">"
EndStr = "</article>"
cnt = 1
WriteInToFile("SR.No.,Company Name,Founder,Sectors,Funded,Invested,Target,Investor,Equity,Days left,Progress,Location,Tax Relife,Likes,Tweets,Share,Content,Photo Url")
Do While InStr(1,mainStr,startStr)> 0 
	tempStr = GetValue(mainStr,startStr,EndStr)
	If Len(tempStr)> 0 Then
		
		'*******************************Extracts MAIN Category URL****************************
		'MsgBox tempStr 		
		MainURL = Replace(tempStr, Chr(34), "")		
		MainURL= RemoveSpecialChar(MainURL)		
		MainURL = RTrim(Replace(MainURL,Chr(34),""))
		MainURL = RTrim(Replace(MainURL,"  ",""))
		pageurl = "http://www.crowdcube.com/investment/" & GetValue(MainURL,"http://www.crowdcube.com/investment/"," title")			
		cname = RemoveallTags(GetValue(MainURL,"title=","alt"))		
		tempSource = replace(ExtractSource(pageurl),chr(34),"")		
		foundername = RemoveSpecialChar(Replace(RemoveallTags(GetValue(tempSource,"<div class=title>Founder</div>","</table>")),"  ",""))
		sectors =  RemoveSpecialChar(replace(RemoveallTags(GetValue(tempSource,"<div class=title>Sectors</div>","</table>")),"  ",""))
		funded =  RemoveallTags(GetValue(MainURL,"<ul class=pitch-stats clearfix>","<small>funded</small>"))
		invested = RemoveallTags(GetValue(MainURL,"<small>funded</small>","<small>invested</small>"))
		target = RemoveallTags(GetValue(MainURL,"<small>invested</small>","<small>target</small>"))
		investor = RemoveallTags(GetValue(MainURL,"<small>target</small>","<small>investors</small>"))
		equity = RemoveallTags(GetValue(MainURL,"<small>investors</small>","<small>equity</small>"))
		daysleft = RemoveallTags(GetValue(MainURL,"<small>equity</small>","<small>day"))
		progress = RemoveallTags(GetValue(MainURL,"<div class=bar style=width:",";"))
		location = RemoveallTags(GetValue(MainURL,"<small class=location>","</small>"))
		tax1 = RemoveallTags(GetValue(MainURL,"<ul class=tax>","</li>"))
		tax2 = RemoveallTags(GetValue(MainURL,"</li>","</ul>"))
		content = RemoveallTags(GetValue(MainURL,"<p>","</p>"))
		if len(tax1)>5 or len(tax2)>5 then
			tax1 = "-"
			tax2 = ""
		end if

		photourl = "http://www.crowdcube.com"& trim(GetValue(MainURL,"<img src=","title"))		
		'HTTPDownload photourl, "C:\Spot_Crowd_Project\scp_source\Crowdcube\images\"
		
		'====================== FB=================================
		fbURl = "https://graph.facebook.com/?ids="&pageurl
		fbCounts = ExtractSource(fbUrl)
		fbcounts =  GetValue(fbCounts,"shares"& chr(34) &":","}")
		if len(trim(fbcounts))=0 or trim(fbcounts)="" then
			fbcounts="0"
		end if
		'=======================Tweeter============================
		TwUrl = "http://urls.api.twitter.com/1/urls/count.json?url=" & pageurl
		Twcounts = ExtractSource(TwUrl)
		Twcounts =  GetValue(TwCounts,":",",")

		'======================linked in Share ====================
		lkUrl = "http://www.linkedin.com/countserv/count/share?url=" & pageUrl
		Lkcounts = ExtractSource(lkUrl)
		lkcounts =  GetValue(lkCounts,":",",")
		
		WriteIntoFile(chr(34)&cstr(cnt)&chr(34)&","&chr(34)&cname&chr(34)&","&chr(34)&foundername&chr(34)&","&chr(34)&sectors&chr(34)&","&chr(34)&funded&chr(34)&","&chr(34)&invested&chr(34)&","&chr(34)&target&chr(34)&","&chr(34)&investor&chr(34)&","&chr(34)&equity&chr(34)&","&chr(34)&daysleft&chr(34)&","&chr(34)&progress&chr(34)&","&chr(34)&location&chr(34)&","&chr(34)&tax1&","&tax2&chr(34)&","&chr(34)&fbcounts&chr(34)&","&chr(34)&Twcounts&chr(34)&","&chr(34)&lkcounts&chr(34)&","&chr(34)&content&chr(34)&","&chr(34)&photourl&chr(34))
		
		cnt=cnt+1
		'*********************************Extracts title of the URL******************************
		
		
	End If
	mainStr = Right(mainStr,Len(mainStr)-InStr(1,mainStr,startStr)-Len(startStr))
	mainStr = Right(mainStr,Len(mainStr)-InStr(1,mainStr,EndStr)-Len(endStr))
	
Loop

cnt=1

dim rawDate, rawDay, rawMonth

rawDate = cDate(date)

rawDay = day(rawDate)
if rawDay < 10 then
    rawDay = "0" & rawDay 
end if

rawMonth = month(rawDate)
if rawMonth< 10 then
    rawMonth = "0" & rawMonth
end if

dim lookupDate
lookupDate = rawMonth
lookupDate = lookupDate & rawDay
lookupDate = lookupDate & year(rawDate)

'=====================

Dim FSO 
Set FSO = CreateObject("Scripting.FileSystemObject")
strFile = "C:\Spot_Crowd_Project\scp_source\Crowdcube\AA_CrowdCube.csv"
strRename = "C:\Spot_Crowd_Project\scp_source\Crowdcube\AA_CrowdCube_"&lookupDate&".csv"
If FSO.FileExists(strFile) Then
       FSO.MoveFile strFile, strRename
End If
Set FSO = Nothing
