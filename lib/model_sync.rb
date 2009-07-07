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
        # ... then sync the changes over
        perform_sync(slave_instance)
      end
    end

    def method_missing(id, *args, &block)
      case(id.to_s)
      when /^create_#{self.class.slave_model_name}$/
        # Only create a new slave if one doesn't already exist
        unless find_slave_instance
          # If we've received a create_{slave_model} call then create a new instance of it and sync to it
          new_instance = self.class.slave_model_class.new
          perform_sync(new_instance)
          # Save the new instance so that its primary key is generated and pass this value onto our master model
          new_instance.save
          self.update_attribute(self.class.relationship.keys.first, new_instance.read_attribute(self.class.relationship.values.first.to_s))
        end
      when /^synch?ed_with_#{self.class.slave_model_name}\?$/
        !!find_slave_instance
      else
        super
      end
    end

  private
    def find_slave_instance
      # return nil if we don't have a value for the foreign key
      return nil unless foreign_key_value = self.read_attribute(self.class.relationship.keys.first)
      # find the instance of the slave class using the relationship hash
      self.class.slave_model_class.find(:first, 
                                        :conditions => "#{self.class.relationship.values.first.to_s} = #{foreign_key_value}")
    end

    def perform_sync(slave_instance)
      # Update all the attributes which we've mapped
      self.class.mappings.each do |source, dest|
        slave_instance.update_attribute(dest, self.read_attribute(source))
      end
      # Call the mapping_block if one is supplied
      self.class.mapping_block.call(self, slave_instance) if self.class.mapping_block
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