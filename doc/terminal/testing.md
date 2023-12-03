# Testing

## Bats

 <badge-doc
 href='https://bats-core.readthedocs.io'></badge-doc> is a
 TAM-compliant testing framework for Bash.

{{% admonition class="info" title="Test Anything Protocol" %}}

[TAP](https://testanything.org/), the Test Anything Protocol, is a simple
text-based interface between testing modules in a test harness. It
decouples the reporting of errors from the presentation of the reports.
{{%/ admonition %}}

### Installation

git based

```shell
git submodule add https://github.com/bats-core/bats-core.git test/bats
git submodule add https://github.com/bats-core/bats-support.git test/test_helper/bats-support
git submodule add https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert
```

### Basic commands
#### `run`

`run` invokes its arguments as a command in a subshell, saves the exit status
and output into global variables: `$status` and `$output`.
`run` returns with a 0 status code so you can continue to make assertions in
your test case The `$lines` array is available for easily accessing individual
lines of output.

??? Example

    ```bash
    @test "invoking foo without arguments prints usage" {
      run foo
      [ "$status" -eq 1 ]
      [ "$output" = "foo: no such file 'nonexistent_filename'" ]
      [ "${lines[0]}" = "usage: foo <filename>" ]
    }
    ```

#### `load`

`load` sources a Bash source file relative to the location of the current test
file.

??? Example

    ```bash
    load test_helper.bash
    ```

#### `skip`

Tests can be skipped by using the skip command at the point in a test you wish to skip.

??? Example

    ```bash
    @test "A test which should run" {
      if [ foo != bar ]; then
        skip "foo isn't bar"
      fi

      run foo
      [ "$status" -eq 0 ]
    }
    ```

#### `setup` and `teardown`
Pre- and post-test hooks have two scopes:

- `setup` and `teardown` functions run before and after each test case,
respectively.
- `setup_file` and `teardown_file` run once before the first test’s `setup` and
after the last test’s `teardown` for the containing file.

#### Print to terminal

Text that is output directly to stdout or stderr (file descriptor 1 or 2), ie echo 'text' is considered part of the test function output and is printed only on test failures. To have text printed unconditionally from within a test function you need to redirect the output to file descriptor 3, eg `echo 'text' >&3`.

### Environment variables


|            Environment variable            | Description                                                                                                                                                                  |
|:-------------------------:|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|   `$BATS_TEST_FILENAME`   | Fully expanded path to the Bats test file.                                                                                                                                   |
|    `$BATS_TEST_DIRNAME`   | Directory in which the Bats test file is located.                                                                                                                            |
|     `$BATS_TEST_NAMES`    | Array of function names for each test case.                                                                                                                                  |
|     `$BATS_TEST_NAME`     | Name of the function containing the current test case.                                                                                                                       |
|  `$BATS_TEST_DESCRIPTION` | Description of the current test case.                                                                                                                                        |
|    `$BATS_TEST_NUMBER`    | (1-based) index of the current test case in the test file.                                                                                                                   |
| `$BATS_SUITE_TEST_NUMBER` | (1-based) index of the current test case in the test suite (over all files).                                                                                                 |
|       `$BATS_TMPDIR`      | Base temporary directory for temporary files / directories. Default: `$TMPDIR`, or `/tmp` if not set.                                                                        |
|     `$BATS_RUN_TMPDIR`    | Location to the temporary directory used by bats to store all its internal temporary files during the tests. (default: `$BATS_TMPDIR/bats-run-$BATS_ROOT_PID-XXXXXX`) |
|   `$BATS_FILE_EXTENSION`  | (default: `bats`) specifies the extension of test files that should be found when running a suite (via `bats [-r] suite_folder/`)                                            |
|    `$BATS_SUITE_TMPDIR`   | Temporary directory common to all tests of a suite. Could be used to create files required by multiple tests.                                                           |
|    `$BATS_FILE_TMPDIR`    | Temporary directory common to all tests of a test file. Could be used to create files required by multiple tests in the same test file.                                 |
|    `$BATS_TEST_TMPDIR`    | Temporary directory unique for each test. Could be used to create files required only for specific tests.                                                               |

### Common assertions

{ghstars}`bats-core/bats-assert`  is a helper library
 providing common assertions:

- `assert` / `refute`: a given expression evaluates to true or false.
- `assert_equal`: two parameters are equal.
- `assert_success` / `assert_failure`: exit status is 0 or 1.
- `assert_output` / `refute_output`: output does (not) contain given content.
- `assert_line` / `refute_line`: a specific line of output does (not) contain
  given content.

### Common functions

{ghstars}`bats-core/bats-support` is a
supporting library providing common functions to test helper libraries:

- Error reporting
- Output formatting
- Language and Execution
