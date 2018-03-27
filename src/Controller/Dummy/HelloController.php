<?php

namespace App\Controller\Dummy;

use App\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

/**
 * Class HelloController
 */
class HelloController extends AbstractController
{
    /**
     * @Route("/", name="dummy_hello_index")
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function indexAction()
    {
        return $this->render("Dummy/hello.html.twig");
    }
}