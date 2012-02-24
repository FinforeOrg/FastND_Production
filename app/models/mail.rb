require 'active_record_base_without_table'
class Mail < ActiveRecord::BaseWithoutTable
   column :id, :integer
   column :subject, :string
   column :message, :text
   column :message_html, :text
   column :sender, :string
   column :receiver, :string
   column :received_date, :datetime
   column :bcc, :string
   column :cc, :string

end
