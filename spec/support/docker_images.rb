# frozen_string_literal: true
# This caches the results of pulling from Docker Hub for the duration of the test session.
module DockerImageCache
  def create(hash)
    return super unless hash['fromImage']

    @cache ||= {}
    @cache[hash['fromImage']] ||= super
  end
end

Docker::Image.singleton_class.send(:prepend, DockerImageCache)
