require "rack/revision_route/version"

module Rack
  class RevisionRoute
    attr_reader :app, :path, :app_dir, :revision

    def initialize(app, app_dir, path)
      @app = app
      @path = path
      @app_dir = app_dir
      @revision = detect_revision
    end

    def call(env)
      if env["REQUEST_METHOD".freeze] == "GET".freeze && env["PATH_INFO".freeze] == path
        body = revision.to_s + "\n"
        [200, {"Content-Type" => "text/plain"}, [body]]
      else
        app.call(env)
      end
    end

    private
    def detect_revision
      revision_file = ::File.join(app_dir, "REVISION")
      git_dir = ::File.join(app_dir, ".git")

      case
      when ::File.exist?(revision_file)
        ::File.read(revision_file).strip
      when ::Dir.exist?(git_dir)
        ::Dir.chdir(app_dir) do
          `git log --format=%H -1`.strip
        end
      end
    end
  end
end
