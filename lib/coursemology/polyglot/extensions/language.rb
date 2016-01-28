# frozen_string_literal: true
class Coursemology::Polyglot::Language
  # Finds the language class with the specified name.
  #
  # @param [String] type The name of the class.
  # @return [nil] If the type is not defined.
  # @return [Class] If the type was found.
  def self.find_by(type:)
    class_ = concrete_languages.find { |language| language.name == type }
    class_.new if class_
  end

  # Finds the language class with the specified name.
  #
  # @param [String] type The name of the class.
  # @return [Class] If the type was found.
  # @raise [ArgumentError] When the type was not found.
  def self.find_by!(type:)
    language = find_by(type: type)
    fail ArgumentError, "Cannot find the language #{type}" unless language

    language
  end
end
