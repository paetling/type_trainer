    public function supports($name)
    {
        $template = $this->parser->parse($name);
        return 'php' === $template->get('engine');
    }

    protected function evaluate(Storage $template, array $parameters = array())
    {
        $this->evalTemplate = $template;
        $this->evalParameters = $parameters;
        unset($template, $parameters);
        if (isset($this->evalParameters['this'])) {
            throw new \InvalidArgumentException('Invalid parameter (this)');
        }
        if (isset($this->evalParameters['view'])) {
            throw new \InvalidArgumentException('Invalid parameter (view)');
        }
        $view = $this;
        if ($this->evalTemplate instanceof FileStorage) {
            extract($this->evalParameters, EXTR_SKIP);
            $this->evalParameters = null;
            ob_start();
            require $this->evalTemplate;
            $this->evalTemplate = null;
            return ob_get_clean();
        } elseif ($this->evalTemplate instanceof StringStorage) {
            extract($this->evalParameters, EXTR_SKIP);
            $this->evalParameters = null;
            ob_start();
            eval('; ?>'.$this->evalTemplate.'<?php ;');
            $this->evalTemplate = null;
            return ob_get_clean();
        }
        return false;
    }
