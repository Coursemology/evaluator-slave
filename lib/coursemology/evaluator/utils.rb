# frozen_string_literal: true
module Coursemology::Evaluator::Utils
  # Represents one block of the Docker Attach protocol.
  DockerAttachBlock = Struct.new(:stream, :length, :bytes)

  # Parses a Docker +attach+ protocol stream into its constituent protocols.
  #
  # See https://docs.docker.com/engine/reference/api/docker_remote_api_v1.19/#attach-to-a-container.
  #
  # This drops all blocks belonging to streams other than STDIN, STDOUT, or STDERR.
  #
  # @param [String] string The input stream to parse.
  # @return [Array<(String, String, String)>] The stdin, stdout, and stderr output.
  def self.parse_docker_stream(string)
    result = [''.dup, ''.dup, ''.dup]
    stream = StringIO.new(string)

    while (block = parse_docker_stream_read_block(stream))
      next if block.stream >= result.length
      result[block.stream] << block.bytes
    end

    stream.close
    result
  end

  # Reads a block from the given stream, and parses it according to the Docker +attach+ protocol.
  #
  # @param [IO] stream The stream to read.
  # @raise [IOError] If the stream is corrupt.
  # @return [DockerAttachBlock] If there is data in the stream.
  # @return [nil] If there is no data left in the stream.
  def self.parse_docker_stream_read_block(stream)
    header = stream.read(8)
    return nil if header.blank?
    fail IOError unless header.length == 8

    console_stream, _, _, _, length = header.unpack('C4N')
    DockerAttachBlock.new(console_stream, length, stream.read(length))
  end
  private_class_method :parse_docker_stream_read_block
end
