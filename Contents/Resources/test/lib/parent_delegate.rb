# Parent delegate
class ParentDelegate
  attr_reader :process_line_blocks
  def initialize
    @process_line_blocks = []
  end

  def add_process_line_block(block)
    @process_line_blocks.push(block)
  end

  def process_line(text)
    block = @process_line_blocks.delete_at(0)
    block(text) unless block.nil?
  end
end
