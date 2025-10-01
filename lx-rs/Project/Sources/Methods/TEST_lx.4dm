//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	//execute in a worker to process callbacks
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $lx : cs:C1710.lx
	$lx:=cs:C1710.lx.new()
	var $providers : Collection
	$providers:=$lx.providers()
	
	var $apiKey : Text
	var $secretFile : 4D:C1709.File
	$secretFile:=Folder:C1567(Folder:C1567("/PROJECT/").platformPath; fk platform path:K87:2).parent.parent.file("OpenAI.token")
	If ($secretFile.exists)
		$apiKey:=$secretFile.getText()
	End if 
	
	$promt:="Extract names and ages"
	
	$file:=File:C1566("Macintosh HD:Users:miyako:Desktop:files:text.txt"; fk platform path:K87:2)
	
	$lx.extract({file: $file; apiKey: $apiKey; provider: "openai"; model: "gpt-4o"})
	
	
	
	//var $srcFolder : 4D.Folder
	//$srcFolder:=Folder(fk documents folder).folder("samples/docx")
	//$srcFolder:=Folder(fk desktop folder).folder("files")
	
	//ASSERT($srcFolder.exists)
	
	//var $dstFolder : 4D.Folder
	//$dstFolder:=Folder(fk desktop folder).folder("extract/docx")
	//$dstFolder.create()
	
	//$files:=$srcFolder.files(fk ignore invisible)
	////$files:=$files.slice(0; 3)
	
	//var $data : 4D.Blob
	
	//$tasks:=[]
	////For each ($file; $files)
	////$tasks.push({file: $file})
	////End for each 
	
	////file to text sync✅
	////$texts:=$extract.getText($tasks)
	
	////file to text async✅
	////$extract.getText($tasks; Formula(onResponse))
	
	//For each ($file; $files)
	//$tasks.push({file: $file.getContent(); data: $file})
	//End for each 
	
	////blob to text sync✅
	////$texts:=$extract.getText($tasks)
	
	////blob to text async✅
	//$extract.getText($tasks; Formula(onResponse))
	
End if 