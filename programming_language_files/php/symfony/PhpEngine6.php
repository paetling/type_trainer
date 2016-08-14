
    public function escape($value, $context = 'html')
    {
        if (is_numeric($value)) {
            return $value;
        }
        // If we deal with a scalar value, we can cache the result to increase
        // the performance when the same value is escaped multiple times (e.g. loops)
        if (is_scalar($value)) {
            if (!isset(self::$escaperCache[$context][$value])) {
                self::$escaperCache[$context][$value] = call_user_func($this->getEscaper($context), $value);
            }
            return self::$escaperCache[$context][$value];
        }
        return call_user_func($this->getEscaper($context), $value);
    }

    public function setCharset($charset)
    {
        if ('UTF8' === $charset = strtoupper($charset)) {
            $charset = 'UTF-8'; // iconv on Windows requires "UTF-8" instead of "UTF8"
        }
        $this->charset = $charset;
        foreach ($this->helpers as $helper) {
            $helper->setCharset($this->charset);
        }
    }
