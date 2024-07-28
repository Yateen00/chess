require_relative "utility"
require_relative "end_conditions"
require_relative "move_handler"
require_relative "setup"
require_relative "print"
module AllModules
  include Utility
  include EndConditions
  include MoveHandler
  include Setup
  include Print
end
