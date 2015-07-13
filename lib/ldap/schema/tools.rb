
# Parts of this code taken from: https://github.com/kmdsbng/parse_ldap_schema/blob/master/parse.rb

module Ldap
  module Schema
    class Tools

      class << self

        def parse_objectclass(schema)
          objs = []

          schema.scan(/^(objectClasses:\s*(?<paren>\((?:\g<paren>|[^()])*\)))/im) do |m|
            obj_s = m[0]
            obj_str = obj_s.gsub(/[\n\r]\s?/, '')

            if obj_str =~ /\bNAME\s*(?<quote>['"])(?<name>[^'"]*)\k<quote>/im
              name = $2
            elsif obj_str =~ /\bNAME\s*\(([^)]*)\)/im
              name = $1.scan(/(?<quote>['"])(?<name>[^'"]*)\k<quote>/).map {|ary| ary[1]}
            end

            sups = []
            obj_str.scan(/\bSUP\s+(\w+)\s+(\w+)/i).each {|sup|
              sups << sup
            }

            if !name.nil?
              objs.push({ :name => name, :sups => sups, :schema => obj_str, :raw_schema => obj_s })
            end

          end

          return objs
        end

        def parse_attributes(schema)
          attrs = []

          schema.scan(/^(attributeTypes:\s*(?<paren>\((?:\g<paren>|[^()])*\)))/im) do |m|
            attr_s = m[0]
            attr_str = attr_s.gsub(/[\n\r]\s?/, '')

            if attr_str =~ /\bNAME\s*(?<quote>['"])(?<name>[^'"]*)\k<quote>/im
              name = $2
            elsif attr_str =~ /\bNAME\s*\(([^)]*)\)/im
              name = $1.scan(/(?<quote>['"])(?<name>[^'"]*)\k<quote>/).map {|ary| ary[1]}
            end

            if !name.nil?
              attrs.push({ :name => name, :schema => attr_str, :raw_schema => attr_s })
            end

          end

          return attrs
        end

      end

      attr_reader :objectClasses, :attributeTypes

      def initialize(schema)
        @schema        = schema
        @objectClasses = []
        @attributeTypes    = []

        parse
      end

      def parse
        @objectClasses = Tools.parse_objectclass(@schema)
        @attributeTypes    = Tools.parse_attributes(@schema)
      end

      def sort
        @objectClasses.sort! { |x,y| x[:name] <=> y[:name] }
        @attributeTypes.sort! { |x,y| x[:name] <=> y[:name] }
      end

    end
  end
end
