# Unittest

Unit tests <badge-doc href='https://docs.python.org/3/library/unittest.html' logo="python"> </badge-doc> are entirely self-contained, the basic building blocks are test cases, created from subclasses of [`TestCase`](https://docs.python.org/3/library/unittest.html#unittest.TestCase) or from a function [`FunctionTestCase`](https://docs.python.org/3/library/unittest.html#unittest.FunctionTestCase).

## Initialization

Fixture creation is performed on several levels:


=== "test level"

    <code>[setUp]</code> and <code>[tearingDown]</code> methods provide object creation and destruction.

    ```python
    import unittest

    class MyTest(unittest.TestCase):

        def setUp(self):

    ```

=== "class level"

     <code>[setUpClass]</code> and <code>[tearingDownClass]</code> methods provide object creation and destruction at class instantiation

    ```python
    import unittest

    class MyTest(unittest.TestCase):

        def setUp(self):

    ```

=== "module level"

    [`setUp`](https://docs.python.org/3/library/unittest.html#unittest.TestCase.setUp) and [`tearingDown`] methods provide object creation and destruction.

    ```python
    import unittest

    class MyTest(unittest.TestCase):

        def setUp(self):

    ```


[setUp]: https://docs.python.org/3/library/unittest.html#unittest.TestCase.setUp "setUp"
[tearingDown]: https://docs.python.org/3/library/unittest.html#unittest.TestCase.tearDown
[setUpClass]: https://docs.python.org/3/library/unittest.html#unittest.TestCase.setUp "setUpClass"
[tearingDownClass]: https://docs.python.org/3/library/unittest.html#unittest.TestCase.tearDownClass
