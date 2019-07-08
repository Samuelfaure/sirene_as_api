module Scopable
  module Controller
    extend ActiveSupport::Concern

<<<<<<< HEAD
    included do
      controller_attributes.each { |attr| add_has_scope_for_attribute(attr) }
    end

    module ClassMethods
      private

      def controller_attributes
        controller_name.classify.constantize.attribute_names
      end

      def add_has_scope_for_attribute(attr)
        has_scope(attr.to_sym, ->(value) { where(Hash[attr, value]) }, only: :index)
=======
    # Add has_scope for each model attribute
    included do
      controller_name.classify.constantize.attribute_names.each do |a|
        has_scope a.to_sym, ->(value) { where(Hash[a, value]) }, only: :index
>>>>>>> Add controllers etablissements unites_legales v3 with scope concern to filter on any fields
      end
    end
  end

  module Model
    extend ActiveSupport::Concern

<<<<<<< HEAD
    included do
      attribute_names.each { |attr| add_scope_for_attribute(attr) }
    end

    module ClassMethods
      private

      def add_scope_for_attribute(attr)
        scope attr.to_sym, ->(value) { where(Hash[attr, value]) }
=======
    # Add scope for each model attribute
    included do
      self.attribute_names.each do |a|
        scope a.to_sym, ->(value) { where(Hash[a, value]) }
>>>>>>> Add controllers etablissements unites_legales v3 with scope concern to filter on any fields
      end
    end
  end
end
