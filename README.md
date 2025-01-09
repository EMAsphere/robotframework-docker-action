# Robot Framework Docker Action

This action runs Robot Framework tests using [ppodgorsek](https://github.com/ppodgorsek/docker-robot-framework) image.

## Example usage

Run with chrome:

```jobs:
  robot_test:
    runs-on: ubuntu-latest
    name: Run Robot Framework Tests
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Robot Framework
        uses: joonvena/robotframework-docker-action@v1.0
```

Run with firefox and in parallel:

```jobs:
  robot_test:
    runs-on: ubuntu-latest
    name: Run Robot Framework Tests
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Robot Framework
        uses: joonvena/robotframework-docker-action@v1.0
        with:
          browser: 'firefox'
          robot_threads: 2
```

Available configurations in with block:

| Name                     | Default                             | Description                                          |
| ------------------------ | ----------------------------------- | ---------------------------------------------------- |

Available outputs:

| Name           | Description                                          | Values                    |
| -------------- | ---------------------------------------------------- | ------------------------- |
| robot_exit_code| Exit code from Robot Framework execution             | Integer (0=success)       |
| test_status    | Status of the test execution                         | PASS/FAIL/NO_TESTS        |
| report_url     | URL of the test report in S3 (if S3 is configured)  | URL string or empty       |

Example usage with outputs:

```yaml
steps:
  - name: Run Robot Tests
    id: robot_tests
    uses: emasphere/robotframework-docker-action@master
    
  - name: Use Test Results
    run: |
      echo "Test Status: ${{ steps.robot_tests.outputs.test_status }}"
      echo "Report URL: ${{ steps.robot_tests.outputs.report_url }}"
```

Configuration options:

| Name                     | Default                             | Description                                          |
| ------------------------ | ----------------------------------- | ---------------------------------------------------- |
| allowed_shared_memory    | '1g'                                | How much container can use shared memory             |
| browser                  | 'chrome'                            | Available options chrome / firefox                   |
| robot_threads            | 1                                   | Change this > 1 if you want to run tests in parallel |
| pabot_options            | ''                                  | These are only used if robot_threads > 1             |
| robot_options            | ''                                  | Pass extra settings for robot command                |
| screen_color_depth       | 24                                  | Color depth of the virtual screen                    |
| screen_height            | 1080                                | Height of the virtual screen                         |
| screen_width             | 1920                                | Width of the virtual screen                          |
| robot_tests_dir          | 'robot_tests'                       | Location of tests inside repository                  |
| robot_reports_dir        | 'reports'                           | Location of report output from test execution        |
| robot_runner_image       | 'ppodgorsek/robot-framework:latest' | Docker image which will be used to execute the tests |
| robot_resources_dir     | 'Resources'                         | Location of resource files inside repository         |
