<?php


class PhpEngine implements EngineInterface, \ArrayAccess
{
    protected $loader;
    protected $current;

    protected $helpers = array();
    protected $parents = array();
    protected $stack = array();
    protected $charset = 'UTF-8';
    protected $cache = array();
    protected $escapers = array();
    protected static $escaperCache = array();
    protected $globals = array();
    protected $parser;
    private $evalTemplate;
    private $evalParameters;

    public function __construct(TemplateNameParserInterface $parser, LoaderInterface $loader, array $helpers = array())
    {
        $this->parser = $parser;
        $this->loader = $loader;
        $this->addHelpers($helpers);
        $this->initializeEscapers();
        foreach ($this->escapers as $context => $escaper) {
            $this->setEscaper($context, $escaper);
        }
    }
