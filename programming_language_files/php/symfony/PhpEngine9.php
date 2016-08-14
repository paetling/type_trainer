                    if (null === $value = preg_replace_callback('#[^\p{L}\p{N} ]#u', $callback, $value)) {
                        throw new \InvalidArgumentException('The string to escape is not a valid UTF-8 string.');
                    }
                    if ('UTF-8' != $this->getCharset()) {
                        $value = iconv('UTF-8', $this->getCharset(), $value);
                    }
                    return $value;
                },
        );
        self::$escaperCache = array();
    }

    public function getLoader()
    {
        return $this->loader;
    }
