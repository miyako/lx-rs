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
	
	//Basic extraction
	
	$input:="Alice Smith is 25 years old"
	$file:=File:C1566(Temporary folder:C486+Generate UUID:C1066+".txt"; fk platform path:K87:2)
	$file.setText($input)
	
	$prompt:="Extract names and ages"
	
	If (False:C215)
		
		$results:=$lx.extract({file: $file; prompt: $prompt; apiKey: $apiKey; provider: "OpenAI"; model: "gpt-4o"})
		
		$result:=$results[0]
		
		$values:=$result.extractions.extract("extraction_text")
		//[25,Alice Smith]
		
	End if 
	
	If (False:C215)
		
		$results:=$lx.extract({file: $file; prompt: $prompt; provider: "Ollama"; model: "mistral"; workers: 8; multipass: True:C214})
		
		$result:=$results[0]
		
		$values:=$result.extractions.extract("extraction_text")
		//[25,Alice Smith]
		
	End if 
	
	//From URL
	
	$prompt:="Extract key facts"
	
	$url:="https://us.4d.com/leadership/"
	
	$results:=$lx.extract({url: $url; prompt: $prompt; provider: "Ollama"; model: "mistral"; workers: 8; multipass: True:C214})
	
	$result:=$results[0]
	
	$result.extractions.query("extraction_class == :1"; "person").extract("extraction_text")
	//["Laurent Ribardiere","LAURENT RIBARDIERE","ATEF DRISSA"]
	
	
End if 