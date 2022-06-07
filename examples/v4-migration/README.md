The purpose of this test is to test out migration to v4 codebase.

Planned steps:

1. Copy backend from ccb codebase
2. Run terraform init and apply
this way our state is exactly the same.
3. change backend module source path to local paths
4. switch branches locally for backend, servce principal and key vault
5. run terraform plan to see changes
6. evaluate if successfull


How to use:

