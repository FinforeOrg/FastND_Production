module Finfores
  module Backgrounds
    class EmailAlert
      @queue = "EmailAlert"

      def self.perform(category,options)
        Finfores::Jobs::AlertWorker.new(category,options)
      end

    end
  end
end