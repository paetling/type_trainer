    public function getCharset()
    {
        return $this->charset;
    }

    public function setEscaper($context, callable $escaper)
    {
        $this->escapers[$context] = $escaper;
        self::$escaperCache[$context] = array();
    }

    public function getEscaper($context)
    {
        if (!isset($this->escapers[$context])) {
            throw new \InvalidArgumentException(sprintf('No registered escaper for context "%s".', $context));
        }
        return $this->escapers[$context];
    }

    public function addGlobal($name, $value)
    {
        $this->globals[$name] = $value;
    }

    public function getGlobals()
    {
        return $this->globals;
    }
