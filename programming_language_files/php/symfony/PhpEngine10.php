    protected function load($name)
    {
        $template = $this->parser->parse($name);
        $key = $template->getLogicalName();
        if (isset($this->cache[$key])) {
            return $this->cache[$key];
        }
        $storage = $this->loader->load($template);
        if (false === $storage) {
            throw new \InvalidArgumentException(sprintf('The template "%s" does not exist.', $template));
        }
        return $this->cache[$key] = $storage;
    }
}
