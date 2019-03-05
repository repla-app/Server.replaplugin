# Parent delegate
class ParentDelegate
  attr_reader :process_output_blocks
  attr_reader :process_error_blocks
  def initialize
    @process_output_blocks = []
    @process_error_blocks = []
  end

  def add_process_output_block(&block)
    @process_output_blocks.push(block)
  end

  def add_process_error_block(&block)
    @process_error_blocks.push(block)
  end

  def process_output(text)
    block = @process_output_blocks.delete_at(0)
    block.call(text) unless block.nil?
  end

  def process_error(text)
    block = @process_error_blocks.delete_at(0)
    block.call(text) unless block.nil?
  end
end
