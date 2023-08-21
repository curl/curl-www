# retracted CVEs - no longer considered vulnerabilities
#
# page
# first vulnerable version
# last vulnerable version
# name
# CVE
# announce date (YYYYMMDD)
# report to the project date (YYYYMMDD),
# CWE
# award money (USD)
# area (single word)
# C-issue (-, OVERFLOW, OVERREAD, DOUBLE_FREE, USE_AFTER_FREE, NULL_MISTAKE)
#
# List of CWEs => https://cwe.mitre.org/data/definitions/658.html
@novuln = (
    "CVE-2019-15601.html|6.0|7.67.0|SMB access smuggling via FILE URL on Windows|CVE-2019-15601|20200108|20191031|CWE-20: Improper Input Validation|400",
    "CVE-2020-19909.html|-|-|Bogus report filed by anonymous|CVE-2020-19909|20230822|20230825|-|-|-|-",
    "CVE-2023-32001.html|7.84.0|8.1.2|fopen race condition|CVE-2023-32001|20230719|20230627|CWE-367: Time-of-check Time-of-use (TOCTOU) Race Condition|2400|storage|-|both|medium",
    );
