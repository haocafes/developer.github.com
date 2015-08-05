require 'spec_helper'

describe Ethon::Easy::Http::Get do
  let(:easy) { Ethon::Easy.new }
  let(:url) { "http://localhost:3001/" }
  let(:params) { nil }
  let(:form) { nil }
  let(:get) { described_class.new(url, {:params => params, :body => form}) }

  describe "#setup" do
    it "sets url" do
      get.setup(easy)
      expect(easy.url).to eq(url)
    end

    context "when body" do
      let(:form) { { :a => 1 } }

      it "sets customrequest" do
        easy.should_receive(:customrequest=).with("GET")
        get.setup(easy)
      end
    end

    context "when no body" do
      it "doesn't set customrequest" do
        easy.should_receive(:customrequest=).never
        get.setup(easy)
      end
    end

    context "when requesting" do
      before do
        get.setup(easy)
        easy.perform
      end

      context "when url already contains params" do
        let(:url) { "http://localhost:3001/?query=here" }
        let(:params) { {:a => "1&b=2"} }

        it "returns ok" do
          expect(easy.return_code).to eq(:ok)
        end

        it "is a get request" do
          expect(easy.response_body).to include('"REQUEST_METHOD":"GET"')
        end

        it "requests parameterized url" do
          expect(easy.effective_url).to eq("http://localhost:3001/?query=here&a=1%26b%3D2")
        end
      end

      context "when params and no body" do
        let(:params) { {:a => "1&b=2"} }

        it "returns ok" do
          expect(easy.return_code).to eq(:ok)
        end

        it "is a get request" do
          expect(easy.response_body).to include('"REQUEST_METHOD":"GET"')
        end

        it "requests parameterized url" do
          expect(easy.effective_url).to eq("http://localhost:3001/?a=1%26b%3D2")
        end
      end

      context "when params and body" do
        let(:params) { {:a => "1&b=2"} }
        let(:form) { {:b => "2"} }

        it "returns ok" do
          expect(easy.return_code).to eq(:ok)
        end

        it "is a get request" do
          expect(easy.response_body).to include('"REQUEST_METHOD":"GET"')
        end

        it "requests parameterized url" do
          expect(easy.effective_url).to eq("http://localhost:3001/?a=1%26b%3D2")
        end
      end
    end
  end
end