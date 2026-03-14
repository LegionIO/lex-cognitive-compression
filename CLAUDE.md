# lex-cognitive-compression

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Models information compression and abstraction as knowledge moves through memory tiers. Raw episodic content is compressed as it ages; fidelity decreases with compression, but storage cost drops. Abstraction groups chunks into higher-level representations. Mirrors the psychological phenomenon where detailed memories fade to gist-level representations over time.

## Gem Info

- **Gem name**: `lex-cognitive-compression`
- **Version**: `0.1.0`
- **Module**: `Legion::Extensions::CognitiveCompression`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_compression/
  cognitive_compression.rb
  version.rb
  client.rb
  helpers/
    constants.rb
    compression_engine.rb
    information_chunk.rb
  runners/
    cognitive_compression.rb
```

## Key Constants

From `helpers/constants.rb`:

- `CHUNK_TYPES` — `%i[episodic semantic procedural sensory emotional abstract relational]`
- `MAX_CHUNKS` = `500`, `MAX_ABSTRACTIONS` = `200`
- `DEFAULT_COMPRESSION_RATIO` = `0.5`, `COMPRESSION_RATE` = `0.1`
- `FIDELITY_LOSS_RATE` = `0.02`, `MIN_FIDELITY` = `0.1`
- `COMPRESSION_LABELS` — `0.8+` = `:highly_compressed`, `0.6` = `:compressed`, `0.4` = `:moderate`, `0.2` = `:detailed`, below = `:raw`
- `FIDELITY_LABELS` — `0.8+` = `:pristine`, `0.6` = `:faithful`, `0.4` = `:approximate`, `0.2` = `:lossy`, below = `:degraded`

## Runners

All methods in `Runners::CognitiveCompression`:

- `store_chunk(label:, chunk_type: :semantic, original_size: 1.0)` — stores a new chunk at default compression ratio
- `compress_chunk(chunk_id:, amount: COMPRESSION_RATE)` — increases compression, decreasing fidelity
- `decompress_chunk(chunk_id:, amount: COMPRESSION_RATE)` — decreases compression, partially restoring fidelity
- `abstract_chunks(chunk_ids:, abstraction_label:)` — combines multiple chunks into a single higher-level abstraction
- `compress_all(amount: COMPRESSION_RATE)` — applies compression to all chunks; intended as periodic runner
- `average_fidelity` — mean fidelity across all stored chunks
- `overall_compression_ratio` — mean compression ratio
- `compression_report` — full report: chunk counts, fidelity, compression distribution, abstraction count

## Helpers

- `CompressionEngine` — manages `@chunks` and `@abstractions`. `abstract_chunks` creates a new `InformationChunk` representing the merged abstraction, linking back to source chunk IDs.
- `InformationChunk` — has `chunk_type`, `original_size`, `compression_ratio`, `fidelity`. `compress!(amount)` increases ratio and decreases fidelity. `decompress!(amount)` reverses compression but fidelity does not fully recover (capped at original minus `FIDELITY_LOSS_RATE * compressions`).

## Integration Points

- `lex-memory` handles long-term trace storage with tier migration; compression models what happens to fidelity as traces move from `episodic` to `semantic` tier — detail is lost, gist is retained.
- `lex-cognitive-chunking` creates named groups; compression models what happens to those groups over time as they age.
- `compress_all` is the natural periodic maintenance runner — called each decay cycle alongside `lex-memory`'s `decay_cycle`.

## Development Notes

- Decompression is lossy: `fidelity` does not return to 1.0 after repeated compress/decompress cycles. `MIN_FIDELITY = 0.1` is a floor; once reached, no further fidelity loss occurs.
- `abstract_chunks` returns `nil` if no valid source chunks are found — the runner wraps this with `{ success: false, error: 'no valid chunks' }`.
- `chunk_type: :episodic` represents autobiographical/event memory (high initial fidelity, fast compression target). `chunk_type: :semantic` represents general knowledge (moderate compression acceptable).
