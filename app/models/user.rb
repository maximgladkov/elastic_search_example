require 'elasticsearch/model'

class User < ActiveRecord::Base
  include Elasticsearch::Model

  def aux_data
    YAML.load(self[:aux_data]) if self[:aux_data].present?
  end

  def aux_data=(hash)
    self[:aux_data] = hash.to_yaml
  end

  def prefixed_aux_data
    aux_data.inject({}) do |hash, (key, value)|
      hash.tap{ |h| h["#{ key }_#{ guess_type_for(value) }"] = value }
    end
  end

  def as_indexed_json(options = {})
    prefixed_aux_data
  end

  private

  def guess_type_for(value)
    case value.class.to_s
    when 'TrueClass', 'FalseClass'
      'boolean'
    when 'Date', 'DateTime'
      'datetime'
    when 'Integer', 'BigDecimal', 'Float'
      'number'
    else
      'string'
    end
  end

end
