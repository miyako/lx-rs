# lx-rs
tool to chunk text (namespace: `lx`)

### usage

#### get providers

```4d
var $lx : cs.lx
$lx:=cs.lx.new()
var $providers : Collection
$providers:=$lx.providers()
```

* result 

```json
[
	{
		"name": "OpenAI",
		"description": "High accuracy, JSON mode support",
		"models": [
			"gpt-4o",
			"gpt-4o-mini",
			"gpt-3.5-turbo"
		],
		"requires": "OPENAI_API_KEY environment variable",
		"type": "api"
	},
	{
		"name": "Ollama",
		"description": "Local inference, privacy-focused",
		"models": [
			"mistral",
			"llama2",
			"qwen",
			"codellama"
		],
		"requires": "Local Ollama installation (ollama.ai)",
		"type": "local"
	},
	{
		"name": "Custom",
		"description": "OpenAI-compatible HTTP APIs",
		"models": [
			"any-model"
		],
		"requires": "--model-url parameter",
		"type": "remote"
	}
]
```

#### Basic extraction

```4d	
	$input:="Alice Smith is 25 years old"
	$file:=File(Temporary folder+Generate UUID+".txt"; fk platform path)
	$file.setText($input)
	
	$prompt:="Extract names and ages"
	
	$results:=$lx.extract({file: $file; prompt: $prompt; apiKey: $apiKey; provider: "OpenAI"; model: "gpt-4o"})
	
	$result:=$results[0]
	
	$values:=$result.extractions.extract("extraction_text")
	//[25,Alice Smith]
	
	$results:=$lx.extract({file: $file; prompt: $prompt; provider: "Ollama"; model: "mistral"; workers: 8; multipass: True})
	
	$result:=$results[0]
	
	$values:=$result.extractions.extract("extraction_text")
	//[25,Alice Smith]
```

## acknowledgements

[langextract-rust](https://crates.io/crates/langextract-rust)
