    public function set(HelperInterface $helper, $alias = null)
    {
        $this->helpers[$helper->getName()] = $helper;
        if (null !== $alias) {
            $this->helpers[$alias] = $helper;
        }
        $helper->setCharset($this->charset);
    }

    public function has($name)
    {
        return isset($this->helpers[$name]);
    }

    public function get($name)
    {
        if (!isset($this->helpers[$name])) {
            throw new \InvalidArgumentException(sprintf('The helper "%s" is not defined.', $name));
        }
        return $this->helpers[$name];
    }

    public function extend($template)
    {
        $this->parents[$this->current] = $template;
    }
