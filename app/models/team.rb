class Team < ActiveRecord::Base
  serialize :members_id, Array
  serialize :technologies, Array
end
