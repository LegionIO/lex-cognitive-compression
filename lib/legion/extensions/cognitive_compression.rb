# frozen_string_literal: true

require_relative 'cognitive_compression/version'
require_relative 'cognitive_compression/helpers/constants'
require_relative 'cognitive_compression/helpers/information_chunk'
require_relative 'cognitive_compression/helpers/compression_engine'
require_relative 'cognitive_compression/runners/cognitive_compression'
require_relative 'cognitive_compression/client'

module Legion
  module Extensions
    module CognitiveCompression
    end
  end
end
