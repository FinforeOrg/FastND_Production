module Finfores
  module Backgrounds
    class TwitterUtils
      @queue = "TwitterUtils"

      def self.perform(task_type, column_id, twitter_ids)
        Finfores::Jobs::TwitterWorker.new(task_type, column_id, twitter_ids)
      end
    end
  end
end