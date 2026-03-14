# lex-cognitive-compression

Cognitive information compression for LegionIO. Models information compression and abstraction as knowledge moves through memory tiers.

## What It Does

Raw memories start with high fidelity but take full storage. Over time they compress — detail fades, gist remains. This extension models that process: chunks are stored at a compression ratio, can be incrementally compressed (losing fidelity), and can be abstracted into higher-level representations. Decompression is lossy — you cannot fully recover the original fidelity once lost.

Seven chunk types are supported: episodic, semantic, procedural, sensory, emotional, abstract, and relational. Each has different natural compression targets appropriate to its type.

## Usage

```ruby
client = Legion::Extensions::CognitiveCompression::Client.new

chunk = client.store_chunk(
  label: 'meeting notes 2026-03-14',
  chunk_type: :episodic,
  original_size: 1.0
)

client.compress_chunk(chunk_id: chunk[:chunk][:id], amount: 0.2)
client.average_fidelity
# => { fidelity: 0.96 }  # small fidelity loss from one compression step

# Abstract multiple chunks into a summary
client.abstract_chunks(
  chunk_ids: [chunk[:chunk][:id]],
  abstraction_label: 'Q1 meeting themes'
)

client.compression_report
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
