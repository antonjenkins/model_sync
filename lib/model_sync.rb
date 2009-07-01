module ModelSync
  module Base
    def self.included(klass)
      klass.class_eval do
        extend Config
      end
    end

    module Config
      attr_reader :slave_model_name, :slave_model_class, :relationship, :mappings, :mapping_block

      def model_sync(options)
        @slave_model_name = options[:sync_to].to_s.downcase
        @slave_model_class = Kernel.const_get(@slave_model_name.classify)
        @relationship = options[:relationship]
        @mappings = options[:mappings]
        @mapping_block = options[:mapping_block]

        # Add a callback to sync_changes on every save
        self.after_save :sync_changes
      end
    end

    def sync_changes
      # If we can find a slave instance...
      if slave_instance = find_slave_instance
        # ... then update all the attributes which we've mapped
        self.class.mappings.each do |source, dest|
          slave_instance.update_attribute(dest, self.read_attribute(source))
        end
        # Call the mapping_block if one is supplied
        self.class.mapping_block.call(self, slave_instance) if self.class.mapping_block
      end
    end

private
    def find_slave_instance
      self.class.slave_model_class.find(:first, 
                                        :conditions => "#{self.class.relationship.values.first.to_s} = #{self.read_attribute(self.class.relationship.keys.first)}")
    end
  end
end

if defined?(::ActiveRecord)
  module ::ActiveRecord
    class Base
      include ModelSync::Base
    end
  end
end