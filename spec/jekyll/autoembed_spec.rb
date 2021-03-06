require 'spec_helper'

class Doc
  attr_accessor :output
end

# fixture
DOC_WITH_BARE_LINKS =<<EOF
<html>
<body>
  <div>gist</div>
  https://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc
  http://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc

  two gists separated by whitespace

  http://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc http://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc

  <div>normal links, shouldn't be touched</div>
  http://example.com/foobar

  <div>already embedded</div>
  <script src="http://gist.github.com/jondot/123"></script>
</body>
</html>
EOF

EXPECTED_DOC_WITH_BARE_LINKS =<<-EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<body>
  <div>gist</div>
  <script src="https://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc.js"></script>
  <script src="http://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc.js"></script>

  two gists separated by whitespace

  <script src="http://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc.js"></script> <script src="http://gist.github.com/jondot/2eae993053f3a7e280ba1a20f772dfdc.js"></script>

  <div>normal links, shouldn't be touched</div>
  http://example.com/foobar

  <div>already embedded</div>
  <script src="http://gist.github.com/jondot/123"></script>
</body>
</html>
EOF

describe Jekyll::Autoembed do
  it 'should auto embed links in doc' do
    doc = Doc.new
    doc.output = DOC_WITH_BARE_LINKS
    Jekyll::Autoembed.execute(doc).output.must_equal EXPECTED_DOC_WITH_BARE_LINKS
  end
end
