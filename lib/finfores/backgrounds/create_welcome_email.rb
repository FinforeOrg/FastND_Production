module Finfores
  module Backgrounds
    class CreateWelcomeEmail
      @queue = "CreateWelcomeEmail"

      def self.perform(uid,password)
        Finfores::Jobs::WelcomeEmail.new(uid,password)
      end

    end
  end
end
