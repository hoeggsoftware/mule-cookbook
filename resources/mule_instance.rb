actions :create

default_action :create

attribute :instance_name, :name_attribute => true, :kind_of => String, :required => true
attribute :version, :kind_of => String, :required => true, :regex => /\d+(\.\d+)+.*/
attribute :user, :kind_of => String, :default => "mule"
attribute :group, :kind_of => String, :default => "mule"
attribute :source_dir, :kind_of => String, :default => "/tmp/mule"
attribute :archive_file, :kind_of => String, :required => true
attribute :home, :kind_of => String, :default => "/usr/local/mule-esb"

attr_accessor :exists