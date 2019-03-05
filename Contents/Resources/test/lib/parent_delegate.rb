# Parent delegate
class ParentDelegate
  attr_reader :process_output_blocks
  def initialize
    @process_output_blocks = []
  end

  def add_process_output_block(&block)
    @process_output_blocks.push(block)
  end

  def process_output(text)
    block = @process_output_blocks.delete_at(0)
    block.call(text) unless block.nil?
  end
end
