module ActiveRecord
  # = Active Record Belongs To Polymorphic Association
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation #:nodoc:
      private

        def conditions
          @conditions ||= interpolate_sql(target_klass.send(:sanitize_sql, @reflection.options[:conditions])) if @reflection.options[:conditions]
        end
        alias :sql_conditions :conditions

        def replace_keys(record)
          super
          @owner[@reflection.foreign_type] = record && record.class.base_class.name
        end

        def different_target?(record)
          super || record.class != target_klass
        end

        def inverse_reflection_for(record)
          @reflection.polymorphic_inverse_of(record.class)
        end

        def target_klass
          type = @owner[@reflection.foreign_type]
          type && type.constantize
        end

        def raise_on_type_mismatch(record)
          # A polymorphic association cannot have a type mismatch, by definition
        end

        def stale_state
          [super, @owner[@reflection.foreign_type].to_s]
        end
    end
  end
end
