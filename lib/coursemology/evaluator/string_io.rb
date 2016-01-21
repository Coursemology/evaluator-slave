# Adapter for StringIO for compatibility with RubyZip.
#
# StringIO does not inherit from IO, so RubyZip does not accept StringIO in place of IO.
class Coursemology::Evaluator::StringIO < ::StringIO
  def is_a?(klass)
    klass == IO || super
  end

  # RubyZip assumes all IO objects respond to path.
  def path
    self
  end
end
