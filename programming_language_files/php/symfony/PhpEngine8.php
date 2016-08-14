    protected function initializeEscapers()
    {
        $flags = ENT_QUOTES | ENT_SUBSTITUTE;
        $this->escapers = array(
            'html' =>
                function ($value) use ($flags) {
                    // Numbers and Boolean values get turned into strings which can cause problems
                    // with type comparisons (e.g. === or is_int() etc).
                    return is_string($value) ? htmlspecialchars($value, $flags, $this->getCharset(), false) : $value;
                },
            'js' =>
                function ($value) {
                    if ('UTF-8' != $this->getCharset()) {
                        $value = iconv($this->getCharset(), 'UTF-8', $value);
                    }
                    $callback = function ($matches) {
                        $char = $matches[0];
                        // \xHH
                        if (!isset($char[1])) {
                            return '\\x'.substr('00'.bin2hex($char), -2);
                        }
                        // \uHHHH
                        $char = iconv('UTF-8', 'UTF-16BE', $char);
                        return '\\u'.substr('0000'.bin2hex($char), -4);
                    };
