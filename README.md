# Important environment variabless

- `DEV_PKG_TARBALL` - the development package we are running reverse dependency checks for
- `CHECK_PKG_LIST` - the package(s) we are checking against
- `AWS_BATCH_JOB_ARRAY_INDEX` - the AWS environment variable set by the array job
- `AWS_REGION` - The AWS region
- `OUTPUT_S3_PATH` - The output S3 path

# Local usage

Get a dev version of a package and build a tarball for it

```shell
git clone --depth 1 https://github.com/tidyverse/glue.git /tmp/glue
R CMD build /tmp/glue .
```
generate the list of reverse dependencies for a given package and save it to a file (here `pkgs`)

```shell
Rscript -e 'writeLines(tools::package_dependencies("glue", reverse = TRUE)[[1]], "pkgs")'
```

Then run the first few 5 jobs to test

```shell
AWS_BATCH_JOB_ARRAY_INDEX=0
while [ $AWS_BATCH_JOB_ARRAY_INDEX -le 4 ]
do
  docker run -v $PWD:/tmp/workdir -e DEV_PKG_TARBALL=glue_1.3.1.tar.gz -e CHECK_PKG_LIST=pkgs -e CHECK_ARGS= -e AWS_BATCH_JOB_ARRAY_INDEX=$AWS_BATCH_JOB_ARRAY_INDEX r_cmd_check
  AWS_BATCH_JOB_ARRAY_INDEX=$((AWS_BATCH_JOB_ARRAY_INDEX + 1))
done
```
