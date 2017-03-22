require "spec_helper"
require "tmpdir"

describe Rack::RevisionRoute do
  let(:app) {
    -> (env) { [200, {"Content-Type" => "text/plain"}, ["app response"]] }
  }
  let(:app_dir) { Dir.mktmpdir }
  let(:path) { "/revision" }
  let(:stack) {
    Rack::RevisionRoute.new(app, app_dir, path)
  }

  it 'has version' do
    expect(Rack::RevisionRoute::VERSION).to be_a String
  end

  it 'through request without /revision' do
    response = Rack::MockRequest.new(stack).get("/")
    expect(response.status).to eq 200
    expect(response.headers["Content-Type"]).to eq "text/plain"
    expect(response.body).to eq "app response"
  end

  context 'app_dir has REVISION file' do
    before do
      File.write("#{app_dir}/REVISION", "foo")
    end

    it 'responses REVISION file content with new line by GET /revision' do
      response = Rack::MockRequest.new(stack).get("/revision")
      expect(response.status).to eq 200
      expect(response.headers["Content-Type"]).to eq "text/plain"
      expect(response.body).to eq "foo\n"
    end
  end

  context 'app_dir has .git directory' do
    before do
      Dir.chdir(app_dir) do
        raise unless system('git init', out: "/dev/null")
        raise unless system('git commit --allow-empty -m "initial commit"', out: "/dev/null")
      end
    end

    it 'responses sha1 by GET /revision' do
      response = Rack::MockRequest.new(stack).get("/revision")
      expect(/\A[0-9a-f]{40}\n\z/).to be_match response.body
    end

    context 'app_dir has REVISION file' do
      before do
        File.write("#{app_dir}/REVISION", "foo")
      end

      it 'responses REVISION file content with new line by GET /revision' do
        response = Rack::MockRequest.new(stack).get("/revision")
        expect(response.body).to eq "foo\n"
      end
    end
  end

  context 'app_dir has no .git directory, no REVISION file' do
    it 'responses blank by GET /revision' do
      response = Rack::MockRequest.new(stack).get("/revision")
      expect(response.body).to eq "\n"
    end
  end
end
