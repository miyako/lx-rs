# lx-rs
tool to chunk text (namespace: `lx`)

### usage

get providers

```4d
var $lx : cs.lx
$lx:=cs.lx.new()
var $providers : Collection
$providers:=$lx.providers()
```

result 

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

## acknowledgements

[langextract-rust](https://crates.io/crates/langextract-rust)
