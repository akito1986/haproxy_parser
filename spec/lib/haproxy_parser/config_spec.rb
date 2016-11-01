require "haproxy_parser/config"

describe HaproxyParser::Config do
  let(:file_dir) do
    File.expand_path(
      "../../../files",
      __FILE__
    )
  end

  let(:instance) do
    described_class.new(
      file
    )
  end

  describe "#parse" do
    subject { instance.parse }
    let(:file) { file_dir + "/default_haproxy.cfg" }
    context "Given several frontends" do
      context "When several frontends refer to same backend" do
        it "size of backends is correct" do
          expect(subject.backends.size).to eq(2)
        end

        it "frontends' backend_name is same" do
          expect(subject.frontends[1].backend_name).to eq(subject.frontends[2].backend_name)
        end
      end
    end

    context "Given parameter in frontend section" do
      it "get value in frontend section" do
        expect(subject.frontends[0].port).to eq("5000")
      end

      it "the number of servers is correct" do
        expect(subject.servers.size).to eq(4)
      end
    end

    context "Given parameter in defaults section" do
      it "get value in defaults section" do
        expect(subject.frontends[0].mode).to eq("http")
      end
    end

    context "Not Given parameter" do
      it "get default value" do
        expect(subject.frontends[0].backend.servers[0].inter).to eq("2000ms")
      end

      it "get correct backend_name" do
        expect(subject.frontends[0].backend.servers[0].backend_name).to eq("backend_http_8080")
      end
    end
  end

  describe "#check_format!" do
    subject { instance.check_format! }

    context "Given incorrect config file" do
      let(:file) { file_dir + "/incorrect_haproxy.cfg" }
      it "occurs exception" do
        expect{ subject }.to raise_error(HaproxyParser::FormatChecker::FormatError)
      end
    end

    context "Given correct config file" do
      let(:file) { file_dir + "/default_haproxy.cfg" }
      it "not occurs exception" do
        expect{ subject }.not_to raise_error
      end
    end
  end
end
