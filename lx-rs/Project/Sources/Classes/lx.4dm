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
	
Function extract($option : Object)
	
	
	
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