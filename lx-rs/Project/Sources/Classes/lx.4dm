Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	If (Not:C34(OB Instance of:C1731($controller; cs:C1710._lx_Controller)))
		$controller:=cs:C1710._lx_Controller
	End if 
	
	Super:C1705("lx-rs"; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function extract($option : Variant; $formula : 4D:C1709.Function) : Collection
	
	var $stdOut; $isStream; $isAsync : Boolean
	var $options : Collection
	var $results : Collection
	$results:=[]
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=[$option]
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
		Else 
			$options:=[]
	End case 
	
	var $commands : Collection
	$commands:=[]
	
	If (OB Instance of:C1731($formula; 4D:C1709.Function))
		$isAsync:=True:C214
		This:C1470.controller.onResponse:=$formula
	End if 
	
	For each ($option; $options)
		
		If ($option=Null:C1517) || (Value type:C1509($option)#Is object:K8:27)
			continue
		End if 
		
		$stdOut:=Not:C34(OB Instance of:C1731($option.output; 4D:C1709.File))
		
		$command:=This:C1470.escape(This:C1470.executablePath)
		
		$command+=" extract "
		
		Case of 
			: ($option.url#Null:C1517) && (Value type:C1509($option.url)=Is text:K8:3) && ($option.url#"")
				$command+=" "
				$command+=This:C1470.escape($option.url)
			: (OB Instance of:C1731($option.file; 4D:C1709.File)) && ($option.file.exists)
				$command+=" "
				$command+=This:C1470.escape(This:C1470.expand($option.file).path)
		End case 
		
		If (Not:C34($stdOut))
			$command+=" --output "
			$command+=This:C1470.escape(This:C1470.expand($option.output).path)
		End if 
		
		If (OB Instance of:C1731($option.examples; 4D:C1709.File)) && ($option.examples.exists)
			$command+=" --examples "
			$command+=This:C1470.escape(This:C1470.expand($option.examples).path)
		End if 
		
		If ($option.format#Null:C1517) && (Value type:C1509($option.format)=Is text:K8:3) && ($option.format#"")
			$command+=" --format "
			$command+=This:C1470.escape($option.format)
		End if 
		
		If ($option.prompt#Null:C1517) && (Value type:C1509($option.prompt)=Is text:K8:3) && ($option.prompt#"")
			$command+=" --prompt "
			$command+=This:C1470.escape($option.prompt)
		End if 
		
		If ($option.provider#Null:C1517) && (Value type:C1509($option.provider)=Is text:K8:3) && ($option.provider#"")
			$command+=" --provider "
			Case of 
				: ($option.provider="openai")
					$option.provider:="open-ai"
				: ($option.provider="ollama")
					$option.provider:="ollama"
				: ($option.provider="custom")
					$option.provider:="custom"
			End case 
			$command+=This:C1470.escape($option.provider)
		End if 
		
		If ($option.model#Null:C1517) && (Value type:C1509($option.model)=Is text:K8:3) && ($option.model#"")
			$command+=" --model "
			$command+=This:C1470.escape($option.model)
		End if 
		
		If ($option.apiKey#Null:C1517) && (Value type:C1509($option.apiKey)=Is text:K8:3) && ($option.apiKey#"")
			$command+=" --api-key "
			$command+=This:C1470.escape($option.apiKey)
		End if 
		
		If ($option.workers#Null:C1517) && ((Value type:C1509($option.workers)=Is real:K8:4) || (Value type:C1509($option.workers)=Is integer:K8:5)) && ($option.workers>0)
			$command+=" --workers "
			$command+=String:C10($option.workers)
		End if 
		
		If ($option.multipass#Null:C1517) && (Value type:C1509($option.multipass)=Is boolean:K8:9) && ($option.multipass)
			$command+=" --multipass"
		End if 
		
		If ($option.passes#Null:C1517) && ((Value type:C1509($option.passes)=Is real:K8:4) || (Value type:C1509($option.passes)=Is integer:K8:5)) && ($option.passes>0)
			$command+=" --passes "
			$command+=String:C10($option.passes)
		End if 
		
		If ($option.temperature#Null:C1517) && ((Value type:C1509($option.temperature)=Is real:K8:4) || (Value type:C1509($option.temperature)=Is integer:K8:5))
			$command+=" --temperature "
			$command+=String:C10($option.temperature)
		End if 
		
		If ($option.batchSize#Null:C1517) && ((Value type:C1509($option.batchSize)=Is real:K8:4) || (Value type:C1509($option.batchSize)=Is integer:K8:5)) && ($option.batchSize>0)
			$command+=" --batch-size "
			$command+=String:C10($option.batchSize)
		End if 
		
		If ($option.maxChars#Null:C1517) && ((Value type:C1509($option.maxChars)=Is real:K8:4) || (Value type:C1509($option.maxChars)=Is integer:K8:5)) && ($option.maxChars>0)
			$command+=" --max-chars "
			$command+=String:C10($option.maxChars)
		End if 
		
		SET TEXT TO PASTEBOARD:C523($command)
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.controller.execute($command; $isStream ? $option.file : Null:C1517; $option.data).worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If ($stdOut) && (Not:C34($isAsync))
			ARRAY LONGINT:C221($pos; 0)
			ARRAY LONGINT:C221($len; 0)
			var $output
			$output:=This:C1470.controller.stdOut
			If (Match regex:C1019("🎯\\s+Found (\\d+) extractions in ([0-9\\.]+)s"; $output; 1; $pos; $len))
				$count:=Num:C11(Substring:C12($output; $pos{1}; $len{1}))
				$duration:=Num:C11(Substring:C12($output; $pos{2}; $len{2}))
				$json:=Substring:C12($output; $pos{0}+$len{0})
				$result:=JSON Parse:C1218($json; Is object:K8:27)
				$results.push($result)
			Else 
				$results.push($output)
			End if 
			This:C1470.controller.clear()
		End if 
		
	End for each 
	
	If ($stdOut) && (Not:C34($isAsync))
		return $results
	End if 
	
Function providers() : Collection
	
	$command:=This:C1470.escape(This:C1470.executablePath)
	$command+=" providers"
	
	var $worker : 4D:C1709.SystemWorker
	$worker:=This:C1470.controller.execute($command; $isStream ? $option.file : Null:C1517; $option.data).worker
	$worker.wait()
	
	var $stdOut : Text
	$stdOut:=This:C1470.controller.stdOut
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	$i:=1
	
	var $providers; $models : Collection
	$providers:=[]
	
	While (Match regex:C1019("(?m)(^.+?)(?s)\\s+📝\\s+(.+?)\\s+🤖\\s+Models:\\s(.+?)\\s+([🔑🏠🌐])(?-s)\\s+Requires:\\s(.+)"; $stdOut; $i; $pos; $len))
		$i:=$pos{0}+$len{0}
		$name:=Substring:C12($stdOut; $pos{1}; $len{1})
		$description:=Substring:C12($stdOut; $pos{2}; $len{2})
		$models:=Split string:C1554(Substring:C12($stdOut; $pos{3}; $len{3}); ","; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
		$icon:=Substring:C12($stdOut; $pos{4}; $len{4})
		$requires:=Substring:C12($stdOut; $pos{5}; $len{5})
		Case of 
			: ($icon="🔑")
				$type:="api"
			: ($icon="🏠")
				$type:="local"
			: ($icon="🌐")
				$type:="remote"
			Else 
				$type:="unknown"
		End case 
		$providers.push({name: $name; description: $description; models: $models; requires: $requires; type: $type})
	End while 
	
	return $providers